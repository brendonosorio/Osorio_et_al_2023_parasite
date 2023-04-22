## -----------------------------------------------------------------------------
##
## Script - Isotope analysis of whale sharks and host-specific parasites
##
##
## Code written by Brendon J. Osorio as part of:
## Parasites as biochemical tracers of foraging patterns and dietary shifts in
## whale sharks
##
## Brendon J. Osorio (1), Grzegorz Skrzypek (1), Mark Meekan (2)
##
## Affiliations:
## (1) Western Australian Biogeochemistry Centre, School of Biological Sciences
## The University of Western Australia, Perth 6009, Australia
## (2) Australian Institute of Marine Science, UWA Oceans Institute, Perth 6009,
## Australia
##
## Email (in author order):
## Brendon Osorio: brendon_osorio@outlook.com
## Grzegorz Skrzypek: g.skrzypek@uwa.edu.au
## Mark Meekan: m.meekan@aims.gov.au
##
## R version 4.0.5 (2021-03-31) -- "Shake and Throw"
## Copyright (C) 2021 The R Foundation for Statistical Computing
## Platform: x86_64-w64-mingw32/x64 (64-bit)
##
## -----------------------------------------------------------------------------

# Packages ---------------------------------------------------------------------
# All packages were handled using renv virtual environments. For help on renv
# installation see https://github.com/rstudio/renv.
# Using renv::restore() in the R terminal will restore the R version
# in a separate virtual environment to ensure that
# dependencies were at the versions which I used to code this file (and that it
# doesn't mess with your personal R library dependencies).
# All packages are found in the renv/ folder.

# If you wish to load R from a terminal CLI, use the below code in R:
# renv::load(/path/to/project)
# after the using renv::restore() which ensures that the working directory
# uses the renv package library

# Note that renv::restore() will install all the packages in the
# renv.lock file (at the specified version) in the virtual environment.
# To see version of packages see the renv.lock file.

# Create a vector of packages which I used in this script
used_packages <- c("scales", "SIBER", "ggplot2",
                   "MuMIn", "patchwork", "visreg", "bayestestR")

# Load the packages using lapply()
lapply(used_packages, library, character.only = TRUE)

# Load in the datasets ---------------------------------------------------------
isotopes <- read.csv("data/isotopes.csv", stringsAsFactors = TRUE)
treatment <- read.csv("data/acid_treatment_data.csv")

# For more information read about each dataset read the README.md file

# SECTION 0 - Comparing Acid Treatments ----------------------------------------
# Treatment procedures were compared by calculating the difference between acid
# and untreated (acid - untreated) and then compared to a null hypothesis of 0
# difference between treatments.

# First calculate acid - untreated differences
parasite_c_diff <- treatment$acid_para_d13c - treatment$ntreat_para_d13c # d13c
parasite_n_diff <- treatment$acid_para_d15n - treatment$ntreat_para_d15n # d15n
parasite_cn_diff <- treatment$acid_para_cn - treatment$ntreat_para_cn # C/N

# Report acid - untreated differences
mean(parasite_c_diff, na.rm = TRUE) # mean d13c
sd(parasite_c_diff, na.rm = TRUE) # SD d13c
mean(parasite_n_diff, na.rm = TRUE) # mean d15n
sd(parasite_n_diff, na.rm = TRUE) # SD d15n
mean(parasite_cn_diff, na.rm = TRUE) # mean CN ratio
sd(parasite_cn_diff, na.rm = TRUE) # SD CN ratio

# Note (na.rm = TRUE) -- some copepods had only one treatement, these copepods
# were removed from difference calculations.

# T test calculations
t.test(mu = 0, parasite_c_diff) # Compare d13c diff to H0 = 0
t.test(mu = 0, parasite_n_diff) # Compare d15n diff to H0 = 0
t.test(mu = 0, parasite_cn_diff) # Compare CN diff to H0 = 0

# As d13c was significantly lower than 0, this was carried on into the isotopes
# dataset as acid_para_d13c in the isotopes.csv file.

# Create dummy object for figure plotting using the diff values calculated above
treatment_dummy <- data.frame(
    carbon_diff = parasite_c_diff,
    nitrogen_diff = parasite_n_diff,
    cn_diff = parasite_cn_diff
)

# Supplementary Figure 1
supp_figure <- function() {
    # Create plot
    par(mar = c(5, 5, 4, 1) + 0.1, bty = "l", lwd = 2)
    # Boxplot of values
    boxplot(treatment_dummy[, c("carbon_diff", "nitrogen_diff", "cn_diff")],
            horizontal = TRUE,
            xlab = expression(paste(
                "Parasite" ["Acid"], " - Parasite" ["Untreated"]
            )),
            col = c("#8abad5", "#f9b683", "#ffc3dc"),
            names = c(
                expression(paste(delta ^ 13, "C")),
                expression(paste(delta ^ 15, "N")),
                "C/N Ratio"
            ),
            las = 1,
            outline = FALSE,
            ylim = c(-0.8, 0.8),
            lwd = 1,
            whisklty = 1
    )
    # Add points to the plot
    abline(v = 0, lty = 2, lwd = 0.5, col = "black")
    rug(x = seq(-1, 1, by = 0.1), ticksize = -0.018, side = 1)
    stripchart(treatment_dummy[, c("carbon_diff", "nitrogen_diff", "cn_diff")],
               col = c("#0072b2", "#fe7308", "#b23168"),
               add = TRUE,
               method = "jitter",
               pch = 19
    )
}

supp_figure()

# Save image to file
# save_supp_figure <- function() {
#     png(filename = "figures/supplementary_figure_1.png",
#         width = 20, height = 12, units = "cm", res = 800)
#     supp_figure()
#     dev.off()
# }
# save_supp_figure()

# SECTION 1 - Distributions of isotope values ----------------------------------

# Read in the isotope values from the supplementary materials
isotopes <- read.csv("Data/isotopes.csv")

