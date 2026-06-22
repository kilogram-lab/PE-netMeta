# Search Strategy v1.0

Project: RCT-only network meta-analysis of treatment strategies for intermediate-risk pulmonary embolism

Date: 2026-06-22

Version status: v1.0 working strategy for formal database searching. Record counts are not yet filled because searches have not yet been executed in each database interface.

## 1. Review Question

Among adult patients with acute intermediate-risk pulmonary embolism, what are the comparative efficacy and safety of anticoagulation, systemic thrombolysis, catheter-directed thrombolysis, ultrasound-assisted catheter-directed thrombolysis, large-bore aspiration thrombectomy, and catheter-assisted aspiration thrombectomy?

## 2. PICOS Summary

Population: Adults with acute intermediate-risk pulmonary embolism. The main analysis will focus on intermediate-risk PE and will later be stratified into intermediate-low, intermediate-high, and all intermediate-risk networks when extractable.

Interventions and comparators: AC, ST, CDT, USCDT, LBAT, and CAT. Trials comparing any eligible node against another eligible node will be considered.

Outcomes: All-cause death, clinical deterioration or treatment failure, major bleeding, intracranial haemorrhage, recurrent PE or VTE, RV/LV ratio or right ventricular recovery, pulmonary artery pressure, and device-related complications.

Study design: Randomized controlled trials only. Quasi-randomized, observational, registry-only, case series, and single-arm studies are excluded from the main analysis.

## 3. Search Principles

1. Use a broad PE + treatment + RCT strategy as the main search, without requiring the words "intermediate-risk" or "submassive", because older RCTs often use terms such as normotensive PE, moderate PE, right ventricular dysfunction, or submassive PE.
2. Do not add outcome terms to the main search, to avoid missing RCTs that report outcomes inconsistently.
3. Run an additional risk-enriched search using intermediate-risk, submassive, normotensive, RV dysfunction, RV/LV, and troponin terms as a sensitivity check.
4. Search from database inception to the final search date.
5. Apply no language restriction. Non-English full texts will be assessed when available.
6. Search bibliographies of included RCTs, previous systematic reviews, major guidelines, ClinicalTrials.gov, and WHO ICTRP.

## 4. PubMed / MEDLINE

### 4.1 Concept Blocks

PE block:

```text
("Pulmonary Embolism"[Mesh]
 OR "pulmonary embolism"[tiab]
 OR "pulmonary emboli"[tiab]
 OR "pulmonary embolus"[tiab]
 OR "pulmonary thromboembolism"[tiab]
 OR "pulmonary thromboemboli"[tiab]
 OR "acute pulmonary embolism"[tiab]
 OR "lung embolism"[tiab])
```

Risk-enrichment block, not used in the broad main search:

```text
("intermediate-risk"[tiab]
 OR "intermediate risk"[tiab]
 OR "intermediate-high"[tiab]
 OR "intermediate high"[tiab]
 OR "intermediate-low"[tiab]
 OR "intermediate low"[tiab]
 OR submassive[tiab]
 OR "sub-massive"[tiab]
 OR normotensive[tiab]
 OR "right ventricular dysfunction"[tiab]
 OR "right ventricular dilatation"[tiab]
 OR "right ventricular dilation"[tiab]
 OR "right ventricle"[tiab]
 OR "RV dysfunction"[tiab]
 OR "RV/LV"[tiab]
 OR "right-to-left ventricular"[tiab]
 OR troponin[tiab]
 OR "cardiac biomarker"[tiab])
```

Treatment block:

