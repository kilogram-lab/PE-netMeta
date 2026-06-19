# RV/LV Data v0.1

Primary early timepoint is 24-48h. Positive change means greater RV/LV reduction/improvement.

```csv
study_id,short_name,node,arm_label,n,baseline_mean,baseline_sd,early_timepoint,early_followup_mean,early_followup_sd,early_change_reduction_mean,early_change_reduction_sd,long_term_timepoint,long_term_value,rv_recovery_event_n,rv_recovery_total_n,measure,analysis_status,conversion_needed,source_note
ULTIMA_2014,ULTIMA,USCDT,USAT/USCDT + UFH,30,1.28,0.19,24h,0.99,0.17,0.3,0.2,90d,,,,echocardiographic RV/LV ratio,main_continuous_nma,no,Mean RV/LV ratio from 1.28+/-0.19 to 0.99+/-0.17 at 24h; mean decrease 0.30+/-0.20.
ULTIMA_2014,ULTIMA,AC,UFH alone,29,1.2,0.14,24h,1.17,0.2,0.03,0.16,90d,,,,echocardiographic RV/LV ratio,main_continuous_nma,no,Mean RV/LV ratio from 1.20+/-0.14 to 1.17+/-0.20 at 24h; mean decrease 0.03+/-0.16.
SUNSET_sPE_2021,SUNSET sPE,USCDT,USAT/EKOS,40,1.5,0.3,48h,1.2,0.2,0.35,0.34,90d,,,,RV/LV ratio,main_continuous_nma,no,RV/LV 1.5+/-0.3 to 1.2+/-0.2 at 48h; delta 0.35+/-0.34.
SUNSET_sPE_2021,SUNSET sPE,CDT,Standard CDT,41,1.7,0.4,48h,1.1,0.2,0.59,0.42,90d,,,,RV/LV ratio,main_continuous_nma,no,RV/LV 1.7+/-0.4 to 1.1+/-0.2 at 48h; delta 0.59+/-0.42.
PEERLESS_2025,PEERLESS,LBAT,FlowTriever LBMT,274,,,24h,,,0.32,0.24,,,,,RV/LV ratio reduction,main_continuous_nma,no,Mean RV/LV reduction 0.32+/-0.24 at 24h.
PEERLESS_2025,PEERLESS,CDT,CDT mixed,276,,,24h,,,0.3,0.26,,,,,RV/LV ratio reduction,main_continuous_nma,no,Mean RV/LV reduction 0.30+/-0.26 at 24h; CDT arm is mixed CDT/USCDT.
STORM_PE_2025,STORM-PE,CAT,CAVT/Penumbra + AC,47,1.63,0.36,48h,,,0.52,0.37,90d planned,,,,RV/LV ratio reduction,main_continuous_nma,no,Baseline 1.63+/-0.36; 48h RV/LV reduction 0.52+/-0.37.
STORM_PE_2025,STORM-PE,AC,AC alone,53,1.56,0.35,48h,,,0.24,0.4,90d planned,,,,RV/LV ratio reduction,main_continuous_nma,no,Baseline 1.56+/-0.35; 48h RV/LV reduction 0.24+/-0.40.
ZHANG_2018,Zhang 2018,ST,Low-dose rt-PA + LMWH,33,1.26,0.22,24h,0.96,0.18,0.31,0.18,90d,,,,CT RV/LV ratio,main_continuous_nma,no,RV/LV from 1.26+/-0.22 to 0.96+/-0.18 at 24h; mean difference 0.31+/-0.18.
ZHANG_2018,Zhang 2018,AC,LMWH,33,1.22,0.19,24h,1.17,0.21,0.04,0.16,90d,,,,CT RV/LV ratio,main_continuous_nma,no,RV/LV from 1.22+/-0.19 to 1.17+/-0.21 at 24h; mean difference 0.04+/-0.16.
PRETHA_2026,PRETHA,CAT,Penumbra Indigo CAT8 thrombectomy,13,1.2,,48h,0.89,,0.3,,1/6/12mo,,,,RV/LV ratio,not_main_missing_sd,yes_missing_sd,RV/LV 1.2 to 0.89 at 48h; mean decrease 0.3; SD not available in v0.2.
PRETHA_2026,PRETHA,CDT,Trans-catheter thrombolysis,13,1.27,,48h,0.88,,0.4,,1/6/12mo,,,,RV/LV ratio,not_main_missing_sd,yes_missing_sd,RV/LV 1.27 to 0.88 at 48h; mean decrease 0.4; SD not available in v0.2.
PRETHA_2026,PRETHA,AC,Conservative treatment,13,1.23,,48h,1.12,,0.11,,1/6/12mo,,,,RV/LV ratio,not_main_missing_sd,yes_missing_sd,RV/LV 1.23 to 1.12 at 48h; SD not available in v0.2.
SINHA_2017,Sinha 2017,ST,Tenecteplase + UFH,45,1.14,0.11,unclear,,,,,30d,RV function improvement 31/45,31,45,baseline RV/LV; RV function improvement,long_term_binary_or_pending_continuous,yes_no_followup_mean_sd,Baseline RV/LV 1.14+/-0.11; RV function improvement 31/45.
SINHA_2017,Sinha 2017,AC,Placebo + UFH,41,1.16,0.14,unclear,,,,,30d,RV function improvement 16/41,16,41,baseline RV/LV; RV function improvement,long_term_binary_or_pending_continuous,yes_no_followup_mean_sd,Baseline RV/LV 1.16+/-0.14; RV function improvement 16/41.
CANARY_2022,CANARY,CDT,cCDT + anticoagulation,48,,,72h,,,,,3mo,RV/LV>0.9: 13/48 at 72h; 2/46 at 3mo; unrecovered RV 3/46,,,RV/LV >0.9 or unrecovered RV,binary_rv_recovery_not_continuous,yes_binary_endpoint,"CANARY reports RV/LV>0.9 and unrecovered RV proportions, not mean/SD change in v0.2."
CANARY_2022,CANARY,AC,Anticoagulation,46,,,72h,,,,,3mo,RV/LV>0.9: 24/46 at 72h; 5/39 at 3mo; unrecovered RV 11/39,,,RV/LV >0.9 or unrecovered RV,binary_rv_recovery_not_continuous,yes_binary_endpoint,"CANARY reports RV/LV>0.9 and unrecovered RV proportions, not mean/SD change in v0.2."
```