# This section is dedicated to Figure 2 showing the distribution of d13c and
# d15n values. This is shown in the function below:
isotope_distribution <- function() {
    # Set plotting values
    par(
        bty = "l",
        lwd = 2,
        mar = c(4, 4, 1, 1)
    )
    # Add points
    plot(
        host_d15n ~ host_d13c,
        data = isotopes,
        xlim = c(-18.5, -14),
        ylim = c(6, 11),
        col = alpha("#fe7308", 0.5),
        ylab = "",
        xlab = "",
        pch = 16,
        cex = 1.1,
        cex.axis = 1.2
    )
    title(
        ylab = expression(paste(delta ^ 15, "N (\u2030)")),
        xlab = expression(paste(delta ^ 13, "C (\u2030)")),
        line = 2.4,
        cex.lab = 1.3
    )
    # Add uncorrected 13C values
    points(
        para_d15n ~ para_d13c, data = isotopes,
        pch = 17,
        col = alpha("#3766c5", 0.5),
        cex = 1.2
    )
    # Whale shark  -------------------------------------------------
    # Nitrogen variance host derm
    segments(
        y0 = mean(isotopes$host_d15n) - sd(isotopes$host_d15n), # Host N
        y1 = mean(isotopes$host_d15n) + sd(isotopes$host_d15n),
        x0 = mean(isotopes$host_d13c), # Host C
        x1 = mean(isotopes$host_d13c),
        lwd = 2, col = "#fe7308"
    )
    # Carbon variance host
    segments(
        x0 = mean(isotopes$host_d13c) - sd(isotopes$host_d13c),
        x1 = mean(isotopes$host_d13c) + sd(isotopes$host_d13c),
        y1 = mean(isotopes$host_d15n),
        y0 = mean(isotopes$host_d15n),
        lwd = 2, col = "#fe7308"
    )
    # Add mean host dermal values
    points(
        x = mean(isotopes$host_d13c),
        y = mean(isotopes$host_d15n),
        pch = 16,
        col = "#fe7308",
        cex = 2
    )
    # Nitrogen variance host blood
    # Note: standard deviation is equal for host blood and dermal tissues
    segments(
        y0 = (mean(isotopes$host_d15n) - 1.5) - sd(isotopes$host_d15n),
        y1 = (mean(isotopes$host_d15n) - 1.5) + sd(isotopes$host_d15n),
        x0 = (mean(isotopes$host_d13c) - 0.9), # Host C
        x1 = (mean(isotopes$host_d13c) - 0.9),
        lwd = 2, col = "#009e73"
    )
    # Carbon variance host
    segments(
        x0 = (mean(isotopes$host_d13c) - 0.9) - sd(isotopes$host_d13c),
        x1 = (mean(isotopes$host_d13c) - 0.9) + sd(isotopes$host_d13c),
        y1 = (mean(isotopes$host_d15n) - 1.5),
        y0 = (mean(isotopes$host_d15n) - 1.5),
        lwd = 2, col = "#009e73"
    )
    # Add mean host blood
    points(
        x = (mean(isotopes$host_d13c) - 0.9),
        y = (mean(isotopes$host_d15n) - 1.5),
        pch = 18,
        col = "#009e73",
        cex = 2.5
    )

    # Copepod -------------------------------------------------------
    # Untreated copepod values
    # Nitrogen
    segments(
        y0 = mean(isotopes$para_d15n) - sd(isotopes$para_d15n), # Host N
        y1 = mean(isotopes$para_d15n) + sd(isotopes$para_d15n),
        x0 = mean(isotopes$para_d13c), # Host C
        x1 = mean(isotopes$para_d13c),
        lwd = 2, col = "#3766c5"
    )
    # Carbon variance copepod untr
    segments(
        x0 = mean(isotopes$para_d13c) - sd(isotopes$para_d13c),
        x1 = mean(isotopes$para_d13c) + sd(isotopes$para_d13c),
        y1 = mean(isotopes$para_d15n),
        y0 = mean(isotopes$para_d15n),
        lwd = 2, col = "#3766c5"
    )
    # Add parasite untreated points
    points(
        x = mean(isotopes$para_d13c),
        y = mean(isotopes$para_d15n),
        pch = 17,
        col = "#3766c5",
        cex = 2
    )
    # Parasites acidified treatment
    segments(
        y0 = mean(isotopes$para_d15n) - sd(isotopes$para_d15n),
        y1 = mean(isotopes$para_d15n) + sd(isotopes$para_d15n),
        x0 = (mean(isotopes$para_d13c) - 0.3), # Host C
        x1 = (mean(isotopes$para_d13c) - 0.3),
        lwd = 2, col = "#a054be"
    )
    # Carbon variance copepod untr
    segments(
        x0 = (mean(isotopes$para_d13c) - 0.3) - sd(isotopes$para_d13c),
        x1 = (mean(isotopes$para_d13c) - 0.3) + sd(isotopes$para_d13c),
        y1 = mean(isotopes$para_d15n),
        y0 = mean(isotopes$para_d15n),
        lwd = 2, col = "#a054be"
    )
    # Add mean parasite acidified values
    points(
        x = (mean(isotopes$para_d13c) - 0.3),
        y = mean(isotopes$para_d15n),
        pch = 15,
        col = "#a054be",
        cex = 2
    )
    # NOTE: The inclusion of the -0.3 value, this is obtained from SECTION 0,
    # showing that d13c in acidified treatments are lower by -0.3 than untreated
    # samples, this change is reflected here.

    # Add legend
    legend(
        "bottomleft",
        inset = 0.02,
        legend = c(
            expression("Host"["Derm"]),
            expression("Host"["Blood"]),
            expression("Parasite"["Acid"]),
            expression("Parasite"["Untrt"])
        ),
        # Set point shapes and colours for each group
        pch = c(16, 18, 15, 17),
        col = c(
            alpha("#fe7308", 1),
            alpha("#009e73", 1),
            alpha("#a054be", 1),
            alpha("#3766c5", 1)
        ),
        lwd = 2,
        lty = 1,
        ncol = 1,
        box.lwd = 1,
        cex = 1.4
    )
}
isotope_distribution()

# Save isotope distribution plot
# save_isotope_plot <- function() {
#     png("figures/figure_2.png",
#         units = "in", width = 10, height = 7, res = 1000)
#     isotope_distribution()
#     dev.off()
# }
# save_isotope_plot()

# SECTION 2 - Parasite Host Correlation ----------------------------------------
# This section calculates the main correlation between the copepod isotope and
# whale shark dermal tissue isotope values. This uses the same isotope.csv
# dataset as above:

# Set set better level naming
levels(isotopes$Sex) <- c("Female", "Male")

# Create linear models comparing copepods and shark isotope values
# Nitrogen model - base model no interaction
nitrogen_lm_1 <- lm(host_d15n ~ para_d15n, data = isotopes)
summary(nitrogen_lm_1) # t-test values
anova(nitrogen_lm_1) # f values
AIC(nitrogen_lm_1) # Calculation of AIC

