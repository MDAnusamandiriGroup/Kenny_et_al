# Meta-Analysis Project

Welcome to the **Meta-Analysis Project Repository**! This repository contains the dataset and R scripts used to perform meta-analyses on a collection of studies. The primary goal of this project is to calculate summary effect sizes, explore subgroup differences, and conduct meta-regressions to understand patterns within the data.

## Contents

- [Dataset](#dataset)
- [Scripts](#scripts)
- [Key Features](#key-features)
- [How to Use](#how-to-use)
- [Results Overview](#results-overview)
- [Acknowledgments](#acknowledgments)

---

## Dataset

### Description
The dataset, **`Updated_Subgroup_Table.csv`**, contains the following columns:

- `n.int`: Sample size for the intervention group.
- `mean.int`: Mean outcome for the intervention group.
- `sd.int`: Standard deviation of the intervention group.
- `n.con`: Sample size for the control group.
- `mean.con`: Mean outcome for the control group.
- `sd.con`: Standard deviation of the control group.
- `author`: Study identifier or author name.
- `sb.biomarker`: Biomarker subgroup classification.
- `sb.inter`: Type of intervention.
- `sb.duration`: Study duration.
- `sb.disease`: Disease type.
- `sb.agegroup`: Age group classification.
- `sb.disactive`: Disease activity.
- `sb.controlgroup`: Control group type.

### Purpose
The dataset is used to perform subgroup analysis and meta-regression to understand the effects of interventions across various subgroups and study characteristics.

---

## Scripts

The R script included in this repository performs the following tasks:

### 1. **Data Import and Preparation**
- Loads the dataset.
- Cleans and preprocesses data to ensure it is ready for analysis.

### 2. **Meta-Analysis**
- Uses the `meta` and `metafor` packages to calculate summary effect sizes.
- Generates forest plots for overall analysis and subgroups.

### 3. **Subgroup Analysis**
- Analyzes predefined subgroups based on variables like biomarker type, intervention, and age group.
- Saves subgroup-specific forest plots as PNG files.

### 4. **Meta-Regression**
- Conducts univariable and multivariable meta-regressions to identify relationships between study characteristics and effect sizes.
- Includes interaction meta-regression for deeper insights.

### 5. **Publication Bias Assessment**
- Generates funnel plots and performs Egger's test to assess potential publication bias.

---

## Key Features

- **Automated Forest Plot Generation**: Subgroup-specific forest plots are saved as high-resolution PNG files for easy sharing and publication.
- **Flexible Subgroup Analysis**: Subgroups can be customized through the script to fit your research questions.
- **Comprehensive Meta-Regression**: Both univariable and multivariable analyses included.
- **Interactive Bubble Plots**: Visualize interaction effects in meta-regression.

---

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/meta-analysis-project.git
   ```

2. Open the R project or R script file in your RStudio.

3. Install required packages (if not already installed):
   ```R
   install.packages("meta")
   install.packages("metafor")
   install.packages("ggplot2")
   install.packages("patchwork")
   ```

4. Set the working directory to the folder containing the dataset:
   ```R
   setwd("path/to/repository")
   ```

5. Run the script to perform the meta-analysis and generate plots.

---

## Results Overview

### Forest Plots
- Summary forest plot and subgroup-specific forest plots can be found in the `plots/` directory.

### Meta-Regression
- Univariable and multivariable regression results highlight key patterns across biomarkers, interventions, and other variables.

### Bubble Plots
- Interaction effects are visualized in `combined_interaction_plot.png` for easier interpretation.

---

## Acknowledgments

This project was developed by **Mila D. Anasanti** and **Kenny Aldi**. If you have any questions or suggestions, feel free to reach out to **mila.mld@nusamandiri.ac.id**.

---

Thank you for exploring this repository! We hope this resource is helpful for your research endeavors. Happy analyzing! 🚀
