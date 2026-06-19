# V1-ALL PDF 全文筛选续表 v0.1

日期：2026-06-19

## 1. 本轮目的

对用户提供的 `V1-ALL` 文件夹中的 17 个 PDF 路径进行全文抽取、去重识别、节点映射和纳入状态判断，并与此前 24 个 PDF 正式筛选 v0.1 结果衔接。

本轮仍按 PICOS v0.2 判断：成人急性中危 PE，RCT-only，六节点为 AC、ST、CDT、USCDT、LBAT、CAT。

## 2. 上一批 24 个 PDF 的纳入清单回顾

上一批正式全文筛选 v0.1 中，按 24 个 PDF 路径、22 个独立全文记录判断：

### 2.1 已列为主分析纳入候选

| 研究 | 文件线索 | 节点 | 备注 |
|---|---|---|---|
| PEITHO / Meyer 2014 | `44 Fibrinolysis for patients with.pdf` | ST vs AC | 中高危 PE；强匹配。 |
| Ahmed 2018 / streptokinase submassive PE | `49 value_of_thrombolytic_therapy_for_submassive...pdf` | ST vs AC | 需提取 RVD、troponin/BNP 映射风险层级。 |
| Fasullo 2011 | `27 Six month echocardiographic study...PDF` | ST vs AC | submassive PE + RVD；需补 biomarker 分层。 |
| Zhang 2018 | `31 Clinical efficacy of low dose rt-PA...pdf` | ST vs AC | 低剂量 rt-PA；主节点 ST，保留剂量变量。 |
| Sinha 2017 | `28 Efficacy and Safety of Thrombolytic...pdf` | ST vs AC | submassive/intermediate-risk PE。 |

### 2.2 暂列待风险映射

| 研究 | 节点 | 暂缓原因 |
|---|---|---|
| PIOPED rt-PA 1990 | ST vs AC | 旧研究、样本量小，未按现代中危 PE 标准入组。 |
| PAIMS 2 | ST vs AC | 旧研究、标题/背景偏 massive PE，需确认是否可提取非高危/中危数据。 |

### 2.3 已排除主分析

上一批其余文献因 high-risk/massive PE、非 RCT、post hoc/二次分析、回顾性研究、单臂或剂量优化、AC 内部比较、ST 内部比较、或非六节点干预而排除主分析。

## 3. 本轮 V1-ALL 文件处理方法

使用 `scripts/extract_v1all_pdf_index.py` 抽取全文文本、页数、字符数和 SHA-256 前 16 位哈希。文本输出目录为 `C:\tmp\pe_nma_v1all_screening_text`，索引文件为 `C:\tmp\pe_nma_v1all_screening_index.json`。

本轮 17 个 PDF 路径均可访问并可抽取文本。No. 12 `Alteplase versus heparin i.PDF` 仅抽取到 749 个字符，疑似扫描/版权影印页，需 OCR 或人工阅读后再作最终判断。

## 4. V1-ALL 逐篇全文筛选表

