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

## Current PICOS v0.1

**Population:** Adults with acute intermediate-risk, intermediate-high-risk, or high-risk PE.

**Interventions and comparators:** Anticoagulation, full-dose systemic thrombolysis, reduced-dose systemic thrombolysis, catheter-directed thrombolysis, ultrasound-assisted catheter-directed thrombolysis, mechanical or aspiration thrombectomy, and other randomized acute PE strategies if RCT evidence exists.

**Outcomes:** All-cause death, clinical deterioration or treatment failure, major bleeding, intracranial hemorrhage, recurrent PE/VTE, right ventricular recovery, ICU/hospital length of stay, and long-term functional outcomes where available.

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

- `PICOS_v0.1.txt`
- `PICOS_v0.1_及_RCT证据矩阵.xlsx`
- `方法和结果.txt`
- literature learning notes and manuscript-planning notes

These files are intentionally kept in the local project output folder because they may include evolving research records, extracted study information, manuscript materials, or large artifacts.

## Reproducible Script

The current script:

```bash
scripts/build_picos_rct_matrix.mjs
```

generates:

- a working PICOS v0.1 text file
- an Excel workbook containing:
  - `Summary`
  - `PICOS_v0.1`
  - `Node_Definitions`
  - `RCT_Evidence_Matrix`
  - `Outcome_Dictionary`
  - `Next_Actions`

The matrix is a seed matrix, not the final included-study list. It starts from RCTs identified in the CMAJ 2023 PE network meta-analysis and adds newer candidate RCT lines that require formal full-text and registry verification.

## Next Steps

1. Run formal database and trial-registry searches.
2. Verify each candidate RCT by full text and registry record.
3. Update the RCT-treatment node-outcome evidence matrix.
4. Check network connectivity separately for each major outcome.
5. Freeze PICOS v1.0 and write the protocol before analysis.

## Project Rule

For every meaningful project operation, update the local `方法和结果.txt` record after reading it in full, and read it again after writing to confirm consistency. This log is the audit trail for future manuscript methods and results sections.
