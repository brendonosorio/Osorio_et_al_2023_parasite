# Parasitic copepods as biochemical tracers of foraging patterns and dietary shifts in whale sharks (*Rhincodon typus* Smith, 1828)

This repository contains the R scripts which were used for stable isotope analysis for the paper **"Parasitic copepods as biochemical tracers of foraging patterns and dietary shifts in whale sharks"**.
DOI - TBD.

## Author Information
Brendon J. Osorio (1), Grzegorz Skrzypek (1), Mark Meekan (2)

Affiliations:
* (1) - Western Australian Biogeochemistry Centre, School of Biological Sciences, The University of Western Australia, Perth 6009, Australia 
* (2) - Australian Institute of Marine Sciences, UWA Oceans Institute, Perth 6009, Australia

Author contact details:

*Brendon J. Osorio*
* Email: brendon_osorio@outlook.com
* ORCiD: 0000-0002-6803-7454

*Grzegorz Skrzypek*
* Email: g.skrzypek@uwa.edu.au
* ORCiD: 0000-0002-5686-2393

*Mark Meekan*
* Email: m.meekan@aims.gov.au
* ORCiD: 0000-0002-3067-9427

## Abstract

Understanding the diet of whale sharks (Rhincodon typus) is essential for the development of appropriate conservation strategies for the species. This study evaluated the use of the parasitic copepod (Pandarus rhincodonicus) as a proxy to infer short-term foraging habitats and trophic positions of whale shark hosts. To accomplish this, bulk stable carbon ($\delta^{13}C$) and nitrogen ($\delta^{15}N$) isotope compositions were analysed from 72 paired samples of whale shark skin (dermal) tissues and copepods collected across six years at the Ningaloo Reef aggregation site, Western Australia. This study found that $\delta^{15}N$ from parasites and whale shark hosts were strongly correlated. As turn-over times of the parasite and whale shark differ (months vs. years, respectively), the ability of copepods to predict δ15N values indicates that the trophic positions of whale sharks remain consistent across these timeframes. Contrastingly, $\delta^{13}C$ in the parasite and host were weakly correlated, likely reflecting differences in the physiology and lifecycle of the copepod parasite compared to the host. Our results suggest $\delta^{15}N$ from parasitic copepods provide a reliable proxy of the trophic position of their whale shark hosts, but interpretation of $\delta^{13}C$ values as a proxy for the host will require future studies on the lifecycle of P. rhincodonicus.

## Directions for use

To use this GitHub repository from the terminal interface, simply `git clone` this repository, `cd` into the repository folder  and use the `Rscript` function on the `script.R` file to run the full data analysis used for the paper.
Alternatively, if using `Rstudio` this GitHub repository can be added using: `File -> New Project -> Version Control -> Git` and then add [https://github.com/brendonosorio/Osorio_et_al_2023](https://github.com/brendonosorio/Osorio_et_al_2023) in the Repository URL.

**IMPORTANT**

Packages were managed using the [renv](https://rstudio.github.io/renv/index.html) project environment developed by Rstudio, and versions can be found in the `renv.lock` file. To ensure that your packages are consistent with those that I used to run this code in your `R` terminal:

```
# If renv is not installed, install the renv package from CRAN
install.packages("renv")

# Then in the project folder run
renv::restore()
```

This process will download all the package versions which I used into an isolated environment and should not over-ride any packages present in your local `R` library.
I think this process can also be done easily in the Rstudio GUI when loading from `git` but I have not check this yet.
**Note** that `rjags` which is used in the `SIBER` package for bayesian ellipse calculations is only an `R` wrapper for `JAGS` and requires `JAGS` to be installed onto your computer outside of `R`.
Installation of `JAGS` can be found in at the website: [https://mcmc-jags.sourceforge.io/](https://mcmc-jags.sourceforge.io/).

## File structure for this git project

The structure of this repository is as follows:

```
├── data
│   ├── acid_treatment_data.csv             # Table 2 supplementary materials
│   ├── isotopes.csv                        # Table 1 supplementary materials
│   └── mcmc_output                         # Subsidiary folder containing MCMC outputs
│       ├── parasite_mcmc_draws.csv
│       ├── parasite_mf_draws.csv
│       ├── whale_mcmc_draws.csv
│       └── whale_mf_draws.csv
├── figures
│   ├── figure_1.pdf
│   ├── figure_2.png
│   ├── figure_3.png
│   ├── figure_4.png
│   ├── figure_5.png
│   ├── figure_6.png
│   └── supplementary_figure_1.png
├── isotope_analysis.R                      # Main analysis 
├── LICENSE
├── README.md
├── renv
│   ├── activate.R                          # Automatically loads renv
└── renv.lock                               # Contains package information
```

