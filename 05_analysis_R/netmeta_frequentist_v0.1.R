options(stringsAsFactors = FALSE)

user_lib <- "C:/Users/kilog/AppData/Local/R/win-library/4.6"
if (dir.exists(user_lib)) .libPaths(c(user_lib, .libPaths()))

suppressPackageStartupMessages({
  library(netmeta)
  library(readr)
  library(dplyr)
})

root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
out_dir <- file.path(root, "05_analysis_R", "netmeta_frequentist_v0.1")
fig_dir <- file.path(root, "06_figures", "netmeta_frequentist_v0.1")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

rv <- read_csv(file.path(root, "04_data_extraction", "RV_LV_data_v0.1.csv"), show_col_types = FALSE)
arms <- read_csv(file.path(root, "04_data_extraction", "data_extraction_arms_v0.2_locked_core_outcomes.csv"), show_col_types = FALSE)

as_yes <- function(x) tolower(trimws(ifelse(is.na(x), "", x))) %in% c("yes", "y", "true", "1")

save_plot <- function(path, expr, width = 1800, height = 1400, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

write_model_outputs <- function(model, prefix, binary = FALSE) {
  sink(file.path(out_dir, paste0(prefix, "_summary.txt")))
  print(summary(model))
  cat("\n\n--- netrank ---\n")
  print(netrank(model, small.values = if (binary) "good" else "bad"))
  sink()

  league <- netleague(model, common = TRUE, random = TRUE, digits = 3)
  capture.output(league, file = file.path(out_dir, paste0(prefix, "_league_table.txt")))

  rank_common <- netrank(model, small.values = if (binary) "good" else "bad", common = TRUE)
  rank_random <- netrank(model, small.values = if (binary) "good" else "bad", random = TRUE)
  capture.output(rank_common, file = file.path(out_dir, paste0(prefix, "_ranking_common.txt")))
  capture.output(rank_random, file = file.path(out_dir, paste0(prefix, "_ranking_random.txt")))

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
  write_csv(pw, file.path(out_dir, "rv_lv_pairwise_netmeta_input_v0.1.csv"))
  model <- netmeta(TE, seTE, treat1, treat2, studlab,
                   data = pw, sm = "MD", reference.group = "AC",
                   common = TRUE, random = TRUE, prediction = FALSE,
                   small.values = "bad", method.tau = "REML",
                   title = "Early 24-48h RV/LV reduction")
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
  write_csv(pw, file.path(out_dir, paste0(prefix, "_pairwise_netmeta_input_v0.1.csv")))
  model <- netmeta(TE, seTE, treat1, treat2, studlab,
                   data = pw, sm = "OR", reference.group = "AC",
                   common = TRUE, random = TRUE, prediction = FALSE,
                   small.values = "good", method.tau = "REML",
                   title = title)
  list(data = dat, pw = pw, model = model)
}

rv_obj <- make_rv_model()
bleed_obj <- make_binary_model("major_bleeding_n", "ready_major_bleeding_nma",
                               "major_bleeding", "Major bleeding")
death_obj <- make_binary_model("death_followup_n", "ready_death_nma",
                               "death_followup", "Death at reported follow-up")

write_csv(rv_obj$data, file.path(out_dir, "rv_lv_arm_data_used_v0.1.csv"))
write_csv(bleed_obj$data, file.path(out_dir, "major_bleeding_arm_data_used_v0.1.csv"))
write_csv(death_obj$data, file.path(out_dir, "death_arm_data_used_v0.1.csv"))

write_model_outputs(rv_obj$model, "rv_lv", binary = FALSE)
write_model_outputs(bleed_obj$model, "major_bleeding", binary = TRUE)
write_model_outputs(death_obj$model, "death_followup", binary = TRUE)

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

est <- bind_rows(
  extract_vs_ac(rv_obj$model, "early_RV_LV_reduction_24_48h_MD", FALSE),
  extract_vs_ac(bleed_obj$model, "major_bleeding_OR", TRUE),
  extract_vs_ac(death_obj$model, "death_followup_OR", TRUE)
)
write_csv(est, file.path(out_dir, "netmeta_vs_AC_estimates_v0.1.csv"))

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

plot_vs_ac(est, "early_RV_LV_reduction_24_48h_MD", "forest_rv_lv_vs_ac_random_v0.1", FALSE)
plot_vs_ac(est, "major_bleeding_OR", "forest_major_bleeding_vs_ac_random_v0.1", TRUE)
plot_vs_ac(est, "death_followup_OR", "forest_death_vs_ac_random_v0.1", TRUE)

md <- c(
  "# Frequentist netmeta v0.1",
  "",
  "Software:",
  paste0("- R: ", R.version.string),
  paste0("- netmeta: ", as.character(packageVersion("netmeta"))),
  paste0("- meta: ", as.character(packageVersion("meta"))),
  "",
  "Models:",
  "- RV/LV: mean difference in early 24-48h RV/LV reduction; positive values mean greater RV/LV reduction than AC.",
  "- Major bleeding and death: odds ratio; OR < 1 favours the treatment compared with AC.",
  "- Both common-effect and random-effects models were fitted with REML tau estimation where applicable.",
  "",
  "Important limitation:",
  "- This is v0.1 based on the current extracted data. It is not the final publication model because STRATIFY, HAIRE, PRETHA SD recovery, and final endpoint harmonisation remain pending.",
  "",
  "## Estimates versus AC",
  paste(capture.output(print(est, row.names = FALSE)), collapse = "\n")
)
writeLines(md, file.path(out_dir, "netmeta_frequentist_v0.1.md"), useBytes = TRUE)

cat("Wrote netmeta frequentist outputs to:\n")
cat(out_dir, "\n")
cat(fig_dir, "\n")
print(est, row.names = FALSE)
