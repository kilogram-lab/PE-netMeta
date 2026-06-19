import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/02肺栓塞网状meta-cdex版";
const tempDir = path.join(outputDir, "01临时文件");
const outputXlsx = path.join(outputDir, "PICOS_v0.2_及_RCT证据矩阵.xlsx");
const outputTxt = path.join(outputDir, "PICOS_v0.2.txt");

await fs.mkdir(outputDir, { recursive: true });
await fs.mkdir(tempDir, { recursive: true });

const today = "2026-06-19";

const picosText = `# PICOS v0.2

项目题目暂定：
Comparative efficacy and safety of reperfusion and anticoagulation strategies for acute intermediate-risk pulmonary embolism: a systematic review and network meta-analysis of randomised controlled trials

版本：v0.2
日期：${today}
用途：在用户既往 PICOS 基础上升级形成的工作版，用于正式检索、筛选、RCT 证据矩阵更新和后续 PROSPERO/protocol 写作。该版本将研究主题聚焦为 intermediate-risk PE，并预设 NMA-1、NMA-2、NMA-3 三个分层分析框架。

P - Population：
成人急性中危肺栓塞（intermediate-risk PE）。优先按 ESC 2019 风险分层并结合后续指南/共识表述进行映射：中低危 PE 为血流动力学稳定，并存在肌钙蛋白升高或右心功能不全之一；中高危 PE 为血流动力学稳定，并同时存在肌钙蛋白升高和右心功能不全。计划设置三个分析层：NMA-1 中低危 PE，NMA-2 中高危 PE，NMA-3 所有中危 PE。排除低危 PE（血流动力学稳定且无肌钙蛋白升高、无右心功能不全）和高危 PE（血流动力学不稳定，如 SBP <90 mmHg 持续至少 15 分钟、SBP 下降 >=40 mmHg 或需要血管活性药物/休克/心脏骤停）。儿童、妊娠、慢性血栓栓塞性肺高压、单纯 DVT、非急性 PE、动物或体外研究排除。

I/C - Interventions and Comparators：
预设 6 个主要 NMA 节点：1）单纯抗凝（AC；UFH/LMWH/DOAC），2）系统溶栓（ST；rt-PA、TNK、链激酶等），3）导管导向溶栓（CDT；多孔导管等），4）超声辅助 CDT（USCDT；如 EKOS），5）大口径抽吸取栓（LBAT；如 FlowTriever/Inari），6）导管辅助抽吸取栓（CAT；如 Indigo/Penumbra）。所有 6 个节点之间的直接或间接比较均为目标比较。若正式 RCT 网络显示某些节点无法连通或结局数据过少，需按 protocol 预设合并或叙述性分析规则，不能事后任意改变节点。

O - Outcomes：
主要结局：全因死亡和临床恶化，均作为二分类变量；临床恶化可包括血流动力学崩溃、抢救性再灌注、循环支持升级、插管/复苏或研究定义的临床失败。
次要结局：大出血（优先 ISTH 标准，其次采用研究定义并标记）、颅内出血、PE 复发、右心功能恢复、肺动脉压下降。
安全性结局：小出血、输血需求、肾功能损害、器械相关并发症。所有结局需记录时间窗，优先院内、48-72 小时、7 天、30 天和最长随访分层。

S - Study Design：
仅纳入随机对照试验（RCT）。使用 Cochrane RoB 2.0 评价偏倚风险。排除观察性研究、病例报告、病例系列、剂量优化研究、二级预防研究、综述、评论和指南。NOS 评分不适用，因为 NOS 用于观察性研究，本研究主分析仅纳入 RCT。

关键执行原则：
1. v0.2 将研究主题正式聚焦为 intermediate-risk PE，不再将高危 PE 纳入主研究对象。
2. 6 个节点作为当前主分析候选节点锁定用于检索和提取；最终能否分别建模取决于每个结局的 RCT 网络连通性。
3. NMA-1、NMA-2、NMA-3 是本项目的重要创新点：中低危、中高危和所有中危分层必须在数据提取阶段同步标记。
4. 不只报告治疗排序，必须报告证据确定性、偏倚风险、不一致性、异质性和临床净获益。
`;

