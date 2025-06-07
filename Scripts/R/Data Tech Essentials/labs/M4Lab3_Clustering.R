###############################################################################
# M4 Lab 4.3 – Unsupervised Learning with K-Means
#           Wi-Fi RSSI dataset (UCI): determine k, run clustering,
#           visualise in PCA space, and (optionally) compare with ground-truth
#
# One-sitting runtime : ≈ 40 min
# Required screenshots : 1) Elbow code + plot
#                        2) Silhouette code + plot
#                        3) K-means console output (size + centroids)
#                        4) PCA cluster plot
#
# HOW TO USE:
#   1. File ▸ New File ▸ R Script, paste everything, and save.
#   2. Run section-by-section (Ctrl + Alt + T).
#   3. Pause at each 📸 line, capture the Source *and* Plots/Console panes.
#   4. Answer Q1–Q4, embed the screenshots, export to PDF, submit.
###############################################################################

############################ HOUSEKEEPING #################################
options(stringsAsFactors = FALSE)

required <- c("tidyverse", "factoextra", "cluster")   # cluster ⇒ silhouette()
new_pkgs <- required[!(required %in% rownames(installed.packages()))]
if (length(new_pkgs)) install.packages(new_pkgs)
lapply(required, library, character.only = TRUE)

set.seed(42)  # reproducible centroids

# OPTIONAL: clear workspace/console
# rm(list = ls()); cat("\014")

############################ 1.  LOAD DATA ####################################
url  <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00422/wifi_localization.txt"
wifi <- read.table(url, header = FALSE)

# Columns V1–V7: RSSI readings; V8: ground-truth room (ignored for clustering)
colnames(wifi) <- c(paste0("RSSI_", 1:7), "Room")

glimpse(wifi)               # structure check
summary(wifi[ , 1:7])       # numeric summaries

############################ 2.  SCALE FEATURES ###############################
wifi_scaled <- scale(wifi[ , 1:7])   # centre & standardise

############################ 3.  CHOOSE k #####################################
## 3a Elbow (within-cluster sum-of-squares) -----------------------------------
fviz_nbclust(wifi_scaled, kmeans, method = "wss") +
  labs(title = "Elbow Method", subtitle = "Pick k at the first pronounced 'kink'")
# 📸 Screenshot 1

## 3b Silhouette width ---------------------------------------------------------
fviz_nbclust(wifi_scaled, kmeans, method = "silhouette") +
  labs(title = "Average Silhouette Width")
# 📸 Screenshot 2

# === Decide your k (update if your elbow/silhouette differ) ==================
k_value <- 4   # change if YOUR plots justify k = 2, 3, etc.

############################ 4.  RUN K-MEANS ##################################
km <- kmeans(wifi_scaled, centers = k_value, nstart = 25)

cat("\n----------- K-MEANS SUMMARY (k =", k_value, ") -----------\n")
cat("Cluster sizes:\n"); print(km$size)
cat("\nCentroids (scaled units):\n"); print(round(km$centers, 2))
# Attach cluster labels to original frame
wifi$cluster <- factor(km$cluster)
# 📸 Screenshot 3  ← include code + console output above

############################ 5.  VISUALISE CLUSTERS (PCA 2-D) #################
fviz_cluster(km, data = wifi_scaled,
             axes   = c(1, 2),
             geom   = "point",
             ellipse.type = "convex",
             repel  = TRUE,
             ggtheme = theme_minimal()) +
  labs(title = paste("K-Means Clusters (k =", k_value, ") in PCA Space"))
# 📸 Screenshot 4

############################ 6.  OPTIONAL: COMPARE TO TRUE ROOMS ##############
cm <- table(Predicted = wifi$cluster, TrueRoom = wifi$Room)
overall_acc <- round(sum(diag(cm)) / sum(cm), 4)

cat("\n------- OPTIONAL: Cluster vs True Room -------\n")
print(cm)
cat("Macro accuracy (naïve overall):", overall_acc, "\n")

############################ 7.  HELPER OUTPUT FOR WRITE-UP ###################
elbow_k_tip  <- "Pick k at elbow-plot kink (lowest K before WSS flattens)."
sil_k_tip    <- "Pick k with highest average silhouette."
cat("\n================= Reflection-Helper =================\n")
cat("Elbow-plot tip : ", elbow_k_tip, "\n")
cat("Silhouette tip : ", sil_k_tip, "\n")
cat("Chosen k       : ", k_value, "\n")
cat("One centroid pattern example:\n")
top_feat <- apply(abs(km$centers), 1, function(x) names(sort(x, decreasing = TRUE)[1]))
for (c in 1:k_value) {
  cat("  • Cluster", c, "dominated by", top_feat[c], "\n")
}
cat("Cluster vs Room macro accuracy:", overall_acc, "\n")
cat("K-means limitation example: sensitive to scale & assumes spherical clusters.\n")
cat("====================================================\n")

############################ 8.  SAVE / KNIT ##################################
# File ▸ Save ▸ FirstName_M4Lab3.R  (or Knit ▶ PDF/Word if using Rmd)
###############################################################################
# End of Script – take four screenshots & complete Q1–Q4 before submission! 🎉
#Authored by I. K. Nti
###############################################################################
