options(stringsAsFactors = FALSE)

root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
out_dir <- file.path(root, "05_analysis_R", "exploratory_nma_v0.1")
fig_dir <- file.path(root, "06_figures", "exploratory_nma_v0.1")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

rv_csv <- file.path(root, "04_data_extraction", "RV_LV_data_v0.1.csv")
arm_csv <- file.path(root, "04_data_extraction", "data_extraction_arms_v0.2_locked_core_outcomes.csv")
rv <- read.csv(rv_csv, check.names = FALSE, na.strings = c("", "NA", "NR"))
arms <- read.csv(arm_csv, check.names = FALSE, na.strings = c("", "NA", "NR"))

ref <- "AC"
nodes_all <- c("AC", "ST", "CDT", "USCDT", "LBAT", "CAT")

as_yes <- function(x) {
  y <- tolower(trimws(ifelse(is.na(x), "", x)))
  y %in% c("yes", "y", "true", "1")
}

num <- function(x) suppressWarnings(as.numeric(x))

pairwise_continuous <- function(df, mean_col, sd_col, n_col) {
  rows <- list()
  k <- 1
  for (sid in unique(df$study_id)) {
    d <- df[df$study_id == sid, ]
    d <- d[!is.na(d[[mean_col]]) & !is.na(d[[sd_col]]) & !is.na(d[[n_col]]), ]
    if (nrow(d) < 2) next
    cmb <- combn(seq_len(nrow(d)), 2)
    for (i in seq_len(ncol(cmb))) {
      a <- d[cmb[1, i], ]
      b <- d[cmb[2, i], ]
      y <- b[[mean_col]] - a[[mean_col]]
      se <- sqrt((a[[sd_col]]^2 / a[[n_col]]) + (b[[sd_col]]^2 / b[[n_col]]))
      rows[[k]] <- data.frame(
        study_id = sid,
        short_name = paste(unique(d$short_name), collapse = "; "),
        t1 = a$node,
        t2 = b$node,
        TE = y,
        seTE = se,
        outcome_scale = "MD in early RV/LV reduction; positive favours t2 over t1"
      )
      k <- k + 1
    }
  }
  if (length(rows) == 0) return(data.frame())
  do.call(rbind, rows)
}

pairwise_binary <- function(df, event_col, ready_col, outcome_name) {
  d <- df
  d$n <- num(d$n_randomized_or_analyzed)
  d$event <- num(d[[event_col]])
  d <- d[as_yes(d[[ready_col]]) & !is.na(d$n) & !is.na(d$event), ]
  rows <- list()
  k <- 1
  for (sid in unique(d$study_id)) {
    s <- d[d$study_id == sid, ]
    if (nrow(s) < 2) next
    cmb <- combn(seq_len(nrow(s)), 2)
    for (i in seq_len(ncol(cmb))) {
      a <- s[cmb[1, i], ]
      b <- s[cmb[2, i], ]
      ea <- a$event
      eb <- b$event
      na <- a$n
      nb <- b$n
      if (ea == 0 || eb == 0 || ea == na || eb == nb) {
        ea <- ea + 0.5
        eb <- eb + 0.5
        na <- na + 1
        nb <- nb + 1
      }
      y <- log((eb / (nb - eb)) / (ea / (na - ea)))
      se <- sqrt(1 / eb + 1 / (nb - eb) + 1 / ea + 1 / (na - ea))
      rows[[k]] <- data.frame(
        study_id = sid,
        short_name = paste(unique(s$short_name), collapse = "; "),
        t1 = a$node,
        t2 = b$node,
        TE = y,
        seTE = se,
        outcome_scale = paste0("log OR for ", outcome_name, "; negative favours t2 over t1")
      )
      k <- k + 1
    }
  }
  if (length(rows) == 0) return(data.frame())
  do.call(rbind, rows)
}

fit_network <- function(pw, outcome_name, beneficial_positive = TRUE) {
  treatments <- sort(unique(c(pw$t1, pw$t2)))
  if (!(ref %in% treatments)) stop(paste("Reference", ref, "missing for", outcome_name))
  nonref <- setdiff(treatments, ref)
  X <- matrix(0, nrow = nrow(pw), ncol = length(nonref))
  colnames(X) <- nonref
  for (i in seq_len(nrow(pw))) {
    if (pw$t2[i] != ref) X[i, pw$t2[i]] <- X[i, pw$t2[i]] + 1
    if (pw$t1[i] != ref) X[i, pw$t1[i]] <- X[i, pw$t1[i]] - 1
  }
  w <- 1 / (pw$seTE^2)
  fit <- lm.wfit(x = X, y = pw$TE, w = w)
  beta <- fit$coefficients
  XtWX_inv <- tryCatch(solve(t(X) %*% diag(w, nrow = length(w)) %*% X), error = function(e) NULL)
  if (is.null(XtWX_inv)) {
    se <- rep(NA_real_, length(beta))
  } else {
    se <- sqrt(diag(XtWX_inv))
  }
  est <- data.frame(
    outcome = outcome_name,
    treatment = names(beta),
    reference = ref,
    estimate_vs_AC = as.numeric(beta),
    se = as.numeric(se),
    lower_95 = as.numeric(beta) - 1.96 * se,
    upper_95 = as.numeric(beta) + 1.96 * se,
    k_pairwise_contrasts = nrow(pw),
    k_studies = length(unique(pw$study_id)),
    stringsAsFactors = FALSE
  )
  if (!beneficial_positive) {
    est$OR_vs_AC <- exp(est$estimate_vs_AC)
    est$OR_lower_95 <- exp(est$lower_95)
    est$OR_upper_95 <- exp(est$upper_95)
  }
  est
}

