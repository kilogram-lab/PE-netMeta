# Small-sample full-text screening pilot v0.1

Date: 2026-06-19

Project question: RCT-only network meta-analysis of treatment strategies for adult acute intermediate-risk pulmonary embolism.

Current PICOS anchor: intermediate-risk PE; nodes AC, ST, CDT, USCDT, LBAT, CAT; outcomes death, clinical deterioration, major bleeding, intracranial hemorrhage, recurrent PE/VTE, RV recovery, pulmonary pressure reduction, and device-related complications.

## Uploaded PDF inventory

The user provided 24 PDF file paths. All 24 paths were confirmed accessible on 2026-06-19. Two articles appear duplicated across V4 and V5 folders: item 27 and item 31. Therefore, the current inventory contains 24 PDF files by path and approximately 22 unique article records pending formal deduplication.

| No. | Status | File |
|---:|---|---|
| 1 | OK | `44 Fibrinolysis for patients with.pdf` |
| 2 | OK | `46 .PDF` |
| 3 | OK | `47 Streptokinase and Heparin versu Source J Thromb Thrombolysis 1995 2 3 227 229.PDF` |
| 4 | OK | `48 Tissue plasminogen activator for the Source Chest SO 1990 Mar 97 3 528 33.PDF` |
| 5 | OK | `49 value_of_thrombolytic_therapy_for_submassive.13(1).pdf` |
| 6 | OK | `50 PAIMS 2 alteplase combined.PDF` |
| 7 | OK | `27 Six month echocardiographic study in patients with submassivePg33 9.PDF` in V5 |
| 8 | OK | `31 Clinical efficacy of low dose recombinant tissue-type plasminogen activator for the treatment .pdf` in V5 |
| 9 | OK, duplicate candidate | `27 Six month echocardiographic study in patients with submassivePg33 9.PDF` in V4 |
| 10 | OK | `28 Efficacy and Safety of Thrombolytic Source J Clin Med Res SO 2017 Feb 9 2 163 169.pdf` |
| 11 | OK | `29 Comparison of acute and convalescent biomarkers of inflammation in patients with acute pulmonary embolism treated with systemic fibrinolysis vs. placebo.pdf` |
| 12 | OK | `30 Diclofenac for reversal of right ventricular dysf Source Thromb Res 2017 Dec 162 1 6.PDF` |
| 13 | OK, duplicate candidate | `31 Clinical efficacy of low dose recombinant tissue-type plasminogen activator for the treatment .pdf` in V4 |
| 14 | OK | `32 One Year Echocardiographic Functional and Qu Source Circ Cardiovasc Interv 2020 13 8 e009012.PDF` |
| 15 | OK | `33 Intermediate Term Outcomes for Patients w Source J Invasive Cardiol 2021 Dec 33 12 E949 E953.PDF.pdf` |
| 16 | OK | `34 Outcomes of Catheter Based Pulmonary Source Cureus SO 2023.pdf` |
| 17 | OK | `35 Inhibition of thrombin-activatable fibrinolysis inhibitor via DS-1040 to accelerate clot lysis in patients with acute pulmonary embolism a randomized phase 1b study.pdf` |
| 18 | OK | `36 Oxygen therapy in patients with inte Source Chest SO 2023.pdf` |
| 19 | OK | `37 Aspiration thrombectomy compared to Source Cardiol J SO 2025.pdf` |
| 20 | OK | `38 Evaluation of Catheter Directed Thro Source J Vasc Interv Radiol SO 2025.pdf` |
| 21 | OK | `23 Randomized trial of subcutaneous low Source Circulation SO 1992 Apr 85 4 1380 9.PDF` |
| 22 | OK | `24 Subcutaneous low molecular weight heparin fragmin Source Thromb Haemost 1995 Dec 74 6 1432 5.PDF.pdf` |
| 23 | OK | `25 Time course of platelet aggregation Source Blood Coagul Fibrinolysis SO 2007 Oct 18 7 661 7.PDF` |
| 24 | OK | `26 Endogenous plasma activated protein Source Crit Care SO 2011 15 1 R23.PDF` |

## Pilot full-text screening decisions

| Study/file | Full-text pilot judgment | PICOS fit | Node mapping | Extractable outcomes | Notes |
|---|---|---|---|---|---|
| Meyer et al., NEJM 2014, PEITHO, `44 Fibrinolysis for patients with.pdf` | Include for main RCT evidence set | Strong fit: randomized, double-blind, normotensive intermediate-risk PE with RV dysfunction and positive troponin | ST vs AC | Death, hemodynamic decompensation/clinical deterioration, major extracranial bleeding, stroke/ICH, recurrent PE, 30-day outcomes | This is a cornerstone intermediate-high-risk PE trial. It anchors ST vs AC. |
| Fasullo et al., Am J Med Sci 2011, `27 Six month echocardiographic...PDF` | Include or likely include after duplicate handling | Fit: randomized, double-blind, submassive PE with RVD and normal blood pressure | ST vs AC | RV function, PASP, recurrence/death, clinical deterioration, major/minor bleeding, 180-day follow-up | Risk stratum likely intermediate-risk; troponin/BNP details need exact extraction for intermediate-low vs intermediate-high mapping. |
| Zhang et al., Saudi Med J 2018, `31 Clinical efficacy of low dose rt-PA...pdf` | Include as candidate RCT | Fit: randomized envelope allocation, acute intermediate-risk PE | ST vs AC, with low-dose systemic rt-PA noted in extraction | Mortality, hemodynamic decompensation, recurrent VTE, major/minor bleeding, PASP, RV/LV ratio | Current six-node scheme maps to ST; extraction should preserve dose because low-dose ST may be a sensitivity/subnode issue. |
| Al Soueidy et al., Cardiol J 2025, `37 Aspiration thrombectomy compared...pdf` | Exclude from RCT-only main analysis | Not fit: retrospective single-center study, includes submassive and massive PE | Not eligible; descriptive only | RV/LV, complications, in-hospital outcomes | Useful background for CAT vs USCDT/CDT narrative, but not eligible for RCT-only NMA. |
| Gonsalves et al., JVIR 2025, `38 Evaluation of Catheter Directed...pdf` | Do not count as an independent main RCT; use as PEERLESS-related supplementary/post hoc record | Partial fit: post hoc analysis of CDT arm within PEERLESS; original RCT compared LBMT/FlowTriever vs CDT | Original trial: LBAT vs CDT; this post hoc comparison: USCDT vs standard CDT within CDT arm, not randomized by CDT type | Mortality, ICH, major bleeding, clinical deterioration/bailout, ICU use, RV/LV, mPAP, transfusion, device/drug SAEs | Important for understanding PEERLESS and CDT heterogeneity. For NMA, extract primary PEERLESS RCT results from the main publication/registry, not this post hoc as a separate randomized comparison. |

## Pilot rule updates

1. PEITHO-like trials with both RV dysfunction and troponin positivity should be mapped as intermediate-high-risk PE when hemodynamically stable.
2. Submassive PE trials with RV dysfunction but unclear biomarker status should be marked intermediate-risk, then categorized as intermediate-low, intermediate-high, or unclear after full extraction.
3. Low-dose systemic thrombolysis can remain under ST in the six-node primary network, but dose must be extracted for sensitivity analysis or subnode exploration.
4. Retrospective catheter-based studies must be excluded from the main RCT-only NMA even if they compare relevant devices.
5. Post hoc analyses of RCT arms should not be counted as independent RCTs. They can provide supplementary endpoint definitions, safety details, and protocol context.