```text
(anticoag*[tiab]
 OR heparin[tiab]
 OR "unfractionated heparin"[tiab]
 OR "low molecular weight heparin"[tiab]
 OR LMWH[tiab]
 OR enoxaparin[tiab]
 OR dalteparin[tiab]
 OR fondaparinux[tiab]
 OR warfarin[tiab]
 OR rivaroxaban[tiab]
 OR apixaban[tiab]
 OR dabigatran[tiab]
 OR edoxaban[tiab]
 OR thrombolys*[tiab]
 OR thrombolytic*[tiab]
 OR fibrinolys*[tiab]
 OR fibrinolytic*[tiab]
 OR alteplase[tiab]
 OR "tissue plasminogen activator"[tiab]
 OR "rt-PA"[tiab]
 OR tPA[tiab]
 OR tenecteplase[tiab]
 OR streptokinase[tiab]
 OR urokinase[tiab]
 OR "catheter-directed"[tiab]
 OR "catheter directed"[tiab]
 OR CDT[tiab]
 OR "ultrasound-assisted"[tiab]
 OR "ultrasound assisted"[tiab]
 OR "ultrasound-facilitated"[tiab]
 OR "ultrasound facilitated"[tiab]
 OR USAT[tiab]
 OR USCDT[tiab]
 OR EKOS[tiab]
 OR thrombectomy[tiab]
 OR embolectomy[tiab]
 OR aspiration[tiab]
 OR "large-bore"[tiab]
 OR "large bore"[tiab]
 OR FlowTriever[tiab]
 OR Inari[tiab]
 OR Indigo[tiab]
 OR Penumbra[tiab])
```

RCT block:

```text
("Randomized Controlled Trial"[Publication Type]
 OR "Controlled Clinical Trial"[Publication Type]
 OR randomized[tiab]
 OR randomised[tiab]
 OR randomly[tiab]
 OR randomization[tiab]
 OR randomisation[tiab]
 OR placebo[tiab]
 OR trial[tiab]
 OR "clinical trial"[Publication Type])
```

Animal exclusion:

```text
NOT (animals[mh] NOT humans[mh])
```

### 4.2 PubMed Main Search

```text
(("Pulmonary Embolism"[Mesh]
 OR "pulmonary embolism"[tiab]
 OR "pulmonary emboli"[tiab]
 OR "pulmonary embolus"[tiab]
 OR "pulmonary thromboembolism"[tiab]
 OR "pulmonary thromboemboli"[tiab]
 OR "acute pulmonary embolism"[tiab]
 OR "lung embolism"[tiab])
 AND
 (anticoag*[tiab]
 OR heparin[tiab]
 OR "unfractionated heparin"[tiab]
 OR "low molecular weight heparin"[tiab]
 OR LMWH[tiab]
 OR enoxaparin[tiab]
 OR dalteparin[tiab]
 OR fondaparinux[tiab]
 OR warfarin[tiab]
 OR rivaroxaban[tiab]
 OR apixaban[tiab]
 OR dabigatran[tiab]
 OR edoxaban[tiab]
 OR thrombolys*[tiab]
 OR thrombolytic*[tiab]
 OR fibrinolys*[tiab]
 OR fibrinolytic*[tiab]
 OR alteplase[tiab]
 OR "tissue plasminogen activator"[tiab]
 OR "rt-PA"[tiab]
 OR tPA[tiab]
 OR tenecteplase[tiab]
 OR streptokinase[tiab]
 OR urokinase[tiab]
 OR "catheter-directed"[tiab]
 OR "catheter directed"[tiab]
 OR CDT[tiab]
 OR "ultrasound-assisted"[tiab]
 OR "ultrasound assisted"[tiab]
 OR "ultrasound-facilitated"[tiab]
 OR "ultrasound facilitated"[tiab]
 OR USAT[tiab]
 OR USCDT[tiab]
 OR EKOS[tiab]
 OR thrombectomy[tiab]
 OR embolectomy[tiab]
 OR aspiration[tiab]
 OR "large-bore"[tiab]
 OR "large bore"[tiab]
 OR FlowTriever[tiab]
 OR Inari[tiab]
 OR Indigo[tiab]
 OR Penumbra[tiab])
 AND
 ("Randomized Controlled Trial"[Publication Type]
 OR "Controlled Clinical Trial"[Publication Type]
 OR randomized[tiab]
 OR randomised[tiab]
 OR randomly[tiab]
 OR randomization[tiab]
 OR randomisation[tiab]
 OR placebo[tiab]
 OR trial[tiab]
 OR "clinical trial"[Publication Type]))
 NOT (animals[mh] NOT humans[mh])
```

