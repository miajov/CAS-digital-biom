# ============================================================
# DIGITAL BIOMARKERS DESCRIPTIVE ANALYSIS
# ============================================================
#
# GOAL:
# Explore your study population, outcome, and candidate
# digital biomarker features before building a prediction model.
#
# ============================================================


# ============================================================
# 1. SET YOUR WORKING DIRECTORY
# ============================================================

# Tell R where your dataset is saved.

# Mac example:
setwd("~/Desktop/")

# Windows example:
# setwd("C:/Users/YourName/Desktop/")


# ============================================================
# 2. LOAD YOUR DATA
# ============================================================

df <- read.csv("~/cas-02-descriptives.csv")

# Look at the first rows of the dataset
head(df)

# See all variable names
names(df)


# ============================================================
# 3. CHOOSE YOUR STUDY POPULATION
# ============================================================
#
# QUESTION:
# Who is the population in which you want to develop
# your digital biomarker?
#
# First, examine which study groups are available.
# ============================================================

table(df$study_group)


# ------------------------------------------------------------
# OPTION A: Choose ONE study group
# ------------------------------------------------------------
## Comment or uncomment the lines below depending on which study
## groups you want to keep. To keep ALL study groups, leave this
## whole section commented out. To restrict to specific groups,
## uncomment the option you want and edit the group names.

# Example: Healthy participants

df <- subset(
  df,
  study_group == "Healthy"
)


# ------------------------------------------------------------
# OPTION B: Combine multiple study groups
# ------------------------------------------------------------
#
# Comment out OPTION A above and uncomment one option below.


# Example: Healthy + Prediabetes

# df <- subset(
#   df,
#   study_group %in% c("Healthy", "Prediabetes")
# )


# Example: Diabetes groups

# df <- subset(
#   df,
#   study_group %in% c(
#     "Diabetes (Insulin Dependent)",
#     "Diabetic (Oral med)"
#   )
# )


# ------------------------------------------------------------
# CHECK YOUR SELECTED POPULATION
# ------------------------------------------------------------

# Number of participants in each study group
table(df$study_group)

# Total number of participants
nrow(df)


# ============================================================
# 4. FILTER BY AGE (OPTIONAL)
# ============================================================
#
# QUESTION:
# Does your research question focus on a particular age group?
#
# If not, leave the age filter commented out.
# ============================================================


# First, look at the age distribution

summary(df$age)


# ------------------------------------------------------------
# OPTION A: Select an age range
# ------------------------------------------------------------

# Example: participants aged 40 to 86 years

# df <- subset(
#   df,
#   age >= 40 & age <= 86
# )


# ------------------------------------------------------------
# OPTION B: Select everyone above a certain age
# ------------------------------------------------------------

# Example: participants aged 60+

# df <- subset(
#   df,
#   age >= 60
# )


# ------------------------------------------------------------
# CHECK YOUR FINAL STUDY POPULATION
# ------------------------------------------------------------

# Total number of participants
nrow(df)

# Age distribution
summary(df$age)

# Study groups remaining
table(df$study_group)


# ============================================================
# 5. CHOOSE YOUR OUTCOME AND CANDIDATE FEATURES
# ============================================================

# ------------------------------------------------------------
# 5A. CHOOSE YOUR OUTCOME
# ------------------------------------------------------------
#
# QUESTION:
# What are you trying to predict?

#triglycerades_binary
#alb_binary
#moca_binary
#cesd_binary

# Your outcome should be binary:
#
# 0 = No
# 1 = Yes
#
# Example:
# alb_binary = albuminuria absent/present
# ------------------------------------------------------------

outcome <- "moca_binary"


# Number of participants with and without the outcome
table(df[[outcome]])


# Percentage with and without the outcome
round(
  prop.table(table(df[[outcome]])) * 100,
  1
)


# ------------------------------------------------------------
# 5B. CHOOSE YOUR CANDIDATE FEATURES
# ------------------------------------------------------------
#
# QUESTION:
# Which variables could potentially help predict your outcome?
#
# Add or remove variables as needed.
# ------------------------------------------------------------

features <- c(
  "waist_to_hip_ratio",
  "BMI",
  "HbA1c",
  "TIR_70_180_pct",
  "food_insecurity_raw_score",
  "walking_infrastructure_score",
  "mean_active_minutes"
)



