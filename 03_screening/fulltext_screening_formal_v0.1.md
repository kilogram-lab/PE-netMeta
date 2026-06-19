# 肺栓塞网状 Meta 分析：正式全文筛选 v0.1

日期：2026-06-19

## 1. 本轮目的

对用户提供的 24 个 PDF 路径启动正式全文筛选流程，按 PICOS v0.2 判断是否可进入成人急性中危肺栓塞 RCT-only 六节点网状 Meta 分析。

## 2. 筛选依据

- Population：成人急性 intermediate-risk PE；主分析排除 low-risk PE 和 high-risk/massive PE。若旧研究无法直接对应 ESC 2019 风险层级，则标记为“待风险映射”。
- Interventions / Comparators：AC、ST、CDT、USCDT、LBAT、CAT 六节点之间的随机比较。
- Outcomes：死亡、临床恶化/血流动力学失代偿、大出血、颅内出血、PE 复发、右心功能恢复、肺动脉压下降等。
- Study design：仅纳入 RCT。post hoc、二次分析、回顾性研究、单臂研究、剂量优化研究、非六节点药物/氧疗/机制研究不进入主分析。

## 3. 文件处理方法

使用 `scripts/extract_screening_pdf_index.py` 对 24 个 PDF 进行全文文本抽取、页数统计和 SHA-256 前 16 位哈希去重。文本输出至 `C:\tmp\pe_nma_formal_screening_text`，索引输出至 `C:\tmp\pe_nma_formal_screening_index.json`。

本轮共 24 个 PDF 路径，按哈希识别出 2 个重复路径：

- No. 09 与 No. 07 为同一篇全文。
- No. 13 与 No. 08 为同一篇全文。

因此，本轮为 24 个 PDF 路径、22 个独立全文记录。

## 4. 总体结论

本轮初步确认 5 篇可作为主分析候选 RCT，均为 ST vs AC：

| 候选 | 研究/文件 | 节点 | 风险层级初判 |
|---|---|---|---|
| 1 | PEITHO / Meyer 2014 | ST vs AC | 中高危 PE |
| 2 | Ahmed 2018 / streptokinase submassive PE | ST vs AC | 中危 PE，需提取 biomarker 细节 |
| 3 | Fasullo 2011 | ST vs AC | submassive PE，需提取 biomarker 细节 |
| 4 | Zhang 2018 low-dose rt-PA | ST vs AC | intermediate-risk PE |
| 5 | Sinha 2017 tenecteplase | ST vs AC | submassive / intermediate-risk PE |

另有 2 篇老 RCT 暂不直接进入主分析，需做风险映射后再定：

- PIOPED rt-PA 1990：RCT，ST vs AC，但样本量极小且未按现代中危 PE 标准入组。
- PAIMS 2：RCT，ST vs AC，但原文为 acute massive PE 背景，需确认是否能排除高危或提取非高危数据。

当前这批 PDF 尚未确认可直接纳入 CDT、USCDT、LBAT、CAT 节点的独立 RCT 主文。PEERLESS 相关 PDF 是 post hoc/补充分析，应继续查找 PEERLESS 原始主报告；TOPCOAT 当前 PDF 是二次生物标志物分析，应继续查找 TOPCOAT 原始主报告。

## 5. 逐篇全文筛选表

