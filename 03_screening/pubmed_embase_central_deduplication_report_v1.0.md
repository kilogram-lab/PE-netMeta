# PubMed + Embase + CENTRAL Deduplication Report v1.0

Date: 2026-06-22

## Inputs

- PubMed + Embase deduplicated screening set v1.0: `03_screening/pubmed_embase_deduplicated_screening_set_v1.0.csv` (11,410 records)
- CENTRAL Trials RIS export: `01_search_strategy/records_exports/20260622_central_trials_3912.ris` (3,912 raw RIS records)

## Deduplication Methods

1. Parsed CENTRAL RIS fields including CENTRAL accession (`AN`), title (`T1`), authors (`A1`), journal (`JA`), publication year (`PY`), publication type (`M3`), keywords (`KW`), URL (`UR`), and cross-reference field (`C3`).
2. Extracted PubMed and Embase IDs from CENTRAL `C3` when available.
3. Matched CENTRAL to PubMed+Embase conservatively in this order: PubMed ID cross-reference, Embase ID cross-reference, exact DOI, exact normalized title + publication year.
4. Fuzzy matching was not used in v1.0.

## Results

| Metric | Count |
|---|---:|
| PubMed + Embase unique records before CENTRAL merge | 11,410 |
| CENTRAL raw RIS records | 3,912 |
| CENTRAL records after internal conservative deduplication | 3,743 |
| CENTRAL internal duplicates removed | 169 |
| CENTRAL records matched to existing PubMed+Embase set | 2,250 |
| - matched by PubMed ID cross-reference | 1,264 |
| - matched by Embase ID cross-reference | 813 |
| - matched by DOI | 56 |
| - matched by exact title + year | 117 |
| CENTRAL unique records added beyond PubMed+Embase | 1,493 |
| Final PubMed + Embase + CENTRAL unique records | 12,903 |

## Outputs

- Combined screening CSV: `03_screening/pubmed_embase_central_deduplicated_screening_set_v1.0.csv`
- Parsed CENTRAL CSV: `03_screening/central_parsed_records_v1.0.csv`
- Duplicate match log: `03_screening/pubmed_embase_central_duplicate_matches_v1.0.csv`
- Machine-readable summary JSON: `03_screening/pubmed_embase_central_deduplication_summary_v1.0.json`

## Interpretation

CENTRAL contributed 1,493 unique records beyond the PubMed+Embase deduplicated set using conservative ID/DOI/title-year matching. These records should enter title/abstract screening unless later excluded by PICOS.
