from __future__ import annotations

import re
from collections import Counter, defaultdict
from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
EXPORT_DIR = ROOT / "01_search_strategy" / "records_exports"
OUT_DIR = ROOT / "03_screening"

SOURCES = {
    "pubmed_main": EXPORT_DIR / "20260622_pubmed_main_3436_medline_abstracts.txt",
    "pubmed_risk_enriched": EXPORT_DIR / "20260622_pubmed_risk_enriched_medline_abstracts.txt",
    "pubmed_device_terms": EXPORT_DIR / "20260622_pubmed_device_terms_medline_abstracts.txt",
}


def parse_medline(path: Path) -> list[dict[str, list[str]]]:
    records: list[dict[str, list[str]]] = []
    current: dict[str, list[str]] = defaultdict(list)
    last_tag: str | None = None

    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        if not raw_line.strip():
            if current:
                if current.get("PMID"):
                    records.append(dict(current))
                current = defaultdict(list)
                last_tag = None
            continue

        if len(raw_line) >= 6 and raw_line[4] == "-":
            tag = raw_line[:4].strip()
            value = raw_line[6:].strip()
            current[tag].append(value)
            last_tag = tag
        elif raw_line.startswith("      ") and last_tag:
            current[last_tag][-1] += " " + raw_line.strip()

    if current:
        if current.get("PMID"):
            records.append(dict(current))

    return records


def first(record: dict[str, list[str]], tag: str) -> str:
    values = record.get(tag, [])
    return values[0] if values else ""


def joined(record: dict[str, list[str]], tag: str, sep: str = "; ") -> str:
    return sep.join(record.get(tag, []))


def extract_year(record: dict[str, list[str]]) -> str:
    dp = first(record, "DP")
    match = re.search(r"(19|20)\d{2}", dp)
    return match.group(0) if match else ""


def extract_doi(record: dict[str, list[str]]) -> str:
    candidates = record.get("AID", []) + record.get("LID", [])
    for value in candidates:
        if "[doi]" in value.lower():
            return re.sub(r"\s*\[doi\].*$", "", value, flags=re.IGNORECASE).strip()
    for value in candidates:
        match = re.search(r"10\.\S+", value)
        if match:
            return match.group(0).rstrip("].)")
    return ""


def normalize_record(record: dict[str, list[str]], source: str) -> dict[str, str]:
    pmid = first(record, "PMID")
    title = first(record, "TI")
    abstract = " ".join(record.get("AB", []))
    publication_types = joined(record, "PT")
    mesh_terms = joined(record, "MH")
    authors = joined(record, "AU")

    return {
        "pmid": pmid,
        "title": title,
        "abstract": abstract,
        "authors": authors,
        "journal": first(record, "JT") or first(record, "TA"),
        "citation": first(record, "SO"),
        "publication_year": extract_year(record),
        "publication_date": first(record, "DP"),
        "doi": extract_doi(record),
        "publication_types": publication_types,
        "mesh_terms": mesh_terms,
        "language": joined(record, "LA"),
        "source": source,
    }


def merge_records() -> tuple[pd.DataFrame, dict[str, object]]:
    by_pmid: dict[str, dict[str, str]] = {}
    source_sets: dict[str, set[str]] = {}
    raw_counts: dict[str, int] = {}

    for source, path in SOURCES.items():
        records = parse_medline(path)
        raw_counts[source] = len(records)
        source_sets[source] = set()

        for record in records:
            normalized = normalize_record(record, source)
            pmid = normalized["pmid"]
            if not pmid:
                continue
            source_sets[source].add(pmid)

            if pmid not in by_pmid:
                by_pmid[pmid] = normalized
                by_pmid[pmid]["source_list"] = source
            else:
                existing = by_pmid[pmid]
                existing_sources = set(existing["source_list"].split("; "))
                existing_sources.add(source)
                existing["source_list"] = "; ".join(sorted(existing_sources))
                for key, value in normalized.items():
                    if key in {"pmid", "source", "source_list"}:
                        continue
                    if not existing.get(key) and value:
                        existing[key] = value

    rows = []
    for pmid, row in by_pmid.items():
        sources = set(row["source_list"].split("; "))
        row = dict(row)
        row["in_pubmed_main"] = "yes" if "pubmed_main" in sources else "no"
        row["in_pubmed_risk_enriched"] = "yes" if "pubmed_risk_enriched" in sources else "no"
        row["in_pubmed_device_terms"] = "yes" if "pubmed_device_terms" in sources else "no"
        row["source_count"] = len(sources)
        row["title_abstract_screening_decision"] = ""
        row["exclusion_reason"] = ""
        row["reviewer_notes"] = ""
        rows.append(row)

    df = pd.DataFrame(rows)
    df = df.sort_values(
        by=["in_pubmed_main", "publication_year", "pmid"],
        ascending=[False, False, False],
        kind="stable",
    )

    ordered_cols = [
        "pmid",
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
        "language",
        "source_list",
        "source_count",
        "in_pubmed_main",
        "in_pubmed_risk_enriched",
        "in_pubmed_device_terms",
        "title_abstract_screening_decision",
        "exclusion_reason",
        "reviewer_notes",
    ]
    df = df[ordered_cols]

    all_raw = sum(raw_counts.values())
    unique_count = len(df)
    stats = {
        "raw_counts": raw_counts,
        "raw_total": all_raw,
        "unique_count": unique_count,
        "duplicates_removed": all_raw - unique_count,
        "main_risk_overlap": len(source_sets["pubmed_main"] & source_sets["pubmed_risk_enriched"]),
        "main_device_overlap": len(source_sets["pubmed_main"] & source_sets["pubmed_device_terms"]),
        "risk_device_overlap": len(source_sets["pubmed_risk_enriched"] & source_sets["pubmed_device_terms"]),
        "all_three_overlap": len(
            source_sets["pubmed_main"]
            & source_sets["pubmed_risk_enriched"]
            & source_sets["pubmed_device_terms"]
        ),
        "risk_unique_not_main": len(source_sets["pubmed_risk_enriched"] - source_sets["pubmed_main"]),
        "device_unique_not_main": len(source_sets["pubmed_device_terms"] - source_sets["pubmed_main"]),
        "source_distribution": Counter(df["source_list"]),
    }
    return df, stats


