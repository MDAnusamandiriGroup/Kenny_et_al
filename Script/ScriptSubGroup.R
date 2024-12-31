# Written by: Mila D Anasanti and Kenny Aldi
# all fedback send to: mila.mld@nusamandiri.ac.id

###############################
## Install and load packages ##
###############################
# Install Packages
# install.packages("meta")
# install.packages("metafor")
# install.packages("ggplot2")
# install.packages("patchwork")

# Set Working Directory
setwd("C:/Users/user1/Downloads/kenny")

# Load required Packages
library(meta)
library(metafor)
library(ggplot2)
library(patchwork)

######################
## Import Dataset   ##
######################

meta1 <- read.csv("Updated_Subgroup_Table.csv")

##################################
##      Start Meta-analysis      ##
##################################

# Calculate summary effect
m1 <- metacont(n.int,	mean.int,	sd.int,	n.con,	mean.con,	sd.con,	studlab=author, data = meta1, subset = NULL,
               exclude = NULL, sm = "SMD")
m1
# Visualize in Forest Plot
forest(mb1, overall = T, fontsize = 10, spacing = 0.7, 
       col.diamond = "blue", col.diamond.lines = "blue")

# Define subgroups and their corresponding variables
subgroups <- list(
  "Biomarker" = "sb.biomarker",
  "Intervention" = "sb.inter",
  "Duration" = "sb.duration",
  "Type Of IBD" = "sb.disease",
  "Age Group" = "sb.agegroup",
  "Disease Activity" = "sb.disactive",
  "Control Group" = "sb.controlgroup"
)

# Loop through each subgroup, perform analysis, print summary and save forest plots
  for (subgroup_name in names(subgroups)) {
    subgroup_var <- subgroups[[subgroup_name]]
    
    # Update meta-analysis for the subgroup
    mu <- update(m1, subgroup = get(subgroup_var), subgroup.name = subgroup_name, common = F)
    # Print summary for the subgroup
    cat("\nSummary for Subgroup:", subgroup_name, "\n")
    print(summary(mu))
    mb <- metabind(mu)
    
    # Define file name for saving
    file_name <- paste0("forest_plot_", subgroup_name, ".png")
    
    # Save the forest plot as PNG
    png(filename = file_name, width = 1500, height = 700, res = 150)
    forest(mb, 
           overall = T, 
           fontsize = 10, 
           spacing = 0.7, 
           col.diamond = "blue", 
           col.diamond.lines = "blue",
           col.subgroup = "black",  # Change subgroup titles to blue
           font.subgroup = 2,
           fontsize.subgroup = 15)      # Set subgroup titles to bold
    dev.off()
    
    # Print confirmation
    cat("Saved forest plot for", subgroup_name, "as", file_name, "\n")
  }

# Univariable Meta-Regression ------------------------------------------------
meta_reg_biomarker <- metareg(m1, ~ `sb.biomarker`)
meta_reg_intervention <- metareg(m1, ~ `sb.inter`)
meta_reg_duration <- metareg(m1, ~ `sb.duration`)
meta_reg_disease_type <- metareg(m1, ~ `Ssb.disease`)
meta_reg_age <- metareg(m1, ~ `sb.agegroup`)

# Print Univariable Results
print(meta_reg_biomarker)
print(meta_reg_intervention)
print(meta_reg_duration)
print(meta_reg_disease_type)
print(meta_reg_age)

# Multivariable Meta-Regression ----------------------------------------------
formula_str <- paste("`sb.biomarker`", 
                     "`sb.inter`", 
                     "`sb.duration`", 
                     "`sb.disease`", 
                     "`sb.agegroup`", 
                     sep = " + ")
meta_reg_multi <- metareg(m1, as.formula(paste("~", formula_str)))
summary(meta_reg_multi)


# Interaction Meta-Regression ------------------------------------------------
# Calculate effect size (Cohen's d) and standard error
meta1$TE <- (meta1$mean.int - meta1$mean.con) / 
  sqrt(((meta1$sd.int^2) * (meta1$n.int - 1) + (meta1$sd.con^2) * (meta1$n.con - 1)) / 
       (meta1$n.int + meta1$n.con - 2))

meta1$seTE <- sqrt((meta1$n.int + meta1$n.con) / 
                   (meta1$n.int * meta1$n.con) + 
                   (meta1$TE^2) / (2 * (meta1$n.int + meta1$n.con)))

# Check for missing values and clean the data
meta1 <- na.omit(meta1)

# Run meta-regressions for interactions
meta_reg_biomarker_duration <- rma(yi = TE, sei = seTE, mods = ~ `sb.biomarker` * `sb.duration`, data = meta1)
meta_reg_intervention_age <- rma(yi = TE, sei = seTE, mods = ~ `sb.inter` * `sb.agegroup`, data = meta1)
meta_reg_age_duration <- rma(yi = TE, sei = seTE, mods = ~ `sb.agegroup` * `sb.duration`, data = meta1)

# Print summaries
cat("Meta-Regression: Biomarker x Duration\n")
print(summary(meta_reg_biomarker_duration))

cat("\nMeta-Regression: Intervention Type x Age Group\n")
print(summary(meta_reg_intervention_age))

cat("\nMeta-Regression: Age Group x Duration\n")
print(summary(meta_reg_age_duration))

# Bubble Plots for Interaction Meta-Regression --------------------------------
create_bubble_plot <- function(meta_reg, title, xlab, ylab) {
  data <- data.frame(
    moderator = meta_reg$X[, 2], # First interaction term
    coefficient = meta_reg$yi,  # Observed outcomes
    size = 1 / meta_reg$vi      # Weights (inverse variance)
  )
  
  ggplot(data, aes(x = moderator, y = coefficient, size = size)) +
    geom_point(alpha = 0.6, color = "steelblue") +
    labs(title = title, x = xlab, y = ylab) +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"),
          axis.title = element_text(size = 10),
          legend.position = "none") +
    scale_size_continuous(range = c(2, 8))  # Adjust bubble sizes
}

# Generate bubble plots
plot1 <- create_bubble_plot(meta_reg_biomarker_duration,
                            "Biomarker × Duration Interaction",
                            "Biomarker Outcome and Duration",
                            "Standardized Mean Difference")
plot2 <- create_bubble_plot(meta_reg_intervention_age,
                            "Intervention × Age Interaction",
                            "Intervention Type and Age Group",
                            "Standardized Mean Difference")
plot3 <- create_bubble_plot(meta_reg_age_duration,
                            "Age × Duration Interaction",
                            "Age Group and Duration",
                            "Standardized Mean Difference")

# Combine bubble plots
combined_plot <- (plot1 / plot2 / plot3)

# Save the combined plot
ggsave("combined_interaction_plot.png", combined_plot, width = 14, height = 8)


# Publication Bias
# Funnel Plot and Egger's Test ----------------------------------------------
funnel(m1, common = F, level = 0.95)
egger_test <- metabias(m1, method = "linreg", k.min = 10)
print(egger_test)