### 4.3 PubMed Risk-Enriched Supplementary Search

```text
(("Pulmonary Embolism"[Mesh]
 OR "pulmonary embolism"[tiab]
 OR "pulmonary emboli"[tiab]
 OR "pulmonary embolus"[tiab]
 OR "pulmonary thromboembolism"[tiab]
 OR "acute pulmonary embolism"[tiab])
 AND
 ("intermediate-risk"[tiab]
 OR "intermediate risk"[tiab]
 OR "intermediate-high"[tiab]
 OR "intermediate high"[tiab]
 OR "intermediate-low"[tiab]
 OR "intermediate low"[tiab]
 OR submassive[tiab]
 OR "sub-massive"[tiab]
 OR normotensive[tiab]
 OR "right ventricular dysfunction"[tiab]
 OR "RV dysfunction"[tiab]
 OR "RV/LV"[tiab]
 OR troponin[tiab])
 AND
 (thrombolys*[tiab]
 OR fibrinolys*[tiab]
 OR alteplase[tiab]
 OR tenecteplase[tiab]
 OR streptokinase[tiab]
 OR urokinase[tiab]
 OR "catheter-directed"[tiab]
 OR "catheter directed"[tiab]
 OR "ultrasound-assisted"[tiab]
 OR "ultrasound facilitated"[tiab]
 OR USAT[tiab]
 OR USCDT[tiab]
 OR EKOS[tiab]
 OR thrombectomy[tiab]
 OR embolectomy[tiab]
 OR aspiration[tiab]
 OR FlowTriever[tiab]
 OR Indigo[tiab]
 OR Penumbra[tiab])
 AND
 (randomized[tiab]
 OR randomised[tiab]
 OR randomly[tiab]
 OR trial[tiab]
 OR placebo[tiab]
 OR "Randomized Controlled Trial"[Publication Type]))
 NOT (animals[mh] NOT humans[mh])
```

### 4.4 PubMed Device-Term Supplementary Search

```text
(("pulmonary embolism"[tiab] OR "Pulmonary Embolism"[Mesh])
 AND
 (FlowTriever[tiab]
 OR Inari[tiab]
 OR Indigo[tiab]
 OR Penumbra[tiab]
 OR EKOS[tiab]
 OR USAT[tiab]
 OR USCDT[tiab]
 OR "large-bore"[tiab]
 OR "large bore"[tiab]
 OR thrombectomy[tiab]
 OR aspiration[tiab]))
```

## 5. Embase

### 5.1 Embase via Ovid

```text
1. exp pulmonary embolism/
2. (pulmonary embolism or pulmonary emboli or pulmonary embolus or pulmonary thromboembolism or pulmonary thromboemboli or acute pulmonary embolism or lung embolism).ti,ab,kw.
3. 1 or 2
4. exp anticoagulant therapy/ or exp anticoagulant agent/
5. exp thrombolytic therapy/ or exp fibrinolytic therapy/ or exp fibrinolytic agent/
6. exp thrombectomy/ or exp embolectomy/
7. (anticoag* or heparin or unfractionated heparin or low molecular weight heparin or LMWH or enoxaparin or dalteparin or fondaparinux or warfarin or rivaroxaban or apixaban or dabigatran or edoxaban).ti,ab,kw.
8. (thrombolys* or thrombolytic* or fibrinolys* or fibrinolytic* or alteplase or tissue plasminogen activator or rt-PA or tPA or tenecteplase or streptokinase or urokinase).ti,ab,kw.
9. (catheter-directed or catheter directed or CDT or ultrasound-assisted or ultrasound assisted or ultrasound-facilitated or ultrasound facilitated or USAT or USCDT or EKOS).ti,ab,kw.
10. (thrombectomy or embolectomy or aspiration or large-bore or large bore or FlowTriever or Inari or Indigo or Penumbra).ti,ab,kw.
11. 4 or 5 or 6 or 7 or 8 or 9 or 10
12. randomized controlled trial/ or controlled clinical trial/ or randomization/ or single blind procedure/ or double blind procedure/
13. (random* or placebo* or trial or groups).ti,ab,kw.
14. 12 or 13
15. 3 and 11 and 14
16. exp animal/ not exp human/
17. 15 not 16
```

