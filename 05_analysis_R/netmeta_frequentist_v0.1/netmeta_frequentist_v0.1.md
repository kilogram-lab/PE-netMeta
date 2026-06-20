# Frequentist netmeta v0.1

Software:
- R: R version 4.6.0 (2026-04-24 ucrt)
- netmeta: 3.6.0
- meta: 8.5.0

Models:
- RV/LV: mean difference in early 24-48h RV/LV reduction; positive values mean greater RV/LV reduction than AC.
- Major bleeding and death: odds ratio; OR < 1 favours the treatment compared with AC.
- Both common-effect and random-effects models were fitted with REML tau estimation where applicable.

Important limitation:
- This is v0.1 based on the current extracted data. It is not the final publication model because STRATIFY, HAIRE, PRETHA SD recovery, and final endpoint harmonisation remain pending.

## Estimates versus AC
                         outcome treatment reference common_estimate
 early_RV_LV_reduction_24_48h_MD       CAT        AC       0.2800000
 early_RV_LV_reduction_24_48h_MD       CDT        AC       0.5100000
 early_RV_LV_reduction_24_48h_MD      LBAT        AC       0.5300000
 early_RV_LV_reduction_24_48h_MD        ST        AC       0.2700000
 early_RV_LV_reduction_24_48h_MD     USCDT        AC       0.2700000
               major_bleeding_OR       CAT        AC       0.1226023
               major_bleeding_OR       CDT        AC       1.0773349
               major_bleeding_OR      LBAT        AC       1.0851474
               major_bleeding_OR        ST        AC       1.3007097
               major_bleeding_OR     USCDT        AC       0.3222633
               death_followup_OR       CDT        AC      -2.0547130
               death_followup_OR      LBAT        AC      -2.7442039
               death_followup_OR        ST        AC      -0.2470432
               death_followup_OR     USCDT        AC       0.2338905
 common_lower common_upper random_estimate random_lower random_upper
    0.1290465    0.4309535       0.2800000    0.1290465    0.4309535
    0.3198847    0.7001153       0.5100000    0.3198847    0.7001153
    0.3353405    0.7246595       0.5300000    0.3353405    0.7246595
    0.1878300    0.3521700       0.2700000    0.1878300    0.3521700
    0.1777322    0.3622678       0.2700000    0.1777322    0.3622678
   -2.6775030    2.9227077       0.1226023   -3.3460766    3.5912812
   -2.1487707    4.3034405       1.0773349   -2.7435159    4.8981857
   -2.2075945    4.3778894       1.0851474   -3.2994205    5.4697154
    0.7315133    1.8699061       0.5741919   -0.7387536    1.8871375
   -0.6044005    1.2489271       0.3222633   -1.9249237    2.5694502
   -5.0460874    0.9366614      -2.0547130   -5.0460874    0.9366614
   -6.5833201    1.0949123      -2.7442039   -6.5833201    1.0949123
   -0.8599808    0.3658945      -0.2470432   -0.8599808    0.3658945
   -1.0831133    1.5508944       0.2338905   -1.0831133    1.5508944
 common_backtransformed common_lower_backtransformed
             0.28000000                  0.129046482
             0.51000000                  0.319884739
             0.53000000                  0.335340545
             0.27000000                  0.187830036
             0.27000000                  0.177732244
             1.13043478                  0.068734568
             2.93684211                  0.116627436
             2.95987616                  0.109964851
             3.67190162                  2.078223188
             1.38024809                  0.546401873
             0.12812960                  0.006434460
             0.06429947                  0.001383249
             0.78110697                  0.423170201
             1.26350618                  0.338539907
 common_upper_backtransformed random_backtransformed
                    0.4309535             0.28000000
                    0.7001153             0.51000000
                    0.7246595             0.53000000
                    0.3521700             0.27000000
                    0.3622678             0.27000000
                   18.5915592             1.13043478
                   73.9537957             2.93684211
                   79.6697017             2.95987616
                    6.4876870             1.77569506
                    3.4866000             1.38024809
                    2.5514489             0.12812960
                    2.9889206             0.06429947
                    1.4418031             0.78110697
                    4.7156859             1.26350618
 random_lower_backtransformed random_upper_backtransformed
                  0.129046482                    0.4309535
                  0.319884739                    0.7001153
                  0.335340545                    0.7246595
                  0.187830036                    0.3521700
                  0.177732244                    0.3622678
                  0.035222276                   36.2805293
                  0.064343722                  134.0463566
                  0.036904547                  237.3926130
                  0.477708950                    6.6004477
                  0.145886892                   13.0586427
                  0.006434460                    2.5514489
                  0.001383249                    2.9889206
                  0.423170201                    1.4418031
                  0.338539907                    4.7156859
