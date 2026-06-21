# Stratified NMA v0.1

This is a first feasibility run of the planned three-network structure.

- NMA-1 is exploratory/sensitivity only because many older trials are submassive or biomarker-incomplete rather than pure ESC intermediate-low PE.
- NMA-2 is intermediate-high enriched/exploratory.
- NMA-3 is all intermediate-risk or mappable intermediate-risk RCTs.

## Feasibility Summary
```
                            stratum                outcome
  NMA1_intermediate_low_exploratory                  rv_lv
  NMA1_intermediate_low_exploratory         major_bleeding
  NMA1_intermediate_low_exploratory         death_followup
  NMA1_intermediate_low_exploratory clinical_deterioration
 NMA2_intermediate_high_exploratory                  rv_lv
 NMA2_intermediate_high_exploratory         major_bleeding
 NMA2_intermediate_high_exploratory         death_followup
 NMA2_intermediate_high_exploratory clinical_deterioration
              NMA3_all_intermediate                  rv_lv
              NMA3_all_intermediate         major_bleeding
              NMA3_all_intermediate         death_followup
              NMA3_all_intermediate clinical_deterioration
                                                                                                                 status
                                                                                                               model_ok
                                                                                                               model_ok
                                                                                                               model_ok
                                                                                                               model_ok
 model_failed: Network consists of 2 separate sub-networks.\n  Use R function 'netconnection' to identify sub-networks.
                                                                                                               model_ok
                                                                                                               model_ok
 model_failed: Network consists of 2 separate sub-networks.\n  Use R function 'netconnection' to identify sub-networks.
                                                                                                               model_ok
                                                                                                               model_ok
                                                                                                               model_ok
 model_failed: Network consists of 2 separate sub-networks.\n  Use R function 'netconnection' to identify sub-networks.
 studies arms                    nodes direct_comparisons
       2    4              AC/ST/USCDT                  2
       7   14              AC/ST/USCDT                  7
       6   12              AC/ST/USCDT                  6
       5   10              AC/ST/USCDT                  5
       3    7 AC/CAT/CDT/LBAT/ST/USCDT                  5
       7   15 AC/CAT/CDT/LBAT/ST/USCDT                  9
       5   11     AC/CDT/LBAT/ST/USCDT                  7
       5   11 AC/CAT/CDT/LBAT/ST/USCDT                  7
       6   13 AC/CAT/CDT/LBAT/ST/USCDT                  8
      14   29 AC/CAT/CDT/LBAT/ST/USCDT                 16
      11   23     AC/CDT/LBAT/ST/USCDT                 13
      10   21 AC/CAT/CDT/LBAT/ST/USCDT                 12
```

## Estimates versus AC
```
                                                   outcome treatment reference
                  NMA1_intermediate_low_exploratory__rv_lv        ST        AC
                  NMA1_intermediate_low_exploratory__rv_lv     USCDT        AC
         NMA1_intermediate_low_exploratory__major_bleeding        ST        AC
         NMA1_intermediate_low_exploratory__death_followup        ST        AC
         NMA1_intermediate_low_exploratory__death_followup     USCDT        AC
 NMA1_intermediate_low_exploratory__clinical_deterioration        ST        AC
        NMA2_intermediate_high_exploratory__major_bleeding       CAT        AC
        NMA2_intermediate_high_exploratory__major_bleeding       CDT        AC
        NMA2_intermediate_high_exploratory__major_bleeding      LBAT        AC
        NMA2_intermediate_high_exploratory__major_bleeding        ST        AC
        NMA2_intermediate_high_exploratory__major_bleeding     USCDT        AC
        NMA2_intermediate_high_exploratory__death_followup       CDT        AC
        NMA2_intermediate_high_exploratory__death_followup      LBAT        AC
        NMA2_intermediate_high_exploratory__death_followup        ST        AC
        NMA2_intermediate_high_exploratory__death_followup     USCDT        AC
                              NMA3_all_intermediate__rv_lv       CAT        AC
                              NMA3_all_intermediate__rv_lv       CDT        AC
                              NMA3_all_intermediate__rv_lv      LBAT        AC
                              NMA3_all_intermediate__rv_lv        ST        AC
                              NMA3_all_intermediate__rv_lv     USCDT        AC
                     NMA3_all_intermediate__major_bleeding       CAT        AC
                     NMA3_all_intermediate__major_bleeding       CDT        AC
                     NMA3_all_intermediate__major_bleeding      LBAT        AC
                     NMA3_all_intermediate__major_bleeding        ST        AC
                     NMA3_all_intermediate__major_bleeding     USCDT        AC
                     NMA3_all_intermediate__death_followup       CDT        AC
                     NMA3_all_intermediate__death_followup      LBAT        AC
                     NMA3_all_intermediate__death_followup        ST        AC
                     NMA3_all_intermediate__death_followup     USCDT        AC
 random_estimate random_lower random_upper random_backtransformed
      0.27000000   0.18783004    0.3521700             0.27000000
      0.27000000   0.17773224    0.3622678             0.27000000
     -0.17140738  -1.45837900    1.1155642             0.84247829
     -0.12856416  -1.16801706    0.9108887             0.87935714
     -1.16643489  -4.40757878    2.0747090             0.31147541
     -1.21782328  -1.84093487   -0.5947117             0.29587350
      0.12260232  -2.67750303    2.9227077             1.13043478
      1.07733489  -2.14877074    4.3034405             2.93684211
      1.08514743  -2.20759450    4.3778894             2.95987616
      1.49747223   0.92335360    2.0715909             4.47037469
      0.80664748   0.06251176    1.5507832             2.24038444
     -2.05471301  -5.54933798    1.4399120             0.12812960
     -2.74420388  -7.35581734    1.8674096             0.06429947
      0.38916095  -1.18628820    1.9646101             1.47574205
      0.32976190  -1.41196030    2.0714841             1.39063698
      0.28000000  -0.03309235    0.5930924             0.28000000
      0.38952840   0.01230615    0.7667507             0.38952840
      0.40952840  -0.05875034    0.8778071             0.40952840
      0.21789700   0.01778767    0.4180063             0.21789700
      0.14952840  -0.04903216    0.3480890             0.14952840
      0.12260232  -3.16829027    3.4134949             1.13043478
      1.07733489  -2.58287571    4.7375455             2.93684211
      1.08514743  -3.01618377    5.1864786             2.95987616
      0.74932046  -0.30382401    1.8024649             2.11556191
      0.69210404  -0.73751040    2.1217185             1.99791481
     -2.05471301  -5.04608742    0.9366614             0.12812960
     -2.74420388  -6.58332007    1.0949123             0.06429947
     -0.08834969  -0.66855023    0.4918508             0.91544070
     -0.06288248  -1.09020072    0.9644358             0.93905383
 random_lower_backtransformed random_upper_backtransformed
                  0.187830036                    0.3521700
                  0.177732244                    0.3622678
                  0.232613034                    3.0512893
                  0.310982990                    2.4865314
                  0.012184644                    7.9622292
                  0.158669022                    0.5517216
                  0.068734568                   18.5915592
                  0.116627436                   73.9537958
                  0.109964851                   79.6697019
                  2.517719683                    7.9374404
                  1.064506977                    4.7151616
                  0.003890032                    4.2203243
                  0.000638865                    6.4715108
                  0.305352570                    7.1321313
                  0.243665158                    7.9365931
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