plot_forest <- function(est, title, file_stub, binary = FALSE) {
  png(file.path(fig_dir, paste0(file_stub, ".png")), width = 1800, height = 1200, res = 220)
  par(mar = c(5, 7, 4, 2))
  y <- seq_len(nrow(est))
  if (binary) {
    x <- est$OR_vs_AC
    lo <- est$OR_lower_95
    hi <- est$OR_upper_95
    plot(x, y, xlim = range(c(lo, hi, 1), na.rm = TRUE), yaxt = "n", log = "x",
         xlab = "Odds ratio vs AC", ylab = "", pch = 19, main = title)
    segments(lo, y, hi, y)
    abline(v = 1, lty = 2, col = "gray40")
  } else {
    x <- est$estimate_vs_AC
    lo <- est$lower_95
    hi <- est$upper_95
    plot(x, y, xlim = range(c(lo, hi, 0), na.rm = TRUE), yaxt = "n",
         xlab = "Mean difference vs AC", ylab = "", pch = 19, main = title)
    segments(lo, y, hi, y)
    abline(v = 0, lty = 2, col = "gray40")
  }
  axis(2, at = y, labels = est$treatment, las = 1)
  dev.off()
}

rv_main <- rv[rv$analysis_status == "main_continuous_nma", ]
rv_main$n <- num(rv_main$n)
rv_main$early_change_reduction_mean <- num(rv_main$early_change_reduction_mean)
rv_main$early_change_reduction_sd <- num(rv_main$early_change_reduction_sd)
pw_rv <- pairwise_continuous(rv_main, "early_change_reduction_mean", "early_change_reduction_sd", "n")
est_rv <- fit_network(pw_rv, "early_RV_LV_reduction_24_48h_MD", TRUE)

pw_bleed <- pairwise_binary(arms, "major_bleeding_n", "ready_major_bleeding_nma", "major bleeding")
est_bleed <- fit_network(pw_bleed, "major_bleeding_logOR", FALSE)

pw_death <- pairwise_binary(arms, "death_followup_n", "ready_death_nma", "death at reported follow-up")
est_death <- fit_network(pw_death, "death_followup_logOR", FALSE)

write.csv(pw_rv, file.path(out_dir, "rv_lv_pairwise_contrasts_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(est_rv, file.path(out_dir, "rv_lv_nma_estimates_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(pw_bleed, file.path(out_dir, "major_bleeding_pairwise_contrasts_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(est_bleed, file.path(out_dir, "major_bleeding_nma_estimates_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(pw_death, file.path(out_dir, "death_pairwise_contrasts_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(est_death, file.path(out_dir, "death_nma_estimates_v0.1.csv"), row.names = FALSE, fileEncoding = "UTF-8")

plot_forest(est_rv, "Exploratory NMA v0.1: early RV/LV reduction", "forest_rv_lv_v0.1", FALSE)
plot_forest(est_bleed, "Exploratory NMA v0.1: major bleeding", "forest_major_bleeding_v0.1", TRUE)
plot_forest(est_death, "Exploratory NMA v0.1: death at follow-up", "forest_death_v0.1", TRUE)

md <- c(
  "# Exploratory NMA v0.1",
  "",
  "This is a preliminary fixed-effect contrast-based weighted least squares analysis implemented in base R because `netmeta` is not currently installed.",
  "",
  "Interpretation rules:",
  "- RV/LV outcome uses early 24-48h mean RV/LV reduction; positive MD versus AC means greater RV/LV reduction.",
  "- Major bleeding and death use log odds ratios; OR < 1 favours the treatment versus AC.",
  "- Sparse/tree-like networks mean estimates are highly dependent on indirect chains and should not be treated as final publication results.",
  "",
  "## RV/LV estimates",
  paste(capture.output(print(est_rv, row.names = FALSE)), collapse = "\n"),
  "",
  "## Major bleeding estimates",
  paste(capture.output(print(est_bleed, row.names = FALSE)), collapse = "\n"),
  "",
  "## Death estimates",
  paste(capture.output(print(est_death, row.names = FALSE)), collapse = "\n")
)
writeLines(md, file.path(out_dir, "exploratory_nma_v0.1.md"), useBytes = TRUE)

cat("Wrote exploratory NMA outputs to:\n")
cat(out_dir, "\n")
cat(fig_dir, "\n")
cat("\nRV/LV estimates:\n")
print(est_rv, row.names = FALSE)
cat("\nMajor bleeding estimates:\n")
print(est_bleed, row.names = FALSE)
cat("\nDeath estimates:\n")
print(est_death, row.names = FALSE)