# Nitrogen model - add Sex as interaction
nitrogen_lm_2 <- lm(host_d15n ~ para_d15n * Sex, data = isotopes)
summary(nitrogen_lm_2)
anova(nitrogen_lm_2)
AIC(nitrogen_lm_2)

# Nitrogen model add Sex no interaction effect
nitrogen_lm_3 <- lm(host_d15n ~ para_d15n + Sex, data = isotopes)
summary(nitrogen_lm_3)
anova(nitrogen_lm_3)
AIC(nitrogen_lm_3)

# Carbon model - base model, no interaction
carbon_lm_1 <- lm(host_d13c ~ para_acid_d13c, data = isotopes)
summary(carbon_lm_1) # t-test values
anova(carbon_lm_1) # f values
AIC(carbon_lm_1) # Calculation of AIC

# Carbon model - add Sex as interaction
carbon_lm_2 <- lm(host_d13c ~ para_acid_d13c * Sex, data = isotopes)
summary(carbon_lm_2) # t-test values
anova(carbon_lm_2) # f values
AIC(carbon_lm_2) # Calculation of AIC

# Carbon model - add sex, no interaction
carbon_lm_3 <- lm(host_d13c ~ para_acid_d13c + Sex, data = isotopes)
summary(carbon_lm_3) # t-test values
anova(carbon_lm_3) # f values
AIC(carbon_lm_3) # Calculation of AIC

# The simplest models for both nitrogen and carbon had the best AIC.
# These were kept in the report and plotted for figure 3.

# Create 95% confidence intervals for plotting
# Define x-values for confidence values (nitrogen)
nitrogen_data <- with(
    isotopes,
    seq(min(para_d15n), max(para_d15n), by = 0.01
    ))
# Confidence intervals - nitrogen y-values
conf_int_n <- predict(
    nitrogen_lm_1, # Simplest model
    newdata = list(para_d15n = nitrogen_data),
    interval = "confidence",
    level = 0.95
)

# Define x-values for confidence values (carbon)
carbon_data <- with(
    isotopes,
    seq(min(para_acid_d13c), max(para_acid_d13c), by = 0.01
    ))
# Confidence intervals - carbon
conf_int_c <- predict(
    carbon_lm_1,
    newdata = list(para_acid_d13c = carbon_data),
    interval = "confidence",
    level = 0.95
)

# Create vectors for male and female sexes
sex_factors <- as.numeric(as.factor(isotopes$Sex)) # Female 1 and male 2
sex_factors

# Plot figure 3
cop_shark_correlation <- function() {
    # Set colour palette
    c_pal <- c(alpha("#0072b2", alpha = 0.8), alpha("#fe7207", 0.8))
    palette(c_pal)
    # Set layout of plot
    layout_matrix <- matrix(c(1, 2), nrow = 1, ncol = 2)
    layout(mat = layout_matrix, heights = c(2, 2), widths = c(2, 2))
    # Set plot options
    par(bty = "l", lwd = 2, mar = c(4, 4.2, 2.2, 1))

    # Carbon plot ---------------------------------------------------
    # Start with empty plot
    plot(host_d13c ~ para_acid_d13c, data = isotopes,
         type = "n", xlab = "", ylab = "", cex.axis = 1.2)
    # Add regression line
    abline(carbon_lm_1, col = "black", lwd = 2, lty = 1)
    # Add confidence intervals
    matlines(x = carbon_data, y = conf_int_c[, 2:3], lty = 2, lwd = 1,
             col = "black")
    # Add points to plot
    points(host_d13c ~ para_acid_d13c, data = isotopes, xlab = "", ylab = "",
           pch = 15 + sex_factors, col = sex_factors, cex = 1.5)
    # Add x and y labs
    title(xlab = expression(paste("Parasite" ~ delta ^ 13, "C (\u2030)")),
          ylab = expression(paste("Host " ~ delta ^ 13, "C (\u2030)")),
          line = 2.5, cex.lab = 1.3)
    # Add legend
    legend("topleft", legend = c("Female", "Male"),
           pch = 15 + 1:nlevels(isotopes$Sex), col = 1:nlevels(isotopes$Sex),
           cex = 1.2, inset = 0.02, box.lwd = 1)
    # Add subfigure text
    mtext("A", side = 3, adj = 0.0, line = 1, cex = 1.5)
    # Include equation
    legend("bottomright", legend = c(
        "y = 0.38x - 8.90", expression("R"^2 ~ "= 0.12, p < 0.001")),
        bty = "n", box.lty = 0, bg = "transparent")

    # Nitrogen Plot -------------------------------------------------
    # Start empty plot
    plot(host_d15n ~ para_d15n, data = isotopes, type = "n",
         xlab = "", ylab = "", cex.axis = 1.2)
    # Add regression line
    abline(nitrogen_lm_1, col = "black", lwd = 2, lty = 1)
    # Add confidence intervals
    matlines(x = nitrogen_data, y = conf_int_n[, 2:3], lty = 2, lwd = 1,
             col = "black")
    # Add points
    points(host_d15n ~ para_d15n, data = isotopes, xlab = "", ylab = "",
           pch = 15 + sex_factors, col = sex_factors, cex = 1.5)
    # Add x and y lab
    title(xlab = expression(paste("Parasite" ~ delta ^ 15, "N (\u2030)")),
          ylab = expression(paste("Host " ~ delta ^ 15, "N (\u2030)")),
          line = 2.5, cex.lab = 1.3)
    # Add legend
    legend("topleft", legend = c("Female", "Male"),
           pch = 15 + 1:nlevels(isotopes$Sex), col = 1:nlevels(isotopes$Sex),
           cex = 1.2, inset = 0.02, box.lwd = 1)
    # Add subfigure text
    mtext("B", side = 3, adj = 0.0, line = 1, cex = 1.5)
    # Add regression model diagnostics
    legend("bottomright", legend = c(
        "y = 0.81x + 1.07", expression("R" ^ 2 ~ "= 0.49, p < 0.001")),
        bty = "n", box.lty = 0, bg = "transparent")
    # Reset to defaults
    par(mfrow = c(1, 1))
}

cop_shark_correlation()

# Save figure
# figure_3_png <- function() {
#      png(filename = "figures/figure_3.png",
#         width = 10, height = 6,
#         units = "in",
#         res = 900)
#     cop_shark_correlation()
#     dev.off()
# }
#
# figure_3_png()

