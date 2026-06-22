# Search Log v1.0

Project: RCT-only network meta-analysis of treatment strategies for intermediate-risk pulmonary embolism

Date created: 2026-06-22

## Search Records

| Database | Platform | Search date | Searcher | Search name | Strategy source | Limits | Records retrieved | Export file | Notes |
|---|---|---:|---|---|---|---|---:|---|---|
| PubMed/MEDLINE | PubMed | 2026-06-22 | User + Codex | Main broad search | `search_strategy_v1.0.md`, PubMed final main query | Inception to search date; no language restriction; humans filter via animal exclusion | 3436 | `records_exports/20260622_pubmed_main_3436_csv.csv` | CSV export verified locally with 3436 rows. Broad search intentionally prioritizes recall; later screening will remove secondary prevention, VTE-only, non-PE, non-RCT, and non-eligible treatment records. |

## Notes

The PubMed main broad search was designed to capture RCTs using both broad treatment-category terms and representative drug/device terms. It intentionally does not require intermediate-risk or submassive PE terminology, because older RCTs may use terms such as normotensive PE, moderate PE, right ventricular dysfunction, or submassive PE inconsistently.

The next PubMed searches to execute are:

1. PubMed risk-enriched supplementary search.
2. PubMed device-term supplementary search.

After PubMed is complete, execute Embase, CENTRAL, Web of Science, ClinicalTrials.gov, WHO ICTRP, CNKI, Wanfang, VIP, and SinoMed/CBM searches and append results to this log.
