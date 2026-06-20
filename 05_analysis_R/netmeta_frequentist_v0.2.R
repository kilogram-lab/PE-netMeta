options(stringsAsFactors = FALSE)

user_lib <- "C:/Users/kilog/AppData/Local/R/win-library/4.6"
if (dir.exists(user_lib)) .libPaths(c(user_lib, .libPaths()))

suppressPackageStartupMessages({
  library(netmeta)
  library(readr)
  library(dplyr)
})

root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
out_dir <- file.path(root, "05_analysis_R", "netmeta_frequentist_v0.2")
fig_dir <- file.path(root, "06_figures", "netmeta_frequentist_v0.2")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

rv <- read_csv(file.path(root, "04_data_extraction", "RV_LV_data_v0.2_STRATIFY_locked.csv"), show_col_types = FALSE)
arms <- read_csv(file.path(root, "04_data_extraction", "data_extraction_arms_v0.3_STRATIFY_locked.csv"), show_col_types = FALSE)

as_yes <- function(x) tolower(trimws(ifelse(is.na(x), "", x))) %in% c("yes", "y", "true", "1")

save_plot <- function(path, expr, width = 1800, height = 1400, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

safe_name <- function(x) gsub("[^A-Za-z0-9_]+", "_", x)

pscore_table <- function(model, prefix, binary = FALSE) {
  rank_common <- netrank(model, small.values = if (binary) "good" else "bad", common = TRUE)
  rank_random <- netrank(model, small.values = if (binary) "good" else "bad", random = TRUE)
  capture.output(rank_common, file = file.path(out_dir, paste0(prefix, "_ranking_common.txt")))
  capture.output(rank_random, file = file.path(out_dir, paste0(prefix, "_ranking_random.txt")))
  txt <- capture.output(rank_random)
  writeLines(txt, file.path(out_dir, paste0(prefix, "_p_score_random.txt")), useBytes = TRUE)
  invisible(txt)
}

write_model_outputs <- function(model, prefix, binary = FALSE) {
  sink(file.path(out_dir, paste0(prefix, "_summary.txt")))
  print(summary(model))
  cat("\n\n--- netrank common ---\n")
  print(netrank(model, small.values = if (binary) "good" else "bad", common = TRUE))
  cat("\n\n--- netrank random ---\n")
  print(netrank(model, small.values = if (binary) "good" else "bad", random = TRUE))
  sink()

  league <- netleague(model, common = TRUE, random = TRUE, digits = 3)
  capture.output(league, file = file.path(out_dir, paste0(prefix, "_league_table.txt")))
  pscore_table(model, prefix, binary)
  saveRDS(model, file.path(out_dir, paste0(prefix, "_netmeta_model.rds")))

  save_plot(file.path(fig_dir, paste0(prefix, "_network.png")), {
    netgraph(model, plastic = FALSE, cex.points = 4, cex = 1.1,
             thickness = "number.of.studies", number.of.studies = TRUE,
             col = "gray25", col.points = "#EAF3F8")
  })
}

make_rv_model <- function() {
  dat <- rv %>%
    filter(analysis_status == "main_continuous_nma") %>%
    mutate(
      mean = as.numeric(early_change_reduction_mean),
      sd = as.numeric(early_change_reduction_sd),
      n = as.numeric(n),
      treat = node,
      studlab = study_id
    ) %>%
    filter(!is.na(mean), !is.na(sd), !is.na(n))

  pw <- pairwise(treat = treat, mean = mean, sd = sd, n = n,
                 studlab = studlab, data = dat, sm = "MD")
  write_csv(dat, file.path(out_dir, "rv_lv_arm_data_used_v0.2.csv"))
  write_csv(pw, file.path(out_dir, "rv_lv_pairwise_netmeta_input_v0.2.csv"))
  model <- netmeta(TE, seTE, treat1, treat2, studlab,
                   data = pw, sm = "MD", reference.group = "AC",
                   common = TRUE, random = TRUE, prediction = FALSE,
                   small.values = "bad", method.tau = "REML",
                   title = "Early 24-96h RV/LV reduction")
  list(data = dat, pw = pw, model = model)
}

make_binary_model <- function(event_col, ready_col, prefix, title) {
  dat <- arms %>%
    mutate(
      event = as.numeric(.data[[event_col]]),
      n = as.numeric(n_randomized_or_analyzed),
      treat = node,
      studlab = study_id,
      ready = as_yes(.data[[ready_col]])
    ) %>%
    filter(ready, !is.na(event), !is.na(n))

  pw <- pairwise(treat = treat, event = event, n = n,
                 studlab = studlab, data = dat, sm = "OR",
                 incr = 0.5, method.incr = "only0")
  write_csv(dat, file.path(out_dir, paste0(prefix, "_arm_data_used_v0.2.csv")))
  write_csv(pw, file.path(out_dir, paste0(prefix, "_pairwise_netmeta_input_v0.2.csv")))
  model <- netmeta(TE, seTE, treat1, treat2, studlab,
                   data = pw, sm = "OR", reference.group = "AC",
                   common = TRUE, random = TRUE, prediction = FALSE,
                   small.values = "good", method.tau = "REML",
                   title = title)
  list(data = dat, pw = pw, model = model)
}

write_binary_feasibility <- function(event_col, ready_col, prefix, include_sensitivity = FALSE) {
  ready_fun <- function(x) {
    y <- tolower(trimws(ifelse(is.na(x), "", x)))
    if (include_sensitivity) y %in% c("yes", "sensitivity") else y %in% c("yes")
  }
  dat <- arms %>%
    mutate(
      event = as.numeric(.data[[event_col]]),
      n = as.numeric(n_randomized_or_analyzed),
      treat = node,
      studlab = study_id,
      ready = ready_fun(.data[[ready_col]])
    ) %>%
    filter(ready, !is.na(event), !is.na(n))
  if (nrow(dat) == 0) return(invisible(dat))
  pw <- pairwise(treat = treat, event = event, n = n,
                 studlab = studlab, data = dat, sm = "OR",
                 incr = 0.5, method.incr = "only0")
  write_csv(dat, file.path(out_dir, paste0(prefix, "_arm_data_feasibility_v0.2.csv")))
  write_csv(pw, file.path(out_dir, paste0(prefix, "_pairwise_feasibility_v0.2.csv")))
  conn <- netconnection(pw$treat1, pw$treat2, pw$studlab)
  capture.output(conn, file = file.path(out_dir, paste0(prefix, "_netconnection_v0.2.txt")))
  save_plot(file.path(fig_dir, paste0(prefix, "_network_feasibility_v0.2.png")), {
    nodes <- sort(unique(c(pw$treat1, pw$treat2)))
    theta <- seq(0, 2 * pi, length.out = length(nodes) + 1)[seq_along(nodes)]
    xy <- data.frame(treat = nodes, x = cos(theta), y = sin(theta))
    plot(xy$x, xy$y, type = "n", axes = FALSE, xlab = "", ylab = "",
         main = paste(prefix, "network feasibility"))
    for (i in seq_len(nrow(pw))) {
      a <- xy[xy$treat == pw$treat1[i], ]
      b <- xy[xy$treat == pw$treat2[i], ]
      segments(a$x, a$y, b$x, b$y, col = "gray35", lwd = 2)
    }
    points(xy$x, xy$y, pch = 21, bg = "#EAF3F8", cex = 4)
    text(xy$x, xy$y, labels = xy$treat, cex = 1.1)
  })
  invisible(dat)
}

extract_vs_ac <- function(model, outcome, binary = FALSE) {
  trts <- setdiff(model$trts, "AC")
  rows <- lapply(trts, function(t) {
    te_c <- model$TE.common[t, "AC"]
    se_c <- model$seTE.common[t, "AC"]
    te_r <- model$TE.random[t, "AC"]
    se_r <- model$seTE.random[t, "AC"]
    data.frame(
      outcome = outcome,
      treatment = t,
      reference = "AC",
      common_estimate = te_c,
      common_lower = te_c - 1.96 * se_c,
      common_upper = te_c + 1.96 * se_c,
      random_estimate = te_r,
      random_lower = te_r - 1.96 * se_r,
      random_upper = te_r + 1.96 * se_r,
      common_backtransformed = if (binary) exp(te_c) else te_c,
      common_lower_backtransformed = if (binary) exp(te_c - 1.96 * se_c) else te_c - 1.96 * se_c,
      common_upper_backtransformed = if (binary) exp(te_c + 1.96 * se_c) else te_c + 1.96 * se_c,
      random_backtransformed = if (binary) exp(te_r) else te_r,
      random_lower_backtransformed = if (binary) exp(te_r - 1.96 * se_r) else te_r - 1.96 * se_r,
      random_upper_backtransformed = if (binary) exp(te_r + 1.96 * se_r) else te_r + 1.96 * se_r
    )
  })
  bind_rows(rows)
}

plot_vs_ac <- function(est_df, outcome_name, file_stub, binary = FALSE) {
  d <- est_df[est_df$outcome == outcome_name, ]
  d <- d[order(d$random_backtransformed), ]
  png(file.path(fig_dir, paste0(file_stub, ".png")), width = 1800, height = 1200, res = 220)
  par(mar = c(5, 8, 4, 2))
  y <- seq_len(nrow(d))
  if (binary) {
    x <- d$random_backtransformed
    lo <- d$random_lower_backtransformed
    hi <- d$random_upper_backtransformed
    plot(x, y, yaxt = "n", log = "x", pch = 19,
         xlim = range(c(lo, hi, 1), na.rm = TRUE),
         xlab = "Random-effects OR versus AC", ylab = "", main = outcome_name)
    segments(lo, y, hi, y)
    abline(v = 1, lty = 2, col = "gray40")
  } else {
    x <- d$random_backtransformed
    lo <- d$random_lower_backtransformed
    hi <- d$random_upper_backtransformed
    plot(x, y, yaxt = "n", pch = 19,
         xlim = range(c(lo, hi, 0), na.rm = TRUE),
         xlab = "Random-effects MD versus AC", ylab = "", main = outcome_name)
    segments(lo, y, hi, y)
    abline(v = 0, lty = 2, col = "gray40")
  }
  axis(2, at = y, labels = d$treatment, las = 1)
  dev.off()
}

compare_with_v01 <- function(est_v02) {
  old_path <- file.path(root, "05_analysis_R", "netmeta_frequentist_v0.1", "netmeta_vs_AC_estimates_v0.1.csv")
  if (!file.exists(old_path)) return(data.frame())
  old <- read_csv(old_path, show_col_types = FALSE)
  normalize_outcome <- function(x) {
    ifelse(x == "early_RV_LV_reduction_24_96h_MD", "early_RV_LV_reduction_24_48h_MD", x)
  }
  old <- old %>% mutate(outcome = normalize_outcome(outcome))
  est_v02 <- est_v02 %>% mutate(outcome = normalize_outcome(outcome))
  new <- est_v02 %>%
    select(outcome, treatment, random_backtransformed, random_lower_backtransformed, random_upper_backtransformed)
  old2 <- old %>%
    select(outcome, treatment, random_backtransformed, random_lower_backtransformed, random_upper_backtransformed)
  cmp <- full_join(
    old2,
    new,
    by = c("outcome", "treatment"),
    suffix = c("_v0.1", "_v0.2")
  ) %>%
    mutate(
      absolute_change = random_backtransformed_v0.2 - random_backtransformed_v0.1,
      relative_change_percent = 100 * (random_backtransformed_v0.2 / random_backtransformed_v0.1 - 1)
    )
  write_csv(cmp, file.path(out_dir, "netmeta_v0.2_vs_v0.1_comparison.csv"))
  cmp
}

rv_obj <- make_rv_model()
bleed_obj <- make_binary_model("major_bleeding_n", "ready_major_bleeding_nma",
                               "major_bleeding", "Major bleeding")
death_obj <- make_binary_model("death_followup_n", "ready_death_nma",
                               "death_followup", "Death at reported follow-up")
clinical_feas <- write_binary_feasibility(
  "clinical_deterioration_n",
  "ready_clinical_deterioration_nma",
  "clinical_deterioration_strict",
  include_sensitivity = FALSE
)

models <- list(
  rv_lv = list(obj = rv_obj, binary = FALSE, outcome = "early_RV_LV_reduction_24_96h_MD"),
  major_bleeding = list(obj = bleed_obj, binary = TRUE, outcome = "major_bleeding_OR"),
  death_followup = list(obj = death_obj, binary = TRUE, outcome = "death_followup_OR")
)

est <- bind_rows(lapply(names(models), function(prefix) {
  item <- models[[prefix]]
  write_model_outputs(item$obj$model, prefix, binary = item$binary)
  extract_vs_ac(item$obj$model, item$outcome, item$binary)
}))

write_csv(est, file.path(out_dir, "netmeta_vs_AC_estimates_v0.2.csv"))

plot_vs_ac(est, "early_RV_LV_reduction_24_96h_MD", "forest_rv_lv_vs_ac_random_v0.2", FALSE)
plot_vs_ac(est, "major_bleeding_OR", "forest_major_bleeding_vs_ac_random_v0.2", TRUE)
plot_vs_ac(est, "death_followup_OR", "forest_death_vs_ac_random_v0.2", TRUE)

cmp <- compare_with_v01(est)

md <- c(
  "# Frequentist netmeta v0.2",
  "",
  "Inputs:",
  "- `04_data_extraction/RV_LV_data_v0.2_STRATIFY_locked.csv`",
  "- `04_data_extraction/data_extraction_arms_v0.3_STRATIFY_locked.csv`",
  "",
  "Software:",
  paste0("- R: ", R.version.string),
  paste0("- netmeta: ", as.character(packageVersion("netmeta"))),
  paste0("- meta: ", as.character(packageVersion("meta"))),
  "",
  "Models:",
  "- RV/LV: mean difference in early 24-96h RV/LV reduction; positive values mean greater RV/LV reduction than AC.",
  "- Major bleeding and death: odds ratio; OR < 1 favours the treatment compared with AC.",
  "- Both common-effect and random-effects models were fitted with REML tau estimation where applicable.",
  "",
  "Important limitations:",
  "- STRATIFY is not included in ICH NMA because complete arm-specific ICH counts are not available.",
  "- Strict clinical deterioration/rescue therapy remains disconnected as a single NMA network; a netconnection and feasibility graph are provided instead of a forced model.",
  "- This v0.2 remains pre-publication because HAIRE OCR, PRETHA RV/LV SD recovery, endpoint harmonisation, prediction intervals, Bayesian validation, RoB 2.0, and CINeMA are still pending.",
  "",
  "## Estimates versus AC",
  "```",
  paste(capture.output(print(est, row.names = FALSE)), collapse = "\n"),
  "```",
  "",
  "## v0.2 vs v0.1 comparison",
  "```",
  paste(capture.output(print(cmp, row.names = FALSE)), collapse = "\n"),
  "```"
)
writeLines(md, file.path(out_dir, "netmeta_frequentist_v0.2.md"), useBytes = TRUE)

cat("Wrote netmeta frequentist v0.2 outputs to:\n")
cat(out_dir, "\n")
cat(fig_dir, "\n")
print(est, row.names = FALSE)
cat("\nComparison v0.2 vs v0.1:\n")
print(cmp, row.names = FALSE)
