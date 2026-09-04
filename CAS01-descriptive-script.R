# ==============================================================================
# CAS O1 - DESCRIPTIVE SCRIPT
# ==============================================================================
# Install packages first (run once)
# Then run the rest of the analysis

# ==============================================================================
# INSTALL REQUIRED PACKAGES (Run this ONCE)
# ==============================================================================

# install.packages("tidyverse", repos = "http://cran.us.r-project.org")
# install.packages("knitr", repos = "http://cran.us.r-project.org")

# Uncomment the lines above to install packages the first time
# After installation, just load them with library() below
install.packages("tidyverse")
install.packages("knitr")
               
# Load libraries
# library() loads the packages so you can use their functions
library(tidyverse)    # For data manipulation (dplyr) and plotting (ggplot2)
library(knitr)        # For creating formatted tables

# ==============================================================================
# STEP 1: CREATE PROJECT FOLDER
# ==============================================================================

# Print a message to show the script is running
cat("Creating project folder...\n\n")

# Create folder in current location
# getwd() gets your current working directory (where files are saved)
project_name <- "CAS_analysis"
project_folder <- file.path(getwd(), project_name)

# Check if folder already exists
# If not, create it
if (!dir.exists(project_folder)) {
  dir.create(project_folder, showWarnings = FALSE)
  cat("✓ Created:", project_folder, "\n\n")
} else {
  # If folder exists, just acknowledge it
  cat("✓ Folder exists:", project_folder, "\n\n")
}

# Show where the folder is located
cat("📁 Your analysis folder is here:\n")
cat("   ", project_folder, "\n\n")
cat("📌 Next: Copy cas_descriptive_df.csv to this location\n")

# ==============================================================================
# STEP 2: LOAD DATA
# ==============================================================================

# Define possible locations to look for the CSV file
# The script searches in multiple places automatically
csv_locations <- c(
  file.path(getwd(), "cas_descriptive_df.csv"),  # Current folder
  "cas_descriptive_df.csv"                       # Alternate location
)

# Find the CSV file by checking each location
# This is a loop that stops when it finds the file
csv_file <- NULL  # Start with no file found
for (loc in csv_locations) {
  if (file.exists(loc)) {  # Check if file exists in this location
    csv_file <- loc        # If found, save the location
    break                  # Stop looking, we found it!
  }
}

# Load the data
# If the file was found, read it into a data frame called "df"
# If not found, show an error message
if (!is.null(csv_file)) {
  # read.csv() reads the CSV file and creates a data frame
  df <- read.csv(csv_file)
  cat("✅ Data loaded!\n")
  cat("File:", csv_file, "\n")
  # Show how many rows (participants) and columns (variables) in the data
  cat("Rows:", nrow(df), "| Columns:", ncol(df), "\n\n")
} else {
  # Error message if file not found
  cat("❌ CSV file not found!\n\n")
  cat("Looked in:\n")
  cat("1.", getwd(), "\n")
  cat("2.", project_folder, "\n")
  cat("3. Your current folder\n\n")
  stop("Please copy CSV file and try again")
}

# Display first few rows so you can see what the data looks like
head(df)

# ==============================================================================
# STEP 3: PLUG IN YOUR OUTCOME VARIABLE
# ==============================================================================

# CHANGE THIS LINE TO YOUR GROUP'S OUTCOME!
# Choose ONE of these:
# - Group 1: "alb_binary"           (albuminuria / kidney damage)
# - Group 2: "moca_binary"          (cognitive impairment)
# - Group 3: "cesd_binary"          (depression)
# - Group 4: "dyslipidemia_binary"  (abnormal lipids)

#OUTCOME_VAR <- "alb_binary"  # Change to your outcome
OUTCOME_VAR <- "cesd_binary"  # Change to your outcome

# Create a simple "outcome" column that references your chosen outcome
# This makes all the code below easier to use
# df[[OUTCOME_VAR]] gets the column with the name you specified above
df$outcome <- df[[OUTCOME_VAR]]  

# Show that the outcome was created successfully
# table() shows how many 0s and 1s are in your outcome variable
cat("Outcome column created!\n") #the last 0 shows count of NAs
cat("Values:", table(df$outcome, useNA = "always"), "\n\n")


# ==============================================================================
# PLOT 0: SAMPLE SIZE BAR CHART
# ==============================================================================
# Shows how many participants are in each study group
# This tells us if groups are roughly of equal size

