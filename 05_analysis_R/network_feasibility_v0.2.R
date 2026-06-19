options(stringsAsFactors = FALSE)

root <- normalizePath(file.path(getwd()), winslash = "/", mustWork = TRUE)
input_csv <- file.path(root, "04_data_extraction", "data_extraction_arms_v0.2_locked_core_outcomes.csv")
out_dir <- file.path(root, "05_analysis_R", "network_feasibility_v0.2")
fig_dir <- file.path(root, "06_figures", "network_feasibility_v0.2")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

arms <- read.csv(input_csv, check.names = FALSE, na.strings = c("", "NA", "NR"))
nodes_all <- c("AC", "ST", "CDT", "USCDT", "LBAT", "CAT")

as_yes <- function(x) {
  y <- tolower(trimws(ifelse(is.na(x), "", x)))
  y %in% c("yes", "y", "true", "1")
}

as_yes_or_sens <- function(x) {
  y <- tolower(trimws(ifelse(is.na(x), "", x)))
  y %in% c("yes", "sensitivity", "sens", "possible")
}

clean_num <- function(x) suppressWarnings(as.numeric(x))

edge_key <- function(a, b) {
  p <- sort(c(a, b))
  paste(p[1], p[2], sep = "--")
}

study_to_edges <- function(df) {
  studies <- split(df, df$study_id)
  edge_rows <- list()
  k <- 1
  for (sid in names(studies)) {
    d <- studies[[sid]]
    ns <- unique(d$node[!is.na(d$node) & d$node != ""])
    if (length(ns) < 2) next
    cmb <- combn(sort(ns), 2)
    for (i in seq_len(ncol(cmb))) {
      edge_rows[[k]] <- data.frame(
        study_id = sid,
        short_name = paste(unique(d$short_name), collapse = "; "),
        t1 = cmb[1, i],
        t2 = cmb[2, i],
        edge = edge_key(cmb[1, i], cmb[2, i])
      )
      k <- k + 1
    }
  }
  if (length(edge_rows) == 0) {
    return(data.frame(study_id = character(), short_name = character(),
                      t1 = character(), t2 = character(), edge = character()))
  }
  do.call(rbind, edge_rows)
}

connected_components <- function(nodes, edges) {
  adj <- setNames(vector("list", length(nodes)), nodes)
  for (n in nodes) adj[[n]] <- character()
  if (nrow(edges) > 0) {
    for (i in seq_len(nrow(edges))) {
      a <- edges$t1[i]
      b <- edges$t2[i]
      adj[[a]] <- unique(c(adj[[a]], b))
      adj[[b]] <- unique(c(adj[[b]], a))
    }
  }
  seen <- setNames(rep(FALSE, length(nodes)), nodes)
  comps <- list()
  for (n in nodes) {
    if (seen[[n]]) next
    q <- n
    seen[[n]] <- TRUE
    comp <- character()
    while (length(q) > 0) {
      cur <- q[1]
      q <- q[-1]
      comp <- c(comp, cur)
      nxt <- adj[[cur]]
      nxt <- nxt[!seen[nxt]]
      if (length(nxt) > 0) {
        seen[nxt] <- TRUE
        q <- c(q, nxt)
      }
    }
    comps[[length(comps) + 1]] <- comp
  }
  comps
}

is_connected <- function(nodes, edges) {
  if (length(nodes) <= 1) return(FALSE)
  comps <- connected_components(nodes, edges)
  length(comps) == 1
}

