options(stringsAsFactors = FALSE)

user_lib <- "C:/Users/kilog/AppData/Local/R/win-library/4.6"
if (dir.exists(user_lib)) .libPaths(c(user_lib, .libPaths()))

suppressPackageStartupMessages({
  library(netmeta)
  library(readr)
  library(dplyr)
})

root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
out_dir <- file.path(root, "05_analysis_R", "stratified_nma_v0.1")
fig_dir <- file.path(root, "06_figures", "stratified_nma_v0.1")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

arms <- read_csv(file.path(root, "04_data_extraction", "data_extraction_arms_v0.3_STRATIFY_locked.csv"), show_col_types = FALSE)
rv <- read_csv(file.path(root, "04_data_extraction", "RV_LV_data_v0.2_STRATIFY_locked.csv"), show_col_types = FALSE)

as_yes <- function(x) tolower(trimws(ifelse(is.na(x), "", x))) %in% c("yes", "y", "true", "1")

study_strata <- tibble::tribble(
  ~study_id, ~nma1, ~nma2, ~nma3, ~strata_note,
  "TOPCOAT_2014", TRUE, FALSE, TRUE, "mixed intermediate-risk; NMA-1 exploratory/sensitivity",
  "ULTIMA_2014", TRUE, FALSE, TRUE, "intermediate-risk by RV/LV only; biomarker not required; NMA-1 exploratory",
  "PEITHO_2014", FALSE, TRUE, TRUE, "intermediate-high: RV dysfunction plus positive troponin",
  "SUNSET_sPE_2021", FALSE, FALSE, TRUE, "catheter-lysis population; intermediate/submassive, risk stratum unclear",
  "CANARY_2022", FALSE, TRUE, TRUE, "intermediate-high PE",
  "PEERLESS_2025", FALSE, TRUE, TRUE, "mostly intermediate-high; included in NMA-2 exploratory",
  "STORM_PE_2025", FALSE, TRUE, TRUE, "intermediate-high PE",
  "STRATIFY_2026", FALSE, TRUE, TRUE, "intermediate-high PE by ESC criteria",
  "PRETHA_2026", FALSE, TRUE, TRUE, "intermediate-high PE",
  "HI_PEITHO_2026", FALSE, TRUE, TRUE, "acute intermediate-risk with distress; treated as NMA-2 exploratory",
  "MAPPET3_2002", TRUE, FALSE, TRUE, "older submassive PE; biomarker not required; NMA-1 sensitivity",
  "HAIRE_1993", FALSE, FALSE, TRUE, "OCR pending; not analysis-ready",
  "CDT_PILOT_2022", FALSE, TRUE, TRUE, "intermediate-high PE",
  "FASULLO_2011", TRUE, FALSE, TRUE, "submassive PE with RVD; biomarker mixed/unclear; NMA-1 sensitivity",
  "SINHA_2017", TRUE, FALSE, TRUE, "submassive/intermediate-risk; NMA-1 sensitivity",
  "ZHANG_2018", TRUE, FALSE, TRUE, "acute intermediate-risk; low-dose ST sensitivity",
  "MOPETT_2013", TRUE, FALSE, TRUE, "moderate PE; sensitivity only",
  "AHMED_2018", TRUE, FALSE, TRUE, "submassive PE; biomarker criteria stated; NMA-1 sensitivity"
)

write_csv(study_strata, file.path(out_dir, "risk_strata_assignment_v0.1.csv"))

strata_defs <- list(
  NMA1_intermediate_low_exploratory = study_strata$study_id[study_strata$nma1],
  NMA2_intermediate_high_exploratory = study_strata$study_id[study_strata$nma2],
  NMA3_all_intermediate = study_strata$study_id[study_strata$nma3]
)