| No. | 文件/研究识别 | 研究设计与人群 | 干预/对照 | 节点映射 | v0.1 判定 | 理由与下一步 |
|---:|---|---|---|---|---|---|
| 01 | TOPCOAT：`Treatment of submassive pulmonary embolism with tenecteplase or placebo` | 多中心、双盲、安慰剂对照 RCT；normotensive submassive PE + RV strain | Tenecteplase vs placebo，均抗凝 | ST vs AC | 纳入候选 | 可补上此前 TOPCOAT 原始主文缺口；提取死亡、循环休克/插管/复发、功能结局、出血/ICH。 |
| 02 | ULTIMA：`Randomized controlled trial of ultrasound-assisted catheter-directed thrombolysis` | RCT；acute intermediate-risk PE，RV/LV ratio >=1.0 | USAT/USCDT + UFH vs UFH | USCDT vs AC | 纳入候选 | 关键 USCDT-AC 直接边；提取 RV/LV 24h、死亡、出血、复发 VTE。 |
| 03 | PEITHO / Meyer 2014 | RCT；intermediate-risk PE，RV dysfunction + positive troponin | Tenecteplase + heparin vs placebo + heparin | ST vs AC | 纳入候选；与上一批同研究 | 与上一批 PEITHO 重复研究但不同文件来源；正式去重时只保留一条研究记录。 |
| 04 | SUNSET sPE | 多中心、随机、head-to-head、single-blind RCT；submassive/intermediate-risk PE | Standard CDT vs ultrasound-assisted thrombolysis/EKOS | CDT vs USCDT | 纳入候选 | 关键 CDT-USCDT 直接边；主要结局为肺动脉血栓负荷变化，另提取 RV/LV、出血和临床事件。 |
| 05 | CANARY | 随机临床试验；acute intermediate-high-risk PE | Catheter-directed thrombolysis vs anticoagulation | CDT vs AC | 纳入候选 | 关键 CDT-AC 直接边；提取 RV recovery、临床恶化、死亡、出血。 |
| 06 | PEERLESS primary results | 前瞻性、多中心 RCT；550 例 intermediate-risk PE，RV dilatation + 临床风险因素 | Large-bore mechanical thrombectomy vs CDT | LBAT vs CDT | 纳入候选 | 关键 LBAT-CDT 直接边；需记录 CDT 对照是否含 USCDT/普通 CDT 组成。主结局为分层 win ratio 复合结局。 |
| 07 | STORM-PE primary outcomes | 国际 RCT；acute intermediate-high-risk PE，RV enlargement + biomarkers | Computer-assisted vacuum thrombectomy with AC vs AC alone；Penumbra Lightning Flash 16F | CAT vs AC | 纳入候选 | 关键 CAT-AC 直接边；提取 RV/LV 48h、PA obstruction、生命体征、安全性和 90 天随访。 |
| 08 | STRATIFY | 多中心、开放、三臂 RCT；acute intermediate-high-risk PE | Low-dose USAT vs IV low-dose alteplase vs heparin | USCDT vs ST vs AC | 纳入候选 | 三臂网络信息量高；主分析 ST 节点需保留低剂量变量，可做敏感性或亚节点分析。 |
| 09 | PRETHA | 单中心、前瞻性、三臂 RCT；39 例 acute intermediate-high-risk PE | Penumbra Indigo CAT8 thrombectomy vs trans-catheter thrombolysis vs anticoagulation | CAT vs CDT vs AC | 纳入候选 | 三臂试验，使用 Penumbra Indigo CAT8，映射为 CAT；样本量小但可连接 CAT、CDT、AC。 |
| 10 | HI-PEITHO | 开放、随机、盲法事件 adjudication RCT；acute intermediate-risk PE | Ultrasound-facilitated catheter-directed fibrinolysis + AC vs AC | USCDT vs AC | 纳入候选 | 关键大型临床结局 RCT；提取 7 天复合结局、30 天大出血、ICH、死亡/失代偿。 |
| 11 | MAPPET-3 / Konstantinides 2002 | RCT；submassive PE | Heparin + alteplase vs heparin alone | ST vs AC | 纳入候选 | 经典 ST-AC 研究；需按现代标准映射中危层级，优先提取临床恶化、死亡、出血。 |
| 12 | Haire 1993：`Alteplase versus heparin in acute pulmonary embolism` | Randomised trial 线索；文本抽取不足 | Alteplase vs heparin | ST vs AC | 待 OCR/风险映射 | 仅抽取到 749 字符，无法可靠判断风险层级和结局；需 OCR 或人工阅读扫描页。 |
| 13 | EuroIntervention 2022 pilot CDT trial | 随机 pilot study；intermediate-high risk acute PE | CDT alteplase 20 mg vs standard anticoagulation | CDT vs AC | 纳入候选 | 小样本但为 CDT-AC 直接边；提取 RV function、CTA、出血和临床稳定性。 |
| 14 | Fasullo 2011 | RCT；submassive PE + RVD | Thrombolysis + heparin vs heparin | ST vs AC | 纳入候选；与上一批同研究 | 与上一批重复研究，正式去重时只保留一条。 |
| 15 | Sinha 2017 | 前瞻性随机研究；acute submassive PE | Tenecteplase + UFH vs placebo + UFH | ST vs AC | 纳入候选；与上一批同研究 | 与上一批同研究；正式去重时只保留一条。 |
| 16 | Zhang 2018 | RCT；acute intermediate-risk PE | Low-dose rt-PA + LMWH vs LMWH | ST vs AC | 纳入候选；与上一批同研究 | 与上一批同研究；正式去重时只保留一条，并保留低剂量变量。 |
| 17 | MOPETT | 前瞻性随机对照；moderate PE | Safe-dose/low-dose tPA + anticoagulation vs anticoagulation | ST vs AC | 纳入候选，需风险映射 | “Moderate PE”不完全等同 ESC intermediate-risk；需核验 RVD/biomarker/血压标准后决定主分析或敏感性。 |

## 5. 本轮新增的关键网络边

本轮 V1-ALL 明显改善网络连通性，新增或确认以下直接比较：

| 直接比较 | 代表研究 |
|---|---|
| ST vs AC | TOPCOAT、PEITHO、MAPPET-3、Fasullo、Sinha、Zhang、MOPETT 等 |
| USCDT vs AC | ULTIMA、STRATIFY、HI-PEITHO |
| CDT vs AC | CANARY、EuroIntervention 2022 pilot、PRETHA |
| CDT vs USCDT | SUNSET sPE |
| LBAT vs CDT | PEERLESS |
| CAT vs AC | STORM-PE、PRETHA |
| CAT vs CDT | PRETHA |

## 6. 当前合并判断

上一批确认的 5 篇纳入候选仍保留；本轮 V1-ALL 又补上多个关键 RCT，尤其是 ULTIMA、CANARY、PEERLESS、STORM-PE、STRATIFY、PRETHA、HI-PEITHO，使 6 节点网络从理论设计转为有实际连接的可能。

当前最需要立即做的不是再改 PICOS，而是建立正式数据提取表 v0.1，并做两项核验：

1. 研究去重：同一研究不同 PDF 来源只保留一条研究记录。
2. 风险映射：把 submassive、moderate、intermediate、intermediate-high 等旧/新术语统一映射到 NMA-1/NMA-2/NMA-3。

## 7. 待确认事项

- No. 12 Haire 1993 需要 OCR 或人工阅读。
- MOPETT 是否进入主分析，取决于是否能映射为中危 PE。
- PEERLESS 对照组 CDT 的具体组成需提取，判断是否能完全归入 CDT，或是否包含 USCDT 混合。
- STRATIFY 的低剂量 IV alteplase 主分析先归入 ST，但应保留 low-dose 字段，后续用于敏感性分析。
