###############################################################################
# PROJECT: LaPalmaFA
# DESCRIPTION: Developmental Instability vs Physiological Stress
# AUTHOR: Divya Malhotra
###############################################################################

# --- LIBRARY SET UP ---
#Ensure libraries below are installed (only needs to be done once)
#Ensure the following CSVs are imported into the working directory: FvFm_R, Rep1_Data, and Rep2_Data 


library(geomorph)
library(tidyverse)
library(Hmisc) 

# --- 1. DATA PREPARATION ---
rep1 <- read.csv("Rep1_Data.csv")
rep2 <- read.csv("Rep2_Data.csv")
fvfm_raw <- read.csv("FvFm_R.csv", check.names = TRUE) 

raw_coords <- rbind(rep1, rep2) %>% mutate(ID = gsub("Leaf_", "", ID))

# FA by Position ANOVA and summary
fa_anova <- aov(FA_Score ~ Position, data = final_df)

fa_summary <- final_df %>%
  group_by(Position) %>%
  dplyr::summarize(
    n = n(),
    Mean_FA = mean(FA_Score),
    SD = sd(FA_Score),
    SE = sd(FA_Score) / sqrt(n()),
    CI_lower = mean(FA_Score) - qt(0.975, df = n()-1) * (sd(FA_Score)/sqrt(n())),
    CI_upper = mean(FA_Score) + qt(0.975, df = n()-1) * (sd(FA_Score)/sqrt(n()))
  )

sink("FA_Position_Summary.txt")
print(summary(fa_anova))
print(fa_summary)
sink()

complete_plants <- raw_coords %>%
  mutate(Plant_Num = as.numeric(gsub("[a-c]", "", ID))) %>%
  group_by(Plant_Num) %>%
  dplyr::summarize(leaf_count = n_distinct(ID)) %>%
  filter(leaf_count == 3) %>% pull(Plant_Num)

final_coords <- raw_coords %>%
  mutate(Plant_Num = as.numeric(gsub("[a-c]", "", ID))) %>%
  filter(Plant_Num %in% complete_plants) %>% arrange(ID, Rep, Landmark)

final_fvfm <- fvfm_raw %>% filter(Plant %in% complete_plants)

# --- 2. SYMMETRY ANALYSIS & FA EXTRACTION ---
n_obs <- nrow(final_coords) / 15
coords_array <- array(as.matrix(final_coords[, c("X", "Y")]), dim = c(15, 2, n_obs))
ind_labels <- as.factor(final_coords$ID[seq(1, nrow(final_coords), by = 15)])
rep_labels <- as.factor(final_coords$Rep[seq(1, nrow(final_coords), by = 15)])
land_pairs <- matrix(c(3,4, 6,7, 8,9, 10,11, 12,13, 14,15), ncol = 2, byrow = TRUE)

asym_results <- bilat.symmetry(A = coords_array, ind = ind_labels, 
                               replicate = rep_labels, object.sym = TRUE, 
                               land.pairs = land_pairs, iter = 999)

# Extract FA Scores
asym_name <- if("asymm.shape" %in% names(asym_results)) "asymm.shape" else "asym.shape"
fa_scores <- apply(asym_results[[asym_name]], 3, function(x) sqrt(sum(x^2)))

final_df <- data.frame(ID = ind_labels, FA_Score = fa_scores) %>%
  group_by(ID) %>%
  dplyr::summarize(FA_Score = mean(FA_Score)) %>%
  left_join(final_fvfm, by = "ID") %>%
  mutate(Position = factor(gsub("[0-9]", "", ID), 
                           levels = c("a", "b", "c"), labels = c("Top", "Middle", "Bottom")))

# --- 3. COMBINED EFFECTS MODEL (Interaction) ---
model_interaction <- lm(FA_Score ~ fv.fm * Position, data = final_df)

# --- 4. OUTPUTS & VISUALS ---

# Create PDF for the report
pdf("Report_Final_Visuals.pdf", width = 10, height = 8)

# A. Combined Effects Plot (Interaction Slopes)
print(
  ggplot(final_df, aes(x = fv.fm, y = FA_Score, color = Position)) +
    geom_point(size = 3, alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, size = 1.5) +
    scale_color_viridis_d() +
    labs(title = "Combined Effects: Stress vs. Asymmetry by Position",
         subtitle = "Slopes represent how Fv/Fm affects FA at different canopy heights",
         x = "Photosynthetic Efficiency (Fv/Fm)", y = "Fluctuating Asymmetry (FA)") +
    theme_minimal()
)

# B. Asymmetry Validation Plot (Shape Components)
plot(asym_results)

dev.off()

# --- 5. PRINT SUMMARY TABLE ---
cat("\n--- STATISTICAL SUMMARY TABLE ---\n")
print(summary(model_interaction))

# Save the table to a text file for easy copying
sink("Summary_Results_Table.txt")
print(summary(model_interaction))
sink()

# --- 6. PRINT REMAINING TABLES ---
# Fv/Fm by Position ANOVA
fvfm_model <- aov(fv.fm ~ Position, data = final_df)
sink("FvFm_Position_ANOVA.txt")
print(summary(fvfm_model))
print(model.tables(fvfm_model, "means"))
sink()
# Fv/Fm summary statistics by position with SE and 95% CI
fvfm_summary <- final_df %>%
  group_by(Position) %>%
  dplyr::summarize(
    n = n(),
    Mean_FvFm = mean(fv.fm),
    SD = sd(fv.fm),
    SE = sd(fv.fm) / sqrt(n()),
    CI_lower = mean(fv.fm) - qt(0.975, df = n()-1) * (sd(fv.fm)/sqrt(n())),
    CI_upper = mean(fv.fm) + qt(0.975, df = n()-1) * (sd(fv.fm)/sqrt(n()))
  )

sink("FvFm_Position_Summary.txt")
print(fvfm_summary)
sink()

# FA by Position ANOVA and summary
fa_anova <- aov(FA_Score ~ Position, data = final_df)

fa_summary <- final_df %>%
  group_by(Position) %>%
  dplyr::summarize(
    n = n(),
    Mean_FA = mean(FA_Score),
    SD = sd(FA_Score),
    SE = sd(FA_Score) / sqrt(n()),
    CI_lower = mean(FA_Score) - qt(0.975, df = n()-1) * (sd(FA_Score)/sqrt(n())),
    CI_upper = mean(FA_Score) + qt(0.975, df = n()-1) * (sd(FA_Score)/sqrt(n()))
  )

sink("FA_Position_Summary.txt")
print(summary(fa_anova))
print(fa_summary)
sink()
