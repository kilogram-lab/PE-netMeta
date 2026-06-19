# Exploratory NMA v0.1

This is a preliminary fixed-effect contrast-based weighted least squares analysis implemented in base R because `netmeta` is not currently installed.

Interpretation rules:
- RV/LV outcome uses early 24-48h mean RV/LV reduction; positive MD versus AC means greater RV/LV reduction.
- Major bleeding and death use log odds ratios; OR < 1 favours the treatment versus AC.
- Sparse/tree-like networks mean estimates are highly dependent on indirect chains and should not be treated as final publication results.

## RV/LV estimates
                         outcome treatment reference estimate_vs_AC         se
 early_RV_LV_reduction_24_48h_MD       CAT        AC           0.28 0.07701710
 early_RV_LV_reduction_24_48h_MD       CDT        AC           0.51 0.09699758
 early_RV_LV_reduction_24_48h_MD      LBAT        AC           0.53 0.09931605
 early_RV_LV_reduction_24_48h_MD        ST        AC           0.27 0.04192345
 early_RV_LV_reduction_24_48h_MD     USCDT        AC           0.27 0.04707539
  lower_95  upper_95 k_pairwise_contrasts k_studies
 0.1290465 0.4309535                    5         5
 0.3198847 0.7001153                    5         5
 0.3353405 0.7246595                    5         5
 0.1878300 0.3521700                    5         5
 0.1777322 0.3622678                    5         5

## Major bleeding estimates
              outcome treatment reference estimate_vs_AC        se   lower_95
 major_bleeding_logOR       CAT        AC      0.1226023 1.4286252 -2.6775030
 major_bleeding_logOR       CDT        AC      0.6200110 1.2813222 -1.8913804
 major_bleeding_logOR      LBAT        AC      0.6278236 1.3247121 -1.9686122
 major_bleeding_logOR        ST        AC      1.2519274 0.2845664  0.6941772
 major_bleeding_logOR     USCDT        AC      0.3037358 0.4603063 -0.5984646
 upper_95 k_pairwise_contrasts k_studies OR_vs_AC OR_lower_95 OR_upper_95
 2.922708                   13        13 1.130435  0.06873457   18.591559
 3.131402                   13        13 1.858949  0.15086341   22.906082
 3.224259                   13        13 1.873529  0.13965052   25.134952
 1.809678                   13        13 3.497077  2.00206107    6.108478
 1.205936                   13        13 1.354911  0.54965494    3.339885

## Death estimates
              outcome treatment reference estimate_vs_AC        se   lower_95
 death_followup_logOR       CDT        AC     -2.0547130 1.5262114 -5.0460874
 death_followup_logOR      LBAT        AC     -2.7442039 1.9587328 -6.5833201
 death_followup_logOR        ST        AC     -0.2412320 0.3090233 -0.8469178
 death_followup_logOR     USCDT        AC      0.2338905 0.6719407 -1.0831133
  upper_95 k_pairwise_contrasts k_studies   OR_vs_AC OR_lower_95 OR_upper_95
 0.9366614                   10        10 0.12812960 0.006434460    2.551449
 1.0949123                   10        10 0.06429947 0.001383249    2.988921
 0.3644537                   10        10 0.78565931 0.428734352    1.439727
 1.5508944                   10        10 1.26350618 0.338539907    4.715686
