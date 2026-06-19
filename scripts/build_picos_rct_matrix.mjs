import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/02肺栓塞网状meta-cdex版";
const tempDir = path.join(outputDir, "01临时文件");
const outputXlsx = path.join(outputDir, "PICOS_v0.1_及_RCT证据矩阵.xlsx");
const outputTxt = path.join(outputDir, "PICOS_v0.1.txt");

await fs.mkdir(outputDir, { recursive: true });
await fs.mkdir(tempDir, { recursive: true });

const today = "2026-06-18";

const picosText = `# PICOS v0.1

项目题目暂定：
Comparative efficacy and safety of reperfusion and anticoagulation strategies for acute intermediate-risk and high-risk pulmonary embolism: a systematic review and network meta-analysis of randomised controlled trials

版本：v0.1
日期：${today}
用途：用于启动正式检索、筛选、RCT 证据矩阵建立和后续 PROSPERO/protocol 写作。该版本为工作版，需根据 RCT-治疗节点-结局矩阵的网络连通性修订为 v1.0。

P - Population：
成人急性肺栓塞患者，重点为中危、中高危或高危 PE。中危/中高危定义优先采用 ESC/AHA 标准，包括血流动力学状态、PESI/sPESI、右室功能障碍和心肌损伤标志物。低危 PE 原则上不纳入，除非 RCT 明确研究再灌注或抗凝策略且可进行临床解释。儿童、妊娠、慢性血栓栓塞性肺高压、单纯 DVT、非急性 PE、动物或体外研究排除。

I/C - Interventions and Comparators：
纳入任何随机比较的急性 PE 治疗策略，包括抗凝、标准剂量全身溶栓、低剂量/半剂量全身溶栓、导管定向溶栓、超声辅助导管溶栓、机械/抽吸取栓、外科取栓或循环支持相关策略。最终主分析节点必须由 RCT 证据和网络连通性决定。节点可在主分析中合并，在敏感性或亚组中按药物、剂量、导管技术和风险层级拆分。

O - Outcomes：
主要疗效结局候选：全因死亡，优先院内或 30 天；临床恶化/治疗失败复合结局，包括死亡、血流动力学崩溃、抢救性溶栓/介入/手术、循环支持升级等。
主要安全性结局候选：严重/主要出血和颅内出血。
次要结局：复发 PE/VTE、任何出血/轻微出血、输血需求、右室功能恢复（RV/LV ratio、TAPSE、PASP、NT-proBNP/troponin 等）、ICU/住院时长、长期 CTEPH、功能状态或生活质量。

S - Study Design：
仅纳入随机对照试验。随机化方法不清、准随机、摘要-only、注册结果-only 研究单独标记，并在敏感性分析中处理。观察性研究、病例系列、病例报告、药代动力学研究、综述、评论和指南不纳入主分析。

关键执行原则：
1. 先建立 RCT-治疗节点-结局证据矩阵，再决定 PICOS v1.0 和主分析节点。
2. 不为了增加节点而牺牲临床清晰度和网络稳定性。
3. 不只报告治疗排序，必须报告证据确定性、偏倚风险、不一致性、异质性和临床净获益。
`;

await fs.writeFile(outputTxt, picosText, "utf8");

