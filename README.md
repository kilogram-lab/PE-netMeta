# PE-netMeta

RCT-only network meta-analysis project for acute pulmonary embolism (PE) treatment strategies.

This repository is used to back up and version-control project code, reproducible scripts, protocol-related notes, and lightweight project documentation. Large outputs, temporary files, PDFs, extracted datasets, and manuscript artifacts are kept outside the GitHub repository in the local project output folder.

## Research Aim

The planned study will compare the efficacy and safety of reperfusion and anticoagulation strategies for acute intermediate-risk, intermediate-high-risk, and high-risk pulmonary embolism using randomized controlled trial (RCT) evidence.

The current strategic direction is:

- RCT-only evidence synthesis
- clinically interpretable treatment nodes
- hard clinical endpoints plus safety outcomes
- explicit assessment of evidence certainty
- network structure determined by RCT connectivity, not by preference for more nodes

## Current PICOS v0.2

**Population:** Adults with acute intermediate-risk PE. The main population excludes low-risk PE and high-risk PE.

Planned population strata:

- `NMA-1`: intermediate-low-risk PE
- `NMA-2`: intermediate-high-risk PE
- `NMA-3`: all intermediate-risk PE

**Interventions and comparators:** Six candidate NMA nodes are currently locked for searching and extraction:

- `AC`: anticoagulation alone
- `ST`: systemic thrombolysis
- `CDT`: catheter-directed thrombolysis
- `USCDT`: ultrasound-assisted catheter-directed thrombolysis
- `LBAT`: large-bore aspiration thrombectomy, such as FlowTriever
- `CAT`: catheter-assisted aspiration thrombectomy, such as Indigo

**Outcomes:** Primary outcomes are all-cause death and clinical deterioration. Secondary and safety outcomes include major bleeding, intracranial hemorrhage, recurrent PE, right ventricular recovery, pulmonary artery pressure reduction, minor bleeding, transfusion, renal injury, and device-related complications.

**Study design:** Randomized controlled trials only. Quasi-randomized or unclear-randomization studies must be flagged and handled separately.

## Repository Structure

```text
.
├── README.md
├── PROJECT_MEMORY.md
├── scripts/
│   └── build_picos_rct_matrix.mjs
└── .gitignore
```

## Key Local Outputs

The following outputs are generated outside this repository:

- `PICOS_v0.2.txt`
- `PICOS_v0.2_及_RCT证据矩阵.xlsx`
- `方法和结果.txt`
- literature learning notes and manuscript-planning notes

These files are intentionally kept in the local project output folder because they may include evolving research records, extracted study information, manuscript materials, or large artifacts.

## Reproducible Script

The current script:

```bash
scripts/build_picos_rct_matrix.mjs
```

generates:

- a working PICOS v0.2 text file
- an Excel workbook containing:
  - `Summary`
  - `PICOS_v0.2`
  - `Population_Strata`
  - `Node_Definitions`
  - `RCT_Evidence_Matrix`
  - `Outcome_Dictionary`
  - `Next_Actions`

The matrix is a seed matrix, not the final included-study list. It starts from RCTs identified in the CMAJ 2023 PE network meta-analysis and adds newer candidate RCT lines that require formal full-text and registry verification.

## Next Steps

1. Run formal database and trial-registry searches.
2. Verify each candidate RCT by full text and registry record.
3. Update the RCT-treatment node-outcome evidence matrix.
4. Classify studies into `NMA-1`, `NMA-2`, and `NMA-3` strata.
5. Check network connectivity separately for each major outcome and risk stratum.
6. Freeze PICOS v1.0 and write the protocol before analysis.

## Project Rule

For every meaningful project operation, update the local `方法和结果.txt` record after reading it in full, and read it again after writing to confirm consistency. This log is the audit trail for future manuscript methods and results sections.