# The %>% symbol is a "pipe" - it sends the data through each step
df %>%
  # group_by() organizes the data by study_group
  group_by(study_group) %>%
  # count() counts how many rows in each group
  count(name = "n") %>%
  ungroup() %>%
  # ggplot() starts creating the plot
  ggplot(aes(x = study_group, y = n, fill = study_group)) +
  # geom_col() creates bar chart
  geom_col(
    alpha = 0.9,        # 90% opaque bars
    color = "white",    # white border around bars
    linewidth = 2.5,
    width = 0.6
  ) +
  # Add sample size labels on top of each bar
  geom_text(
    aes(label = paste0("n=", n)),
    vjust = -0.8,       # Move text up (away from bar)
    fontface = "bold",
    size = 7,
    color = "#1A1A1A"
  ) +
  # Set custom colors for each group
  scale_fill_manual(
    values = c(
      "Healthy" = "#1E88E5",                    # Deep Blue
      "Pre-diabetes" = "#00ACC1",               # Teal
      "Diabetic (Oral med)" = "#FB8C00",        # Deep Orange
      "Diabetes (Insulin Dependent)" = "#D32F2F" # Deep Red
    )
  ) +
  # Set y-axis to have some space at top for labels
  scale_y_continuous(
    limits = c(0, max(df %>% group_by(study_group) %>% count() %>% pull(n)) * 1.15)
  ) +
  # Add labels
  labs(
    title = "Number of Participants per Study Group",
    x = "Study Group",
    y = "Number of Participants",
    fill = "Study Group",
    caption = paste("Total N =", nrow(df))
  ) +
  # Apply minimal theme (clean, professional look)
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 22, color = "#1A1A1A", margin = margin(0, 0, 12, 0)),
    axis.title = element_text(face = "bold", size = 14, color = "#2C3E50"),
    axis.text.x = element_text(size = 12, face = "bold", color = "#2C3E50", hjust = 1),
    axis.text.y = element_text(size = 12, color = "#555555"),
    panel.grid.major.y = element_line(color = "#E8E8E8", linewidth = 0.5, linetype = "dotted"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none",  # Don't show legend (redundant with x-axis)
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "#FAFAFA", color = NA),
    plot.caption = element_text(size = 11, color = "#999999", margin = margin(20, 0, 0, 0)),
    plot.margin = margin(20, 25, 20, 25)
  )


# ==============================================================================
# TABLE 1: OVERALL SAMPLE
# ==============================================================================
# Shows basic characteristics of ALL 1,068 participants
# Key number to look at: "Outcome Positive %" - overall prevalence

# summarise() creates summary statistics for the entire sample
table1 <- df %>%
  summarise(
    # Total number of participants
    N = n(),
    # Age: mean ± standard deviation
    # mean() calculates average, sd() calculates spread
    `Age (M±SD)` = paste0(round(mean(age, na.rm = TRUE), 1), " ± ", 
                          round(sd(age, na.rm = TRUE), 1)),
    # What % are female? (M and F are coded, so use "F")
    `Female %` = paste0(round(sum(sex == "F") / n() * 100, 0), "%"),
    # What % have your outcome in the entire sample?
    # sum(outcome == 1) counts positive cases
    `Outcome Positive %` = paste0(round(sum(outcome == 1, na.rm = TRUE) / n() * 100, 1), "%")
  ) %>%
  # t() transposes the table (rows become columns)
  t() %>%
  # as.data.frame() converts to proper table format
  as.data.frame()

# Rename the column to "Value"
colnames(table1) <- "Value"
# kable() formats the table nicely
print(kable(table1, caption = "Overall Sample Characteristics"))

# hint: look at outcome positive

# ==============================================================================
# PLOT 1: PREVALENCE BY STUDY GROUP
# ==============================================================================
# THIS IS THE MOST IMPORTANT PLOT!
# Shows what % of each group has your outcome
# Helps answer: "Does disease severity affect the outcome?"

