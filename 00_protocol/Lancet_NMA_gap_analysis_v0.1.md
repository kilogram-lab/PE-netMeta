# Lancet NMA Gap Analysis v0.1

Date: 2026-06-19

Purpose: Convert the user's prior summary of three Lancet network meta-analysis examples into actionable guidance for the PE-netMeta project.

## Bottom Line

The prior summary is highly useful and should be incorporated into the project strategy, especially in four areas:

1. Stronger "clinical practice changing" narrative.
2. Comprehensive multilingual database search, including Chinese databases.
3. Dual analytical framework: frequentist primary NMA plus Bayesian validation.
4. High-quality visual and certainty presentation: league table, net heat plot, prediction intervals, and CINeMA/GRADE-style confidence assessment.

The most important refinement is that we must not overclaim before formal screening and analysis. Statements such as "USCDT should be first-line" or "PROSPERO completed" should only be used after data verification and registration confirmation.

## What To Borrow Directly

### 1. The Lancet-Style "Added Value" Narrative

The PE NMA should not be framed as a routine update. It should be framed as a decision-making evidence synthesis:

"Which reperfusion strategy should be selected for which intermediate-risk PE patient?"

This framing is stronger than simply asking whether one treatment is statistically superior to another.

### 2. Six-Node Treatment Structure

The six-node structure is clinically attractive and should remain the search and extraction framework:

- `AC`: anticoagulation alone
- `ST`: systemic thrombolysis
- `CDT`: catheter-directed thrombolysis
- `USCDT`: ultrasound-assisted catheter-directed thrombolysis
- `LBAT`: large-bore aspiration thrombectomy
- `CAT`: catheter-assisted aspiration thrombectomy

This improves on the CMAJ 2023 NMA, which used broader nodes and mixed randomized and observational evidence.

### 3. Three Stratified NMAs

The planned stratification is a real methodological and clinical strength:

- `NMA-1`: intermediate-low-risk PE
- `NMA-2`: intermediate-high-risk PE
- `NMA-3`: all intermediate-risk PE

This could be one of the main "Added value of this study" points because it maps directly to clinical risk-based decision-making.

### 4. Broad Search Strategy

A search plan including English and Chinese databases is worth keeping. It supports a Lancet-level completeness argument.

Planned database families should include:

- English biomedical databases: PubMed/MEDLINE, Embase, Cochrane CENTRAL, Web of Science or Scopus.
- Trial registries: ClinicalTrials.gov, WHO ICTRP, EU Clinical Trials Register if feasible.
- Chinese databases: CNKI, Wanfang, VIP, SinoMed/CBM, and another suitable Chinese biomedical database if accessible.

Important caveat: Chinese RCTs need careful randomization and authenticity checks. The Schneider-Thoma Lancet example is useful not only because it searched Chinese databases, but because it actively handled quality concerns.

### 5. Dual Framework Validation

Use a frequentist NMA as the main analysis and a Bayesian NMA as validation, or vice versa if protocol-justified.

Minimum reporting:

- Compare effect direction and magnitude across frequentist and Bayesian models.
- Report heterogeneity and prediction intervals.
- Explore inconsistency with global and local methods.
- Use net heat plot or comparable tools where appropriate.

### 6. Visual Strategy

Keep:

- Network plots by outcome and risk stratum.
- League tables for efficacy and safety.
- Net heat plots for inconsistency contribution.
- Prediction intervals in forest/summary plots.
- CINeMA/GRADE evidence confidence map.
- A possible PE-specific "benefit-harm map" showing clinical deterioration/death versus major bleeding/ICH.

The PE-specific benefit-harm map may be our closest analogue to a Lancet-style innovative visualization.

## Statements That Need Correction Or Caution

### 1. "14 RCTs"

Current project records do not support fixing the number at 14. The v0.1/v0.2 seed matrix began from 19 CMAJ 2023 RCTs plus newer candidate RCT lines. After applying PICOS v0.2 and excluding high-risk or mixed high-risk trials without separable intermediate-risk data, the final number may decrease.

Recommended wording:

"The final number of eligible RCTs will be determined after formal screening and full-text verification."

### 2. "PROSPERO registration completed"

Current project records do not show a PROSPERO registration number for our PE NMA. Unless the user provides a completed registration ID, this should be treated as pending.

Recommended wording:

"PROSPERO registration is planned before data analysis."

### 3. "All three Lancet examples used CINeMA"

This should not be stated unless verified article by article. CINeMA is definitely a strong method to use, but the safer project-level statement is:

"Confidence in network estimates will be assessed using CINeMA or GRADE for NMA."

### 4. "USCDT should be first-line based on HI-PEITHO"

This is too strong before the formal NMA is completed. It risks sounding predetermined.

Recommended pre-analysis wording:

"If USCDT shows a favorable benefit-harm profile in intermediate-high-risk PE, the findings could support earlier use of USCDT in selected patients."

Recommended post-analysis wording should depend on actual results and certainty:

"USCDT may be preferred for selected intermediate-high-risk PE patients when the certainty of evidence is moderate or high and bleeding risk is acceptable."

### 5. "LBAT and CAT require further RCT evidence"

This may be true, but should be made evidence-dependent. If PEERLESS, STORM-PE, PEERLESS II, STRATIFY, or PRETHA provide usable randomized evidence, the wording must reflect the actual certainty.

Recommended wording:

"LBAT and CAT will be interpreted according to direct RCT evidence, network connectivity, and certainty ratings; sparse evidence will be explicitly labeled."

## Revised Cover Letter Core Narrative

Suggested cautious version:

We present a randomized-trial-only network meta-analysis comparing six clinically relevant treatment strategies for acute intermediate-risk pulmonary embolism: anticoagulation alone, systemic thrombolysis, catheter-directed thrombolysis, ultrasound-assisted catheter-directed thrombolysis, large-bore aspiration thrombectomy, and catheter-assisted aspiration thrombectomy.

This study addresses key limitations of previous evidence syntheses by separating intermediate-low-risk and intermediate-high-risk PE where data allow, integrating recently published randomized trials, searching both English and Chinese databases, and validating network estimates using complementary statistical frameworks.

Rather than providing a single overall ranking, this project aims to identify which strategy offers the most favorable benefit-harm balance for specific intermediate-risk PE strata, with explicit attention to clinical deterioration, all-cause mortality, major bleeding, intracranial hemorrhage, right ventricular recovery, and device-related complications.

## Research In Context Draft Logic

### Evidence Before This Study

Previous PE network meta-analyses compared broad categories such as anticoagulation, systemic thrombolysis, and catheter-directed thrombolysis, often combining randomized and observational evidence. These analyses were limited in their ability to distinguish intermediate-low-risk from intermediate-high-risk PE and did not fully separate newer catheter-based reperfusion strategies.

### Added Value Of This Study

This study will use RCT-only evidence to compare six clinically meaningful treatment nodes and will evaluate the network separately for intermediate-low-risk PE, intermediate-high-risk PE, and all intermediate-risk PE. It will incorporate recent RCT evidence, apply RoB 2.0, use frequentist and Bayesian validation, and assess confidence in estimates with CINeMA or GRADE for NMA.

### Implications Of All The Available Evidence

The goal is to provide actionable guidance on selecting reperfusion or anticoagulation strategies for intermediate-risk PE patients, while clearly identifying where evidence is strong enough for practice and where additional head-to-head RCTs remain necessary.

## Highest-Priority Next Actions

1. Do not write definitive clinical recommendations until formal data extraction and NMA results are available.
2. Verify PROSPERO status; if not registered, prepare and submit registration before analysis.
3. Confirm candidate RCTs, especially PEERLESS, STORM-PE, HI-PEITHO, STRATIFY, PRETHA, PEERLESS II, and PEITHO-3.
4. Build the formal search strategy for English, Chinese, and trial-registry databases.
5. Add extraction fields for risk stratum, device type, clinical deterioration definition, and device-related complications.
6. Pre-specify benefit-harm visualization, likely death/clinical deterioration versus major bleeding/ICH.