# SECTION 3 - Trophic Discrimination Factors -----------------------------------
# This section calculates the trophic discrimination factors (TDF) between
# P. rhincodonicus and whale shark host values.

# First calculate whale shark host blood isotope values for TDF calculations.

# Host blood isotopes on average -1.5 lower 15n and -0.9 lower 13c
# See Wyatt et al., (2019) table 6 - doi: https://doi.org/10.1002/ecm.1339

# Nitrogen - comparing parasite v blood  (raw) values
cop_shark_15n_diff <- isotopes$para_d15n - (isotopes$host_d15n - 1.5)
mean(cop_shark_15n_diff) # In report
sd(cop_shark_15n_diff) # In report

# Carbon - comparing parasite (acid corrected) v blood (raw) values
cop_shark_13c_diff <- (isotopes$para_d13c - 0.3) - (isotopes$host_d13c - 0.9)
mean(cop_shark_13c_diff) # In report
sd(cop_shark_13c_diff) # In report

# Compare against the hypothesised +3.4 d15n and +1 d13c values.
t.test(cop_shark_15n_diff, mu = 3.4) # Nitrogen
t.test(cop_shark_13c_diff, mu = 1) # Carbon

# Assess TDF scaling which was observed from Thieltges et al. 2019
# This is done using a simple correlation between TDF and host isotopic values.
# Compare the cop-shark diffs to host isotopic blood estimated values

# Host blood estimated values are:
blood_13c <- isotopes$host_d13c - 0.9 # Blood carbon values
blood_15n <- isotopes$host_d15n - 1.5 # Blood nitrogen values

# Check for negative scaling of TDF with host isotope values:
# Calculate scaling tdf for carbon
tdf_c_scaling <- lm(cop_shark_13c_diff ~ blood_13c)
summary(tdf_c_scaling) # Values in report

# Calculate scaling tdf for nitrogen
tdf_n_scaling <- lm(cop_shark_15n_diff ~ blood_15n)
summary(tdf_n_scaling) # Values in report

# As we will be plotting the linear regression for TDF scaling, calculate the
# 95% confidence interval for the linear regressions above:

# Carbon
# Create x values for confidence intervals
new_data_c_bl <- with(
    isotopes, seq(min(host_d13c - 0.9), max(host_d13c - 0.9), by = 0.01))

# Confidence intervals for scaling TDF predictions
conf_int_c_bl <- predict(tdf_c_scaling,
                         newdata = list(blood_13c = new_data_c_bl),
                         interval = "confidence",
                         level = 0.95)
conf_int_c_bl

# Nitrogen
# Create x values for confidence intervals
new_data_n_bl <- with(isotopes,
                      seq(min(host_d15n - 1.5), max(host_d15n - 1.5), by = 0.01))

# Confidence intervals for scaling TDF predictions
conf_int_n_bl <- predict(tdf_n_scaling,
                         newdata = list(blood_15n = new_data_n_bl),
                         interval = "confidence",
                         level = 0.95)
conf_int_n_bl

# Calculate the TDF values adjusted for negative correlation from above:
# Carbon
blood_13c_adj <- predict(tdf_c_scaling, newdata = data.frame(blood_13c))
# Nitrogen
blood_15n_adj <- predict(tdf_n_scaling, newdata = data.frame(blood_15n))

mean(blood_13c_adj) # In report
sd(blood_13c_adj) # In report

mean(blood_15n_adj) # In report
sd(blood_15n_adj) # In report

# Compare against the +1 and +3.4 hypothesised values from Minagwawa
t.test(mu = 1, blood_13c_adj) # Carbon
t.test(mu = 3.4, blood_15n_adj) # Nitrogen

# Now create correlation plots between TDF and host isotope values
tdf_scaling <- function() {
    # Set plot size etc
    par(bty = "l", lwd = 2, mar = c(3.5, 4.5, 2.5, 1),cex.axis = 1.2)

    # Carbon values
    plot(cop_shark_13c_diff ~ blood_13c, xlab = "", ylab = "", pch = 19,
         col = alpha("#8abad5", alpha = 0.9), cex = 1.2)
    # Add x and y labels
    title(xlab = expression(paste(delta ^ 13, "C"["Bl"] ~ "(\u2030)")),
          ylab = expression(paste(Delta ^ 13, "C"["P-Bl"] ~ "(\u2030)")),
          line = 2.6, cex.lab = 1.4)
    # Add prediction lines
    abline(tdf_c_scaling, col = "black")
    # Add confidence interval
    matlines(x = new_data_c_bl, y = conf_int_c_bl[, 2:3], lty = 2, lwd = 1,
             col = "black")
    # Add regression text
    legend(-17.32, -1.78, legend = c(
        "y = -0.64(x) - 11.36", expression(paste("R"^2, " = 0.33, p < 0.001"))),
        bty = "n", cex = 1.1)
    mtext("A", side = 3, adj = 0.0, line = 1, cex = 1.5)

    # Nitrogen plot
    plot(cop_shark_15n_diff ~ blood_15n, xlab = "", ylab = "", pch = 19,
         col = alpha("#3ea96a", alpha = 0.4), cex = 1.2)
    # Add x and y labels
    title(xlab = expression(paste(delta ^ 15, "N"["Bl"] ~ "(\u2030)")),
          ylab = expression(paste(Delta ^ 15, "N"["P-Bl"] ~ "(\u2030)")),
          line = 2.4, cex.main = 1.1, cex.lab = 1.4)
    # Add prediction line
    abline(tdf_n_scaling, col = "black")
    # Add confidence interval lines
    matlines(x = new_data_n_bl, y = conf_int_n_bl[, 2:3], lty = 2, lwd = 1,
             col = "black")
    # Add regression text
    legend(4.3, 1, legend = c("y = -0.38(x) + 4.98",
                              expression(paste("R"^2, " = 0.26, p < 0.001 "))),
           bty = "n", cex = 1.1)
    mtext("B", side = 3, adj = 0.0, line = 1, cex = 1.5)
}
tdf_scaling()

