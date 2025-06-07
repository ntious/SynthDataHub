###############################################################################
# M4 Lab 4.1 – Introduction to Supervised Learning
#           Simple & Multiple Linear Regression with the built-in mtcars data
#
# One-sitting runtime  : ~40 min
# Target screenshots   : 1) Source pane -- SLR code + summary
#                       2) Plots pane  -- scatter with regression line
#                       3) Console     -- full MLR summary
#
# HOW TO USE:
#   1. Open RStudio  →  File ▸ New File ▸ R Script.
#   2. Paste this entire script.  Click  ▶ Run  line-by-line or section-by-section
#      (Ctrl + Alt + T runs the current section).
#   3. When a section notes “📸 Screenshot”, pause and take the required shot.
#   4. Answer Q1–Q3 in a Word doc, save as PDF, and submit.
###############################################################################

######################## HOUSEKEEPING ######################################
# Install / load required packages -------------------------------------------
required <- c("tidyverse", "caTools", "class", "e1071")  # add more as you explore
new_pkgs <- required[!(required %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) install.packages(new_pkgs)
lapply(required, library, character.only = TRUE)

# Reproducibility
set.seed(123)

# OPTIONAL: start with a clean slate (uncomment if desired)
# cat("\014")          # Clear console (same as Ctrl + L)
# rm(list = ls())      # Remove objects from workspace

######################## 1. LOAD & EXPLORE DATA ################################
# The mtcars dataset ships with base R ----------------------------------------
data(mtcars)          # load into memory
head(mtcars)          # quick peek at first 6 rows
summary(mtcars)       # descriptive statistics
str(mtcars)           # data types & structure

######################## 2. SIMPLE LINEAR REGRESSION (SLR) #####################
# Goal: predict mpg using horsepower (hp) -------------------------------------
model_slr <- lm(mpg ~ hp, data = mtcars)

# Inspect model ----------------------------------------------------------------
summary(model_slr)    # 📸 Screenshot 1: run this WITH the code above visible

# Visualise fit ----------------------------------------------------------------
plot(mtcars$hp, mtcars$mpg,
     main = "Simple Linear Regression: MPG vs. HP",
     xlab = "Horsepower (hp)",
     ylab = "Miles Per Gallon (mpg)",
     col  = "steelblue",
     pch  = 16)
abline(model_slr, col = "red", lwd = 2)   # 📸 Screenshot 2: scatter + line

######################## 3. MULTIPLE LINEAR REGRESSION (MLR) ###################
# Goal: predict mpg using hp, weight (wt), and ¼-mile time (qsec) --------------
model_mlr <- lm(mpg ~ hp + wt + qsec, data = mtcars)

# Full model report ------------------------------------------------------------
summary(model_mlr)    # 📸 Screenshot 3: copy entire console output

######################## 4. PREDICTION WITH NEW DATA ###########################
# Suppose a new car has 100 hp, weighs 2.5 (1000 lbs), and runs the ¼-mile in 18 s
new_car_data <- data.frame(hp = 100, wt = 2.5, qsec = 18)
predicted_mpg <- predict(model_mlr, newdata = new_car_data)
cat("\nPredicted MPG for (hp = 100, wt = 2.5, qsec = 18):",
    round(predicted_mpg, 2), "\n")

######################## 5. ANSWERS HELPER (Q1 – Q3) ###########################
# These lines compute the statistics students need to answer the write-up ------
R2_SLR        <- summary(model_slr)$r.squared
AdjR2_MLR     <- summary(model_mlr)$adj.r.squared
variance_diff <- AdjR2_MLR - R2_SLR            # positive = MLR explains more

cat("\n-- Helper Output ------------------------------------------------------\n")
cat("R² (SLR)             :", round(R2_SLR,   4), "\n")
cat("Adjusted R² (MLR)    :", round(AdjR2_MLR,4), "\n")
cat("Difference (points)  :", round(variance_diff,4), "\n\n")

# Which predictors are significant at α = 0.05?
sig_coef <- summary(model_mlr)$coefficients[ , "Pr(>|t|)"] < 0.05
cat("Significant predictors (α = 0.05):",
    paste(names(sig_coef)[sig_coef], collapse = ", "), "\n")

# Minimum mpg in the dataset ---------------------------------------------------
cat("Minimum observed mpg :", min(mtcars$mpg), "\n")
cat("-----------------------------------------------------------------------\n")

######################## 6. SAVE / KNIT ########################################
# File ▸ Save  ▸ FirstName_M4Lab1.R   (or Knit ▸ HTML/PDF if using Rmd)

###############################################################################
# End of Script – good luck! Remember to embed the three screenshots in your
# PDF, followed by answers to Q1–Q3. Submit before the deadline. :)
#Authored by I. K. NTI
###############################################################################
