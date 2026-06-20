# Frequentist netmeta v0.2

Inputs:
- `04_data_extraction/RV_LV_data_v0.2_STRATIFY_locked.csv`
- `04_data_extraction/data_extraction_arms_v0.3_STRATIFY_locked.csv`

Software:
- R: R version 4.6.0 (2026-04-24 ucrt)
- netmeta: 3.6.0
- meta: 8.5.0

Models:
- RV/LV: mean difference in early 24-96h RV/LV reduction; positive values mean greater RV/LV reduction than AC.
- Major bleeding and death: odds ratio; OR < 1 favours the treatment compared with AC.
- Both common-effect and random-effects models were fitted with REML tau estimation where applicable.

Important limitations:
- STRATIFY is not included in ICH NMA because complete arm-specific ICH counts are not available.
- Strict clinical deterioration/rescue therapy remains disconnected as a single NMA network; a netconnection and feasibility graph are provided instead of a forced model.
- This v0.2 remains pre-publication because HAIRE OCR, PRETHA RV/LV SD recovery, endpoint harmonisation, prediction intervals, Bayesian validation, RoB 2.0, and CINeMA are still pending.

## Estimates versus AC
```
                         outcome treatment reference common_estimate
 early_RV_LV_reduction_24_96h_MD       CAT        AC      0.28000000
 early_RV_LV_reduction_24_96h_MD       CDT        AC      0.39669662
 early_RV_LV_reduction_24_96h_MD      LBAT        AC      0.41669662
 early_RV_LV_reduction_24_96h_MD        ST        AC      0.23604511
 early_RV_LV_reduction_24_96h_MD     USCDT        AC      0.15669662
               major_bleeding_OR       CAT        AC      0.12260232
               major_bleeding_OR       CDT        AC      1.07733489
               major_bleeding_OR      LBAT        AC      1.08514743
               major_bleeding_OR        ST        AC      1.22030933
               major_bleeding_OR     USCDT        AC      0.71288240
               death_followup_OR       CDT        AC     -2.05471301
               death_followup_OR      LBAT        AC     -2.74420388
               death_followup_OR        ST        AC     -0.08834969
               death_followup_OR     USCDT        AC     -0.06288248
 common_lower common_upper random_estimate random_lower random_upper
   0.12904648    0.4309535      0.28000000  -0.03309235    0.5930924
   0.21802636    0.5753669      0.38952840   0.01230615    0.7667507
   0.23319852    0.6001947      0.40952840  -0.05875034    0.8778071
   0.16990245    0.3021878      0.21789700   0.01778767    0.4180063
   0.09117878    0.2222145      0.14952840  -0.04903216    0.3480890
  -2.67750303    2.9227077      0.12260232  -3.16829027    3.4134949
  -2.14877074    4.3034405      1.07733489  -2.58287571    4.7375455
  -2.20759450    4.3778894      1.08514743  -3.01618377    5.1864786
   0.69602326    1.7445954      0.74932046  -0.30382401    1.8024649
  -0.02703209    1.4527969      0.69210404  -0.73751040    2.1217185
  -5.04608742    0.9366614     -2.05471301  -5.04608742    0.9366614
  -6.58332007    1.0949123     -2.74420388  -6.58332007    1.0949123
  -0.66855023    0.4918508     -0.08834969  -0.66855023    0.4918508
  -1.09020071    0.9644358     -0.06288248  -1.09020072    0.9644358
 common_backtransformed common_lower_backtransformed
             0.28000000                  0.129046482
             0.39669662                  0.218026362
             0.41669662                  0.233198522
             0.23604511                  0.169902454
             0.15669662                  0.091178782
             1.13043478                  0.068734568
             2.93684211                  0.116627436
             2.95987616                  0.109964851
             3.38823565                  2.005760434
             2.03986249                  0.973330010
             0.12812960                  0.006434460
             0.06429947                  0.001383249
             0.91544070                  0.512450974
             0.93905383                  0.336149017
 common_upper_backtransformed random_backtransformed
                    0.4309535             0.28000000
                    0.5753669             0.38952840
                    0.6001947             0.40952840
                    0.3021878             0.21789700
                    0.2222145             0.14952840
                   18.5915592             1.13043478
                   73.9537957             2.93684211
                   79.6697017             2.95987616
                    5.7235852             2.11556191
                    4.2750546             1.99791481
                    2.5514489             0.12812960
                    2.9889206             0.06429947
                    1.6353402             0.91544070
                    2.6233071             0.93905383
 random_lower_backtransformed random_upper_backtransformed
                 -0.033092354                    0.5930924
                  0.012306148                    0.7667507
                 -0.058750337                    0.8778071
                  0.017787667                    0.4180063
                 -0.049032159                    0.3480890
                  0.042075474                   30.3712038
                  0.075556413                  114.1536658
                  0.048987811                  178.8376892
                  0.737990737                    6.0645778
                  0.478303219                    8.3454667
                  0.006434460                    2.5514489
                  0.001383249                    2.9889206
                  0.512450974                    1.6353402
                  0.336149017                    2.6233071
```

## v0.2 vs v0.1 comparison
```
# A tibble: 14 × 10
   outcome               treatment random_backtransform…¹ random_lower_backtra…²
   <chr>                 <chr>                      <dbl>                  <dbl>
 1 early_RV_LV_reductio… CAT                       0.280                 0.129  
 2 early_RV_LV_reductio… CDT                       0.510                 0.320  
 3 early_RV_LV_reductio… LBAT                      0.530                 0.335  
 4 early_RV_LV_reductio… ST                        0.270                 0.188  
 5 early_RV_LV_reductio… USCDT                     0.270                 0.178  
 6 major_bleeding_OR     CAT                       1.13                  0.0352 
 7 major_bleeding_OR     CDT                       2.94                  0.0643 
 8 major_bleeding_OR     LBAT                      2.96                  0.0369 
 9 major_bleeding_OR     ST                        1.78                  0.478  
10 major_bleeding_OR     USCDT                     1.38                  0.146  
11 death_followup_OR     CDT                       0.128                 0.00643
12 death_followup_OR     LBAT                      0.0643                0.00138
13 death_followup_OR     ST                        0.781                 0.423  
14 death_followup_OR     USCDT                     1.26                  0.339  
# ℹ abbreviated names: ¹​random_backtransformed_v0.1,
#   ²​random_lower_backtransformed_v0.1
# ℹ 6 more variables: random_upper_backtransformed_v0.1 <dbl>,
#   random_backtransformed_v0.2 <dbl>, random_lower_backtransformed_v0.2 <dbl>,
#   random_upper_backtransformed_v0.2 <dbl>, absolute_change <dbl>,
#   relative_change_percent <dbl>
```
