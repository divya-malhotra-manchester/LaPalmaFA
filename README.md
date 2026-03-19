# LaPalmaFA

## Developmental Instability vs Physiological Stress in *Ageratina adenophora*
**Author:** Divya Malhotra  
**Institution:** University of Manchester  
**Field Site:** Barranco de las Angustias, Caldera de Taburiente National Park, La Palma, Spain  
**Date:** January–February 2026  

---

## Project Overview
This repository contains all data, analysis scripts, and statistical outputs for a study investigating the relationship between fluctuating asymmetry (FA) and chlorophyll fluorescence (Fv/Fm) in the invasive species *Ageratina adenophora* across canopy positions. FA was quantified using geometric morphometrics with 15 bilateral landmarks processed in ImageJ; Fv/Fm was measured in situ using a FluorPen FP 100.

---

## Repository Contents

| File | Description |
|------|-------------|
| `La_Palma_FA_vs_FvFm.R` | Full R analysis pipeline |
| `Rep1_Data.csv` | ImageJ landmark coordinates, Replicate 1 |
| `Rep2_Data.csv` | ImageJ landmark coordinates, Replicate 2 |
| `FvFm_R.csv` | Chlorophyll fluorescence data |
| `Summary_Results_Table.txt` | Combined effects model output (FA ~ Fv/Fm × Position) |
| `FvFm_Position_ANOVA.txt` | One-way ANOVA: Fv/Fm by canopy position |
| `FvFm_Position_Summary.txt` | Fv/Fm means, SD, SE, and 95% CI by position |
| `FA_Position_Summary.txt` | FA means, SD, SE, and 95% CI by position |
| `Report_Final_Visuals.pdf` | Interaction plot and asymmetry shape components |
| `Final_Analysis_Plots.pdf` | Fv/Fm and FA by canopy position bar charts |

---

## How to Replicate This Analysis

### Requirements
- R (≥ 4.0)
- RStudio (recommended)
- The following R packages:
  - `geomorph`
  - `tidyverse`
  - `Hmisc`

Install packages if needed:
```r
install.packages(c("geomorph", "tidyverse", "Hmisc"))
```

### Steps
1. Download all files in this repository to the same local folder
2. Open `La_Palma_FA_vs_FvFm.R` in RStudio
3. Go to **Session > Set Working Directory > To Source File Location**
4. Click **Source** to run the complete analysis pipeline
5. All output files will be generated automatically in the same folder

---

## Data Collection Summary
- **Species:** *Ageratina adenophora* (Sprengel) King & Robinson
- **Sites:** 7 sites along Barranco de las Angustias (Sites 3, 5, 6, 8, 9, 10, 11)
- **Sample:** 10 plants, 30 leaves, 60 total observations (2 digitising replicates)
- **Canopy positions sampled:** Top, Middle, Bottom identified as a, b, and c respectively, for example, 2c would be Leaf 2, Bottom leaf
- **Dates:** 31st January – 2nd February 2026

---

## Contact
For queries regarding this repository, please contact:  
Divya Malhotra — divya.malhotra@student.manchester.ac.uk
