# Data Extraction v0.3 STRATIFY Locked

Incremental update from v0.2. STRATIFY 2026 was checked against full-text Table 2 and Figure 1.

## Audit

| item | value |
| --- | --- |
| version | v0.3_STRATIFY_locked |
| arm_rows | 38 |
| studies | 18 |
| stratify_change | STRATIFY event counts and RV/LV values locked from Table 2/Figure 1 |
| remaining_manual_step | HAIRE_1993 OCR/manual review; STRATIFY arm-specific ICH unavailable in article tables |

## STRATIFY Rows

| study_id | short_name | arm_label | node | n_randomized_or_analyzed | risk_mapping_v0.2 | death_7d_n | death_followup_n | clinical_deterioration_n | primary_clinical_composite_n | major_bleeding_n | major_bleeding_definition | intracranial_hemorrhage_n | recurrent_pe_n | rv_lv_or_rv_recovery_locked | follow_up_locked | locked_status_v0.2 | ready_death_nma | ready_clinical_deterioration_nma | ready_major_bleeding_nma | ready_ich_nma | source_note_v0.2 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| STRATIFY_2026 | STRATIFY | USAT low-dose alteplase | USCDT | 71.0 | intermediate-high PE by ESC criteria | 2.0 | 2.0 | 1.0 |  | 6.0 | ISTH major bleeding; TIMI major also reported |  |  | RV/LV diameter ratio reduction 48-96h: 0.3 +/- 0.3 | 48-96h imaging and 3 months | core locked for STRATIFY v0.3; ICH arm-specific not reported | yes | yes | yes | no | STRATIFY Table 2/Figure 1: randomized n=71; deaths 2 by 3 months; full-dose thrombolysis for clinical deterioration 1; ISTH major bleeding 6; RV/LV reduction 0.3 SD 0.3 at 48-96h. Text confirms two fatal intracranial haemorrhages overall but does not provide complete arm-specific ICH counts. |
| STRATIFY_2026 | STRATIFY | IV low-dose alteplase | ST | 70.0 | intermediate-high PE by ESC criteria; low-dose ST sensitivity | 0.0 | 4.0 | 2.0 |  | 6.0 | ISTH major bleeding; TIMI major also reported |  |  | RV/LV diameter ratio reduction 48-96h: 0.4 +/- 0.4 | 48-96h imaging and 3 months | core locked for STRATIFY v0.3; ICH arm-specific not reported | yes | yes | yes | no | STRATIFY Table 2/Figure 1: randomized n=70; deaths 4 by 3 months; full-dose thrombolysis for clinical deterioration 2; ISTH major bleeding 6; RV/LV reduction 0.4 SD 0.4 at 48-96h. Low-dose IV alteplase should be flagged as ST low-dose/sensitivity. |
| STRATIFY_2026 | STRATIFY | Heparin alone | AC | 69.0 | intermediate-high PE by ESC criteria | 0.0 | 0.0 | 2.0 |  | 1.0 | ISTH major bleeding; TIMI major also reported |  |  | RV/LV diameter ratio reduction 48-96h: 0.3 +/- 0.3 | 48-96h imaging and 3 months | core locked for STRATIFY v0.3; ICH arm-specific not reported | yes | yes | yes | no | STRATIFY Table 2/Figure 1: randomized n=69; deaths 0 by 3 months; full-dose thrombolysis for clinical deterioration 2; ISTH major bleeding 1; RV/LV reduction 0.3 SD 0.3 at 48-96h. |

## Study Summary

| study_id | short_name | arms | nodes | locked_status | ready_death | ready_clinical | ready_bleeding | ready_ich |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| AHMED_2018 | Ahmed 2018 | 2 | ST vs AC | partial locked; mortality not reported as event count | no | no | yes | yes |
| CANARY_2022 | CANARY | 2 | CDT vs AC | core locked for death/bleeding/RV; ICH not separately reported | yes | sensitivity | yes | no |
| CDT_PILOT_2022 | EuroIntervention pilot CDT | 2 | CDT vs AC | partial locked; primary composite exact count pending | no | no | yes | yes |
| FASULLO_2011 | Fasullo 2011 | 2 | ST vs AC | core locked | yes | yes | yes | yes |
| HAIRE_1993 | Haire 1993 | 2 | ST vs AC | OCR_needed | no | no | no | no |
| HI_PEITHO_2026 | HI-PEITHO | 2 | USCDT vs AC | core locked | yes | yes | yes | yes |
| MAPPET3_2002 | MAPPET-3 | 2 | ST vs AC | core locked | yes | yes | yes | yes |
| MOPETT_2013 | MOPETT | 2 | ST vs AC | core locked; sensitivity-only risk stratum | sensitivity | sensitivity | sensitivity | sensitivity |
| PEERLESS_2025 | PEERLESS | 2 | LBAT vs CDT | core locked; CDT arm mixed: 59.8% USCDT, 23.2% side-hole CDT, 8.7% side-slit CDT; core locked; CDT comparator is mixed | yes | yes | yes | yes |
| PEITHO_2014 | PEITHO | 2 | ST vs AC | core locked | yes | yes | yes | yes |
| PRETHA_2026 | PRETHA | 3 | CAT vs CDT vs AC | partial locked; bleeding definition WHO grade; partial locked; clinical event definition differs | sensitivity | no | sensitivity | sensitivity |
| SINHA_2017 | Sinha 2017 | 2 | ST vs AC | core locked | yes | yes | yes | yes |
| STORM_PE_2025 | STORM-PE | 2 | CAT vs AC | core locked; ICH not separately stated | yes | yes | yes | no |
| STRATIFY_2026 | STRATIFY | 3 | USCDT vs ST vs AC | core locked for STRATIFY v0.3; ICH arm-specific not reported | yes | yes | yes | no |
| SUNSET_sPE_2021 | SUNSET sPE | 2 | USCDT vs CDT | partial locked; table assigns adverse events by group as extracted | sensitivity | no | sensitivity | sensitivity |
| TOPCOAT_2014 | TOPCOAT | 2 | ST vs AC | core locked; outcome harmonization needed | yes | sensitivity | yes | yes |
| ULTIMA_2014 | ULTIMA | 2 | USCDT vs AC | core locked | yes | yes | yes | yes |
| ZHANG_2018 | Zhang 2018 | 2 | ST vs AC | core locked | yes | yes | yes | yes |