# Plot the Trophic discriminiation factors against the hypothesised values
cop_shark_diff_plot <- function() {
    # Plot the scaling tdf plots
    par(bty = "l", lwd = 2, mar = c(5, 7, 3, 1))
    boxplot(list(
        cop_shark_13c_diff, blood_13c_adj, cop_shark_15n_diff, blood_15n_adj),
        ylim = c(-3.1, 3.7),
        xlab = (expression("Parasite - Host"["Blood"] ~ "(\u2030)")),
        horizontal = TRUE, col = c("#8abad5", "#8abad5", "#8ae4ab", "#8ae4ab"),
        names = c(
            expression(paste(Delta ^ 13, "C"["P-Bl(raw)"])),
            expression(paste(Delta ^ 13, "C"["P-Bl(adj)"])),
            expression(paste(Delta ^ 15, "N"["P-Bl(raw)"])),
            expression(paste(Delta ^ 15, "N"["P-Bl(adj)"]))),
        las = 1, lwd = 1, outline = FALSE, whisklty = 1, cex.lab = 1.4,
        cex.axis = 1.4)
    abline(v = 0, lty = 2, lwd = 1, col = "black")
    stripchart(list(
        cop_shark_13c_diff, blood_13c_adj, cop_shark_15n_diff, blood_15n_adj),
        add = TRUE, method = "jitter", pch = 19, cex = 1,
        col = c(alpha("#0072b2", alpha = 0.4),
                alpha("#0072b2", alpha = 0.4),
                alpha("#3ea96a", alpha = 0.4),
                alpha("#3ea96a", alpha = 0.4)))
    mtext("C", side = 3, adj = 0.0, line = 1, cex = 1.5)
    # Add hypothesis lines
    segments(x0 = 1, y0 = 2.4, y1 = 0.9, col = "royalblue3", lty = 4)
    segments(x0 = 3.4, y0 = 2.6, y1 = 4.6, col = "seagreen", lty = 3)
    # Add text for hypothesis values
    text(x = 3.3, y = 2.3,
         label = expression(paste("H"["0"] ~ Delta ^ 15, "N"["P-Bl"])),
         col = "seagreen", cex = 1.4)
    text(x = 1, y = 0.6,
         label = expression(paste("H"["0"] ~ Delta ^ 13, "C"["P-Bl"])),
         col = "royalblue3", cex = 1.4)
}
cop_shark_diff_plot()

# Collate previous plots into the layout for figure 4
plot_tdf_all <- function() {
    # Define layout of final plot
    layout_matrix <- matrix(c(1, 3, 2, 3), nrow = 2, ncol = 2)
    layout(mat = layout_matrix)
    # Plot subfigures A and B
    tdf_scaling()
    # Plot subfigure C
    cop_shark_diff_plot()
}
plot_tdf_all()

# Save this as a png
# figure_4 <- function() {
#     png("figures/figure_4.png", width = 10, height = 8,
#         res = 1000, units = "in")
#     plot_tdf_all()
#     dev.off()
# }
#
# figure_4()

# SECTION 4 - Drivers of whale shark isotope values ----------------------------
# This section attempts to determine the drivers of whale shark d13c and d15n
# isotope values.

# Set factors as levels
isotopes$Year <- as.factor(isotopes$Year)
levels(isotopes$Sex) <- c("Female", "Male")

## Dredge variables on full interaction models ---------------------------------
### Whale shark dermal nitrogen values -----------------------------------------
# Create model with full interactions - whale shark nitrogen values
lm_n_full <- lm(host_d15n ~ length_est * Sex * Year, data = isotopes,
                na.action = "na.fail")
summary(lm_n_full)

# Full model accounts for around 66% of variance in whale shark derm d15n.

# Apply MuMIn dredge to dermal nitrogen values
dredge_model_sel_15n_a <- dredge(lm_n_full,
                                 rank = "AICc", # Output orders by AICc
                                 extra = c("R^2", BIC) # Output provide R2 and BIC
)
# Show all run models
print(dredge_model_sel_15n_a) # Models with >10% weight in AICc are reported.

# To calculate weights for BIC
dredge_model_sel_15n_b <- dredge(lm_n_full,
                                 rank = "BIC" # Output orders by BIC
)
print(dredge_model_sel_15n_b) # Presented in Table 3, as wBIC etc.

### Whale shark dermal carbon values -------------------------------------------
# Create a model with full interactions
lm_c_full <- lm(host_d13c ~ length_est * Sex * Year, data = isotopes,
                na.action = "na.fail")

# Apply MuMIn dredge to dermal nitrogen values
dredge_model_sel_13c_a <- dredge(lm_c_full,
                                 rank = "AICc", # Output orders by AICc
                                 extra = c("R^2", BIC) # Output provide R2 and BIC
)
# Show all run models
print(dredge_model_sel_13c_a) # Models with >10% weight in AICc are reported.

# To calculate weights for BIC
dredge_model_sel_13c_b <- dredge(lm_c_full,
                                 rank = "BIC" # Output orders by BIC
)
print(dredge_model_sel_13c_b) # Presented in Table 3, as wBIC etc.

## Produce plots on best models ------------------------------------------------
# This is used to produce partial dependence plots, it is important to note that
# values shown in each plot are not raw data points but partial residuals.

# For details see:
# http://pbreheny.github.io/visreg/
# https://cloud.r-project.org/web/packages/visreg/index.html

# Best carbon model
AICc_c_model <- lm(host_d13c ~ length_est + Sex + Year, data = isotopes)
summary(AICc_c_model) # t-test on model
anova(AICc_c_model) # F test on model

# Plot the model using visreg
visreg_aicc_c <- visreg(AICc_c_model, "length_est",
                        overlay = TRUE, partial = FALSE, rug = FALSE,
                        plot = FALSE)
visreg_aicc_c$res$sex <- isotopes$Sex # Add sex levels for plotting functions

### Whale shark length and dermal 13C values -----------------------------------
shark_d13c_length <- ggplot() +
    # Add confidence intervals
    geom_ribbon(data = visreg_aicc_c$fit,
                aes(ymin = visregLwr, ymax = visregUpr, x = length_est),
                alpha = 0.1, linetype = 1, size = 0.2) +
    # Add regression line
    geom_line(data = visreg_aicc_c$fit, aes(x = length_est, y = visregFit),
              col = "black", lty = 1, size = 0.9) +
    # Add points
    geom_point(data = visreg_aicc_c$res,
               aes(x = length_est, y = visregRes, col = sex, pch = sex),
               size = 3) +
    # Set colours
    scale_color_manual(values = c(alpha("#0072b2", 1), alpha("#fe7308", 1)),
                       labels = c("Female", "Male")) +
    scale_shape_discrete(labels = c("Female", "Male")) +
    # Change theme to be consistent
    theme_classic() +
    # Alter themes
    theme(axis.line = element_line(size = 0.8, color = "black"),
          legend.position = "top",
          legend.title = element_blank(),
          legend.margin = margin(0.5),
          axis.text = element_text(size = 13),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 16)) +
    labs(x = "Shark Length (m)",
         y = expression(paste(delta ^ 13, "C (\u2030)")),
         title = "A")
