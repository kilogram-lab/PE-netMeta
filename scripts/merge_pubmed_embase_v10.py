from __future__ import annotations

import csv
import json
import re
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
EXPORT_DIR = ROOT / "01_search_strategy" / "records_exports"
SCREENING_DIR = ROOT / "03_screening"

PUBMED_CSV = SCREENING_DIR / "pubmed_deduplicated_screening_set_v1.0.csv"
EMBASE_RIS = EXPORT_DIR / "20260622_embase_main_8899.ris"

OUT_CSV = SCREENING_DIR / "pubmed_embase_deduplicated_screening_set_v1.0.csv"
EMBASE_PARSED_CSV = SCREENING_DIR / "embase_parsed_records_v1.0.csv"
MATCH_CSV = SCREENING_DIR / "pubmed_embase_duplicate_matches_v1.0.csv"
REPORT_MD = SCREENING_DIR / "pubmed_embase_deduplication_report_v1.0.md"
SUMMARY_JSON = SCREENING_DIR / "pubmed_embase_deduplication_summary_v1.0.json"


def normalize_doi(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    text = str(value).strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    text = re.sub(r"^doi:\s*", "", text)
    match = re.search(r"10\.\d{4,9}/\S+", text)
    if not match:
        return ""
    doi = match.group(0).strip()
    doi = doi.rstrip(" .;,)]}")
    return doi


def normalize_title(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    text = unicodedata.normalize("NFKD", str(value)).lower()
    text = re.sub(r"[^\w\s]", " ", text, flags=re.UNICODE)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def extract_first_author(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    text = str(value).strip()
    if not text:
        return ""
    first = re.split(r";|\|", text)[0].strip()
    if "," in first:
        first = first.split(",", 1)[0]
    else:
        first = first.split()[0]
    first = unicodedata.normalize("NFKD", first).lower()
    first = re.sub(r"[^a-z0-9]", "", first)
    return first


def parse_ris(path: Path) -> list[dict[str, list[str]]]:
    records: list[dict[str, list[str]]] = []
    current: dict[str, list[str]] = defaultdict(list)
    last_tag: str | None = None

    with path.open("r", encoding="utf-8", errors="replace", newline="") as handle:
        for raw_line in handle:
            line = raw_line.rstrip("\r\n")
            if not line.strip():
                continue
            if re.match(r"^[A-Z0-9]{2}  - ", line):
                tag = line[:2]
                value = line[6:].strip()
                if tag == "TY" and current:
                    records.append(dict(current))
                    current = defaultdict(list)
                elif tag == "ER":
                    current[tag].append(value)
                    records.append(dict(current))
                    current = defaultdict(list)
                    last_tag = None
                    continue
                current[tag].append(value)
                last_tag = tag
            elif last_tag and current.get(last_tag):
                current[last_tag][-1] += " " + line.strip()

    if current:
        records.append(dict(current))

    return records


def first(record: dict[str, list[str]], tag: str) -> str:
    values = record.get(tag, [])
    return values[0] if values else ""


def joined(record: dict[str, list[str]], tag: str, sep: str = "; ") -> str:
    return sep.join(v for v in record.get(tag, []) if v)


def normalize_embase_record(record: dict[str, list[str]]) -> dict[str, str]:
    year = first(record, "Y1")
    year_match = re.search(r"(19|20)\d{2}", year)
    publication_year = year_match.group(0) if year_match else ""
    authors = joined(record, "A1")
    doi = normalize_doi(first(record, "DO") or first(record, "L2"))
    title = first(record, "T1") or first(record, "TI")
    abstract = first(record, "N2") or first(record, "AB")
    return {
        "record_id": "EMBASE:" + first(record, "U2"),
        "pmid": "",
        "embase_id": first(record, "U2"),
        "title": title,
        "abstract": abstract,
        "authors": authors,
        "journal": first(record, "JF") or first(record, "JO"),
        "citation": "",
        "publication_year": publication_year,
        "publication_date": first(record, "U4") or first(record, "U3") or year,
        "doi": doi,
        "publication_types": first(record, "M3"),
        "mesh_terms": "",
        "emtree_terms": joined(record, "KW"),
        "language": first(record, "LA"),
        "source_list": "embase_main",
        "source_count": 1,
        "in_pubmed_main": False,
        "in_pubmed_risk_enriched": False,
        "in_pubmed_device_terms": False,
        "in_embase_main": True,
        "pubmed_pmid_matched": "",
        "embase_id_matched": first(record, "U2"),
        "dedup_match_type": "embase_unique",
        "title_abstract_screening_decision": "",
        "exclusion_reason": "",
        "reviewer_notes": "",
    }


def pubmed_to_unified(row: pd.Series) -> dict[str, object]:
    source_list = str(row.get("source_list", "") or "")
    return {
        "record_id": "PMID:" + str(row.get("pmid", "") or ""),
        "pmid": str(row.get("pmid", "") or ""),
        "embase_id": "",
        "title": row.get("title", ""),
        "abstract": row.get("abstract", ""),
        "authors": row.get("authors", ""),
        "journal": row.get("journal", ""),
        "citation": row.get("citation", ""),
        "publication_year": str(row.get("publication_year", "") or ""),
        "publication_date": row.get("publication_date", ""),
        "doi": normalize_doi(row.get("doi", "")),
        "publication_types": row.get("publication_types", ""),
        "mesh_terms": row.get("mesh_terms", ""),
        "emtree_terms": "",
        "language": row.get("language", ""),
        "source_list": source_list,
        "source_count": int(row.get("source_count", 1) or 1),
        "in_pubmed_main": bool(row.get("in_pubmed_main", False)),
        "in_pubmed_risk_enriched": bool(row.get("in_pubmed_risk_enriched", False)),
        "in_pubmed_device_terms": bool(row.get("in_pubmed_device_terms", False)),
        "in_embase_main": False,
        "pubmed_pmid_matched": str(row.get("pmid", "") or ""),
        "embase_id_matched": "",
        "dedup_match_type": "pubmed_unique_so_far",
        "title_abstract_screening_decision": row.get("title_abstract_screening_decision", ""),
        "exclusion_reason": row.get("exclusion_reason", ""),
        "reviewer_notes": row.get("reviewer_notes", ""),
    }


def add_keys(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["doi_norm"] = df["doi"].map(normalize_doi)
    df["title_norm"] = df["title"].map(normalize_title)
    df["first_author_norm"] = df["authors"].map(extract_first_author)
    df["year_norm"] = df["publication_year"].fillna("").astype(str).str.extract(r"((?:19|20)\d{2})", expand=False).fillna("")
    df["title_year_key"] = df["title_norm"] + "||" + df["year_norm"]
    return df


def deduplicate_embase(embase_df: pd.DataFrame) -> tuple[pd.DataFrame, list[dict[str, str]]]:
    seen_doi: dict[str, int] = {}
    seen_title_year: dict[str, int] = {}
    keep_indices: list[int] = []
    internal_dups: list[dict[str, str]] = []

    for idx, row in embase_df.iterrows():
        doi = row["doi_norm"]
        title_key = row["title_year_key"] if row["title_norm"] and row["year_norm"] else ""
        match_idx = None
        match_type = ""
        if doi and doi in seen_doi:
            match_idx = seen_doi[doi]
            match_type = "embase_internal_doi"
        elif title_key and title_key in seen_title_year:
            match_idx = seen_title_year[title_key]
            match_type = "embase_internal_title_year"

        if match_idx is None:
            keep_indices.append(idx)
            if doi:
                seen_doi[doi] = idx
            if title_key:
                seen_title_year[title_key] = idx
        else:
            internal_dups.append(
                {
                    "match_type": match_type,
                    "kept_embase_id": str(embase_df.loc[match_idx, "embase_id"]),
                    "duplicate_embase_id": str(row["embase_id"]),
                    "duplicate_title": str(row["title"]),
                    "doi": str(row["doi"]),
                }
            )

    return embase_df.loc[keep_indices].reset_index(drop=True), internal_dups


def merge_sources(source_list: str, new_source: str) -> str:
    parts = [p.strip() for p in str(source_list or "").split(";") if p.strip()]
    if new_source not in parts:
        parts.append(new_source)
    return "; ".join(parts)


def main() -> None:
    SCREENING_DIR.mkdir(parents=True, exist_ok=True)

    pubmed_raw = pd.read_csv(PUBMED_CSV, dtype=str, keep_default_na=False)
    pubmed = pd.DataFrame([pubmed_to_unified(row) for _, row in pubmed_raw.iterrows()])
    pubmed = add_keys(pubmed)

    ris_records = parse_ris(EMBASE_RIS)
    embase = pd.DataFrame([normalize_embase_record(record) for record in ris_records])
    embase = add_keys(embase)
    embase.to_csv(EMBASE_PARSED_CSV, index=False, encoding="utf-8-sig", quoting=csv.QUOTE_MINIMAL)

    embase_unique, embase_internal_dups = deduplicate_embase(embase)

    pubmed_by_doi = {}
    pubmed_by_title_year = {}
    combined = pubmed.copy()
    for idx, row in combined.iterrows():
        if row["doi_norm"]:
            pubmed_by_doi.setdefault(row["doi_norm"], idx)
        if row["title_norm"] and row["year_norm"]:
            pubmed_by_title_year.setdefault(row["title_year_key"], idx)

    match_rows: list[dict[str, str]] = []
    embase_added_rows: list[dict[str, object]] = []

    for _, row in embase_unique.iterrows():
        match_idx = None
        match_type = ""
        if row["doi_norm"] and row["doi_norm"] in pubmed_by_doi:
            match_idx = pubmed_by_doi[row["doi_norm"]]
            match_type = "doi"
        elif row["title_norm"] and row["year_norm"] and row["title_year_key"] in pubmed_by_title_year:
            match_idx = pubmed_by_title_year[row["title_year_key"]]
            match_type = "title_year"

        if match_idx is None:
            embase_added_rows.append(row.to_dict())
        else:
            combined.at[match_idx, "in_embase_main"] = True
            combined.at[match_idx, "source_list"] = merge_sources(combined.at[match_idx, "source_list"], "embase_main")
            combined.at[match_idx, "source_count"] = len([p for p in str(combined.at[match_idx, "source_list"]).split(";") if p.strip()])
            old_ids = str(combined.at[match_idx, "embase_id_matched"] or "")
            new_id = str(row["embase_id"])
            combined.at[match_idx, "embase_id_matched"] = "; ".join([x for x in [old_ids, new_id] if x])
            combined.at[match_idx, "dedup_match_type"] = "pubmed_embase_" + match_type
            if not str(combined.at[match_idx, "emtree_terms"] or ""):
                combined.at[match_idx, "emtree_terms"] = row["emtree_terms"]
            match_rows.append(
                {
                    "match_type": match_type,
                    "pmid": str(combined.at[match_idx, "pmid"]),
                    "embase_id": str(row["embase_id"]),
                    "pubmed_title": str(combined.at[match_idx, "title"]),
                    "embase_title": str(row["title"]),
                    "doi": str(row["doi_norm"]),
                    "publication_year": str(row["year_norm"]),
                }
            )

    if embase_added_rows:
        combined = pd.concat([combined, pd.DataFrame(embase_added_rows)], ignore_index=True)

    output_cols = [
        "record_id",
        "pmid",
        "embase_id",
        "title",
        "abstract",
        "authors",
        "journal",
        "citation",
        "publication_year",
        "publication_date",
        "doi",
        "publication_types",
        "mesh_terms",
        "emtree_terms",
        "language",
        "source_list",
        "source_count",
        "in_pubmed_main",
        "in_pubmed_risk_enriched",
        "in_pubmed_device_terms",
        "in_embase_main",
        "pubmed_pmid_matched",
        "embase_id_matched",
        "dedup_match_type",
        "title_abstract_screening_decision",
        "exclusion_reason",
        "reviewer_notes",
    ]
    combined_out = combined[output_cols].fillna("")
    combined_out.to_csv(OUT_CSV, index=False, encoding="utf-8-sig", quoting=csv.QUOTE_MINIMAL)
    pd.DataFrame(match_rows).to_csv(MATCH_CSV, index=False, encoding="utf-8-sig")

    match_counter = Counter(row["match_type"] for row in match_rows)
    summary = {
        "pubmed_unique_before_embase": len(pubmed),
        "embase_raw_ris_records": len(ris_records),
        "embase_after_internal_dedup": len(embase_unique),
        "embase_internal_duplicates_removed": len(embase_internal_dups),
        "embase_matched_to_pubmed": len(match_rows),
        "embase_matched_to_pubmed_by_doi": match_counter.get("doi", 0),
        "embase_matched_to_pubmed_by_title_year": match_counter.get("title_year", 0),
        "embase_unique_added_beyond_pubmed": len(embase_added_rows),
        "final_pubmed_embase_unique_records": len(combined_out),
        "combined_csv": "03_screening/pubmed_embase_deduplicated_screening_set_v1.0.csv",
        "embase_parsed_csv": "03_screening/embase_parsed_records_v1.0.csv",
        "duplicate_match_csv": "03_screening/pubmed_embase_duplicate_matches_v1.0.csv",
    }
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    report = f"""# PubMed + Embase Deduplication Report v1.0

Date: 2026-06-22

## Inputs

- PubMed deduplicated screening set v1.0: `03_screening/pubmed_deduplicated_screening_set_v1.0.csv` ({len(pubmed):,} records)
- Embase main RIS export: `01_search_strategy/records_exports/20260622_embase_main_8899.ris` ({len(ris_records):,} raw RIS records)

## Deduplication Methods

1. Parsed Embase RIS fields including accession (`U2`), title (`T1`), abstract (`N2`), authors (`A1`), journal (`JF`/`JO`), year (`Y1`), DOI (`DO`), publication type (`M3`), language (`LA`), and Emtree/index terms (`KW`).
2. Standardized DOI by lowercasing and removing DOI URL prefixes.
3. Standardized titles by Unicode normalization, lowercasing, removing punctuation, and collapsing whitespace.
4. Removed internal Embase duplicates conservatively using exact DOI first, then exact normalized title + publication year.
5. Matched Embase to PubMed conservatively using exact DOI first, then exact normalized title + publication year.
6. Fuzzy matching was not used in v1.0 to avoid accidental deletion of distinct conference abstracts, updates, or related reports.

## Results

| Metric | Count |
|---|---:|
| PubMed unique records before Embase merge | {len(pubmed):,} |
| Embase raw RIS records | {len(ris_records):,} |
| Embase records after internal conservative deduplication | {len(embase_unique):,} |
| Embase internal duplicates removed | {len(embase_internal_dups):,} |
| Embase records matched to PubMed | {len(match_rows):,} |
| - matched by DOI | {match_counter.get("doi", 0):,} |
| - matched by exact title + year | {match_counter.get("title_year", 0):,} |
| Embase unique records added beyond PubMed | {len(embase_added_rows):,} |
| Final PubMed + Embase unique records | {len(combined_out):,} |

## Outputs

- Combined screening CSV: `03_screening/pubmed_embase_deduplicated_screening_set_v1.0.csv`
- Parsed Embase CSV: `03_screening/embase_parsed_records_v1.0.csv`
- PubMed-Embase duplicate match log: `03_screening/pubmed_embase_duplicate_matches_v1.0.csv`
- Machine-readable summary JSON: `03_screening/pubmed_embase_deduplication_summary_v1.0.json`

## Interpretation

Embase contributed {len(embase_added_rows):,} unique records beyond the PubMed deduplicated set using conservative DOI/title-year matching. These records should enter title/abstract screening together with PubMed records. A later optional fuzzy duplicate audit can be performed before final PRISMA counts if needed.
"""
    REPORT_MD.write_text(report, encoding="utf-8")

    print(report)


if __name__ == "__main__":
    main()
