import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const root = process.cwd();
const screeningDir = path.join(root, "03_screening");
const csvPath = path.join(screeningDir, "pubmed_embase_central_deduplicated_screening_set_v1.0.csv");
const summaryPath = path.join(screeningDir, "pubmed_embase_central_deduplication_summary_v1.0.json");
const outputPath = path.join(screeningDir, "pubmed_embase_central_deduplicated_screening_set_v1.0.xlsx");
const previewPath = path.join(screeningDir, "pubmed_embase_central_deduplication_summary_preview_v1.0.png");

const csvText = await fs.readFile(csvPath, "utf8");
const summary = JSON.parse(await fs.readFile(summaryPath, "utf8"));

const workbook = await Workbook.fromCSV(csvText, { sheetName: "Records" });
const records = workbook.worksheets.getItem("Records");
records.showGridLines = false;

const finalRows = summary.final_pubmed_embase_central_unique_records + 1;
const finalCols = 32;
const tableRange = `A1:AF${finalRows}`;
records.tables.add(tableRange, true, "PubMedEmbaseCentralScreeningTable");
records.freezePanes.freezeRows(1);
records.getRange("A1:AF1").format = {
  fill: "#1F4E79",
  font: { bold: true, color: "#FFFFFF" },
};
records.getRange("A:AF").format.wrapText = false;
records.getRange("A:D").format.columnWidth = 16;
records.getRange("E:E").format.columnWidth = 48;
records.getRange("F:F").format.columnWidth = 60;
records.getRange("G:I").format.columnWidth = 26;
records.getRange("J:L").format.columnWidth = 14;
records.getRange("M:P").format.columnWidth = 24;
records.getRange("Q:AC").format.columnWidth = 18;
records.getRange("AD:AF").format.columnWidth = 26;
records.getRange(`AD2:AD${finalRows}`).dataValidation = {
  rule: {
    type: "list",
    values: ["include", "exclude", "maybe", "duplicate", "await_fulltext"],
  },
};

const summarySheet = workbook.worksheets.add("Summary");
summarySheet.showGridLines = false;
summarySheet.getRange("A1:D1").merge();
summarySheet.getRange("A1").values = [["PubMed + Embase + CENTRAL Deduplication Summary v1.0"]];
summarySheet.getRange("A1").format = {
  fill: "#1F4E79",
  font: { bold: true, color: "#FFFFFF", size: 14 },
};

const rows = [
  ["Metric", "Count", "Interpretation", "Source"],
  ["PubMed + Embase unique before CENTRAL merge", summary.pubmed_embase_unique_before_central, "Two-database deduplicated set", "pubmed_embase_deduplicated_screening_set_v1.0.csv"],
  ["CENTRAL raw RIS records", summary.central_raw_ris_records, "Original Cochrane CENTRAL Trials RIS export", "20260622_central_trials_3912.ris"],
  ["CENTRAL after internal conservative deduplication", summary.central_after_internal_dedup, "Internal CENTRAL duplicates removed by ID, DOI, or title-year", "merge_pubmed_embase_central_v10.py"],
  ["CENTRAL internal duplicates removed", summary.central_internal_duplicates_removed, "Duplicates within CENTRAL export", "merge_pubmed_embase_central_v10.py"],
  ["CENTRAL matched to existing PubMed+Embase set", summary.central_matched_to_existing, "Records already represented in PubMed+Embase", "duplicate match log"],
  ["Matched by PubMed ID cross-reference", summary.central_matched_by_pubmed_ref, "CENTRAL C3 contained PubMed ID", "duplicate match log"],
  ["Matched by Embase ID cross-reference", summary.central_matched_by_embase_ref, "CENTRAL C3 contained Embase ID", "duplicate match log"],
  ["Matched by DOI", summary.central_matched_by_doi, "Exact DOI match", "duplicate match log"],
  ["Matched by exact title + year", summary.central_matched_by_title_year, "No ID/DOI match; exact normalized title and year", "duplicate match log"],
  ["CENTRAL unique added beyond PubMed+Embase", summary.central_unique_added_beyond_pubmed_embase, "New unique records contributed by CENTRAL", "combined set"],
  ["Final PubMed + Embase + CENTRAL unique records", summary.final_pubmed_embase_central_unique_records, "Records entering title/abstract screening so far", "combined set"],
];
summarySheet.getRange(`A3:D${rows.length + 2}`).values = rows;
summarySheet.tables.add(`A3:D${rows.length + 2}`, true, "DedupSummaryTable");
summarySheet.getRange("A3:D3").format = {
  fill: "#D9EAF7",
  font: { bold: true, color: "#000000" },
};
summarySheet.getRange("A:D").format.wrapText = true;
summarySheet.getRange("A:A").format.columnWidth = 46;
summarySheet.getRange("B:B").format.columnWidth = 14;
summarySheet.getRange("C:C").format.columnWidth = 58;
summarySheet.getRange("D:D").format.columnWidth = 42;
summarySheet.getRange("B4:B14").format.numberFormat = "#,##0";
summarySheet.freezePanes.freezeRows(3);

summarySheet.getRange("A17:D17").merge();
summarySheet.getRange("A17").values = [["Deduplication rule"]];
summarySheet.getRange("A17").format = { fill: "#E2F0D9", font: { bold: true } };
summarySheet.getRange("A18:D18").merge();
summarySheet.getRange("A18").values = [["Conservative matching only: CENTRAL PubMed/Embase cross-reference first, exact DOI second, then exact normalized title + publication year. Fuzzy matching was not used in v1.0."]];
summarySheet.getRange("A20:D20").merge();
summarySheet.getRange("A20").values = [["Next action"]];
summarySheet.getRange("A20").format = { fill: "#E2F0D9", font: { bold: true } };
summarySheet.getRange("A21:D21").merge();
summarySheet.getRange("A21").values = [["Run Web of Science search and then perform four-database deduplication."]];

const inspect = await workbook.inspect({
  kind: "table",
  range: "Summary!A3:D14",
  include: "values",
  maxChars: 3000,
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