# ============================================================
# 5C. DESCRIPTIVE STATISTICS FOR YOUR FEATURES
# ============================================================
#
# Before examining associations, understand your variables.
#
# This table shows:
#
# N       = number of available observations
# Mean    = average
# SD      = standard deviation
# Min     = minimum
# Median  = median
# Max     = maximum
# Missing = number of missing observations
# ============================================================


descriptives <- data.frame(
  
  Feature = features,
  
  N = sapply(df[, features], function(x)
    sum(!is.na(x))),
  
  Mean = sapply(df[, features], function(x)
    mean(x, na.rm = TRUE)),
  
  SD = sapply(df[, features], function(x)
    sd(x, na.rm = TRUE)),
  
  Min = sapply(df[, features], function(x)
    min(x, na.rm = TRUE)),
  
  Median = sapply(df[, features], function(x)
    median(x, na.rm = TRUE)),
  
  Max = sapply(df[, features], function(x)
    max(x, na.rm = TRUE)),
  
  Missing = sapply(df[, features], function(x)
    sum(is.na(x)))
)


# Round values to 2 decimal places

descriptives[, c(
  "Mean",
  "SD",
  "Min",
  "Median",
  "Max"
)] <- round(
  descriptives[, c(
    "Mean",
    "SD",
    "Min",
    "Median",
    "Max"
  )],
  2
)


# View the descriptive statistics table

descriptives


# ============================================================
# 6. FEATURE–OUTCOME ASSOCIATIONS
# ============================================================
#
# HERE WE ASK:
#
# "Is EACH candidate feature associated with the OUTCOME?"
#
#
#       Feature 1 ──────> Outcome
#
#       Feature 2 ──────> Outcome
#
#       Feature 3 ──────> Outcome
#
#
# We examine each feature separately against the binary outcome.
#
# For EACH feature we calculate:
#
# 1. Correlation with the outcome
# 2. P-value for that correlation
#
#
# IMPORTANT:
#
# This is NOT yet a prediction model.
#
# We are exploring whether individual features contain
# potential signal related to the outcome.
# ============================================================


# ------------------------------------------------------------
# WHAT DOES THE CORRELATION MEAN?
# ------------------------------------------------------------
#
# Because the outcome is coded 0/1, Pearson correlation
# gives the point-biserial correlation for continuous features.
#
#
# Positive correlation:
#
# r > 0
#
# Higher values of the feature are associated with outcome = 1.
#
#
# Negative correlation:
#
# r < 0
#
# Lower values of the feature are associated with outcome = 1.
#
#
# Correlation close to 0:
#
# Little linear association with the outcome.
# ------------------------------------------------------------


# Create an empty results table

results <- data.frame(
  Feature = features,
  Correlation_with_outcome = NA,
  P_value = NA
)


# ------------------------------------------------------------
# CALCULATE CORRELATION + P-VALUE FOR EACH FEATURE
# ------------------------------------------------------------

for (i in seq_along(features)) {
  
  variable <- features[i]
  
  
  # Keep participants who have BOTH:
  #
  # 1. the feature
  # 2. the outcome
  
  complete <- complete.cases(
    df[[variable]],
    df[[outcome]]
  )
  
  
  # Test:
  #
  # FEATURE <----> OUTCOME
  
  test <- cor.test(
    df[[variable]][complete],
    df[[outcome]][complete],
    method = "pearson"
  )
  
  
  # Save the correlation and its p-value
  
  results$Correlation_with_outcome[i] <- test$estimate
  
  results$P_value[i] <- test$p.value
}


# ============================================================
# 6A. RANK FEATURES BY ASSOCIATION WITH THE OUTCOME
# ============================================================
#
# We now rank the candidate features from the
# STRONGEST to WEAKEST association with the outcome.
#
# We rank using ABSOLUTE correlation because:
#
# r =  0.40
#
# and
#
# r = -0.40
#
# have the same association strength.
#
# The original correlation is kept so that you can still
# see whether the association is positive or negative.
# ============================================================


# Calculate absolute correlation BEFORE rounding

