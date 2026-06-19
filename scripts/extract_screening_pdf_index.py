from __future__ import annotations

import hashlib
import json
import pathlib
import re
import sys

import pypdf


PDF_PATHS = [
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/44 Fibrinolysis for patients with.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/46 .PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/47 Streptokinase and Heparin versu Source J Thromb Thrombolysis 1995 2 3 227 229.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/48 Tissue plasminogen activator for the Source Chest SO 1990 Mar 97 3 528 33.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/49 value_of_thrombolytic_therapy_for_submassive.13(1).pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/50 PAIMS 2 alteplase combined.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/27 Six month echocardiographic study in patients with submassivePg33 9.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V5  2023网状meta纳入的rct/31 Clinical efficacy of low dose recombinant tissue-type plasminogen activator for the treatment .pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/27 Six month echocardiographic study in patients with submassivePg33 9.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/28 Efficacy and Safety of Thrombolytic Source J Clin Med Res SO 2017 Feb 9 2 163 169.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/29 Comparison of acute and convalescent biomarkers of inflammation in patients with acute pulmonary embolism treated with systemic fibrinolysis vs. placebo.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/30 Diclofenac for reversal of right ventricular dysf Source Thromb Res 2017 Dec 162 1 6.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/31 Clinical efficacy of low dose recombinant tissue-type plasminogen activator for the treatment .pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/32 One Year Echocardiographic Functional and Qu Source Circ Cardiovasc Interv 2020 13 8 e009012.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/33 Intermediate Term Outcomes for Patients w Source J Invasive Cardiol 2021 Dec 33 12 E949 E953.PDF.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/34 Outcomes of Catheter Based Pulmonary Source Cureus SO 2023.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/35 Inhibition of thrombin-activatable fibrinolysis inhibitor via DS-1040 to accelerate clot lysis in patients with acute pulmonary embolism a randomized phase 1b study.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/36 Oxygen therapy in patients with inte Source Chest SO 2023.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/37 Aspiration thrombectomy compared to Source Cardiol J SO 2025.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/38 Evaluation of Catheter Directed Thro Source J Vasc Interv Radiol SO 2025.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/23 Randomized trial of subcutaneous low Source Circulation SO 1992 Apr 85 4 1380 9.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/24 Subcutaneous low molecular weight heparin fragmin Source Thromb Haemost 1995 Dec 74 6 1432 5.PDF.pdf",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/25 Time course of platelet aggregation Source Blood Coagul Fibrinolysis SO 2007 Oct 18 7 661 7.PDF",
    r"C:/Users/kilog/Downloads/DVT-PE网状meta/PE临床研究/V4 16篇CSV独有文献_EndNote导入格式/26 Endogenous plasma activated protein Source Crit Care SO 2011 15 1 R23.PDF",
]


FLAG_PATTERNS = {
    "random": r"random|randomized|randomised",
    "retrospective": r"retrospective",
    "prospective": r"prospective",
    "placebo": r"placebo",
    "heparin": r"heparin|lmwh|enoxaparin",
    "thrombolysis": r"thrombolysis|fibrinolysis|alteplase|tenecteplase|rt-pa|streptokinase",
    "catheter_device": r"catheter|ekos|ultrasound|flowtriever|indigo|penumbra|thrombectomy",
    "intermediate": r"intermediate|submassive|normotensive",
    "massive_highrisk": r"massive|high-risk|shock|hypotension",
    "dvt_only": r"deep vein thrombosis",
    "oxygen": r"oxygen",
    "diclofenac": r"diclofenac",
    "biomarker_or_phase1": r"biomarker|inflammation|platelet|activated protein c|fibrinolysis inhibitor|ds-1040|phase 1b",
}


def extract_text(pdf_path: pathlib.Path) -> tuple[str, int | None, str | None]:
    try:
        reader = pypdf.PdfReader(str(pdf_path))
        pages = len(reader.pages)
        chunks = []
        for page in reader.pages:
            try:
                chunks.append(page.extract_text() or "")
            except Exception:
                chunks.append("")
        return "\n".join(chunks), pages, None
    except Exception as exc:  # pragma: no cover - diagnostic path
        return "", None, str(exc)


def main() -> int:
    outdir = pathlib.Path(r"C:/tmp/pe_nma_formal_screening_text")
    outdir.mkdir(parents=True, exist_ok=True)
    records = []

    for no, raw_path in enumerate(PDF_PATHS, start=1):
        pdf_path = pathlib.Path(raw_path)
        data = pdf_path.read_bytes()
        sha16 = hashlib.sha256(data).hexdigest()[:16]
        text, pages, error = extract_text(pdf_path)
        normalized = re.sub(r"\s+", " ", text).strip()
        lower = normalized.lower()

        text_file = outdir / f"{no:02d}_{pdf_path.stem[:80]}.txt"
        text_file.write_text(text, encoding="utf-8", errors="ignore")

        flags = {
            name: bool(re.search(pattern, lower))
            for name, pattern in FLAG_PATTERNS.items()
        }
        records.append(
            {
                "no": no,
                "file": pdf_path.name,
                "path": raw_path,
                "sha16": sha16,
                "pages": pages,
                "chars": len(text),
                "text_file": str(text_file),
                "head": normalized[:500],
                "flags": flags,
                "error": error,
            }
        )

    index_path = pathlib.Path(r"C:/tmp/pe_nma_formal_screening_index.json")
    index_path.write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")

    for rec in records:
        flag_list = ",".join(name for name, value in rec["flags"].items() if value)
        print(
            f"{rec['no']:02d}\t{rec['pages']}p\t{rec['chars']}ch\t"
            f"{rec['sha16']}\t{rec['file']}\t{flag_list}"
        )
    print(f"INDEX\t{index_path}")
    print(f"TEXT_DIR\t{outdir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

