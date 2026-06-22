# PubMed + Embase Deduplication Report v1.0

Date: 2026-06-22

## Inputs

- PubMed deduplicated screening set v1.0: `03_screening/pubmed_deduplicated_screening_set_v1.0.csv` (5,525 records)
- Embase main RIS export: `01_search_strategy/records_exports/20260622_embase_main_8899.ris` (8,899 raw RIS records)

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
| PubMed unique records before Embase merge | 5,525 |
| Embase raw RIS records | 8,899 |
| Embase records after internal conservative deduplication | 8,522 |
| Embase internal duplicates removed | 377 |
| Embase records matched to PubMed | 2,637 |
| - matched by DOI | 2,180 |
| - matched by exact title + year | 457 |
| Embase unique records added beyond PubMed | 5,885 |
| Final PubMed + Embase unique records | 11,410 |

## Outputs

- Combined screening CSV: `03_screening/pubmed_embase_deduplicated_screening_set_v1.0.csv`
- Parsed Embase CSV: `03_screening/embase_parsed_records_v1.0.csv`
- PubMed-Embase duplicate match log: `03_screening/pubmed_embase_duplicate_matches_v1.0.csv`
- Machine-readable summary JSON: `03_screening/pubmed_embase_deduplication_summary_v1.0.json`

## Interpretation

Embase contributed 5,885 unique records beyond the PubMed deduplicated set using conservative DOI/title-year matching. These records should enter title/abstract screening together with PubMed records. A later optional fuzzy duplicate audit can be performed before final PRISMA counts if needed.