save_plot <- function(path, expr, width = 1800, height = 1400, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

plot_edges <- function(pw, title, path) {
  save_plot(path, {
    if (nrow(pw) == 0) {
      plot.new()
      title(main = paste(title, "no analyzable direct comparison"))
    } else {
      nodes <- sort(unique(c(pw$treat1, pw$treat2)))
      theta <- seq(0, 2 * pi, length.out = length(nodes) + 1)[seq_along(nodes)]
      xy <- data.frame(treat = nodes, x = cos(theta), y = sin(theta))
      plot(xy$x, xy$y, type = "n", axes = FALSE, xlab = "", ylab = "", main = title)
      edges <- pw %>% count(treat1, treat2, name = "k")
      for (i in seq_len(nrow(edges))) {
        a <- xy[xy$treat == edges$treat1[i], ]
        b <- xy[xy$treat == edges$treat2[i], ]
        segments(a$x, a$y, b$x, b$y, col = "gray35", lwd = 1.5 + edges$k[i])
        text((a$x + b$x) / 2, (a$y + b$y) / 2, labels = edges$k[i], cex = 0.9)
      }
      points(xy$x, xy$y, pch = 21, bg = "#EAF3F8", cex = 4)
      text(xy$x, xy$y, labels = xy$treat, cex = 1.1)
    }
  })
}

extract_vs_ac <- function(model, outcome, binary = FALSE) {
  trts <- setdiff(model$trts, "AC")
  bind_rows(lapply(trts, function(t) {
    te_r <- model$TE.random[t, "AC"]
    se_r <- model$seTE.random[t, "AC"]
    data.frame(
      outcome = outcome,
      treatment = t,
      reference = "AC",
      random_estimate = te_r,
      random_lower = te_r - 1.96 * se_r,
      random_upper = te_r + 1.96 * se_r,
      random_backtransformed = if (binary) exp(te_r) else te_r,
      random_lower_backtransformed = if (binary) exp(te_r - 1.96 * se_r) else te_r - 1.96 * se_r,
      random_upper_backtransformed = if (binary) exp(te_r + 1.96 * se_r) else te_r + 1.96 * se_r
    )
  }))
}

run_rv <- function(stratum_name, studies) {
  dat <- rv %>%
    filter(study_id %in% studies, analysis_status == "main_continuous_nma") %>%
    mutate(
      mean = as.numeric(early_change_reduction_mean),
      sd = as.numeric(early_change_reduction_sd),
      n = as.numeric(n),
      treat = node,
      studlab = study_id
    ) %>%
    filter(!is.na(mean), !is.na(sd), !is.na(n))
  if (nrow(dat) < 2 || length(unique(dat$studlab)) < 1) {
    return(list(status = "not_enough_arm_data", data = dat, pw = data.frame(), model = NULL))
  }
  pw <- pairwise(treat = treat, mean = mean, sd = sd, n = n, studlab = studlab, data = dat, sm = "MD")
  write_csv(dat, file.path(out_dir, paste0(stratum_name, "_rv_lv_arm_data.csv")))
  write_csv(pw, file.path(out_dir, paste0(stratum_name, "_rv_lv_pairwise.csv")))
  plot_edges(pw, paste(stratum_name, "RV/LV"), file.path(fig_dir, paste0(stratum_name, "_rv_lv_network.png")))
  model <- tryCatch(
    netmeta(TE, seTE, treat1, treat2, studlab, data = pw, sm = "MD",
            reference.group = "AC", common = TRUE, random = TRUE,
            prediction = FALSE, small.values = "bad", method.tau = "REML",
            title = paste(stratum_name, "RV/LV")),
    error = function(e) e
  )
  if (inherits(model, "error")) {
    capture.output(model$message, file = file.path(out_dir, paste0(stratum_name, "_rv_lv_model_error.txt")))
    return(list(status = paste("model_failed:", model$message), data = dat, pw = pw, model = NULL))
  }
  capture.output(summary(model), file = file.path(out_dir, paste0(stratum_name, "_rv_lv_summary.txt")))
  capture.output(netleague(model, common = TRUE, random = TRUE, digits = 3), file = file.path(out_dir, paste0(stratum_name, "_rv_lv_league_table.txt")))
  capture.output(netrank(model, small.values = "bad", random = TRUE), file = file.path(out_dir, paste0(stratum_name, "_rv_lv_p_score_random.txt")))
  saveRDS(model, file.path(out_dir, paste0(stratum_name, "_rv_lv_model.rds")))
  list(status = "model_ok", data = dat, pw = pw, model = model)
}

run_binary <- function(stratum_name, studies, event_col, ready_col, prefix, title) {
  dat <- arms %>%
    filter(study_id %in% studies) %>%
    mutate(
      event = as.numeric(.data[[event_col]]),
      n = as.numeric(n_randomized_or_analyzed),
      treat = node,
      studlab = study_id,
      ready = as_yes(.data[[ready_col]])
    ) %>%
    filter(ready, !is.na(event), !is.na(n))
  if (nrow(dat) < 2 || length(unique(dat$studlab)) < 1) {
    return(list(status = "not_enough_arm_data", data = dat, pw = data.frame(), model = NULL))
  }
  pw <- pairwise(treat = treat, event = event, n = n, studlab = studlab,
                 data = dat, sm = "OR", incr = 0.5, method.incr = "only0")
  write_csv(dat, file.path(out_dir, paste0(stratum_name, "_", prefix, "_arm_data.csv")))
  write_csv(pw, file.path(out_dir, paste0(stratum_name, "_", prefix, "_pairwise.csv")))
  plot_edges(pw, paste(stratum_name, title), file.path(fig_dir, paste0(stratum_name, "_", prefix, "_network.png")))
  model <- tryCatch(
    netmeta(TE, seTE, treat1, treat2, studlab, data = pw, sm = "OR",
            reference.group = "AC", common = TRUE, random = TRUE,
            prediction = FALSE, small.values = "good", method.tau = "REML",
            title = paste(stratum_name, title)),
    error = function(e) e
  )
  if (inherits(model, "error")) {
    capture.output(model$message, file = file.path(out_dir, paste0(stratum_name, "_", prefix, "_model_error.txt")))
    conn <- tryCatch(netconnection(pw$treat1, pw$treat2, pw$studlab), error = function(e) e)
    capture.output(conn, file = file.path(out_dir, paste0(stratum_name, "_", prefix, "_netconnection.txt")))
    return(list(status = paste("model_failed:", model$message), data = dat, pw = pw, model = NULL))
  }
  capture.output(summary(model), file = file.path(out_dir, paste0(stratum_name, "_", prefix, "_summary.txt")))
  capture.output(netleague(model, common = TRUE, random = TRUE, digits = 3), file = file.path(out_dir, paste0(stratum_name, "_", prefix, "_league_table.txt")))
  capture.output(netrank(model, small.values = "good", random = TRUE), file = file.path(out_dir, paste0(stratum_name, "_", prefix, "_p_score_random.txt")))
  saveRDS(model, file.path(out_dir, paste0(stratum_name, "_", prefix, "_model.rds")))
  list(status = "model_ok", data = dat, pw = pw, model = model)
}

all_estimates <- list()
summary_rows <- list()

for (stratum_name in names(strata_defs)) {
  studies <- strata_defs[[stratum_name]]
  outcomes <- list(
    rv_lv = run_rv(stratum_name, studies),
    major_bleeding = run_binary(stratum_name, studies, "major_bleeding_n", "ready_major_bleeding_nma", "major_bleeding", "major bleeding"),
    death_followup = run_binary(stratum_name, studies, "death_followup_n", "ready_death_nma", "death_followup", "death at reported follow-up"),
    clinical_deterioration = run_binary(stratum_name, studies, "clinical_deterioration_n", "ready_clinical_deterioration_nma", "clinical_deterioration", "clinical deterioration")
  )
  for (outcome_name in names(outcomes)) {
    obj <- outcomes[[outcome_name]]
    summary_rows[[length(summary_rows) + 1]] <- data.frame(
      stratum = stratum_name,
      outcome = outcome_name,
      status = obj$status,
      studies = if (nrow(obj$data) > 0) length(unique(obj$data$studlab)) else 0,
      arms = nrow(obj$data),
      nodes = if (nrow(obj$data) > 0) paste(sort(unique(obj$data$treat)), collapse = "/") else "",
      direct_comparisons = if (nrow(obj$pw) > 0) nrow(obj$pw) else 0
    )
    if (!is.null(obj$model)) {
      all_estimates[[length(all_estimates) + 1]] <- extract_vs_ac(
        obj$model,
        paste(stratum_name, outcome_name, sep = "__"),
        binary = outcome_name != "rv_lv"
      )
    }
  }
}

summary_df <- bind_rows(summary_rows)
est_df <- if (length(all_estimates) > 0) bind_rows(all_estimates) else data.frame()
write_csv(summary_df, file.path(out_dir, "stratified_nma_feasibility_summary_v0.1.csv"))
write_csv(est_df, file.path(out_dir, "stratified_nma_vs_AC_estimates_v0.1.csv"))

md <- c(
  "# Stratified NMA v0.1",
  "",
  "This is a first feasibility run of the planned three-network structure.",
  "",
  "- NMA-1 is exploratory/sensitivity only because many older trials are submassive or biomarker-incomplete rather than pure ESC intermediate-low PE.",
  "- NMA-2 is intermediate-high enriched/exploratory.",
  "- NMA-3 is all intermediate-risk or mappable intermediate-risk RCTs.",
  "",
  "## Feasibility Summary",
  "```",
  paste(capture.output(print(summary_df, row.names = FALSE)), collapse = "\n"),
  "```",
  "",
  "## Estimates versus AC",
  "```",
  paste(capture.output(print(est_df, row.names = FALSE)), collapse = "\n"),
  "```"
)
writeLines(md, file.path(out_dir, "stratified_nma_v0.1.md"), useBytes = TRUE)

cat("Wrote stratified NMA outputs to:\n")
cat(out_dir, "\n")
cat(fig_dir, "\n")
print(summary_df, row.names = FALSE)
if (nrow(est_df) > 0) print(est_df, row.names = FALSE)