def write_outputs(df: pd.DataFrame, stats: dict[str, object]) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    csv_path = OUT_DIR / "pubmed_deduplicated_screening_set_v1.0.csv"
    xlsx_path = OUT_DIR / "pubmed_deduplicated_screening_set_v1.0.xlsx"
    md_path = OUT_DIR / "pubmed_deduplication_report_v1.0.md"

    df.to_csv(csv_path, index=False, encoding="utf-8-sig")
    with pd.ExcelWriter(xlsx_path, engine="openpyxl") as writer:
        df.to_excel(writer, sheet_name="records", index=False)
        summary = pd.DataFrame(
            [
                {"metric": "pubmed_main_raw", "value": stats["raw_counts"]["pubmed_main"]},
                {"metric": "pubmed_risk_enriched_raw", "value": stats["raw_counts"]["pubmed_risk_enriched"]},
                {"metric": "pubmed_device_terms_raw", "value": stats["raw_counts"]["pubmed_device_terms"]},
                {"metric": "raw_total_before_deduplication", "value": stats["raw_total"]},
                {"metric": "unique_records_after_pmid_deduplication", "value": stats["unique_count"]},
                {"metric": "duplicates_removed_by_pmid", "value": stats["duplicates_removed"]},
                {"metric": "main_risk_overlap", "value": stats["main_risk_overlap"]},
                {"metric": "main_device_overlap", "value": stats["main_device_overlap"]},
                {"metric": "risk_device_overlap", "value": stats["risk_device_overlap"]},
                {"metric": "all_three_overlap", "value": stats["all_three_overlap"]},
                {"metric": "risk_unique_not_in_main", "value": stats["risk_unique_not_main"]},
                {"metric": "device_unique_not_in_main", "value": stats["device_unique_not_main"]},
            ]
        )
        summary.to_excel(writer, sheet_name="dedup_summary", index=False)

    source_distribution = stats["source_distribution"]
    lines = [
        "# PubMed Deduplication Report v1.0",
        "",
        "Date: 2026-06-22",
        "",
        "## Input Files",
        "",
        f"- PubMed main: `{SOURCES['pubmed_main'].relative_to(ROOT)}`",
        f"- PubMed risk-enriched: `{SOURCES['pubmed_risk_enriched'].relative_to(ROOT)}`",
        f"- PubMed device terms: `{SOURCES['pubmed_device_terms'].relative_to(ROOT)}`",
        "",
        "## Counts",
        "",
        f"- PubMed main raw records: {stats['raw_counts']['pubmed_main']}",
        f"- PubMed risk-enriched raw records: {stats['raw_counts']['pubmed_risk_enriched']}",
        f"- PubMed device-term raw records: {stats['raw_counts']['pubmed_device_terms']}",
        f"- Raw total before deduplication: {stats['raw_total']}",
        f"- Unique records after PMID deduplication: {stats['unique_count']}",
        f"- Duplicates removed by PMID: {stats['duplicates_removed']}",
        "",
        "## Overlap",
        "",
        f"- Main and risk-enriched overlap: {stats['main_risk_overlap']}",
        f"- Main and device-term overlap: {stats['main_device_overlap']}",
        f"- Risk-enriched and device-term overlap: {stats['risk_device_overlap']}",
        f"- All three searches: {stats['all_three_overlap']}",
        f"- Risk-enriched records not in main search: {stats['risk_unique_not_main']}",
        f"- Device-term records not in main search: {stats['device_unique_not_main']}",
        "",
        "## Source Distribution After Deduplication",
        "",
    ]
    for source_list, count in sorted(source_distribution.items()):
        lines.append(f"- {source_list}: {count}")
    lines.extend(
        [
            "",
            "## Output Files",
            "",
            f"- CSV screening set: `{csv_path.relative_to(ROOT)}`",
            f"- Excel screening set: `{xlsx_path.relative_to(ROOT)}`",
            f"- This report: `{md_path.relative_to(ROOT)}`",
            "",
            "## Notes",
            "",
            "Deduplication was based on PMID. The dataset is intended for title/abstract screening. "
            "The device-term supplementary search was deliberately broad and was not restricted to RCTs, "
            "so many records from that source are expected to be excluded during screening.",
            "",
        ]
    )
    md_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    for name, path in SOURCES.items():
        if not path.exists():
            raise FileNotFoundError(f"Missing input for {name}: {path}")
    df, stats = merge_records()
    write_outputs(df, stats)
    print(f"raw_total={stats['raw_total']}")
    print(f"unique_records={stats['unique_count']}")
    print(f"duplicates_removed={stats['duplicates_removed']}")
    print(f"main_risk_overlap={stats['main_risk_overlap']}")
    print(f"main_device_overlap={stats['main_device_overlap']}")
    print(f"risk_device_overlap={stats['risk_device_overlap']}")
    print(f"all_three_overlap={stats['all_three_overlap']}")
    print(f"risk_unique_not_main={stats['risk_unique_not_main']}")
    print(f"device_unique_not_main={stats['device_unique_not_main']}")


if __name__ == "__main__":
    main()