shark_d13c_length

### Whale shark dermal 13c and year --------------------------------------------
visreg_aicc_c_year <- visreg(AICc_c_model, "Year",
                             overlay = TRUE, partial = TRUE,
                             rug = FALSE, plot = FALSE)
visreg_aicc_c_year

# Plot partial values
shark_d13c_year <- ggplot() +
    # Create boxplot manually using visreg values
    geom_boxplot(data = visreg_aicc_c_year$fit, stat = "identity", aes(
        lower = visregLwr, upper = visregUpr,
        ymin = visregLwr, ymax = visregUpr,
        middle = visregFit, col = Year, x = Year,
        fill = Year), alpha = 0.1) +
    # Add points to boxplots
    geom_jitter(data = visreg_aicc_c_year$res,
                aes(x = Year, y = visregRes, col = Year), size = 3) +
    # Manually define scale colours
    scale_color_manual(values = c(
        "#E69F00", "#56B4E9", "#009E73",
        "#000000", "#D55E00", "#CC79A7")) +
    # Manually define colours
    scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73",
                                 "#000000", "#D55E00", "#CC79A7")) +
    # Adjust theme
    theme_classic() +
    # Make theme consistent
    theme(axis.line = element_line(size = 0.8, color = "black"),
          legend.position = "none",
          legend.title = element_blank(),
          axis.text = element_text(size = 13),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 16)) +
    labs(x = "Year", y = expression(paste(delta ^ 13, "C (\u2030)")),
         title = "B")
shark_d13c_year

### Whale shark dermal 13c and sex----------------------------------------------
visreg_aicc_c_sex <- visreg(AICc_c_model, "Sex",
                            overlay = TRUE, partial = FALSE,
                            rug = FALSE, plot = FALSE)

# Create partial plot
shark_d13c_sex <- ggplot() +
    # Create boxplot for values
    geom_boxplot(data = visreg_aicc_c_sex$fit, stat = "identity", aes(
        lower = visregLwr, upper = visregUpr,
        ymin = visregLwr, ymax = visregUpr,
        middle = visregFit, col = Sex, x = Sex,
        fill = Sex), alpha = 0.1) +
    # Set points in plot
    geom_jitter(data = visreg_aicc_c_sex$res,
                aes(x = Sex, y = visregRes, col = Sex, pch = Sex), size = 3) +
    scale_color_manual(values = c("#0072b2", "#fe7308"),
                       labels = c("Female", "Male")) +
    scale_fill_manual(values = c("#0683c9", "#e89556"),
                      labels = c("Female", "Male")) +
    theme_classic() +
    theme(axis.line = element_line(size = 0.8, color = "black"),
          legend.position = "none",
          legend.title = element_blank(),
          axis.text = element_text(size = 13),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 16)) +
    guides(col = guide_legend(ncol = 2)) +
    labs(x = "Sex", y = expression(paste(delta ^ 13, "C (\u2030)")),
         title = "C") +
    scale_x_discrete(labels = c("Female", "Male"))
shark_d13c_sex

## Best Nitrogen Model ---------------------------------------------------------
# Create model - based on BIC, same as AICc
bic_n_model <- lm(host_d15n ~ length_est + Year, data = isotopes)
summary(bic_n_model)
anova(bic_n_model)

### Nitrogen by length ---------------------------------------------------------
# Create visreg plot
visreg_n_length <- visreg(bic_n_model, "length_est",
                          partial = FALSE, rug = FALSE, plot = FALSE)
visreg_n_length$res$sex <- isotopes$Sex

# Plot values
n_length_plot <- ggplot() +
    # Confidence intervals
    geom_ribbon(data = visreg_n_length$fit,
                aes(ymin = visregLwr, ymax = visregUpr, x = length_est),
                alpha = 0.1, linetype = 1, size = 0.2) +
    geom_line(data = visreg_n_length$fit,
              aes(x = length_est, y = visregFit),
              col = "black", lty = 1, size = 0.9) +
    geom_point(data = visreg_n_length$res,
               aes(x = length_est, y = visregRes, col = sex, pch = sex),
               size = 3) +
    scale_color_manual(values = c("#0072b2", "#fe7308")) +
    theme_classic() +
    theme(axis.line = element_line(size = 0.8, color = "black"),
          legend.position = "none",
          legend.title = element_blank(),
          axis.text = element_text(size = 13),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 16)) +
    labs(x = "Shark Length (m)",
         y = expression(paste(delta ^ 15, "N (\u2030)")),
         title = "D")
n_length_plot

### Nitrogen and year ----------------------------------------------------------
visreg_n_year <- visreg(bic_n_model, "Year",
                        partial = FALSE, rug = FALSE, plot = FALSE)

n_year <- ggplot() +
    geom_boxplot(data = visreg_n_year$fit, stat = "identity",
                 aes(lower = visregLwr, upper = visregUpr,
                     ymin = visregLwr, ymax = visregUpr,
                     middle = visregFit, col = Year, x = Year,
                     fill = Year), alpha = 0.1) +
    geom_jitter(data = visreg_n_year$res,
                aes(x = Year, y = visregRes, col = Year),
                size = 3) +
    scale_color_manual(values = c(
        "#E69F00", "#56B4E9", "#009E73",
        "#000000", "#D55E00", "#CC79A7")) +
    scale_fill_manual(values = c(
        "#E69F00", "#56B4E9", "#009E73",
        "#000000", "#D55E00", "#CC79A7")) +
    theme_classic() +
    theme(axis.line = element_line(size = 0.8, color = "black"),
          legend.position = "none",
          legend.title = element_blank(),
          axis.text = element_text(size = 13),
          axis.title = element_text(size = 14),
          legend.text = element_text(size = 14),
          plot.title = element_text(size = 16)) +
    labs(x = "Year", y = expression(paste(delta ^ 15, "N (\u2030)")),
         title = "E")
n_year

# Roll carbon plots into one main figure
carbon_plots <- shark_d13c_length + shark_d13c_year + shark_d13c_sex +
    plot_layout(nrow = 3, ncol = 1)