| No. | 文件/研究识别 | 设计 | 人群判断 | 干预/对照 | 节点映射 | v0.1 判定 | 理由与下一步 |
|---:|---|---|---|---|---|---|---|
| 01 | `44 Fibrinolysis for patients with.pdf`；PEITHO / Meyer 2014 | RCT，双盲 | 血流动力学稳定，RV dysfunction + positive troponin | Tenecteplase + heparin vs placebo + heparin | ST vs AC | 纳入候选 | 强匹配中高危 PE；提取死亡、临床恶化/失代偿、大出血、卒中/ICH、复发 PE。 |
| 02 | `46 .PDF`；systemic or local thrombolysis in high-risk PE | RCT | high-risk PE | 全身 vs 局部/肺动脉溶栓 | 非主分析节点 | 排除主分析 | 高危 PE，不符合中危 PE 主分析；可归档为高危背景。 |
| 03 | `47 Streptokinase and Heparin versus Heparin Alone...1995.PDF` | RCT | massive PE | Streptokinase + heparin vs heparin | ST vs AC | 排除主分析 | massive/high-risk PE，不符合中危 PE 主分析。 |
| 04 | `48 Tissue plasminogen activator...Chest 1990.PDF`；PIOPED rt-PA | RCT，双盲 | 急性 PE；排除 shock/major disability，但未按 RV dysfunction/troponin 入组 | rt-PA + heparin vs placebo + heparin | ST vs AC | 待风险映射 | 样本量 13 例，旧研究不满足现代中危定义；若无法确认中危或提取亚组，应排除主分析。 |
| 05 | `49 value_of_thrombolytic_therapy_for_submassive.13(1).pdf` | RCT | submassive PE，血流动力学稳定，疑似 RV/biomarker 阳性 | Streptokinase + anticoagulation vs anticoagulation | ST vs AC | 纳入候选 | 符合 ST vs AC；需提取 RVD、troponin/BNP、出血和死亡定义，映射中低危/中高危。 |
| 06 | `50 PAIMS 2 alteplase combined.PDF` | RCT，开放 | 急性 PE；标题/背景偏 massive PE；排除 cardiogenic shock | Alteplase + heparin vs heparin | ST vs AC | 待风险映射 | 可能为旧式重症/混合人群；需确认血压、RVD/biomarker 与是否可作为中危 PE。 |
| 07 | `27 Six month echocardiographic study...V5.PDF`；Fasullo 2011 | RCT，双盲 | submassive PE，正常血压，RVD | Thrombolysis + heparin vs placebo/heparin | ST vs AC | 纳入候选 | 可提取右心功能、PASP、临床恶化、死亡/复发和出血；需补 biomarker 以分层。 |
| 08 | `31 Clinical efficacy of low dose rt-PA...V5.pdf`；Zhang 2018 | RCT | acute intermediate-risk PE | Low-dose rt-PA + LMWH vs LMWH | ST vs AC | 纳入候选 | 主分析归入 ST，保留低剂量变量用于敏感性/亚节点分析。 |
| 09 | `27 Six month echocardiographic study...V4.PDF` | 重复全文 | 同 No. 07 | 同 No. 07 | 同 No. 07 | 排除重复 | SHA 与 No. 07 一致；不重复计数。 |
| 10 | `28 Efficacy and Safety of Thrombolytic...2017.pdf`；Sinha 2017 | RCT，前瞻性 | acute submassive / intermediate-risk PE | Tenecteplase + UFH vs placebo + UFH | ST vs AC | 纳入候选 | 可提取死亡、血流动力学失代偿、复发 PE、大出血、出血性卒中；需确认 RVD 与 biomarker。 |
| 11 | `29 Comparison of acute and convalescent biomarkers...pdf` | TOPCOAT 二次/生物标志物分析 | acute PE 试验亚样本 | Tenecteplase vs placebo 的二次指标 | ST vs AC 信息源 | 不作为独立 RCT | 不是独立主报告；用于补充 TOPCOAT 资料。下一步查找 TOPCOAT 原始主报告。 |
| 12 | `30 Diclofenac for reversal of right ventricular dysfunction...PDF`；AINEP | RCT | intermediate-risk PE | Diclofenac vs placebo，均抗凝 | 非六节点 | 排除主分析 | 干预为 NSAID，不属于 AC/ST/CDT/USCDT/LBAT/CAT 六节点。 |
| 13 | `31 Clinical efficacy of low dose rt-PA...V4.pdf` | 重复全文 | 同 No. 08 | 同 No. 08 | 同 No. 08 | 排除重复 | SHA 与 No. 08 一致；不重复计数。 |
| 14 | `32 One Year Echocardiographic Functional...2020.PDF`；OPTALYSE follow-up | RCT 随访/剂量研究 | intermediate-risk PE | USCDT 不同 tPA 剂量/时长 | USCDT 内部剂量 | 排除主分析 | 不比较六节点之间治疗策略；可作为 USCDT 长期结局背景。 |
| 15 | `33 Intermediate Term Outcomes...J Invasive Cardiol 2021.PDF.pdf` | 回顾性 | submassive PE | CDT 单队列/观察性 | CDT 背景 | 排除主分析 | 非 RCT，且无法作为独立网络比较。 |
| 16 | `34 Outcomes of Catheter Based Pulmonary...Cureus 2023.pdf` | 回顾性/单中心 | submassive/massive 混合 | FlowTriever 等 catheter-based therapy | LBAT/CAT 背景 | 排除主分析 | 非 RCT，且混合高危/中危。 |
| 17 | `35 DS-1040...randomized phase 1b study.pdf` | RCT，phase 1b | intermediate-risk PE | DS-1040 + enoxaparin vs placebo + enoxaparin | 非六节点 | 排除主分析 | 新型 TAFI 抑制剂/机制与剂量探索，不属于预设治疗节点。 |
| 18 | `36 Oxygen therapy in patients with intermediate-risk PE...Chest 2023.pdf` | RCT，开放 proof-of-concept | intermediate-risk PE | Oxygen therapy + anticoagulation vs anticoagulation | 非六节点 | 排除主分析 | 氧疗不是预设治疗节点；可作支持治疗背景。 |
| 19 | `37 Aspiration thrombectomy compared to...Cardiol J 2025.pdf` | 回顾性 | submassive/massive PE | Penumbra aspiration vs EKOS/CDT | CAT vs USCDT 背景 | 排除主分析 | 非 RCT；可用于讨论但不能进入 RCT-only NMA。 |
| 20 | `38 Evaluation of Catheter Directed...JVIR 2025.pdf`；PEERLESS 相关 | post hoc 分析 | intermediate-risk PE 相关 | PEERLESS CDT arm 内部差异 | 补充信息 | 不作为独立 RCT | 不是独立随机比较主报告；下一步查找 PEERLESS 原始主报告用于 LBAT vs CDT/USCDT 判断。 |
| 21 | `23 Randomized trial of subcutaneous low...Circulation 1992.PDF` | RCT | submassive PE | LMWH/CY 216 vs IV UFH | AC 内部比较 | 排除主分析 | 比较抗凝方案/剂量/给药方式，均属于 AC 节点内部，不形成六节点网络边。 |
| 22 | `24 Subcutaneous low molecular weight heparin fragmin...1995.PDF.pdf` | RCT，开放 pilot | acute non-massive PE | LMWH vs UFH | AC 内部比较 | 排除主分析 | AC 节点内部比较，不进入治疗策略 NMA。 |
| 23 | `25 Time course of platelet aggregation...2007.PDF` | 小样本随机/机制研究 | massive 或 submassive PE 混合 | Ultrahigh-dose streptokinase vs tPA | ST 内部比较 | 排除主分析 | 比较两种系统溶栓方案且含 massive PE；主要为血小板/纤维蛋白原机制指标，不形成六节点主网络边。 |
| 24 | `26 Endogenous plasma activated protein...Crit Care 2011.PDF` | RCT/探索性 | acute submassive PE | Drotrecogin alfa + enoxaparin vs enoxaparin | 非六节点 | 排除主分析 | DAA/activated protein C 机制治疗不属于六节点；主要为凝血标志物研究。 |

## 6. 立即下一步

1. 对 5 篇纳入候选 RCT 建立正式数据提取表 v0.1，字段包括作者、年份、风险层级、样本量、节点、剂量、死亡、临床恶化、大出血、ICH、复发 PE、右心功能、随访时间。
2. 对 PIOPED 1990 和 PAIMS 2 做第二轮风险映射，若不能明确为中危 PE，主分析排除。
3. 补找原始主报告：TOPCOAT、PEERLESS，以及 ULTIMA 等可能连接 CDT/USCDT/LBAT/CAT 节点的 RCT。
4. 将正式检索和全文筛选继续分开记录：本批 PDF 是用户提供的候选全文，不等同于最终系统检索结果。