results$Absolute_correlation <- abs(
  results$Correlation_with_outcome
)


# Sort from strongest to weakest association

results <- results[
  order(
    results$Absolute_correlation,
    decreasing = TRUE
  ),
]


# Add rank

results$Rank <- 1:nrow(results)


# Round values for easier reading

results$Correlation_with_outcome <- round(
  results$Correlation_with_outcome,
  2
)

results$Absolute_correlation <- round(
  results$Absolute_correlation,
  2
)

results$P_value <- round(
  results$P_value,
  3
)


# Put columns in an easy-to-read order

results <- results[, c(
  "Rank",
  "Feature",
  "Correlation_with_outcome",
  "P_value",
  "Absolute_correlation"
)]


# ------------------------------------------------------------
# VIEW THE FEATURE–OUTCOME RESULTS
# ------------------------------------------------------------

results


# ------------------------------------------------------------
# HOW TO INTERPRET THE TABLE
# ------------------------------------------------------------
#
# Example:
#
# Rank  Feature       Correlation     P-value    Absolute correlation
#
#  1    HbA1c             0.30         0.002             0.30
#  2    BMI              -0.22         0.018             0.22
#  3    Waist             0.08         0.310             0.08
#
#
# CORRELATION tells you:
#
# --> Strength AND direction of the association.
#
#
# P-VALUE tells you:
#
# --> Statistical evidence for an association.
#
#
# A commonly used threshold is:
#
# p < 0.05
#
#
# IMPORTANT:
#
# p < 0.05 does NOT mean that a feature is necessarily
# a good predictor.
#
# Similarly, a larger correlation does NOT automatically
# mean that a feature should be included in your model.
#
# Predictive usefulness should ultimately be evaluated
# using out-of-sample prediction performance.


# ============================================================
# 7. VISUALIZE FEATURES BY OUTCOME
# ============================================================
#
# HERE WE ASK:
#
# "What does the relationship between a feature and
#  the OUTCOME actually look like?"
#
#
# Choose up to 7 features to visualize.
#
# These may be features that:
#
# - show an interesting association with the outcome
# - are clinically or physiologically relevant
# - you are considering for your prediction model
#
# You only need to change the variable names below.
# ============================================================

plot_features <- c(
  "waist_to_hip_ratio",
  "BMI",
  "HbA1c"
)


# You can include up to 10 numeric variables:
#
# plot_features <- c(
#   "variable1",
#   "variable2",
#   "variable3",
#   "variable4",
#   "variable5",
#   "variable6",
#   "variable7"
# )


# ------------------------------------------------------------
# CREATE ONE PLOT FOR EACH FEATURE — SHOW ON SCREEN AND SAVE
# ------------------------------------------------------------

# Folder where plots will be saved
# Mac example:
save_folder <- "~/Desktop/"

# Windows example:
# save_folder <- "C:/Users/YourName/Desktop/"


for (variable in plot_features) {
  
  # Function that draws the plot (reused for screen + file)
  draw_plot <- function() {
    boxplot(
      df[[variable]] ~ df[[outcome]],
      
      xlab = "Outcome (0 = No, 1 = Yes)",
      ylab = variable,
      main = paste(variable, "by Outcome"),
      
      col = c("lightblue", "lightcoral"),
      border = "gray30",
      las = 1
    )
    
    # Add individual participants as points
    stripchart(
      df[[variable]] ~ df[[outcome]],
      vertical = TRUE,
      method = "jitter",
      pch = 16,
      col = rgb(0, 0, 0, 0.30),
      add = TRUE
    )
  }
  
  
  # 1. Show the plot on screen
  draw_plot()
  
  
  # 2. Save the same plot to Desktop as a PNG
  
  file_path <- paste0(
    save_folder,
    variable,
    "_by_Outcome.png"
  )
  
  png(
    filename = file_path,
    width = 800,
    height = 600
  )
  
  draw_plot()
  
  dev.off()
}