Risk-enriched Ovid supplementary line:

```text
18. (intermediate-risk or intermediate risk or intermediate-high or intermediate high or intermediate-low or intermediate low or submassive or sub-massive or normotensive or right ventricular dysfunction or RV dysfunction or RV/LV or troponin).ti,ab,kw.
19. 3 and 11 and 14 and 18
20. 19 not 16
```

### 5.2 Embase.com Adaptation

```text
('pulmonary embolism'/exp OR 'pulmonary embolism':ti,ab,kw OR 'pulmonary emboli':ti,ab,kw OR 'pulmonary thromboembolism':ti,ab,kw)
AND
('anticoagulant therapy'/exp OR 'thrombolytic therapy'/exp OR 'thrombectomy'/exp
 OR anticoag*:ti,ab,kw OR heparin:ti,ab,kw OR thrombolys*:ti,ab,kw OR fibrinolys*:ti,ab,kw
 OR alteplase:ti,ab,kw OR tenecteplase:ti,ab,kw OR streptokinase:ti,ab,kw OR urokinase:ti,ab,kw
 OR 'catheter-directed':ti,ab,kw OR 'catheter directed':ti,ab,kw OR 'ultrasound-assisted':ti,ab,kw
 OR 'ultrasound facilitated':ti,ab,kw OR USAT:ti,ab,kw OR USCDT:ti,ab,kw OR EKOS:ti,ab,kw
 OR thrombectomy:ti,ab,kw OR embolectomy:ti,ab,kw OR aspiration:ti,ab,kw
 OR FlowTriever:ti,ab,kw OR Inari:ti,ab,kw OR Indigo:ti,ab,kw OR Penumbra:ti,ab,kw)
AND
('randomized controlled trial'/exp OR random*:ti,ab,kw OR placebo*:ti,ab,kw OR trial:ti,ab,kw)
NOT ('animal'/exp NOT 'human'/exp)
```

## 6. Cochrane CENTRAL

```text
([mh "Pulmonary Embolism"]
 OR "pulmonary embolism":ti,ab,kw
 OR "pulmonary emboli":ti,ab,kw
 OR "pulmonary thromboembolism":ti,ab,kw)
AND
(anticoag*:ti,ab,kw
 OR heparin:ti,ab,kw
 OR thrombolys*:ti,ab,kw
 OR fibrinolys*:ti,ab,kw
 OR alteplase:ti,ab,kw
 OR tenecteplase:ti,ab,kw
 OR streptokinase:ti,ab,kw
 OR urokinase:ti,ab,kw
 OR "catheter-directed":ti,ab,kw
 OR "catheter directed":ti,ab,kw
 OR "ultrasound-assisted":ti,ab,kw
 OR "ultrasound facilitated":ti,ab,kw
 OR USAT:ti,ab,kw
 OR USCDT:ti,ab,kw
 OR EKOS:ti,ab,kw
 OR thrombectomy:ti,ab,kw
 OR embolectomy:ti,ab,kw
 OR aspiration:ti,ab,kw
 OR FlowTriever:ti,ab,kw
 OR Inari:ti,ab,kw
 OR Indigo:ti,ab,kw
 OR Penumbra:ti,ab,kw)
```

CENTRAL already focuses on controlled trials, so no additional RCT filter is required for the main search. If the result set is very large, add:

```text
AND (random*:ti,ab,kw OR placebo:ti,ab,kw OR trial:ti,ab,kw)
```

## 7. Web of Science Core Collection

