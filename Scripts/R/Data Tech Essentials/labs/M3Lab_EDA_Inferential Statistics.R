###############################################################################
# Data Tech Essentials:Exploratory Data Analysis & Inferential Statistics #
# ----------------------------------------------------------------------------
# This single script runs start-to-finish: install/load packages, import data, 
# perform EDA, correlation analysis, a Welch t-test, a simple linear regression,
# and model-diagnostic checks.  Inline comments tell students WHAT each step
# does, WHY it is useful, and WHICH reflection-question it helps answer.      
###############################################################################
#Authored by I. K. NTI
# ─────────────────────────────────────────────────────────────────────────────
# STEP 1  •  Environment bootstrap  
#   • Installs / loads required packages  
#   • Sets reproducible seed & default string handling                    
# ─────────────────────────────────────────────────────────────────────────────
required <- c("tidyverse", "skimr", "corrplot", "lmtest", "readr")
new_pkgs <- required[!(required %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) install.packages(new_pkgs)
lapply(required, library, character.only = TRUE)

options(stringsAsFactors = FALSE)   # keep character columns as chr, not factor
set.seed(42)                        # reproducible sampling / plots

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2  •  Import data  (Reflection Q-ready: *What does the raw data look like?*)
#   • Reads the CSV directly from GitHub (raw link)  
#   • `glimpse()` previews column types & row count                        
# ─────────────────────────────────────────────────────────────────────────────
url <- paste0(
  "https://raw.githubusercontent.com/ntious/SynthDataHub/main/",
  "Information%20Technology%20%26%20Computer%20Science/it_perf_logs.csv"
)
perf <- read_csv(url)
glimpse(perf)          # ➜ Reflection Q1 starts here

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3A •  Descriptive statistics  (answers: centre, spread, outliers)
# ─────────────────────────────────────────────────────────────────────────────
skimr::skim(perf)      # quick skim table (mean, sd, p-tiles, missing%)
perf %>% 
  summarise(across(where(is.numeric),
                   list(min  = min,
                        q1   = ~ quantile(.x, .25),
                        med  = median,
                        q3   = ~ quantile(.x, .75),
                        max  = max),
                   .names = "{.col}_{.fn}"))

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3B •  Distribution plots (histogram & box-plot)     
#   • Helps describe symmetry / skew / multimodality and detect outliers      
# ─────────────────────────────────────────────────────────────────────────────
ggplot(perf, aes(CPU_Load)) +
  geom_histogram(bins = 30, fill = "steelblue", colour = "white") +
  labs(title = "CPU-utilisation distribution (%)")

ggplot(perf, aes(x = "", y = Avg_Response_Time)) +
  geom_boxplot(fill = "salmon") +
  labs(title = "Response-time spread (ms)", x = NULL, y = "ms")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4 •  Correlation heat-map  (Reflection Q-ready: strongest ±ρ & multicollinearity)
# ─────────────────────────────────────────────────────────────────────────────
numeric_cols <- perf %>% select(where(is.numeric))
M <- cor(numeric_cols)

corrplot(M,
         method      = "color",
         addCoef.col = "black",
         tl.col      = "black",
         number.cex  = 0.8,
         title       = "Correlation heat-map (IT metrics)",
         mar         = c(0, 0, 2, 0))

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5 •  Welch two-sample t-test  
#   • Compares response time in high-CPU (>70 %) vs low-CPU periods  
#   • Feeds Reflection Q3 (significance & effect size)                        
# ─────────────────────────────────────────────────────────────────────────────
perf <- perf %>% mutate(HighCPU = CPU_Load > 70)
t_test_out <- t.test(Avg_Response_Time ~ HighCPU, data = perf)
print(t_test_out)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 6 •  Simple linear regression  
#   • Model: Avg_Response_Time  ~  CPU_Load                                
#   • Answers: slope magnitude, % variance explained (R²) – Reflection Q3  
# ─────────────────────────────────────────────────────────────────────────────
model_slr <- lm(Avg_Response_Time ~ CPU_Load, data = perf)
summary(model_slr)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 7 •  Diagnostic checks  
#   • Residuals-vs-Fitted & Q-Q plots (linearity & normality)  
#   • Breusch–Pagan test for heteroscedasticity – Reflection Q4             
# ─────────────────────────────────────────────────────────────────────────────
par(mfrow = c(1, 2))
plot(model_slr, which = 1)    # Residuals vs Fitted
plot(model_slr, which = 2)    # Normal Q-Q
par(mfrow = c(1, 1))

bp_out <- lmtest::bptest(model_slr)
print(bp_out)

# ─────────────────────────────────────────────────────────────────────────────
# END-OF-SCRIPT NOTES FOR STUDENTS
# ---------------------------------------------------------------------------
# • Screenshot 1  = summary-statistics console AFTER Step 3A
# • Screenshot 2  = t-test console output in Step 5
# • Screenshot 3  = linear-regression summary in Step 6
# • Screenshot 4  = diagnostic plots + BP p-value in Step 7
#
# Reflection Q1 → centre, shape, outliers (use hist & skim)
# Reflection Q2 → strongest correlation, IT meaning, multicollinearity comment
# Reflection Q3 → t-test significance, ms difference, capacity insight
# Reflection Q4 → additional predictors & potential non-linearities
###############################################################################