const picosRows = [
  ["Domain", "v0.1 Decision", "Operational Definition", "Notes / v1.0 Issues"],
  ["Population", "Adults with acute intermediate-risk, intermediate-high-risk, or high-risk PE", "Use trial authors' definitions first; map to ESC/AHA risk strata where possible", "Low-risk PE excluded unless clinically justified by RCT context"],
  ["Intervention", "Any randomized acute PE treatment strategy beyond standard care", "Anticoagulation, systemic thrombolysis by dose/drug, CDT, USAT, thrombectomy/aspiration, surgical/circulatory strategies if RCT evidence exists", "Final nodes depend on RCT connectivity"],
  ["Comparator", "Any eligible randomized comparator", "Anticoagulation, placebo/standard care, other thrombolytic or interventional strategy", "Multi-arm trials retained if randomized"],
  ["Primary efficacy outcome", "All-cause death and/or clinical deterioration/treatment failure", "Prefer in-hospital or 30-day mortality; define composite prospectively", "Death may be sparse; composite may be more analyzable"],
  ["Primary safety outcome", "Major/serious bleeding and intracranial hemorrhage", "Use ISTH/TIMI/GUSTO if available; otherwise trial definition with sensitivity analysis", "Definitions must be captured exactly"],
  ["Secondary outcomes", "Recurrent VTE/PE, RV recovery, ICU/hospital stay, minor bleeding, transfusion, long-term outcomes", "Extract time point and measurement scale for each outcome", "Continuous RV outcomes may need separate NMA/pairwise analysis"],
  ["Study design", "RCT only", "Parallel, factorial, or eligible multi-arm randomized trials", "Quasi-randomized/randomization unclear flagged for sensitivity/exclusion"],
];

const nodeRows = [
  ["Node Code", "Node Name", "Working Definition", "Main Analysis?", "Sensitivity / Split Options"],
  ["AC", "Anticoagulation alone", "UFH, LMWH, DOAC/VKA, or standard anticoagulation without planned reperfusion", "Yes", "UFH vs LMWH vs DOAC if enough RCTs"],
  ["ST_FULL", "Full-dose systemic thrombolysis", "Systemic thrombolytic regimen generally considered full/standard dose", "Likely", "Split by alteplase/tPA, tenecteplase, urokinase, streptokinase"],
  ["ST_LOW", "Reduced-dose systemic thrombolysis", "Half-dose or low-dose systemic thrombolysis", "Likely if connected", "Split half-dose vs other reduced-dose if enough data"],
  ["CDT", "Catheter-directed thrombolysis", "Local catheter-directed infusion of thrombolytic drug without clear USAT-only classification", "Likely", "Split drug, dose, infusion duration"],
  ["USAT", "Ultrasound-assisted catheter-directed thrombolysis", "Ultrasound-facilitated catheter-directed thrombolysis", "If RCT-connected", "Combine with CDT if sparse"],
  ["MT_ASP", "Mechanical thrombectomy / aspiration", "Catheter-based mechanical or large-bore aspiration thrombectomy without lytic as primary mechanism", "If RCT-connected", "Device-specific split only if enough RCTs"],
  ["SURG", "Surgical embolectomy", "Open surgical embolectomy strategy", "Only if RCT exists and connected", "Likely narrative if no RCT network"],
  ["ECMO", "ECMO-supported strategy", "Extracorporeal support as part of randomized acute PE strategy", "Only if RCT exists and connected", "Likely narrative if no RCT network"],
];

const outcomeRows = [
  ["Outcome", "Priority", "Type", "Preferred Time Window", "Extraction Notes"],
  ["All-cause death", "Primary efficacy candidate", "Dichotomous", "In-hospital, 30 days, closest early time point", "Record exact timing; do not mix long-term unless separate"],
  ["Clinical deterioration / treatment failure", "Primary efficacy candidate", "Dichotomous composite", "In-hospital to 30 days", "Needs protocol definition before analysis"],
  ["Major/serious bleeding", "Primary safety", "Dichotomous", "In-hospital to 30 days", "Record bleeding definition"],
  ["Intracranial hemorrhage", "Primary safety", "Dichotomous", "In-hospital to 30 days", "Rare event methods may be needed"],
  ["Recurrent PE/VTE", "Secondary efficacy", "Dichotomous", "30 days and longest follow-up", "Separate PE and VTE if possible"],
  ["Any/minor bleeding", "Secondary safety", "Dichotomous", "In-hospital to 30 days", "Definition heterogeneity expected"],
  ["Blood transfusion", "Secondary safety", "Dichotomous", "In-hospital to 30 days", "May be inconsistently reported"],
  ["RV/LV ratio", "Mechanistic efficacy", "Continuous", "24-72 h, 7 d, 30 d, 90 d", "Separate time points; record imaging modality"],
  ["PASP / pulmonary pressure", "Mechanistic efficacy", "Continuous", "Early and follow-up", "Unit and method required"],
  ["ICU/hospital length of stay", "Resource outcome", "Continuous/time", "Index admission", "Mean/SD preferred; medians need conversion flag"],
  ["CTEPH / functional status / QoL", "Long-term exploratory", "Dichotomous/continuous", "3-24 months", "Likely sparse; narrative if needed"],
];

