from __future__ import annotations

import hashlib
import json
import pathlib
import re
import sys

import pypdf


PDF_PATHS = [
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/03 Treatment of submassive pulmonary .pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/04 Randomized controlled trial of ultrasound assi.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/05 Meyer-2014-Fibrinolysis for patients with inte.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/09 Randomized Trial Comparing Standard Source JAC.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/11 Catheter Directed Thrombolysis vs An Source JA.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/14 Large bore Mechanical Thrombectomy V Source Ci.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/15 Randomized Controlled Trial of Mecha Source Ci.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/16 stratify.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/17 Percutaneous Reperfusion Therapies v Source Pulm Circ SO 2026.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/18 Ultrasound Facilitated Catheter Dir Source N Engl J Med SO 2026.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/19 Heparin plus alteplase.PDF",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/20 Alteplase versus heparin i.PDF",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/21 A pilot randomised trial of catheter dire Source EuroIntervention 2022 May 27 EIJ D 21 01080.PDF.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/27 Six month echocardiographic study in patients with submassivePg33 9.PDF",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/28 Efficacy and Safety of Thrombolytic Source J Clin Med Res SO 2017 Feb 9 2 163 169.pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/31 Clinical efficacy of low dose recombinant tissue-type plasminogen activator for the treatment .pdf",
    r"D:/001综合文件夹海康备份/44 自己的系列/52自己的写作文章/02肺栓塞和DVT/01肺栓塞的网状meta/03纳入的文献/V1-ALL/02 Moderate Pulmonary Embolism.pdf",
]


FLAG_PATTERNS = {
    "random": r"random|randomized|randomised",
    "intermediate": r"intermediate|submassive|moderate|normotensive",
    "massive_highrisk": r"massive|high-risk|shock|hypotension",
    "systemic_thrombolysis": r"systemic|alteplase|tenecteplase|rt-pa|streptokinase|thrombolysis|fibrinolysis",
    "catheter": r"catheter|ultrasound|ekos|uscdt|cdt",
    "thrombectomy": r"thrombectomy|large-bore|flowtriever|indigo|penumbra|mechanical",
    "anticoagulation": r"heparin|anticoagulation|anticoagulant|enoxaparin|lmwh|ufh",
    "trial_registry": r"clinicaltrials\.gov|nct\d+",
}


def extract_text(pdf_path: pathlib.Path) -> tuple[str, int | None, str | None]:
    try:
        reader = pypdf.PdfReader(str(pdf_path))
        chunks = []
        for page in reader.pages:
            try:
                chunks.append(page.extract_text() or "")
            except Exception:
                chunks.append("")
        return "\n".join(chunks), len(reader.pages), None
    except Exception as exc:
        return "", None, str(exc)


def main() -> int:
    outdir = pathlib.Path(r"C:/tmp/pe_nma_v1all_screening_text")
    outdir.mkdir(parents=True, exist_ok=True)
    records = []

    for no, raw_path in enumerate(PDF_PATHS, start=1):
        pdf_path = pathlib.Path(raw_path)
        exists = pdf_path.exists()
        data = pdf_path.read_bytes() if exists else b""
        sha16 = hashlib.sha256(data).hexdigest()[:16] if exists else None
        text, pages, error = extract_text(pdf_path) if exists else ("", None, "missing")
        normalized = re.sub(r"\s+", " ", text).strip()
        lower = normalized.lower()

        safe_stem = re.sub(r"[^A-Za-z0-9_. -]+", "_", pdf_path.stem)[:90]
        text_file = outdir / f"{no:02d}_{safe_stem}.txt"
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
                "exists": exists,
                "sha16": sha16,
                "pages": pages,
                "chars": len(text),
                "text_file": str(text_file),
                "head": normalized[:800],
                "flags": flags,
                "error": error,
            }
        )

    index_path = pathlib.Path(r"C:/tmp/pe_nma_v1all_screening_index.json")
    index_path.write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")

    for rec in records:
        flag_list = ",".join(name for name, value in rec["flags"].items() if value)
        print(
            f"{rec['no']:02d}\t{rec['exists']}\t{rec['pages']}p\t{rec['chars']}ch\t"
            f"{rec['sha16']}\t{rec['file']}\t{flag_list}"
        )
    print(f"INDEX\t{index_path}")
    print(f"TEXT_DIR\t{outdir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