await fs.writeFile(outputTxt, picosText, "utf8");

const picosRows = [
  ["Domain", "v0.2 Decision", "Operational Definition", "Notes / v1.0 Issues"],
  ["Population", "Adults with acute intermediate-risk PE only", "Intermediate-low, intermediate-high, and mixed intermediate-risk PE; exclude low-risk and high-risk PE from main analysis", "Use ESC 2019 definitions as anchor; map trial definitions carefully"],
  ["Population strata", "NMA-1, NMA-2, NMA-3", "NMA-1 intermediate-low; NMA-2 intermediate-high; NMA-3 all intermediate-risk mixed", "Extract cTn status and RV dysfunction status for every study/arm if available"],
  ["Intervention", "Six candidate nodes locked for search/extraction", "AC, ST, CDT, USCDT, LBAT, CAT", "Final modeling may combine sparse nodes only if pre-specified"],
  ["Comparator", "Any eligible randomized comparator among the six nodes", "Direct and indirect comparisons across all connected nodes", "Multi-arm trials retained if randomized"],
  ["Primary outcome", "All-cause death and clinical deterioration", "Binary outcomes; record exact time point and composite definition", "Clinical deterioration definition must be harmonized before analysis"],
  ["Secondary outcomes", "Major bleeding, ICH, PE recurrence, RV recovery, pulmonary pressure reduction", "Prefer ISTH for major bleeding; record trial definition when ISTH unavailable", "Continuous RV outcomes may need separate NMA/pairwise analysis"],
  ["Safety outcomes", "Minor bleeding, transfusion, renal injury, device-related complications", "Device complications particularly important for LBAT/CAT/CDT/USCDT", "May be sparse; report narratively if NMA impossible"],
  ["Study design", "RCT only", "Use Cochrane RoB 2.0; NOS not applicable", "Exclude observational studies, case reports, dose-optimization and secondary-prevention studies"],
];

const nodeRows = [
  ["Node Code", "Node Name", "Working Definition", "Main Analysis?", "Sensitivity / Split Options"],
  ["AC", "Anticoagulation alone", "UFH, LMWH, DOAC/VKA, or standard anticoagulation without planned reperfusion", "Yes", "UFH vs LMWH vs DOAC if enough RCTs"],
  ["ST", "Systemic thrombolysis", "Systemic thrombolytic therapy, including rt-PA, tenecteplase, streptokinase, urokinase; dose recorded separately", "Yes", "Split full-dose vs reduced-dose and by drug if enough RCTs"],
  ["CDT", "Catheter-directed thrombolysis", "Catheter-directed local thrombolysis via multi-side-hole or comparable infusion catheter without ultrasound assistance", "Yes if connected", "Split drug, dose, infusion duration"],
  ["USCDT", "Ultrasound-assisted catheter-directed thrombolysis", "Ultrasound-facilitated CDT, such as EKOS", "Yes if connected", "Combine with CDT only by pre-specified sparse-network rule"],
  ["LBAT", "Large-bore aspiration thrombectomy", "Large-bore mechanical/aspiration thrombectomy, e.g. FlowTriever/Inari", "Yes if connected", "Device-specific analysis if multiple LBAT devices emerge"],
  ["CAT", "Catheter-assisted aspiration thrombectomy", "Catheter-assisted vacuum/aspiration thrombectomy, e.g. Indigo/Penumbra", "Yes if connected", "Device-specific analysis if enough RCTs"],
];