# ============================================================
# 8. FEATURE–FEATURE CORRELATION MATRIX
# ============================================================
#
# THIS IS DIFFERENT FROM STEP 6.
#
#
# STEP 6 asked:
#
# "Is each FEATURE associated with the OUTCOME?"
#
#
#       Feature 1 ──────> Outcome
#
#       Feature 2 ──────> Outcome
#
#       Feature 3 ──────> Outcome
#
#
# STEP 8 asks:
#
# "How strongly are the FEATURES associated
#  with EACH OTHER?"
#
#
#       Feature 1 <────> Feature 2
#
#       Feature 1 <────> Feature 3
#
#       Feature 2 <────> Feature 3
#
#
# WHY DO WE CARE?
#
# Some candidate predictors may contain very similar
# information.
#
# For example:
#
# BMI <----> waist-to-hip ratio
#
# may be strongly correlated because both capture aspects
# of body composition.
#
# Very highly correlated predictors may therefore provide
# overlapping or redundant information.
# ============================================================


# Select ONLY the candidate predictor features

selected <- df[, features]


# ------------------------------------------------------------
# CALCULATE THE FEATURE–FEATURE CORRELATION MATRIX
# ------------------------------------------------------------

correlations <- cor(
  selected,
  use = "pairwise.complete.obs"
)


# ------------------------------------------------------------
# HOW TO READ THE CORRELATION MATRIX
# ------------------------------------------------------------
#
# Each number represents the correlation between
# TWO candidate predictor features.

# Example:
#                      BMI      HbA1c      Waist
#
# BMI                  1.00      0.30       0.65
#
# HbA1c                0.30      1.00       0.20
#
# Waist                0.65      0.20       1.00


# The diagonal is always 1.00 because each variable
# is perfectly correlated with itself.
#
#
# Correlations closer to:
#  1 = strong positive relationship
# -1 = strong negative relationship
#  0 = little linear relationship


# QUESTION:
# Are any of your candidate predictors very strongly
# correlated with each other?
# If yes, think about whether they provide different
# information or mostly measure the same underlying construct.
# ------------------------------------------------------------
# VIEW THE CORRELATION MATRIX
# ------------------------------------------------------------

round(correlations, 2)


round(correlations, 2)


# ------------------------------------------------------------
# CHECK FOR HIGHLY CORRELATED FEATURE PAIRS
# ------------------------------------------------------------
# Flag any pair of features with |correlation| above a threshold
# (excluding the diagonal, which is always 1.00 by definition)

threshold <- 0.8  # <-- high correlation cut off

# Set the diagonal to NA so it doesn't get flagged
diag(correlations) <- NA

# Find which pairs exceed the threshold
high_corr <- which(
  abs(correlations) > threshold,
  arr.ind = TRUE
)

if (nrow(high_corr) == 0) {
  
  cat("No feature pairs exceed a correlation of", threshold, "\n")
  
} else {
  
  high_corr_table <- data.frame(
    Feature_1 = rownames(correlations)[high_corr[, 1]],
    Feature_2 = colnames(correlations)[high_corr[, 2]],
    Correlation = round(correlations[high_corr], 2)
  )
  
  # Remove duplicate pairs (A-B and B-A are the same pair)
  high_corr_table <- high_corr_table[
    high_corr_table$Feature_1 < high_corr_table$Feature_2,
  ]
  
  print(high_corr_table)
  
}


# ============================================================
# QUESTIONS TO THINK ABOUT
# ============================================================
#
#
# STUDY POPULATION
# ------------------------------------------------------------
#
# 1. Who are you trying to predict the outcome in?
#
# 2. How common is the outcome in this population?
#
#
# FEATURES vs OUTCOME
# ------------------------------------------------------------
#
# 3. Which features have the strongest associations
#    with the outcome?
#
# 4. Are these associations positive or negative?
#
# 5. What are the p-values?
#
# 6. Do the plots show visible differences between
#    participants with and without the outcome?
#
#
# FEATURES vs FEATURES
# ------------------------------------------------------------
#
# 7. Which candidate features are strongly correlated
#    with each other?
#
# 8. Could some predictors contain redundant information?
#
#
# MOVING TO PREDICTION
# ------------------------------------------------------------
#
# 9. Which features would you consider taking forward
#    into your prediction model?
#
#
# IMPORTANT:
# Correlations and p-values are EXPLORATORY.
#
# Whether a feature actually improves prediction should
# ultimately be evaluated using OUT-OF-SAMPLE
# model performance.
#
# ============================================================