carbon_plots

# Roll nitrogen plots into another figure
nitrogen_plots <- n_length_plot + n_year + plot_layout(nrow = 2, ncol = 1)
nitrogen_plots

# Main plot - keep them together
main_plot <- (carbon_plots | nitrogen_plots)
main_plot

# Save this as a png file for figure 5
# ggsave("figures/figure_5.png", main_plot, device = "png", width = 12,
#        height = 10, units = "in", dpi = 320)

# SECTION 5 - SIBER Analysis ---------------------------------------------------
# This section is dedicated to the Bayesian analysis estimating isotopic niche
# space and size across both male and female whale shark hosts and associated
# parasites.

# SIBER requires data to be within a set format:
# iso1 | iso2 | group | community

# which is defined as below:

# Create parasite data
parasite_data <- data.frame(
    iso1 = c(isotopes$para_acid_d13c),
    iso2 = c(isotopes$para_d15n),
    group = c(isotopes$Sex),
    community = c(rep(1, nrow(isotopes)))
)

whale_data <- data.frame(
    iso1 = c(isotopes$host_d13c),
    iso2 = c(isotopes$host_d15n),
    group = c(isotopes$Sex),
    community = c(rep(1, nrow(isotopes)))
)

# Create SIBER objects for both dataframes
parasite_siber <- createSiberObject(parasite_data)
whale_siber <- createSiberObject(whale_data)

# Set parameters for bayesian models (i.e., MCMC draws and burnin)
parms <- list()
parms$n.iter <- 2 * 10^4
parms$n.burnin <- 1 * 10^3
parms$n.thin <- 1 # NO thinning applied
parms$n.chains <- 2

# Define the priors - defines the Inverse Wishart distribution prior
priors <- list()
priors$R <- 1 * diag(2) # This is the scaling vector
priors$k <- 2
# The degrees of freedom, in bivariate case (i.e., 15n and 13c) is 2
priors$tau.mu <- 1.0E-3 # Precision on the normal prior

# Determine posterior estimates from parasite isotopes
parasite_posterior <- siberMVN(parasite_siber, parms, priors)
parasite_ellipses <- siberEllipses(parasite_posterior)

# As SIBER posteriors change with each draw, set values into a file to
# ensure that values remain consistent across draws.
# write.csv(
#     parasite_ellipses,
#     file = "data/mcmc_output/parasite_mcmc_draws.csv",
#     row.names = F,
# )

# Determine posterior estimates from whale shark isotopes
whale_posterior <- siberMVN(whale_siber, parms, priors)
whale_ellipses <- siberEllipses(whale_posterior)

# As SIBER posteriors change with each draw, set values into a file to
# ensure that values remain consistent across draws.
# write.csv(
#     whale_ellipses,
#     file = "data/mcmc_output/whale_mcmc_draws.csv",
#     row.names = FALSE
# )

# Read in set draws - whale sharks
whale_ellipses_set <- read.csv("data/mcmc_output/whale_mcmc_draws.csv",)

# Read set values
parasite_ellipses_set <- read.csv("data/mcmc_output/parasite_mcmc_draws.csv")

# Calculate median posterior SEAb estimates parasites
parasite_median_seab <- c(median(parasite_ellipses_set[, 1]), # Report
                          median(parasite_ellipses_set[, 2]))
print(parasite_median_seab)
hdi_parasite_female <- hdi(parasite_ellipses_set[, 1]) # Report
print(hdi_parasite_female)
hdi_parasite_male <- hdi(parasite_ellipses_set[, 2]) # Report
print(hdi_parasite_male)

# Calculate median posterior SEAb estimates whale sharks
whale_median_seab <- c(median(whale_ellipses_set[, 1]),
                       median(whale_ellipses_set[, 2]))
print(whale_median_seab)
hdi_whale_female <- hdi(whale_ellipses_set[, 1])
print(hdi_whale_female)
hdi_whale_male <- hdi(whale_ellipses_set[, 2])
print(hdi_whale_male)

# Calculate point estimates of isotopic niches
groupMetricsML(whale_siber)
groupMetricsML(parasite_siber)

## Create density graphs for SEAb estimates ------------------------------------
# Set colour palette (1 = female, 2 = male)
colour_palette <- c("#0072b2", "#fe7308")

# From parasite data
parasite_density_plot <- function() {
    par(bty = "L", mar = c(4, 4, 1, 2))
    # Female density
    plot(density(parasite_ellipses_set[, 1]),
         ylim = c(-0.3, 3.5), main = "",
         xlim = c(0.3, 2.5),
         col = colour_palette[1],
         xlab = expression(
             paste("Standard Ellipse Area (", "\u2030" ^ 2 ,")")),
         lwd = 2)
    points(y = -0.3, x = parasite_median_seab[1], pch = 19, cex = 1,
           col = colour_palette[1])
    segments(y1 = -0.3, y0 = -0.3, x0 = hdi_parasite_female[, 2],
             x1 = hdi_parasite_female[, 3], lwd = 3, col = colour_palette[1])
    # Male density
    lines(density(parasite_ellipses_set[, 2]),
          col = colour_palette[2], lwd = 2)
    points(y = -0.1, x = parasite_median_seab[2], pch = 19, cex = 1,
           col = colour_palette[2])
    segments(y1 = -0.1, y0 = -0.1, x0 = hdi_parasite_male[, 2],
             x1 = hdi_parasite_male[, 3], lwd = 3, col = colour_palette[2])
    legend("topright", legend = c("Female", "Male"),
           col = colour_palette, lty = 1, lwd = 2,
           cex = 0.8)
    text(x = 0.3, y = 3.5, labels = "D")
}
parasite_density_plot()