const outcomeRows = [
  ["Outcome", "Priority", "Type", "Preferred Time Window", "Extraction Notes"],
  ["All-cause death", "Primary", "Dichotomous", "In-hospital, 7 d, 30 d, closest early time point", "Record exact timing; do not mix long-term unless separate"],
  ["Clinical deterioration", "Primary", "Dichotomous composite", "In-hospital to 30 d", "Extract each component: hemodynamic collapse, bailout therapy, intubation, circulatory support, CPR, trial-defined failure"],
  ["Major bleeding", "Secondary / key safety", "Dichotomous", "In-hospital to 30 d", "Prefer ISTH; otherwise trial definition with sensitivity flag"],
  ["Intracranial hemorrhage", "Secondary / key safety", "Dichotomous", "In-hospital to 30 d", "Rare event methods may be needed"],
  ["Recurrent PE", "Secondary efficacy", "Dichotomous", "30 d and longest follow-up", "Separate PE recurrence from all VTE if possible"],
  ["RV function recovery", "Secondary efficacy", "Continuous/dichotomous", "24-72 h, 7 d, 30 d, 90 d", "RV/LV ratio, TAPSE, RV dysfunction resolution; record modality"],
  ["Pulmonary artery pressure reduction", "Secondary efficacy", "Continuous", "Early and follow-up", "PASP or mPAP; unit and method required"],
  ["Minor bleeding", "Safety", "Dichotomous", "In-hospital to 30 d", "Definition heterogeneity expected"],
  ["Blood transfusion", "Safety", "Dichotomous", "In-hospital to 30 d", "May be inconsistently reported"],
  ["Renal function injury", "Safety", "Dichotomous/continuous", "In-hospital to 30 d", "Important for contrast/device procedures"],
  ["Device-related complications", "Safety", "Dichotomous", "Procedural to 30 d", "Vascular injury, device failure, arrhythmia, hemolysis, perforation, procedure-related deterioration"],
  ["ICU/hospital length of stay", "Resource outcome", "Continuous/time", "Index admission", "Mean/SD preferred; medians need conversion flag"],
  ["CTEPH / functional status / QoL", "Long-term exploratory", "Dichotomous/continuous", "3-24 mo", "Likely sparse; narrative if needed"],
];

const strataRows = [
  ["Analysis", "Population", "Definition", "Main Use", "Key Extraction Variables"],
  ["NMA-1", "Intermediate-low-risk PE", "Hemodynamically stable plus either elevated cTn or RV dysfunction, but not both", "Tests whether less intensive intermediate-risk patients benefit or are harmed by reperfusion/device strategies", "Hemodynamic stability; cTn; RV dysfunction; PESI/sPESI if available"],
  ["NMA-2", "Intermediate-high-risk PE", "Hemodynamically stable plus both elevated cTn and RV dysfunction", "Likely primary clinically important stratum for escalation beyond anticoagulation", "Hemodynamic stability; cTn; RV dysfunction; decompensation criteria"],
  ["NMA-3", "All intermediate-risk PE", "Intermediate-low plus intermediate-high, or trial-defined intermediate-risk when subgroup separation impossible", "Maximizes power and network connectivity", "Trial definition; proportion intermediate-high; subgroup data availability"],
  ["Excluded", "Low-risk PE", "Hemodynamically stable without cTn elevation and without RV dysfunction", "Exclude from main analysis", "Reason for exclusion"],
  ["Excluded", "High-risk PE", "Hemodynamic instability, shock, cardiac arrest, sustained SBP <90 mmHg, SBP drop >=40 mmHg, or vasopressors", "Exclude from main analysis; consider separate future study if enough RCTs", "Reason for exclusion"],
];