plot_network <- function(nodes, edges_count, sample_by_node, title, file_stub) {
  png(file.path(fig_dir, paste0(file_stub, ".png")), width = 1800, height = 1400, res = 220)
  par(mar = c(1, 1, 4, 1), family = "sans")
  n <- length(nodes)
  theta <- seq(pi / 2, pi / 2 + 2 * pi, length.out = n + 1)[1:n]
  xy <- data.frame(node = nodes, x = cos(theta), y = sin(theta))
  plot(xy$x, xy$y, type = "n", axes = FALSE, xlab = "", ylab = "",
       xlim = c(-1.35, 1.35), ylim = c(-1.25, 1.25), asp = 1,
       main = title, cex.main = 1.0)
  if (nrow(edges_count) > 0) {
    for (i in seq_len(nrow(edges_count))) {
      a <- xy[xy$node == edges_count$t1[i], ]
      b <- xy[xy$node == edges_count$t2[i], ]
      lw <- 1.5 + 2.2 * sqrt(edges_count$studies[i])
      segments(a$x, a$y, b$x, b$y, lwd = lw, col = "#4B6B88")
      mx <- (a$x + b$x) / 2
      my <- (a$y + b$y) / 2
      text(mx, my, labels = edges_count$studies[i], cex = 0.85, col = "#111111")
    }
  }
  max_n <- max(sample_by_node$n, na.rm = TRUE)
  if (!is.finite(max_n) || max_n <= 0) max_n <- 1
  sizes <- 12 + 22 * sqrt(sample_by_node$n[match(nodes, sample_by_node$node)] / max_n)
  sizes[!is.finite(sizes)] <- 12
  symbols(xy$x, xy$y, circles = sizes / 300, inches = FALSE, add = TRUE,
          bg = "#EAF3F8", fg = "#1F425C", lwd = 1.5)
  text(xy$x, xy$y, labels = nodes, cex = 0.95, font = 2)
  legend("bottomleft", legend = c("Node size: randomized/analyzed sample", "Edge width/label: number of RCTs"),
         bty = "n", cex = 0.75)
  dev.off()

  pdf(file.path(fig_dir, paste0(file_stub, ".pdf")), width = 7.5, height = 6.2)
  par(mar = c(1, 1, 4, 1), family = "sans")
  plot(xy$x, xy$y, type = "n", axes = FALSE, xlab = "", ylab = "",
       xlim = c(-1.35, 1.35), ylim = c(-1.25, 1.25), asp = 1,
       main = title, cex.main = 0.95)
  if (nrow(edges_count) > 0) {
    for (i in seq_len(nrow(edges_count))) {
      a <- xy[xy$node == edges_count$t1[i], ]
      b <- xy[xy$node == edges_count$t2[i], ]
      lw <- 1.5 + 2.2 * sqrt(edges_count$studies[i])
      segments(a$x, a$y, b$x, b$y, lwd = lw, col = "#4B6B88")
      text((a$x + b$x) / 2, (a$y + b$y) / 2, labels = edges_count$studies[i], cex = 0.75)
    }
  }
  symbols(xy$x, xy$y, circles = sizes / 300, inches = FALSE, add = TRUE,
          bg = "#EAF3F8", fg = "#1F425C", lwd = 1.4)
  text(xy$x, xy$y, labels = nodes, cex = 0.9, font = 2)
  legend("bottomleft", legend = c("Node size: randomized/analyzed sample", "Edge width/label: number of RCTs"),
         bty = "n", cex = 0.7)
  dev.off()
}

summarise_outcome <- function(name, event_col, ready_col = NULL, include_sensitivity = FALSE,
                              rv_lv_mode = FALSE) {
  d <- arms
  if (!rv_lv_mode) {
    d$n <- clean_num(d$n_randomized_or_analyzed)
    d$event <- clean_num(d[[event_col]])
    ready <- rep(TRUE, nrow(d))
    if (!is.null(ready_col)) {
      ready <- if (include_sensitivity) as_yes_or_sens(d[[ready_col]]) else as_yes(d[[ready_col]])
    }
    d <- d[ready & !is.na(d$n) & !is.na(d$event), ]
  } else {
    d$n <- clean_num(d$n_randomized_or_analyzed)
    rv <- trimws(ifelse(is.na(d$rv_lv_or_rv_recovery_locked), "", d$rv_lv_or_rv_recovery_locked))
    d <- d[!is.na(d$n) & rv != "", ]
  }
  study_sizes <- aggregate(node ~ study_id, d, function(x) length(unique(x)))
  ok_studies <- study_sizes$study_id[study_sizes$node >= 2]
  d <- d[d$study_id %in% ok_studies, ]
  edges <- study_to_edges(d)
  if (nrow(edges) > 0) {
    edges_count <- aggregate(study_id ~ edge + t1 + t2, edges, function(x) length(unique(x)))
    names(edges_count)[names(edges_count) == "study_id"] <- "studies"
    edges_count <- edges_count[order(edges_count$t1, edges_count$t2), ]
  } else {
    edges_count <- data.frame(edge = character(), t1 = character(), t2 = character(), studies = integer())
  }
  nodes <- sort(unique(d$node))
  sample_by_node <- aggregate(n ~ node, d, sum, na.rm = TRUE)
  event_by_node <- if (!rv_lv_mode) aggregate(event ~ node, d, sum, na.rm = TRUE) else data.frame(node = nodes, event = NA)
  comps <- if (length(nodes) > 0) connected_components(nodes, edges) else list()
  conn <- length(nodes) >= 2 && is_connected(nodes, edges)
  has_loop <- nrow(edges_count) >= length(nodes)
  verdict <- if (length(nodes) < 2 || nrow(edges_count) < 1) {
    "not_analyzable"
  } else if (!conn) {
    "disconnected"
  } else if (length(nodes) < 3) {
    "pairwise_only"
  } else if (!has_loop) {
    "connected_but_tree_sparse"
  } else {
    "connected_with_loop"
  }
  edge_label <- if (nrow(edges_count) > 0) {
    paste(paste0(edges_count$t1, "-", edges_count$t2, " (", edges_count$studies, ")"), collapse = "; ")
  } else {
    ""
  }
  comp_label <- paste(vapply(comps, function(x) paste(x, collapse = "/"), character(1)), collapse = " | ")
  summary <- data.frame(
    outcome = name,
    studies = length(unique(d$study_id)),
    arms = nrow(d),
    nodes = paste(nodes, collapse = ", "),
    n_nodes = length(nodes),
    direct_edges = nrow(edges_count),
    edge_details = edge_label,
    connected = conn,
    components = comp_label,
    loop_present = has_loop,
    verdict = verdict
  )
  list(data = d, edges = edges, edges_count = edges_count, summary = summary,
       sample_by_node = sample_by_node, event_by_node = event_by_node, nodes = nodes)
}

