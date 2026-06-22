# Search Log v1.0

Project: RCT-only network meta-analysis of treatment strategies for intermediate-risk pulmonary embolism

Date created: 2026-06-22

## Search Records

| Database | Platform | Search date | Searcher | Search name | Strategy source | Limits | Records retrieved | Export file | Notes |
|---|---|---:|---|---|---|---|---:|---|---|
| PubMed/MEDLINE | PubMed | 2026-06-22 | User + Codex | Main broad search | `search_strategy_v1.0.md`, PubMed final main query | Inception to search date; no language restriction; humans filter via animal exclusion | 3436 | `records_exports/20260622_pubmed_main_3436_medline_abstracts.txt` | MEDLINE-format text export with abstracts verified locally by counting 3436 `PMID-` records. Auxiliary CSV export also archived as `records_exports/20260622_pubmed_main_3436_csv.csv`. Broad search intentionally prioritizes recall; later screening will remove secondary prevention, VTE-only, non-PE, non-RCT, and non-eligible treatment records. |
| PubMed/MEDLINE | PubMed via NCBI E-utilities | 2026-06-22 | Codex | Risk-enriched supplementary search | `search_strategy_v1.0.md`, Section 4.3 | Inception to search date; no language restriction; humans filter via animal exclusion | 252 | `records_exports/20260622_pubmed_risk_enriched_medline_abstracts.txt` | MEDLINE-format text export with abstracts verified locally by counting 252 `PMID-` records. PMID overlap check against the PubMed main broad search found 252/252 already included in the main search and 0 new unique PubMed records. |

## Notes

The PubMed main broad search was designed to capture RCTs using both broad treatment-category terms and representative drug/device terms. It intentionally does not require intermediate-risk or submassive PE terminology, because older RCTs may use terms such as normotensive PE, moderate PE, right ventricular dysfunction, or submassive PE inconsistently.

The next PubMed search to execute is:

1. PubMed device-term supplementary search.

After PubMed is complete, execute Embase, CENTRAL, Web of Science, ClinicalTrials.gov, WHO ICTRP, CNKI, Wanfang, VIP, and SinoMed/CBM searches and append results to this log.
