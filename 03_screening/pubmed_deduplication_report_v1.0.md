# PubMed Deduplication Report v1.0

Date: 2026-06-22

## Input Files

- PubMed main: `01_search_strategy\records_exports\20260622_pubmed_main_3436_medline_abstracts.txt`
- PubMed risk-enriched: `01_search_strategy\records_exports\20260622_pubmed_risk_enriched_medline_abstracts.txt`
- PubMed device terms: `01_search_strategy\records_exports\20260622_pubmed_device_terms_medline_abstracts.txt`

## Counts

- PubMed main raw records: 3436
- PubMed risk-enriched raw records: 252
- PubMed device-term raw records: 2269
- Raw total before deduplication: 5957
- Unique records after PMID deduplication: 5525
- Duplicates removed by PMID: 432

## Overlap

- Main and risk-enriched overlap: 252
- Main and device-term overlap: 180
- Risk-enriched and device-term overlap: 83
- All three searches: 83
- Risk-enriched records not in main search: 0
- Device-term records not in main search: 2089

## Source Distribution After Deduplication

- pubmed_device_terms: 2089
- pubmed_device_terms; pubmed_main: 97
- pubmed_device_terms; pubmed_main; pubmed_risk_enriched: 83
- pubmed_main: 3087
- pubmed_main; pubmed_risk_enriched: 169

## Output Files

- CSV screening set: `03_screening\pubmed_deduplicated_screening_set_v1.0.csv`
- Excel screening set: `03_screening\pubmed_deduplicated_screening_set_v1.0.xlsx`
- This report: `03_screening\pubmed_deduplication_report_v1.0.md`

## Notes

Deduplication was based on PMID. The dataset is intended for title/abstract screening. The device-term supplementary search was deliberately broad and was not restricted to RCTs, so many records from that source are expected to be excluded during screening.
