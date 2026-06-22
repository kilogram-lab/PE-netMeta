import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const root = process.cwd();
const screeningDir = path.join(root, "03_screening");
const csvPath = path.join(screeningDir, "pubmed_embase_deduplicated_screening_set_v1.0.csv");
const summaryPath = path.join(screeningDir, "pubmed_embase_deduplication_summary_v1.0.json");
const outputPath = path.join(screeningDir, "pubmed_embase_deduplicated_screening_set_v1.0.xlsx");
const previewPath = path.join(screeningDir, "pubmed_embase_deduplication_summary_preview_v1.0.png");

const csvText = await fs.readFile(csvPath, "utf8");
const summary = JSON.parse(await fs.readFile(summaryPath, "utf8"));

const workbook = await Workbook.fromCSV(csvText, { sheetName: "Records" });
const records = workbook.worksheets.getItem("Records");
records.showGridLines = false;

const finalRows = summary.final_pubmed_embase_unique_records + 1;
const finalCols = 27;
const tableRange = `A1:AA${finalRows}`;
records.tables.add(tableRange, true, "PubMedEmbaseScreeningTable");
records.freezePanes.freezeRows(1);
records.getRange("A1:AA1").format = {
  fill: "#1F4E79",
  font: { bold: true, color: "#FFFFFF" },
};
records.getRange("A:AA").format.wrapText = false;
records.getRange("A:A").format.columnWidth = 18;
records.getRange("B:C").format.columnWidth = 16;
records.getRange("D:D").format.columnWidth = 48;
records.getRange("E:E").format.columnWidth = 60;
records.getRange("F:H").format.columnWidth = 28;
records.getRange("I:J").format.columnWidth = 14;
records.getRange("K:O").format.columnWidth = 24;
records.getRange("P:X").format.columnWidth = 18;
records.getRange("Y:AA").format.columnWidth = 26;

records.getRange(`Y2:Y${finalRows}`).dataValidation = {
  rule: {
    type: "list",
    values: ["include", "exclude", "maybe", "duplicate", "await_fulltext"],
  },
};

const summarySheet = workbook.worksheets.add("Summary");
summarySheet.showGridLines = false;
summarySheet.getRange("A1:D1").merge();
summarySheet.getRange("A1").values = [["PubMed + Embase Deduplication Summary v1.0"]];
summarySheet.getRange("A1").format = {
  fill: "#1F4E79",
  font: { bold: true, color: "#FFFFFF", size: 14 },
};

const rows = [
  ["Metric", "Count", "Interpretation", "Source"],
  ["PubMed unique before Embase merge", summary.pubmed_unique_before_embase, "PubMed three-search deduplicated set", "pubmed_deduplicated_screening_set_v1.0.csv"],
  ["Embase raw RIS records", summary.embase_raw_ris_records, "Original Embase.com RIS export", "20260622_embase_main_8899.ris"],
  ["Embase after internal conservative deduplication", summary.embase_after_internal_dedup, "Internal Embase duplicates removed by DOI or title-year", "merge_pubmed_embase_v10.py"],
  ["Embase internal duplicates removed", summary.embase_internal_duplicates_removed, "Duplicates within Embase export", "merge_pubmed_embase_v10.py"],
  ["Embase matched to PubMed", summary.embase_matched_to_pubmed, "Records already represented in PubMed set", "duplicate match log"],
  ["Matched by DOI", summary.embase_matched_to_pubmed_by_doi, "Exact DOI match", "duplicate match log"],
  ["Matched by exact title + year", summary.embase_matched_to_pubmed_by_title_year, "No DOI match; exact normalized title and year", "duplicate match log"],
  ["Embase unique added beyond PubMed", summary.embase_unique_added_beyond_pubmed, "New unique records contributed by Embase", "combined set"],
  ["Final PubMed + Embase unique records", summary.final_pubmed_embase_unique_records, "Records entering title/abstract screening so far", "combined set"],
];
summarySheet.getRange(`A3:D${rows.length + 2}`).values = rows;
summarySheet.tables.add(`A3:D${rows.length + 2}`, true, "DedupSummaryTable");
summarySheet.getRange("A3:D3").format = {
  fill: "#D9EAF7",
  font: { bold: true, color: "#000000" },
};
summarySheet.getRange("A:D").format.wrapText = true;
summarySheet.getRange("A:A").format.columnWidth = 42;
summarySheet.getRange("B:B").format.columnWidth = 14;
summarySheet.getRange("C:C").format.columnWidth = 58;
summarySheet.getRange("D:D").format.columnWidth = 42;
summarySheet.getRange("B4:B12").format.numberFormat = "#,##0";
summarySheet.freezePanes.freezeRows(3);

const notes = [
  ["Deduplication rule"],
  ["Conservative matching only: exact DOI first, then exact normalized title + publication year. Fuzzy matching was not used in v1.0."],
  ["Next action"],
  ["Run CENTRAL and Web of Science searches, or use this combined set for title/abstract screening preparation."],
];
summarySheet.getRange("A15:D15").merge();
summarySheet.getRange("A15").values = [[notes[0][0]]];
summarySheet.getRange("A15").format = { fill: "#E2F0D9", font: { bold: true } };
summarySheet.getRange("A16:D16").merge();
summarySheet.getRange("A16").values = [[notes[1][0]]];
summarySheet.getRange("A18:D18").merge();
summarySheet.getRange("A18").values = [[notes[2][0]]];
summarySheet.getRange("A18").format = { fill: "#E2F0D9", font: { bold: true } };
summarySheet.getRange("A19:D19").merge();
summarySheet.getRange("A19").values = [[notes[3][0]]];

const inspect = await workbook.inspect({
  kind: "table",
  range: "Summary!A3:D12",
  include: "values",
  maxChars: 2500,
});
console.log(inspect.ndjson);

const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 50 },
  summary: "formula error scan",
});
console.log(errors.ndjson);

const preview = await workbook.render({
  sheetName: "Summary",
  autoCrop: "all",
  scale: 1,
  format: "png",
});
await fs.writeFile(previewPath, new Uint8Array(await preview.arrayBuffer()));

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
console.log(JSON.stringify({ outputPath, previewPath, rows: finalRows - 1 }));
