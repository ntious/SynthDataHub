###############################################################################
# M4 Lab 4.3 – Introduction to Supervised Classification in R
#           K-Nearest Neighbours • Naïve Bayes • Logistic Regression
#
# Runtime (one sitting) : ≈ 40 min
# Required screenshots  : 1) KNN confusion matrix/accuracy
#                         2) Naïve Bayes confusion matrix/accuracy
#                         3) Logistic Regression confusion matrix/accuracy
#
# HOW TO USE:
#   1. Open RStudio →  File ▸ New File ▸ R Script.
#   2. Paste this script and run section-by-section (Ctrl + Alt + T).
#   3. Pause at each 📸 Screenshot cue, capture the full source & console.
#   4. Answer the five reflection questions; knit or save everything as PDF.
###############################################################################

############################ HOUSEKEEPING ##################################
# Packages --------------------------------------------------------------------
required <- c("tidyverse", "caTools", "class", "e1071")   # add more as needed
new_pkgs <- required[!(required %in% rownames(installed.packages()))]
if (length(new_pkgs)) install.packages(new_pkgs)
lapply(required, library, character.only = TRUE)

set.seed(123)  # reproducibility

# OPTIONAL: clean workspace / console
# rm(list = ls()); cat("\014")

############################ 1. LOAD & PREP DATA ##############################
data(iris)                 # built-in dataset
# Filter to binary classification: setosa vs versicolor -----------------------
iris_bin <- iris %>%
  filter(Species %in% c("setosa", "versicolor")) %>%
  mutate(Species = factor(Species))          # ensure exactly 2 levels

str(iris_bin) ; head(iris_bin)               # quick sanity checks

# Train / test split -----------------------------------------------------------
split <- caTools::sample.split(iris_bin$Species, SplitRatio = 0.70)
train  <- subset(iris_bin, split)
test   <- subset(iris_bin, !split)

cat("\nObs in train :", nrow(train),
    "\nObs in test  :", nrow(test), "\n")

############################ 2. FEATURE SCALING ################################
# Only Sepal.Length & Sepal.Width are used (per lab instructions) -------------
train_x <- scale(train[ , c("Sepal.Length", "Sepal.Width")])
test_x  <- scale(test [ , c("Sepal.Length", "Sepal.Width")],
                 center = attr(train_x, "scaled:center"),
                 scale  = attr(train_x, "scaled:scale"))

############################ 3. k-NEAREST NEIGHBOURS ###########################
# Helper function to fit-&-score a single k ------------------------------------
knn_fit <- function(k) {
  pred <- class::knn(train_x, test_x, cl = train$Species, k = k)
  cm   <- table(Predicted = pred, Actual = test$Species)
  acc  <- round(sum(diag(cm)) / sum(cm), 4)
  list(k = k, cm = cm, acc = acc)
}

# Primary run (k = 5) ----------------------------------------------------------
knn_main <- knn_fit(5)

cat("\n------------- KNN (k = 5) -------------\n")
print(knn_main$cm)
cat("Accuracy:", knn_main$acc, "\n")

# 📸 Screenshot 1: include code above + console output

# Extra runs for reflection question ------------------------------------------
k_vals  <- c(3, 7, 15)
knn_tune <- lapply(k_vals, knn_fit)          # list of results

############################ 4. NAÏVE BAYES ####################################
library(e1071)
nb_model <- naiveBayes(Species ~ Sepal.Length + Sepal.Width, data = train)
print(nb_model)                              # prior / conditional tables

nb_pred  <- predict(nb_model, newdata = test, type = "class")
nb_cm    <- table(Predicted = nb_pred, Actual = test$Species)
nb_acc   <- round(sum(diag(nb_cm)) / sum(nb_cm), 4)

cat("\n------------- Naïve Bayes -------------\n")
print(nb_cm)
cat("Accuracy:", nb_acc, "\n")

# 📸 Screenshot 2: include code above + console output

############################ 5. LOGISTIC REGRESSION ###########################
logit_model <- glm(
  Species ~ Sepal.Length + Sepal.Width,
  data   = train,
  family = binomial)

summary(logit_model)                         # coefficients / p-values

# Predict probabilities and class labels --------------------------------------
logit_prob <- predict(logit_model, newdata = test, type = "response")
logit_pred <- ifelse(logit_prob >= 0.5, "versicolor", "setosa") |>
              factor(levels = levels(test$Species))

logit_cm  <- table(Predicted = logit_pred, Actual = test$Species)
logit_acc <- round(sum(diag(logit_cm)) / sum(logit_cm), 4)

cat("\n---------- Logistic Regression ---------\n")
print(logit_cm)
cat("Accuracy:", logit_acc, "\n")

# 📸 Screenshot 3: include code above + console output

############################ 6. RESULTS SUMMARY ###############################
# Pull accuracies into a tidy frame for quick reference ------------------------
acc_df <- tibble(
  Model = c("KNN (k = 5)",
            sprintf("KNN (k = %d)", k_vals),
            "Naïve Bayes",
            "Logistic Reg."),
  Accuracy = c(knn_main$acc,
               sapply(knn_tune, `[[`, "acc"),
               nb_acc,
               logit_acc)
)

print(acc_df)

############################ 7. HELPER OUTPUT FOR WRITE-UP #####################
cat("\n================ Reflection-Helper ================\n")
cat("Tuned K values & accuracies:\n")
for (res in knn_tune) {
  cat("  k =", res$k, "→ Accuracy:", res$acc, "\n")
}

cat("\nHighest overall accuracy model:",
    acc_df$Model[which.max(acc_df$Accuracy)], "\n")

cat("\nREMINDERS:\n",
    " • Discuss how k controls bias–variance (small k = low bias, high variance; large k = opposite).\n",
    " • KNN limitations: O(N) prediction cost, curse of dimensionality, need for scaling, etc.\n",
    " • Naïve Bayes ‘naïve’ assumption: conditional independence of features.\n",
    "====================================================\n")

############################ 8. SAVE / KNIT ###################################
# File ▸ Save ▸ FirstName_M4Lab2.R   (or Knit → PDF/Word if using Rmd)
###############################################################################
# End of Script – remember to embed three screenshots and answer all questions!
# Authored by I. K. Nti
###############################################################################