const rctRows = [
  ["Study ID", "First Author", "Year", "Sample Size", "PE Risk", "Arm 1 Label", "Arm 1 Node", "Arm 2 Label", "Arm 2 Node", "Arm 3 Label", "Arm 3 Node", "Follow-up", "Key Outcomes to Verify", "Current Status", "Source Note"],
  ["Fasullo 2011", "Fasullo", 2011, 72, "Intermediate-high", "tPA", "ST", "UFH", "AC", "", "", "6 mo", "Death; bleeding; RV function", "Seed RCT from CMAJ 2023; full text needed", "CMAJ 2023 Table 2"],
  ["Meyer 2014 / PEITHO", "Meyer", 2014, 1005, "Intermediate-high", "Tenecteplase", "ST", "UFH", "AC", "", "", "30 d", "Death; hemodynamic decompensation; major bleeding; ICH", "Seed RCT; high priority", "CMAJ 2023 Table 2"],
  ["Dotter 1979", "Dotter", 1979, 31, "Intermediate or high", "Streptokinase", "ST", "UFH", "AC", "", "", "7 d", "Death; bleeding; angiographic/physiologic outcomes", "Seed RCT; old trial; high-risk patients may need exclusion/subgroup", "CMAJ 2023 Table 2"],
  ["Macovei 2015", "Macovei", 2015, 52, "High", "Intra-arterial thrombolysis", "CDT", "Streptokinase", "ST", "", "", "NA", "Death; bleeding; reperfusion outcomes", "Likely excluded from main PICOS v0.2 because high-risk PE", "CMAJ 2023 Table 2"],
  ["Jerjes-Sanchez 1995", "Jerjes-Sanchez", 1995, 8, "High", "Streptokinase", "ST", "UFH", "AC", "", "", "1-3 d", "Death; bleeding", "Likely excluded from main PICOS v0.2 because high-risk PE", "CMAJ 2023 Table 2"],
  ["Blackmon 1970", "Blackmon", 1970, 160, "Intermediate or high", "Urokinase", "ST", "UFH", "AC", "", "", "14 d", "Death; bleeding; recurrence", "Seed RCT; old trial; high-risk patients may need exclusion/subgroup", "CMAJ 2023 Table 2"],
  ["Stein 1990", "Stein", 1990, 13, "Unclear", "tPA", "ST", "UFH", "AC", "", "", "7 d", "Death; bleeding; RV/angiographic outcomes", "Seed RCT; PE severity unclear", "CMAJ 2023 Table 2"],
  ["Tibbutt 1974", "Tibbutt", 1974, 30, "Intermediate or high", "Streptokinase", "ST", "UFH", "AC", "", "", "6 mo", "Death; bleeding; recurrence", "Seed RCT; old trial; high-risk patients may need exclusion/subgroup", "CMAJ 2023 Table 2"],
  ["Ahmed 2018", "Ahmed", 2018, 52, "Intermediate-high", "Systemic thrombolysis", "ST", "Anticoagulation", "AC", "", "", "NA", "Death; clinical deterioration; bleeding", "Seed RCT; full text needed", "CMAJ 2023 Table 2"],
  ["Ly 1978", "Ly", 1978, 25, "Intermediate or high", "Streptokinase", "ST", "UFH", "AC", "", "", "30 d", "Death; bleeding", "Seed RCT; old trial; high-risk patients may need exclusion/subgroup", "CMAJ 2023 Table 2"],
  ["Miller 1971", "Miller", 1971, 23, "High", "Streptokinase", "ST", "UFH", "AC", "", "", "3 d", "Death; bleeding; hemodynamics", "Likely excluded from main PICOS v0.2 because high-risk PE", "CMAJ 2023 Table 2"],
  ["Kucher 2014 / ULTIMA", "Kucher", 2014, 59, "Intermediate", "USCDT", "USCDT", "UFH", "AC", "", "", "90 d", "RV/LV ratio; death; bleeding", "Seed RCT; key USCDT link", "CMAJ 2023 Table 2"],
  ["Goldhaber 1993", "Goldhaber", 1993, 101, "Intermediate partly; unclear partly", "tPA", "ST", "UFH", "AC", "", "", "14 d", "Death; bleeding; recurrence", "Seed RCT; severity mixed/unclear", "CMAJ 2023 Table 2"],
  ["Zhang 2018", "Zhang", 2018, 66, "Intermediate", "rt-PA", "ST", "LMWH", "AC", "", "", "90 d", "Death; bleeding; RV function", "Seed RCT; full text needed", "CMAJ 2023 Table 2"],
  ["Dalla-Volta 1992", "Dalla-Volta", 1992, 36, "Unclear", "tPA", "ST", "UFH", "AC", "", "", "30 d", "Death; bleeding; hemodynamics", "Seed RCT; PE severity unclear", "CMAJ 2023 Table 2"],
  ["Sharifi 2013 / MOPETT", "Sharifi", 2013, 121, "Intermediate", "Low-dose tPA", "ST", "UFH/LMWH", "AC", "", "", "840 d", "Death; pulmonary hypertension; bleeding", "Seed RCT; low-dose systemic thrombolysis captured as dose modifier under ST", "CMAJ 2023 Table 2"],
  ["Konstantinides 2002", "Konstantinides", 2002, 256, "Intermediate", "tPA", "ST", "UFH", "AC", "", "", "30 d", "Death; clinical deterioration; bleeding", "Seed RCT; high priority", "CMAJ 2023 Table 2"],
  ["Kroupa 2022", "Kroupa", 2022, 23, "Intermediate-high", "CDT", "CDT", "Anticoagulation", "AC", "", "", "30 d", "Death; bleeding; RV function", "Seed RCT; pilot", "CMAJ 2023 Table 2"],
  ["Sadeghipour 2022 / CANARY", "Sadeghipour", 2022, 94, "Intermediate-high", "CDT", "CDT", "Anticoagulation", "AC", "", "", "3 mo", "RV/LV ratio; death; bleeding", "Seed RCT; key CDT link", "CMAJ 2023 Table 2"],
  ["PEERLESS", "Tu / PEERLESS investigators", 2024, 550, "Intermediate-risk / intermediate-high-risk; verify exact criteria", "Large-bore mechanical thrombectomy", "LBAT", "Catheter-directed thrombolysis", "CDT/USCDT", "", "", "Discharge/7 d and 30 d; verify", "Hierarchical composite; death; ICH; major bleeding; clinical deterioration; bailout therapy; ICU use", "New published RCT candidate; full text extraction needed", "Web search 2026-06-18; Circulation/ClinicalTrials.gov candidate"],
  ["STORM-PE", "STORM-PE investigators", 2025, 100, "Intermediate-high-risk", "Computer-assisted vacuum thrombectomy + anticoagulation", "CAT", "Anticoagulation alone", "AC", "", "", "48 h, 30 d, 90 d; verify", "RV/LV ratio; major adverse events; death; rescue therapy; recurrent PE; major bleeding", "New published/reported RCT candidate; full text extraction needed", "Web search 2026-06-18; Circulation/Penumbra/SCAI candidate"],
  ["HI-PEITHO", "HI-PEITHO investigators", 2026, 544, "Intermediate-high-risk / elevated-risk forms of PE; verify exact criteria", "USCDT + anticoagulation", "USCDT", "Anticoagulation alone", "AC", "", "", "7 d primary; 30 d safety; verify", "PE-related death; cardiorespiratory decompensation; recurrent PE; bleeding", "New NEJM RCT candidate; full text extraction needed", "Web search 2026-06-18; NEJM/ACC/SCAI candidate"],
  ["PEITHO-3", "PEITHO-3 investigators", "Ongoing candidate", "650-800 planned", "Intermediate-high-risk", "Reduced-dose alteplase + anticoagulation", "ST", "Placebo + anticoagulation", "AC", "", "", "30 d; 6 mo; 2 y; verify", "All-cause death; hemodynamic decompensation; recurrent PE; severe/life-threatening bleeding; long-term function/RV dysfunction", "Ongoing RCT candidate; not yet main-analysis eligible unless results available; dose captured as modifier under ST", "NCT04430569; rationale/design and registry sources"],
  ["PEERLESS II", "PEERLESS II investigators", "Ongoing candidate", "", "Intermediate-risk; verify", "FlowTriever + anticoagulation", "LBAT", "Anticoagulation alone", "AC", "", "", "Verify", "Clinical composite; death; deterioration; bleeding; RV/functional outcomes", "Ongoing RCT candidate; registry verification needed", "NCT06055920 candidate"],
];