const rctRows = [
  ["Study ID", "First Author", "Year", "Sample Size", "PE Risk", "Arm 1 Label", "Arm 1 Node", "Arm 2 Label", "Arm 2 Node", "Arm 3 Label", "Arm 3 Node", "Follow-up", "Key Outcomes to Verify", "Current Status", "Source Note"],
  ["Fasullo 2011", "Fasullo", 2011, 72, "Intermediate-high", "tPA", "ST_FULL", "UFH", "AC", "", "", "6 mo", "Death; bleeding; RV function", "Seed RCT from CMAJ 2023; full text needed", "CMAJ 2023 Table 2"],
  ["Meyer 2014 / PEITHO", "Meyer", 2014, 1005, "Intermediate-high", "Tenecteplase", "ST_FULL", "UFH", "AC", "", "", "30 d", "Death; hemodynamic decompensation; major bleeding; ICH", "Seed RCT; high priority", "CMAJ 2023 Table 2"],
  ["Dotter 1979", "Dotter", 1979, 31, "Intermediate or high", "Streptokinase", "ST_FULL", "UFH", "AC", "", "", "7 d", "Death; bleeding; angiographic/physiologic outcomes", "Seed RCT; old trial", "CMAJ 2023 Table 2"],
  ["Macovei 2015", "Macovei", 2015, 52, "High", "Intra-arterial thrombolysis", "CDT", "Streptokinase", "ST_FULL", "", "", "NA", "Death; bleeding; reperfusion outcomes", "Seed RCT; node classification needs full text", "CMAJ 2023 Table 2"],
  ["Jerjes-Sanchez 1995", "Jerjes-Sanchez", 1995, 8, "High", "Streptokinase", "ST_FULL", "UFH", "AC", "", "", "1-3 d", "Death; bleeding", "Seed RCT; very small", "CMAJ 2023 Table 2"],
  ["Blackmon 1970", "Blackmon", 1970, 160, "Intermediate or high", "Urokinase", "ST_FULL", "UFH", "AC", "", "", "14 d", "Death; bleeding; recurrence", "Seed RCT; old trial", "CMAJ 2023 Table 2"],
  ["Stein 1990", "Stein", 1990, 13, "Unclear", "tPA", "ST_FULL", "UFH", "AC", "", "", "7 d", "Death; bleeding; RV/angiographic outcomes", "Seed RCT; PE severity unclear", "CMAJ 2023 Table 2"],
  ["Tibbutt 1974", "Tibbutt", 1974, 30, "Intermediate or high", "Streptokinase", "ST_FULL", "UFH", "AC", "", "", "6 mo", "Death; bleeding; recurrence", "Seed RCT; old trial", "CMAJ 2023 Table 2"],
  ["Ahmed 2018", "Ahmed", 2018, 52, "Intermediate-high", "Systemic thrombolysis", "ST_FULL", "Anticoagulation", "AC", "", "", "NA", "Death; clinical deterioration; bleeding", "Seed RCT; full text needed", "CMAJ 2023 Table 2"],
  ["Ly 1978", "Ly", 1978, 25, "Intermediate or high", "Streptokinase", "ST_FULL", "UFH", "AC", "", "", "30 d", "Death; bleeding", "Seed RCT; old trial", "CMAJ 2023 Table 2"],
  ["Miller 1971", "Miller", 1971, 23, "High", "Streptokinase", "ST_FULL", "UFH", "AC", "", "", "3 d", "Death; bleeding; hemodynamics", "Seed RCT; old trial", "CMAJ 2023 Table 2"],
  ["Kucher 2014 / ULTIMA", "Kucher", 2014, 59, "Intermediate", "USAT", "USAT", "UFH", "AC", "", "", "90 d", "RV/LV ratio; death; bleeding", "Seed RCT; key CDT/USAT link", "CMAJ 2023 Table 2"],
  ["Goldhaber 1993", "Goldhaber", 1993, 101, "Intermediate partly; unclear partly", "tPA", "ST_FULL", "UFH", "AC", "", "", "14 d", "Death; bleeding; recurrence", "Seed RCT; severity mixed/unclear", "CMAJ 2023 Table 2"],
  ["Zhang 2018", "Zhang", 2018, 66, "Intermediate", "rt-PA", "ST_FULL", "LMWH", "AC", "", "", "90 d", "Death; bleeding; RV function", "Seed RCT; full text needed", "CMAJ 2023 Table 2"],
  ["Dalla-Volta 1992", "Dalla-Volta", 1992, 36, "Unclear", "tPA", "ST_FULL", "UFH", "AC", "", "", "30 d", "Death; bleeding; hemodynamics", "Seed RCT; PE severity unclear", "CMAJ 2023 Table 2"],
  ["Sharifi 2013 / MOPETT", "Sharifi", 2013, 121, "Intermediate", "Low-dose tPA", "ST_LOW", "UFH/LMWH", "AC", "", "", "840 d", "Death; pulmonary hypertension; bleeding", "Seed RCT; key low-dose node", "CMAJ 2023 Table 2"],
  ["Konstantinides 2002", "Konstantinides", 2002, 256, "Intermediate", "tPA", "ST_FULL", "UFH", "AC", "", "", "30 d", "Death; clinical deterioration; bleeding", "Seed RCT; high priority", "CMAJ 2023 Table 2"],
  ["Kroupa 2022", "Kroupa", 2022, 23, "Intermediate-high", "CDT", "CDT", "Anticoagulation", "AC", "", "", "30 d", "Death; bleeding; RV function", "Seed RCT; pilot", "CMAJ 2023 Table 2"],
  ["Sadeghipour 2022 / CANARY", "Sadeghipour", 2022, 94, "Intermediate-high", "CDT", "CDT", "Anticoagulation", "AC", "", "", "3 mo", "RV/LV ratio; death; bleeding", "Seed RCT; key CDT link", "CMAJ 2023 Table 2"],
  ["PEERLESS", "Tu / PEERLESS investigators", 2024, 550, "Intermediate-risk / intermediate-high-risk; verify exact criteria", "Large-bore mechanical thrombectomy", "MT_ASP", "Catheter-directed thrombolysis", "CDT/USAT", "", "", "Discharge/7 d and 30 d; verify", "Hierarchical composite; death; ICH; major bleeding; clinical deterioration; bailout therapy; ICU use", "New published RCT candidate; full text extraction needed", "Web search 2026-06-18; Circulation/ClinicalTrials.gov candidate"],
  ["STORM-PE", "STORM-PE investigators", 2025, 100, "Intermediate-high-risk", "Computer-assisted vacuum thrombectomy + anticoagulation", "MT_ASP", "Anticoagulation alone", "AC", "", "", "48 h, 30 d, 90 d; verify", "RV/LV ratio; major adverse events; death; rescue therapy; recurrent PE; major bleeding", "New published/reported RCT candidate; full text extraction needed", "Web search 2026-06-18; Circulation/Penumbra/SCAI candidate"],
  ["HI-PEITHO", "HI-PEITHO investigators", 2026, 544, "Intermediate-high-risk / elevated-risk forms of PE; verify exact criteria", "USCDT/USAT + anticoagulation", "USAT", "Anticoagulation alone", "AC", "", "", "7 d primary; 30 d safety; verify", "PE-related death; cardiorespiratory decompensation; recurrent PE; bleeding", "New NEJM RCT candidate; full text extraction needed", "Web search 2026-06-18; NEJM/ACC/SCAI candidate"],
  ["PEITHO-3", "PEITHO-3 investigators", "Ongoing candidate", "650-800 planned", "Intermediate-high-risk", "Reduced-dose alteplase + anticoagulation", "ST_LOW", "Placebo + anticoagulation", "AC", "", "", "30 d; 6 mo; 2 y; verify", "All-cause death; hemodynamic decompensation; recurrent PE; severe/life-threatening bleeding; long-term function/RV dysfunction", "Ongoing RCT candidate; not yet main-analysis eligible unless results available", "NCT04430569; rationale/design and registry sources"],
  ["PEERLESS II", "PEERLESS II investigators", "Ongoing candidate", "", "Intermediate-risk; verify", "FlowTriever + anticoagulation", "MT_ASP", "Anticoagulation alone", "AC", "", "", "Verify", "Clinical composite; death; deterioration; bleeding; RV/functional outcomes", "Ongoing RCT candidate; registry verification needed", "NCT06055920 candidate"],
];

