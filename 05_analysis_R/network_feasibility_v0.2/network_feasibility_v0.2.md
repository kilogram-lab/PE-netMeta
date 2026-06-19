# Network Feasibility Check v0.2

Input: `04_data_extraction/data_extraction_arms_v0.2_locked_core_outcomes.csv`.

Rules:
- Binary outcomes used arms with non-missing sample size and event count plus the corresponding `ready_*_nma == yes` flag.
- Clinical deterioration also has a sensitivity version including `ready_*_nma == sensitivity`.
- RV/LV used arms with non-empty `rv_lv_or_rv_recovery_locked`; this is a feasibility graph only, because the v0.2 field is still text and needs numeric harmonisation before continuous-outcome NMA.
- Verdict definitions: `connected_with_loop` supports full network consistency exploration; `connected_but_tree_sparse` is connected but lacks closed loops; `pairwise_only` has only two nodes; `disconnected` is not suitable as a single NMA; `not_analyzable` lacks a usable comparison.

## Summary

                            outcome studies arms                         nodes
                     death_followup      10   20      AC, CDT, LBAT, ST, USCDT
             clinical_deterioration       9   18 AC, CAT, CDT, LBAT, ST, USCDT
 clinical_deterioration_sensitivity      10   20 AC, CAT, CDT, LBAT, ST, USCDT
         primary_clinical_composite       8   16       AC, CAT, CDT, ST, USCDT
                     major_bleeding      13   26 AC, CAT, CDT, LBAT, ST, USCDT
            intracranial_hemorrhage      11   22      AC, CDT, LBAT, ST, USCDT
               rv_lv_or_rv_recovery      10   21 AC, CAT, CDT, LBAT, ST, USCDT
 n_nodes direct_edges
       5            4
       6            4
       6            4
       5            4
       6            5
       5            4
       6            7
                                                                              edge_details
                                         AC-CDT (1); AC-ST (6); AC-USCDT (2); CDT-LBAT (1)
                                         AC-CAT (1); AC-ST (5); AC-USCDT (2); CDT-LBAT (1)
                                         AC-CAT (1); AC-ST (6); AC-USCDT (2); CDT-LBAT (1)
                                           AC-CAT (1); AC-CDT (1); AC-ST (5); AC-USCDT (1)
                             AC-CAT (1); AC-CDT (2); AC-ST (7); AC-USCDT (2); CDT-LBAT (1)
                                         AC-CDT (1); AC-ST (7); AC-USCDT (2); CDT-LBAT (1)
 AC-CAT (2); AC-CDT (2); AC-ST (4); AC-USCDT (1); CAT-CDT (1); CDT-LBAT (1); CDT-USCDT (1)
 connected                 components loop_present                   verdict
      TRUE       AC/CDT/ST/USCDT/LBAT        FALSE connected_but_tree_sparse
     FALSE AC/ST/USCDT/CAT | CDT/LBAT        FALSE              disconnected
     FALSE AC/ST/USCDT/CAT | CDT/LBAT        FALSE              disconnected
      TRUE        AC/CDT/USCDT/ST/CAT        FALSE connected_but_tree_sparse
      TRUE   AC/ST/CDT/USCDT/CAT/LBAT        FALSE connected_but_tree_sparse
      TRUE       AC/ST/CDT/USCDT/LBAT        FALSE connected_but_tree_sparse
      TRUE   AC/ST/CDT/CAT/USCDT/LBAT         TRUE       connected_with_loop

## Immediate Interpretation

- death_followup: connected_but_tree_sparse; studies=10, nodes=5, edges=4. Edges: AC-CDT (1); AC-ST (6); AC-USCDT (2); CDT-LBAT (1).
- clinical_deterioration: disconnected; studies=9, nodes=6, edges=4. Edges: AC-CAT (1); AC-ST (5); AC-USCDT (2); CDT-LBAT (1).
- clinical_deterioration_sensitivity: disconnected; studies=10, nodes=6, edges=4. Edges: AC-CAT (1); AC-ST (6); AC-USCDT (2); CDT-LBAT (1).
- primary_clinical_composite: connected_but_tree_sparse; studies=8, nodes=5, edges=4. Edges: AC-CAT (1); AC-CDT (1); AC-ST (5); AC-USCDT (1).
- major_bleeding: connected_but_tree_sparse; studies=13, nodes=6, edges=5. Edges: AC-CAT (1); AC-CDT (2); AC-ST (7); AC-USCDT (2); CDT-LBAT (1).
- intracranial_hemorrhage: connected_but_tree_sparse; studies=11, nodes=5, edges=4. Edges: AC-CDT (1); AC-ST (7); AC-USCDT (2); CDT-LBAT (1).
- rv_lv_or_rv_recovery: connected_with_loop; studies=10, nodes=6, edges=7. Edges: AC-CAT (2); AC-CDT (2); AC-ST (4); AC-USCDT (1); CAT-CDT (1); CDT-LBAT (1); CDT-USCDT (1).