outcomes <- list(
  death = summarise_outcome("death_followup", "death_followup_n", "ready_death_nma"),
  clinical = summarise_outcome("clinical_deterioration", "clinical_deterioration_n", "ready_clinical_deterioration_nma"),
  clinical_sensitivity = summarise_outcome("clinical_deterioration_sensitivity", "clinical_deterioration_n", "ready_clinical_deterioration_nma", TRUE),
  clinical_composite = summarise_outcome("primary_clinical_composite", "primary_clinical_composite_n", "ready_clinical_deterioration_nma", TRUE),
  major_bleeding = summarise_outcome("major_bleeding", "major_bleeding_n", "ready_major_bleeding_nma"),
  ich = summarise_outcome("intracranial_hemorrhage", "intracranial_hemorrhage_n", "ready_ich_nma"),
  rv_lv = summarise_outcome("rv_lv_or_rv_recovery", NULL, NULL, FALSE, TRUE)
)

summary_df <- do.call(rbind, lapply(outcomes, function(x) x$summary))
write.csv(summary_df, file.path(out_dir, "network_feasibility_summary_v0.2.csv"), row.names = FALSE, fileEncoding = "UTF-8")

for (nm in names(outcomes)) {
  obj <- outcomes[[nm]]
  write.csv(obj$data, file.path(out_dir, paste0(nm, "_included_arms_v0.2.csv")), row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(obj$edges_count, file.path(out_dir, paste0(nm, "_direct_edges_v0.2.csv")), row.names = FALSE, fileEncoding = "UTF-8")
  if (length(obj$nodes) >= 2 && nrow(obj$edges_count) >= 1) {
    plot_network(obj$nodes, obj$edges_count, obj$sample_by_node,
                 paste0("PE NMA v0.2 network: ", obj$summary$outcome),
                 paste0("network_", nm, "_v0.2"))
  }
}

md <- c(
  "# Network Feasibility Check v0.2",
  "",
  "Input: `04_data_extraction/data_extraction_arms_v0.2_locked_core_outcomes.csv`.",
  "",
  "Rules:",
  "- Binary outcomes used arms with non-missing sample size and event count plus the corresponding `ready_*_nma == yes` flag.",
  "- Clinical deterioration also has a sensitivity version including `ready_*_nma == sensitivity`.",
  "- RV/LV used arms with non-empty `rv_lv_or_rv_recovery_locked`; this is a feasibility graph only, because the v0.2 field is still text and needs numeric harmonisation before continuous-outcome NMA.",
  "- Verdict definitions: `connected_with_loop` supports full network consistency exploration; `connected_but_tree_sparse` is connected but lacks closed loops; `pairwise_only` has only two nodes; `disconnected` is not suitable as a single NMA; `not_analyzable` lacks a usable comparison.",
  "",
  "## Summary",
  "",
  paste(capture.output(print(summary_df, row.names = FALSE)), collapse = "\n"),
  "",
  "## Immediate Interpretation",
  ""
)

interpret <- c()
for (i in seq_len(nrow(summary_df))) {
  r <- summary_df[i, ]
  msg <- paste0("- ", r$outcome, ": ", r$verdict, "; studies=", r$studies,
                ", nodes=", r$n_nodes, ", edges=", r$direct_edges,
                ". Edges: ", ifelse(r$edge_details == "", "none", r$edge_details), ".")
  interpret <- c(interpret, msg)
}
md <- c(md, interpret, "")
writeLines(md, file.path(out_dir, "network_feasibility_v0.2.md"), useBytes = TRUE)

cat("Wrote outputs to:\n")
cat(out_dir, "\n")
cat(fig_dir, "\n")
print(summary_df, row.names = FALSE)