const actionRows = [
  ["Priority", "Action", "Purpose", "Output"],
  [1, "Run formal database searches", "Identify all RCTs up to current date", "Search logs and deduplicated records"],
  [2, "Verify every seed RCT full text", "Confirm eligibility, randomization, PE risk, arms, outcomes", "Updated RCT matrix with inclusion decision"],
  [3, "Verify new RCT candidates and trial registries", "Determine whether PEERLESS, STORM-PE, HI-PEITHO, PEITHO-3 and similar trials have usable results", "Candidate RCT status table"],
  [4, "Draw preliminary network by outcome", "Check whether main nodes connect for death, clinical deterioration, major bleeding, ICH", "Network feasibility report"],
  [5, "Freeze PICOS v1.0 and protocol", "Prevent post hoc node/outcome decisions", "PROSPERO/protocol draft"],
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
  ["Version", "PICOS v0.1"],
  ["Date", today],
  ["Core direction", "RCT-only, multi-node, clinically interpretable PE treatment NMA"],
  ["Seed RCTs from CMAJ 2023", 19],
  ["New candidate RCT lines added", 5],
  ["Immediate decision needed", "Do not freeze nodes until network connectivity is checked by outcome"],
  ["Key risk", "Too many nodes may fragment the RCT network"],
  ["Next file to create", "Formal search strategy and screening log"],
];

const summary = addSheet("Summary", summaryRows);
const picos = addSheet("PICOS_v0.1", picosRows);
const nodes = addSheet("Node_Definitions", nodeRows);
const matrix = addSheet("RCT_Evidence_Matrix", rctRows);
const outcomes = addSheet("Outcome_Dictionary", outcomeRows);
const actions = addSheet("Next_Actions", actionRows);

for (const ws of [summary, picos, nodes, matrix, outcomes, actions]) {
  const used = ws.getUsedRange();
  used.format.autofitColumns();
  used.format.autofitRows();
}

summary.getRange("A1:B1").format = { fill: "#0F766E", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("A1:B9").format.columnWidthPx = 260;
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

for (const sheetName of ["Summary", "PICOS_v0.1", "RCT_Evidence_Matrix"]) {
  const preview = await wb.render({ sheetName, autoCrop: "all", scale: 1, format: "png" });
  await fs.writeFile(path.join(tempDir, `${sheetName}_preview.png`), new Uint8Array(await preview.arrayBuffer()));
}

const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputXlsx);
console.log(`WROTE ${outputXlsx}`);
console.log(`WROTE ${outputTxt}`);