```text
TS=("pulmonary embolism" OR "pulmonary emboli" OR "pulmonary embolus" OR "pulmonary thromboembolism" OR "acute pulmonary embolism")
AND
TS=(anticoag* OR heparin OR "low molecular weight heparin" OR LMWH OR enoxaparin OR dalteparin OR fondaparinux OR warfarin OR rivaroxaban OR apixaban OR dabigatran OR edoxaban
 OR thrombolys* OR thrombolytic* OR fibrinolys* OR fibrinolytic* OR alteplase OR "tissue plasminogen activator" OR "rt-PA" OR tPA OR tenecteplase OR streptokinase OR urokinase
 OR "catheter-directed" OR "catheter directed" OR CDT OR "ultrasound-assisted" OR "ultrasound assisted" OR "ultrasound-facilitated" OR "ultrasound facilitated" OR USAT OR USCDT OR EKOS
 OR thrombectomy OR embolectomy OR aspiration OR "large-bore" OR "large bore" OR FlowTriever OR Inari OR Indigo OR Penumbra)
AND
TS=(random* OR placebo* OR trial OR "controlled trial" OR "clinical trial")
```

Risk-enriched supplementary Web of Science search:

```text
TS=("pulmonary embolism" OR "pulmonary emboli" OR "pulmonary thromboembolism")
AND
TS=("intermediate-risk" OR "intermediate risk" OR "intermediate-high" OR "intermediate high" OR "intermediate-low" OR "intermediate low" OR submassive OR "sub-massive" OR normotensive OR "right ventricular dysfunction" OR "RV dysfunction" OR "RV/LV" OR troponin)
AND
TS=(thrombolys* OR fibrinolys* OR alteplase OR tenecteplase OR streptokinase OR urokinase OR "catheter-directed" OR "catheter directed" OR "ultrasound-assisted" OR "ultrasound facilitated" OR thrombectomy OR aspiration OR FlowTriever OR Indigo OR Penumbra OR EKOS)
AND
TS=(random* OR placebo* OR trial)
```

## 8. Clinical Trial Registries

### 8.1 ClinicalTrials.gov

Primary registry search:

```text
Condition or disease: pulmonary embolism
Other terms: randomized OR thrombolysis OR catheter-directed OR thrombectomy OR aspiration OR anticoagulation OR FlowTriever OR Indigo OR EKOS
Study type: Interventional studies
Recruitment status: All studies
Age: Adult and older adult
```

Supplementary device searches:

```text
Condition or disease: pulmonary embolism
Other terms: FlowTriever

Condition or disease: pulmonary embolism
Other terms: Indigo OR Penumbra

Condition or disease: pulmonary embolism
Other terms: EKOS OR ultrasound-assisted OR ultrasound facilitated
```

### 8.2 WHO ICTRP

Use broad searches because interface syntax varies:

```text
pulmonary embolism AND randomized
pulmonary embolism AND thrombolysis
pulmonary embolism AND catheter-directed
pulmonary embolism AND thrombectomy
pulmonary embolism AND FlowTriever
pulmonary embolism AND Indigo
pulmonary embolism AND EKOS
```

## 9. Chinese Databases

Databases: CNKI, Wanfang Data, VIP, SinoMed/CBM.

### 9.1 Main Chinese Search

```text
(肺栓塞 OR 肺血栓栓塞 OR 急性肺栓塞)
AND
(抗凝 OR 肝素 OR 低分子肝素 OR 依诺肝素 OR 达肝素 OR 华法林 OR 利伐沙班 OR 阿哌沙班
 OR 溶栓 OR 纤溶 OR 阿替普酶 OR 替奈普酶 OR 链激酶 OR 尿激酶
 OR 导管溶栓 OR 导管定向溶栓 OR 超声辅助溶栓 OR 超声辅助导管溶栓
 OR 机械取栓 OR 抽吸取栓 OR 血栓切除 OR FlowTriever OR Indigo OR Penumbra OR EKOS)
AND
(随机 OR 随机对照 OR 对照试验 OR 临床试验)
```

### 9.2 Risk-Enriched Chinese Supplementary Search

```text
(肺栓塞 OR 肺血栓栓塞 OR 急性肺栓塞)
AND
(中危 OR 中高危 OR 中低危 OR 次大面积 OR 非高危 OR 血流动力学稳定
 OR 右心功能不全 OR 右室功能不全 OR 右心室扩大 OR 右室扩大 OR RV/LV OR 肌钙蛋白)
AND
(抗凝 OR 溶栓 OR 导管溶栓 OR 超声辅助溶栓 OR 机械取栓 OR 抽吸取栓 OR 血栓切除)
AND
(随机 OR 随机对照 OR 对照试验 OR 临床试验)
```