df %>%
  # Calculate stats for each study group separately
  group_by(study_group) %>%
  summarise(
    # How many have the outcome (outcome = 1)
    positive = sum(outcome == 1, na.rm = TRUE),
    # Total people in this group
    total = n(),
    # Calculate prevalence percentage
    prevalence = positive / total * 100,
    .groups = "drop"  # Ungroup after calculations
  ) %>%
  # reorder() arranges bars from highest to lowest prevalence
  # This makes patterns easier to see
  ggplot(aes(x = reorder(study_group, -prevalence), y = prevalence, fill = study_group)) +
  # Create bars
  geom_col(alpha = 0.85, color = "white", linewidth = 1.5) +
  # Add percentage labels on top
  # \n creates a line break to show percentage on one line, count on next
  geom_text(aes(label = paste0(round(prevalence, 1), "%\n(n=", positive, ")")), 
            vjust = -0.5, fontface = "bold", size = 5, color = "black") +
  # Custom colors for study groups
  scale_fill_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A")) +
  # Labels
  labs(title = paste("Prevalence by Study Group"),
       subtitle = "Ordered by prevalence (highest to lowest)",
       x = "Study Group", 
       y = "Prevalence (%)", 
       fill = "Study Group",
       caption = paste("n =", nrow(df))) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, color = "#7F8C8D"),
    axis.title = element_text(face = "bold", size = 13, color = "#2C3E50"),
    axis.text.x = element_text(hjust = 1, size = 11, face = "bold"),
    axis.text.y = element_text(size = 11),
    legend.position = "none",
    panel.grid.major.y = element_line(color = "#ECF0F1", linewidth = 0.3),
    panel.grid.minor.y = element_blank(),
    plot.background = element_rect(fill = "white", color = NA)
  ) +
  # Set y-axis limit with some space at top
  ylim(0, max(df %>% group_by(study_group) %>% 
                summarise(prev = sum(outcome == 1, na.rm = TRUE) / n() * 100, .groups = "drop") %>% 
                pull(prev)) * 1.15)


# ==============================================================================
# PLOT 2: OUTCOME PREVALENCE BY SEX
# ==============================================================================
# Shows whether males and females differ in outcome prevalence
# Helps answer: "Is sex a factor in your outcome?"

df %>%
  # Calculate stats for each sex separately
  group_by(sex) %>%
  summarise(
    positive = sum(outcome == 1, na.rm = TRUE),  # How many positive
    total = n(),                                  # Total in group
    prevalence = positive / total * 100,          # Calculate %
    .groups = "drop"
  ) %>%
  ggplot(aes(x = sex, y = prevalence, fill = sex)) +
  # Create bars with professional styling
  geom_col(
    alpha = 0.9,              # Very opaque
    color = "#FFFFFF",        # White borders
    linewidth = 3,
    width = 0.6
  ) +
  # Add percentage labels on top
  geom_text(
    aes(label = paste0(round(prevalence, 1), "%")), 
    vjust = -1.5,            # Move above bar
    fontface = "bold", 
    size = 8, 
    color = "#2C3E50",
    family = "sans"
  ) +
  # Add sample size information
  geom_text(
    aes(label = paste0("n=", positive, " / ", total)), 
    vjust = -0.3,
    fontface = "italic", 
    size = 5.5, 
    color = "#7F8C8D",
    family = "sans"
  ) +
  # Colors: red for female, blue for male
  scale_fill_manual(
    values = c(
      "F" = "#E63946",   # Red for Female
      "M" = "#457B9D"    # Blue for Male
    ),
    labels = c("F" = "Female", "M" = "Male")
  ) +
  # Y-axis from 0-70% (adjust if your data needs different range)
  scale_y_continuous(
    limits = c(0, 70),
    breaks = seq(0, 100, 20),
    labels = paste0(seq(0, 100, 20), "%")
  ) +
  # Labels
  labs(
    title = paste("Prevalence by Sex"),
    subtitle = "Female (Red) vs Male (Blue)",
    x = "", 
    y = "Prevalence (%)", 
    fill = "Sex",
    caption = paste("Total participants: n =", nrow(df))
  ) +
  # Clean, professional theme
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 22, color = "#1A1A1A", margin = margin(0, 0, 10, 0), family = "sans"),
    plot.subtitle = element_text(size = 14, color = "#555555", margin = margin(0, 0, 20, 0), family = "sans"),
    axis.title.y = element_text(face = "bold", size = 14, color = "#2C3E50", margin = margin(0, 15, 0, 0), family = "sans"),
    axis.text.x = element_text(size = 15, face = "bold", color = "#2C3E50", family = "sans"),
    axis.text.y = element_text(size = 12, color = "#555555", family = "sans"),
    panel.grid.major.y = element_line(color = "#E8E8E8", linewidth = 0.5, linetype = "dotted"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none",
    plot.background = element_rect(fill = "#FFFFFF", color = NA),
    panel.background = element_rect(fill = "#FAFAFA", color = NA),
    plot.caption = element_text(size = 11, color = "#999999", hjust = 0, margin = margin(20, 0, 0, 0), family = "sans"),
    plot.margin = margin(20, 25, 20, 25)
  )

# ==============================================================================
# PLOT 3: OUTCOME PREVALENCE BY AGE QUARTILES
# ==============================================================================
# Shows whether outcome changes with age
# Quartiles = divide age into 4 equal groups (25% each)
# Q1 = youngest, Q4 = oldest