const actionRows = [
  ["Priority", "Action", "Purpose", "Output"],
  [1, "Run formal database searches", "Identify all RCTs up to current date", "Search logs and deduplicated records"],
  [2, "Verify every seed RCT full text", "Confirm eligibility, randomization, PE risk, arms, outcomes", "Updated RCT matrix with inclusion decision"],
  [3, "Verify new RCT candidates and trial registries", "Determine whether PEERLESS, STORM-PE, HI-PEITHO, PEITHO-3 and similar trials have usable results", "Candidate RCT status table"],
  [4, "Classify every study into NMA-1/NMA-2/NMA-3", "Make risk strata usable rather than just descriptive", "Population strata map"],
  [5, "Draw preliminary network by outcome and stratum", "Check whether AC, ST, CDT, USCDT, LBAT, CAT connect for death, deterioration, bleeding, ICH", "Network feasibility report"],
  [6, "Freeze PICOS v1.0 and protocol", "Prevent post hoc node/outcome decisions", "PROSPERO/protocol draft"],
];

const wb = Workbook.create();

function addSheet(name, rows) {
  const ws = wb.worksheets.add(name);
  ws.getRangeByIndexes(0, 0, rows.length, rows[0].length).values = rows;
  const header = ws.getRangeByIndexes(0, 0, 1, rows[0].length);
  header.format = { fill: "#1F4E79", font: { bold: true, color: "#FFFFFF" } };
  ws.getRangeByIndexes(0, 0, rows.length, rows[0].length).format = {
    wrapText: true,
    verticalAlignment: "top",
    borders: { preset: "all", style: "thin", color: "#D9D9D9" },
  };
  ws.freezePanes.freezeRows(1);
  try {
    ws.tables.add(`A1:${String.fromCharCode(64 + rows[0].length)}${rows.length}`, true, `${name.replace(/[^A-Za-z0-9]/g, "")}Table`);
  } catch {}
  return ws;
}

