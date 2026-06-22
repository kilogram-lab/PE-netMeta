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

BASE_CSV = SCREENING_DIR / "pubmed_embase_deduplicated_screening_set_v1.0.csv"
CENTRAL_RIS = EXPORT_DIR / "20260622_central_trials_3912.ris"

OUT_CSV = SCREENING_DIR / "pubmed_embase_central_deduplicated_screening_set_v1.0.csv"
CENTRAL_PARSED_CSV = SCREENING_DIR / "central_parsed_records_v1.0.csv"
MATCH_CSV = SCREENING_DIR / "pubmed_embase_central_duplicate_matches_v1.0.csv"
REPORT_MD = SCREENING_DIR / "pubmed_embase_central_deduplication_report_v1.0.md"
SUMMARY_JSON = SCREENING_DIR / "pubmed_embase_central_deduplication_summary_v1.0.json"


def normalize_doi(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    text = str(value).strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    text = re.sub(r"^doi:\s*", "", text)
    match = re.search(r"10\.\d{4,9}/\S+", text)
    if not match:
        return ""
    return match.group(0).strip().rstrip(" .;,)]}")


def normalize_title(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    text = unicodedata.normalize("NFKD", str(value)).lower()
    text = re.sub(r"[^\w\s]", " ", text, flags=re.UNICODE)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def normalize_id(value: object) -> str:
    if value is None or pd.isna(value):
        return ""
    return re.sub(r"\D", "", str(value))


def parse_ris(path: Path) -> list[dict[str, list[str]]]:
    records: list[dict[str, list[str]]] = []
    current: dict[str, list[str]] = defaultdict(list)
    last_tag: str | None = None

    with path.open("r", encoding="utf-8", errors="replace", newline="") as handle:
        for raw_line in handle:
            line = raw_line.rstrip("\r\n")
            if not line.strip() or line.startswith("Record #") or line.startswith("Provider:") or line.startswith("Content:"):
                continue
            if re.match(r"^[A-Z0-9]{2}  -\s*", line):
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


def extract_crossrefs(c3_values: list[str]) -> tuple[str, str]:
    text = " ".join(c3_values)
    pmids = re.findall(r"PUBMED\s+(\d+)", text, flags=re.IGNORECASE)
    embase_ids = re.findall(r"EMBASE\s+(\d+)", text, flags=re.IGNORECASE)
    return "; ".join(dict.fromkeys(pmids)), "; ".join(dict.fromkeys(embase_ids))


def normalize_central_record(record: dict[str, list[str]]) -> dict[str, object]:
    pmid_refs, embase_refs = extract_crossrefs(record.get("C3", []))
    title = first(record, "T1") or first(record, "TI")
    year = first(record, "PY") or first(record, "Y1")
    year_match = re.search(r"(19|20)\d{2}", year)
    publication_year = year_match.group(0) if year_match else ""
    return {
        "record_id": "CENTRAL:" + first(record, "AN"),
        "pmid": "",
        "embase_id": "",
        "central_id": first(record, "AN"),
        "title": title,
        "abstract": first(record, "N2") or first(record, "AB"),
        "authors": joined(record, "A1"),
        "journal": first(record, "JF") or first(record, "JA") or first(record, "JO"),
        "citation": "",
        "publication_year": publication_year,
        "publication_date": publication_year,
        "doi": normalize_doi(first(record, "DO") or first(record, "UR")),
        "publication_types": first(record, "M3"),
        "mesh_terms": "",
        "emtree_terms": joined(record, "KW"),
        "language": first(record, "LA"),
        "source_list": "central_trials",
        "source_count": 1,
        "in_pubmed_main": False,
        "in_pubmed_risk_enriched": False,
        "in_pubmed_device_terms": False,
        "in_embase_main": False,
        "in_central_trials": True,
        "pubmed_pmid_matched": pmid_refs,
        "embase_id_matched": embase_refs,
        "central_id_matched": first(record, "AN"),
        "central_pubmed_refs": pmid_refs,
        "central_embase_refs": embase_refs,
        "dedup_match_type": "central_unique",
        "title_abstract_screening_decision": "",
        "exclusion_reason": "",
        "reviewer_notes": "",
    }


def add_keys(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    for col in ["doi", "title", "publication_year", "pmid", "embase_id", "pubmed_pmid_matched", "embase_id_matched"]:
        if col not in df.columns:
            df[col] = ""
    df["doi_norm"] = df["doi"].map(normalize_doi)
    df["title_norm"] = df["title"].map(normalize_title)
    df["year_norm"] = df["publication_year"].fillna("").astype(str).str.extract(r"((?:19|20)\d{2})", expand=False).fillna("")
    df["title_year_key"] = df["title_norm"] + "||" + df["year_norm"]
    df["pmid_norm"] = df["pmid"].map(normalize_id)
    df["embase_id_norm"] = df["embase_id"].map(normalize_id)
    return df


def split_ids(value: object) -> list[str]:
    if value is None or pd.isna(value):
        return []
    ids = []
    for part in re.split(r"[;,]\s*|\s+", str(value)):
        norm = normalize_id(part)
        if norm:
            ids.append(norm)
    return list(dict.fromkeys(ids))


def deduplicate_central(central_df: pd.DataFrame) -> tuple[pd.DataFrame, list[dict[str, str]]]:
    seen_central: dict[str, int] = {}
    seen_doi: dict[str, int] = {}
    seen_title_year: dict[str, int] = {}
    keep_indices: list[int] = []
    internal_dups: list[dict[str, str]] = []

    for idx, row in central_df.iterrows():
        match_idx = None
        match_type = ""
        central_id = str(row["central_id"])
        if central_id and central_id in seen_central:
            match_idx = seen_central[central_id]
            match_type = "central_internal_id"
        elif row["doi_norm"] and row["doi_norm"] in seen_doi:
            match_idx = seen_doi[row["doi_norm"]]
            match_type = "central_internal_doi"
        elif row["title_norm"] and row["year_norm"] and row["title_year_key"] in seen_title_year:
            match_idx = seen_title_year[row["title_year_key"]]
            match_type = "central_internal_title_year"

        if match_idx is None:
            keep_indices.append(idx)
            if central_id:
                seen_central[central_id] = idx
            if row["doi_norm"]:
                seen_doi[row["doi_norm"]] = idx
            if row["title_norm"] and row["year_norm"]:
                seen_title_year[row["title_year_key"]] = idx
        else:
            internal_dups.append(
                {
                    "match_type": match_type,
                    "kept_central_id": str(central_df.loc[match_idx, "central_id"]),
                    "duplicate_central_id": central_id,
                    "duplicate_title": str(row["title"]),
                    "doi": str(row["doi"]),
                }
            )
    return central_df.loc[keep_indices].reset_index(drop=True), internal_dups


def merge_sources(source_list: object, new_source: str) -> str:
    parts = [p.strip() for p in str(source_list or "").split(";") if p.strip()]
    if new_source not in parts:
        parts.append(new_source)
    return "; ".join(parts)


def append_id(existing: object, new_id: object) -> str:
    parts = [p.strip() for p in str(existing or "").split(";") if p.strip()]
    new_text = str(new_id or "").strip()
    if new_text:
        for item in [p.strip() for p in new_text.split(";") if p.strip()]:
            if item not in parts:
                parts.append(item)
    return "; ".join(parts)


def main() -> None:
    SCREENING_DIR.mkdir(parents=True, exist_ok=True)
    base = pd.read_csv(BASE_CSV, dtype=str, keep_default_na=False)
    if "in_central_trials" not in base.columns:
        base["in_central_trials"] = False
    if "central_id" not in base.columns:
        base["central_id"] = ""
    if "central_id_matched" not in base.columns:
        base["central_id_matched"] = ""
    if "central_pubmed_refs" not in base.columns:
        base["central_pubmed_refs"] = ""
    if "central_embase_refs" not in base.columns:
        base["central_embase_refs"] = ""
    base = add_keys(base)

    ris_records = parse_ris(CENTRAL_RIS)
    central = pd.DataFrame([normalize_central_record(record) for record in ris_records])
    central = add_keys(central)
    central.to_csv(CENTRAL_PARSED_CSV, index=False, encoding="utf-8-sig", quoting=csv.QUOTE_MINIMAL)
    central_unique, central_internal_dups = deduplicate_central(central)

    by_pmid: dict[str, int] = {}
    by_embase: dict[str, int] = {}
    by_doi: dict[str, int] = {}
    by_title_year: dict[str, int] = {}
    combined = base.copy()
    for idx, row in combined.iterrows():
        for pmid in split_ids(row.get("pmid", "")) + split_ids(row.get("pubmed_pmid_matched", "")):
            by_pmid.setdefault(pmid, idx)
        for embase_id in split_ids(row.get("embase_id", "")) + split_ids(row.get("embase_id_matched", "")):
            by_embase.setdefault(embase_id, idx)
        if row["doi_norm"]:
            by_doi.setdefault(row["doi_norm"], idx)
        if row["title_norm"] and row["year_norm"]:
            by_title_year.setdefault(row["title_year_key"], idx)

    match_rows: list[dict[str, str]] = []
    added_rows: list[dict[str, object]] = []
    for _, row in central_unique.iterrows():
        match_idx = None
        match_type = ""
        for pmid in split_ids(row.get("central_pubmed_refs", "")):
            if pmid in by_pmid:
                match_idx = by_pmid[pmid]
                match_type = "central_pubmed_ref"
                break
        if match_idx is None:
            for embase_id in split_ids(row.get("central_embase_refs", "")):
                if embase_id in by_embase:
                    match_idx = by_embase[embase_id]
                    match_type = "central_embase_ref"
                    break
        if match_idx is None and row["doi_norm"] and row["doi_norm"] in by_doi:
            match_idx = by_doi[row["doi_norm"]]
            match_type = "doi"
        if match_idx is None and row["title_norm"] and row["year_norm"] and row["title_year_key"] in by_title_year:
            match_idx = by_title_year[row["title_year_key"]]
            match_type = "title_year"

        if match_idx is None:
            added_rows.append(row.to_dict())
        else:
            combined.at[match_idx, "in_central_trials"] = True
            combined.at[match_idx, "source_list"] = merge_sources(combined.at[match_idx, "source_list"], "central_trials")
            combined.at[match_idx, "source_count"] = len([p for p in str(combined.at[match_idx, "source_list"]).split(";") if p.strip()])
            combined.at[match_idx, "central_id_matched"] = append_id(combined.at[match_idx, "central_id_matched"], row["central_id"])
            combined.at[match_idx, "pubmed_pmid_matched"] = append_id(combined.at[match_idx, "pubmed_pmid_matched"], row["central_pubmed_refs"])
            combined.at[match_idx, "embase_id_matched"] = append_id(combined.at[match_idx, "embase_id_matched"], row["central_embase_refs"])
            combined.at[match_idx, "central_pubmed_refs"] = append_id(combined.at[match_idx, "central_pubmed_refs"], row["central_pubmed_refs"])
            combined.at[match_idx, "central_embase_refs"] = append_id(combined.at[match_idx, "central_embase_refs"], row["central_embase_refs"])
            combined.at[match_idx, "dedup_match_type"] = "central_" + match_type
            match_rows.append(
                {
                    "match_type": match_type,
                    "record_id": str(combined.at[match_idx, "record_id"]),
                    "pmid": str(combined.at[match_idx, "pmid"]),
                    "embase_id": str(combined.at[match_idx, "embase_id"]),
                    "central_id": str(row["central_id"]),
                    "base_title": str(combined.at[match_idx, "title"]),
                    "central_title": str(row["title"]),
                    "doi": str(row["doi_norm"]),
                    "publication_year": str(row["year_norm"]),
                }
            )

    if added_rows:
        combined = pd.concat([combined, pd.DataFrame(added_rows)], ignore_index=True)

    output_cols = [
        "record_id",
        "pmid",
        "embase_id",
        "central_id",
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
        "in_central_trials",
        "pubmed_pmid_matched",
        "embase_id_matched",
        "central_id_matched",
        "central_pubmed_refs",
        "central_embase_refs",
        "dedup_match_type",
        "title_abstract_screening_decision",
        "exclusion_reason",
        "reviewer_notes",
    ]
    combined_out = combined[output_cols].fillna("")
    combined_out.to_csv(OUT_CSV, index=False, encoding="utf-8-sig", quoting=csv.QUOTE_MINIMAL)
    pd.DataFrame(match_rows).to_csv(MATCH_CSV, index=False, encoding="utf-8-sig")

    counter = Counter(row["match_type"] for row in match_rows)
    summary = {
        "pubmed_embase_unique_before_central": len(base),
        "central_raw_ris_records": len(ris_records),
        "central_after_internal_dedup": len(central_unique),
        "central_internal_duplicates_removed": len(central_internal_dups),
        "central_matched_to_existing": len(match_rows),
        "central_matched_by_pubmed_ref": counter.get("central_pubmed_ref", 0),
        "central_matched_by_embase_ref": counter.get("central_embase_ref", 0),
        "central_matched_by_doi": counter.get("doi", 0),
        "central_matched_by_title_year": counter.get("title_year", 0),
        "central_unique_added_beyond_pubmed_embase": len(added_rows),
        "final_pubmed_embase_central_unique_records": len(combined_out),
    }
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    report = f"""# PubMed + Embase + CENTRAL Deduplication Report v1.0

Date: 2026-06-22

## Inputs

- PubMed + Embase deduplicated screening set v1.0: `03_screening/pubmed_embase_deduplicated_screening_set_v1.0.csv` ({len(base):,} records)
- CENTRAL Trials RIS export: `01_search_strategy/records_exports/20260622_central_trials_3912.ris` ({len(ris_records):,} raw RIS records)

## Deduplication Methods

1. Parsed CENTRAL RIS fields including CENTRAL accession (`AN`), title (`T1`), authors (`A1`), journal (`JA`), publication year (`PY`), publication type (`M3`), keywords (`KW`), URL (`UR`), and cross-reference field (`C3`).
2. Extracted PubMed and Embase IDs from CENTRAL `C3` when available.
3. Matched CENTRAL to PubMed+Embase conservatively in this order: PubMed ID cross-reference, Embase ID cross-reference, exact DOI, exact normalized title + publication year.
4. Fuzzy matching was not used in v1.0.

## Results

| Metric | Count |
|---|---:|
| PubMed + Embase unique records before CENTRAL merge | {len(base):,} |
| CENTRAL raw RIS records | {len(ris_records):,} |
| CENTRAL records after internal conservative deduplication | {len(central_unique):,} |
| CENTRAL internal duplicates removed | {len(central_internal_dups):,} |
| CENTRAL records matched to existing PubMed+Embase set | {len(match_rows):,} |
| - matched by PubMed ID cross-reference | {counter.get("central_pubmed_ref", 0):,} |
| - matched by Embase ID cross-reference | {counter.get("central_embase_ref", 0):,} |
| - matched by DOI | {counter.get("doi", 0):,} |
| - matched by exact title + year | {counter.get("title_year", 0):,} |
| CENTRAL unique records added beyond PubMed+Embase | {len(added_rows):,} |
| Final PubMed + Embase + CENTRAL unique records | {len(combined_out):,} |

## Outputs

- Combined screening CSV: `03_screening/pubmed_embase_central_deduplicated_screening_set_v1.0.csv`
- Parsed CENTRAL CSV: `03_screening/central_parsed_records_v1.0.csv`
- Duplicate match log: `03_screening/pubmed_embase_central_duplicate_matches_v1.0.csv`
- Machine-readable summary JSON: `03_screening/pubmed_embase_central_deduplication_summary_v1.0.json`

## Interpretation

CENTRAL contributed {len(added_rows):,} unique records beyond the PubMed+Embase deduplicated set using conservative ID/DOI/title-year matching. These records should enter title/abstract screening unless later excluded by PICOS.
"""
    REPORT_MD.write_text(report, encoding="utf-8")
    print(report)


if __name__ == "__main__":
    main()