# Whale shark density points
whale_shark_density <- function() {
    par(bty = "L", mar = c(4, 4, 1, 2))
    # Female density
    plot(density(whale_ellipses_set[, 1]),
         ylim = c(-0.3, 3.5), main = "",
         xlim = c(0.3, 3.5),
         col = colour_palette[1],
         xlab = expression(
             paste("Standard Ellipse Area (", "\u2030" ^ 2 ,")")),
         lwd = 2)
    points(y = -0.3, x = whale_median_seab[1], pch = 19, cex = 1,
           col = colour_palette[1])
    segments(y1 = -0.3, y0 = -0.3, x0 = hdi_whale_female[, 2],
             x1 = hdi_whale_female[, 3], lwd = 3, col = colour_palette[1])
    # Male density
    lines(density(whale_ellipses_set[, 2]),
          col = colour_palette[2], lwd = 2)
    points(y = -0.1, x = whale_median_seab[2], pch = 19, cex = 1,
           col = colour_palette[2])
    segments(y1 = -0.1, y0 = -0.1, x0 = hdi_whale_male[, 2],
             x1 = hdi_whale_male[, 3], lwd = 3, col = colour_palette[2])
    legend("topright", legend = c("Female", "Male"),
           col = colour_palette, lty = 1, lwd = 2,
           cex = 0.8)
    text(x = 0.3, y = 3.5, labels = "B")
}
whale_shark_density()

## Create bivariate plots ------------------------------------------------------
# Create bivariate plot of isotope niche using maxlikelihood estimate (parasite)
parasite_plot <- function() {
    # Create base plot
    par(bty = "L", mar = c(4, 4, 1, 2))
    plot(isotopes$para_acid_d13c, isotopes$para_d15n,
        col = colour_palette[isotopes$Sex], xlab = "", ylab = "",
        xlim = c(-18.5, -14), ylim = c(5.5, 11), pch = c(19, 19))
    title(xlab = expression(paste(delta ^ {13}, "C (\u2030)")))
    title(ylab = expression(paste(delta ^ {15}, "N (\u2030)")), line = 2)
    legend("bottomright", legend = c("Female", "Male"), pch = c(19, 19),
           lty = c(1, 1), col = colour_palette, inset = 0.05,
           cex = 0.8)
    text(-18.5, 11, label = "C")
    # Add standard ellipse areas females
    coords <- addEllipse(
        parasite_siber$ML.mu[[1]][,, 1], parasite_siber$ML.cov[[1]][,, 1],
        m = 72, n = 100, ci.mean = FALSE, small.sample = TRUE,
        p.interval = 0.40, col = colour_palette[1], lty = 1, lwd = 1)
    # Add standard ellipse areas males
    coords <- addEllipse(
        parasite_siber$ML.mu[[1]][,, 2], parasite_siber$ML.cov[[1]][,, 2],
        m = 72, n = 100, ci.mean = FALSE, small.sample = TRUE,
        p.interval = 0.40, col = colour_palette[2], lty = 1, lwd = 1)
}
parasite_plot()

# Create bivariate plot of isotopic niche (whale shark)
whale_plot <- function() {
    par(bty = "L", mar = c(4, 4, 1, 2))
    plot(isotopes$host_d13c, isotopes$host_d15n,
        col = colour_palette[isotopes$Sex], xlab = "", ylab = "",
        xlim = c(-18.5, -14), ylim = c(5.5, 11), pch = c(19, 19))
    title(xlab = expression(paste(delta ^ {13}, "C (\u2030)")))
    title(ylab = expression(paste(delta ^ {15}, "N (\u2030)")), line = 2)
    legend("bottomleft", legend = c("Female", "Male"), pch = c(19, 19),
           lty = c(1, 1), col = colour_palette, inset = 0.05,
           cex = 0.8)
    text(-18.5, 11, label = "A")
    # Add standard ellipse areas females
    coords <- addEllipse(
        whale_siber$ML.mu[[1]][,, 1], whale_siber$ML.cov[[1]][,, 1],
        m = 72, n = 100, ci.mean = FALSE, small.sample = TRUE,
        p.interval = 0.40, col = colour_palette[1], lty = 1, lwd = 1)
    # Add standard ellipse areas males
    coords <- addEllipse(
        whale_siber$ML.mu[[1]][,, 2], whale_siber$ML.cov[[1]][,, 2],
        m = 72, n = 100, ci.mean = FALSE, small.sample = TRUE,
        p.interval = 0.40, col = colour_palette[2], lty = 1, lwd = 1)
}
whale_plot()

# Save isotopic niche areas and size plots
standard_ellipse_plot <- function() {
    par(mfrow = c(2, 2))
    whale_plot()
    whale_shark_density()
    parasite_plot()
    parasite_density_plot()
    par(mfrow = c(1,1))
}
standard_ellipse_plot()

# save this plot
figure_6 <- function() {
    png(filename = "figures/figure_6.png",
        width = 7, height = 7, unit = "in",
        res = 900)
    standard_ellipse_plot()
    dev.off()
}
figure_6()
# Plot was saved to pdf using 7 X 5.28 inches (width/height).

# Calculate SEA metrics
groupMetricsML(whale_siber)
groupMetricsML(parasite_siber)

## Calculate Bayesian overlap ---------------------------------------------------
# Calculate overlap - parasite first
# parasite_overlap <- bayesianOverlap(
#     "1.1", "1.2",
#     parasite_posterior,
#     draws = 1000,
#     p.interval = 0.4,
#     n = 100
# )

# write.csv(
#     parasite_overlap,
#     file = "data/mcmc_output/parasite_mf_draws.csv",
#     row.names = FALSE
# )

# whale_overlap <- bayesianOverlap(
#     "1.1", "1.2",
#     whale_posterior,
#     draws = 1000,
#     p.interval = 0.4,
#     n = 100
# )

#  write.csv(
#     whale_overlap,
#     file = "data/mcmc_output/whale_mf_draws.csv",
#     row.names = FALSE
# )

## Plotting isotope overlap -----------------------------------------------------
# Calculate overlap from mfdraws
whale_overlap_set <- read.csv(
    "data/mcmc_output/whale_mf_draws.csv"
)

# This calculates overlap of both ellipses over each other
hdi(whale_overlap_set$overlap / ((
    whale_overlap_set$area1 + whale_overlap_set$area2 -
        whale_overlap_set$overlap)) * 100)
median((whale_overlap_set$overlap / (
    whale_overlap_set$area1 + whale_overlap_set$area2 -
        whale_overlap_set$overlap)) * 100)

parasite_overlap_set <- read.csv(
    "data/mcmc_output/parasite_mf_draws.csv"
)

# This calculates overlap of both ellipses over each other
hdi((parasite_overlap_set$overlap / (
    parasite_overlap_set$area1 + parasite_overlap_set$area2 -
        parasite_overlap_set$overlap)) * 100)
median((parasite_overlap_set$overlap / (
    parasite_overlap_set$area1 + parasite_overlap_set$area2 -
        parasite_overlap_set$overlap)) * 100)

# -----------------------------  END -------------------------------------------