### 9.3 Chinese Search Notes

1. For each Chinese database, adapt field tags to title/abstract/keyword when possible.
2. Record whether the database supports simplified/traditional variants and whether subject terms were used.
3. Export all available bibliographic fields, abstracts, keywords, DOI, journal, year, and source database.

## 10. Handsearching and Citation Chasing

Sources:

1. Included RCT reference lists.
2. Previous systematic reviews and network meta-analyses on PE thrombolysis, catheter-directed therapy, and thrombectomy.
3. ESC, CHEST, ASH, AHA, and ERS PE guidelines and cited RCTs.
4. Trial acronyms and device names: PEITHO, ULTIMA, SUNSET sPE, CANARY, PEERLESS, STORM-PE, HI-PEITHO, STRATIFY, PRETHA, MOPETT, EKOS, FlowTriever, Indigo, Penumbra.

## 11. Export and Deduplication Plan

Export all records in RIS or XML when available, plus CSV where needed.

Recommended file naming:

```text
01_search_strategy/records_exports/YYYYMMDD_database_platform_main.ris
01_search_strategy/records_exports/YYYYMMDD_database_platform_risk_enriched.ris
01_search_strategy/records_exports/YYYYMMDD_database_platform_device.ris
```

Deduplication sequence:

1. Import all records into Zotero or EndNote.
2. Deduplicate using DOI, PMID, trial registration number, title, year, journal, and first author.
3. Export deduplicated records for screening.
4. Preserve database-specific raw exports and a deduplication report for PRISMA.

## 12. Search Log Template

| Database | Platform | Search date | Searcher | Search name | Exact query/file | Limits | Records retrieved | Export file | Notes |
|---|---|---:|---|---|---|---|---:|---|---|
| PubMed/MEDLINE | PubMed | TBD | TBD | Main | Section 4.2 | Inception to search date; no language restriction | TBD | TBD | Broad main RCT search |
| PubMed/MEDLINE | PubMed | TBD | TBD | Risk-enriched | Section 4.3 | Inception to search date; no language restriction | TBD | TBD | Sensitivity search |
| PubMed/MEDLINE | PubMed | TBD | TBD | Device terms | Section 4.4 | Inception to search date; no language restriction | TBD | TBD | Device and acronym capture |
| Embase | Ovid/Embase.com | TBD | TBD | Main | Section 5 | Inception to search date; no language restriction | TBD | TBD | Platform syntax to be finalized at execution |
| CENTRAL | Cochrane Library | TBD | TBD | Main | Section 6 | Inception to search date; no language restriction | TBD | TBD | Trial database |
| Web of Science | Core Collection | TBD | TBD | Main | Section 7 | Inception to search date; no language restriction | TBD | TBD | Citation database |
| ClinicalTrials.gov | Registry | TBD | TBD | Registry | Section 8.1 | All statuses | TBD | TBD | Completed and ongoing RCTs |
| WHO ICTRP | Registry | TBD | TBD | Registry | Section 8.2 | All statuses | TBD | TBD | International registry search |
| CNKI | CNKI | TBD | TBD | Main | Section 9.1 | Inception to search date; no language restriction | TBD | TBD | Chinese database |
| Wanfang | Wanfang | TBD | TBD | Main | Section 9.1 | Inception to search date; no language restriction | TBD | TBD | Chinese database |
| VIP | VIP | TBD | TBD | Main | Section 9.1 | Inception to search date; no language restriction | TBD | TBD | Chinese database |
| SinoMed/CBM | SinoMed/CBM | TBD | TBD | Main | Section 9.1 | Inception to search date; no language restriction | TBD | TBD | Chinese biomedical database |

## 13. Immediate Next Step

Execute PubMed main, risk-enriched, and device-term searches first. Record exact search date, record counts, exported file names, and any syntax changes. Then execute Embase, CENTRAL, Web of Science, ClinicalTrials.gov, WHO ICTRP, and Chinese database searches using the same log template.