const summaryRows = [
  ["Item", "Value"],
  ["Version", "PICOS v0.2"],
  ["Date", today],
  ["Core direction", "RCT-only, six-node, intermediate-risk PE treatment NMA"],
  ["Seed RCTs from CMAJ 2023", 19],
  ["New candidate RCT lines added", 5],
  ["Population plan", "NMA-1 intermediate-low; NMA-2 intermediate-high; NMA-3 all intermediate-risk"],
  ["Six nodes", "AC, ST, CDT, USCDT, LBAT, CAT"],
  ["Immediate decision needed", "Do not include high-risk PE in main PICOS; verify trial-level risk strata"],
  ["Key risk", "Six locked nodes may still fragment by outcome and risk stratum"],
  ["Next file to create", "Formal search strategy and screening log"],
];

const summary = addSheet("Summary", summaryRows);
const picos = addSheet("PICOS_v0.2", picosRows);
const strata = addSheet("Population_Strata", strataRows);
const nodes = addSheet("Node_Definitions", nodeRows);
const matrix = addSheet("RCT_Evidence_Matrix", rctRows);
const outcomes = addSheet("Outcome_Dictionary", outcomeRows);
const actions = addSheet("Next_Actions", actionRows);

for (const ws of [summary, picos, strata, nodes, matrix, outcomes, actions]) {
  const used = ws.getUsedRange();
  used.format.autofitColumns();
  used.format.autofitRows();
}

summary.getRange("A1:B1").format = { fill: "#0F766E", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("A1:B10").format.columnWidthPx = 260;
matrix.getRange("A1:O1").format = { fill: "#7030A0", font: { bold: true, color: "#FFFFFF" } };
matrix.getRange("A:O").format.columnWidthPx = 150;
matrix.getRange("M:M").format.columnWidthPx = 260;
matrix.getRange("N:N").format.columnWidthPx = 220;

const inspect = await wb.inspect({
  kind: "workbook,sheet,table",
  maxChars: 6000,
  tableMaxRows: 5,
  tableMaxCols: 8,
});
console.log(inspect.ndjson);

const errors = await wb.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "formula error scan",
});
console.log(errors.ndjson);

for (const sheetName of ["Summary", "PICOS_v0.2", "Population_Strata", "RCT_Evidence_Matrix"]) {
  const preview = await wb.render({ sheetName, autoCrop: "all", scale: 1, format: "png" });
  await fs.writeFile(path.join(tempDir, `${sheetName}_preview.png`), new Uint8Array(await preview.arrayBuffer()));
}

const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputXlsx);
console.log(`WROTE ${outputXlsx}`);
console.log(`WROTE ${outputTxt}`);