# Create age quartiles first
# ntile(df$age, 4) divides people into 4 equal-sized age groups
df$age_quartile <- ntile(df$age, 4)

# Get the age ranges for each quartile
# This creates labels like "Q1: 40-51" to show actual age ranges
age_quartile_labels <- df %>%
  group_by(age_quartile) %>%
  summarise(
    # Find min and max age in each quartile
    min_age = min(age, na.rm = TRUE),
    max_age = max(age, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  # Create nice labels with age ranges
  mutate(label = paste0("Q", age_quartile, ": ", round(min_age), "-", round(max_age)))

# Plot outcome by age quartile
df %>%
  group_by(age_quartile) %>%
  summarise(
    positive = sum(outcome == 1, na.rm = TRUE),  # How many positive
    total = n(),                                  # Total (always 267)
    prevalence = positive / total * 100,          # Calculate %
    .groups = "drop"
  ) %>%
  # Add the age range labels
  left_join(age_quartile_labels, by = "age_quartile") %>%
  # factor(age_quartile) converts to 1,2,3,4 for color mapping
  ggplot(aes(x = reorder(label, age_quartile), y = prevalence, fill = factor(age_quartile))) +
  # Create bars
  geom_col(
    alpha = 0.9, 
    color = "#FFFFFF",     # White borders
    linewidth = 3,
    width = 0.65
  ) +
  # Add percentage labels on top
  geom_text(
    aes(label = paste0(round(prevalence, 1), "%")), 
    vjust = -1.5, 
    fontface = "bold", 
    size = 8, 
    color = "#2C3E50",
    family = "sans"
  ) +
  # Add sample size (always n/267)
  geom_text(
    aes(label = paste0("n=", positive, " / ", total)), 
    vjust = -0.3, 
    fontface = "italic", 
    size = 5.5, 
    color = "#7F8C8D",
    family = "sans"
  ) +
  # Colors by age quartile: Blue → Green → Orange → Red
  # Shows progression from young to old
  scale_fill_manual(
    values = c(
      "1" = "#3498DB",  # Blue - Q1 (youngest, age 40-51)
      "2" = "#2ECC71",  # Green - Q2 (age 52-60)
      "3" = "#F39C12",  # Orange - Q3 (age 61-69)
      "4" = "#E74C3C"   # Red - Q4 (oldest, age 69-87)
    ),
    labels = c(
      "1" = "Q1",
      "2" = "Q2",
      "3" = "Q3",
      "4" = "Q4"
    )
  ) +
  # Y-axis from 0-60% (adjust if needed)
  scale_y_continuous(
    limits = c(0, 60),
    breaks = seq(0, 60, 20),
    labels = paste0(seq(0, 60, 20), "%")
  ) +
  # Labels
  labs(
    title = paste("Prevalence by Age Quartiles"),
    x = "Age Quartile", 
    y = "Prevalence (%)", 
    fill = "Quartile",
    caption = paste("Total participants: n =", nrow(df))
  ) +
  # Clean professional theme
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1A1A1A", margin = margin(0, 0, 10, 0), family = "sans"),
    axis.title.x = element_text(face = "bold", size = 10, color = "#2C3E50", margin = margin(15, 0, 0, 0), family = "sans"),
    axis.title.y = element_text(face = "bold", size = 10, color = "#2C3E50", margin = margin(0, 15, 0, 0), family = "sans"),
    axis.text.x = element_text(size = 13, face = "bold", color = "#2C3E50", family = "sans"),
    axis.text.y = element_text(size = 12, color = "#555555", family = "sans"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 12, color = "#2C3E50", family = "sans"),
    legend.text = element_text(size = 11, color = "#555555", family = "sans"),
    panel.grid.major.y = element_line(color = "#E8E8E8", linewidth = 0.5, linetype = "dotted"),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    plot.background = element_rect(fill = "#FFFFFF", color = NA),
    panel.background = element_rect(fill = "#FAFAFA", color = NA),
    plot.caption = element_text(size = 11, color = "#999999", hjust = 0, margin = margin(20, 0, 0, 0), family = "sans"),
    plot.margin = margin(20, 25, 20, 25)
  )

# ==============================================================================
# END OF SCRIPT
# ==============================================================================
# You now have:
# ✓ 1 sample size chart (shows group distributions)
# ✓ 1 summary table (overall characteristics)
# ✓ 3 key plots (by study group, sex, and age)
# 
# Next: Use the plots and table to try to answer the descriptive questions.
