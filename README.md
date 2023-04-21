# Parasitic copepods as biochemical tracers of foraging patterns and dietary shifts in whale sharks

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

To use this GitHub repository from a Command-line interface, simply `git-clone` this repository, `cd` into the repository folder  and use the `Rscript` function on the `script.R` file to run the full data analysis used for the paper.
Alternatively, if using `Rstudio` this GitHub repository can be added using: `File -> New Project -> Version Control -> Git` and then add [https://github.com/brendonosorio/Osorio_et_al_2023](https://github.com/brendonosorio/Osorio_et_al_2023) in the Repository URL.

## Methods

## Data-specific information for `isotopes.csv`
The `isotopes.csv` is the main dataset which was used for the statistical analyses conducted in the report, and is the same data as provided in the supplementary materials.

Number of variables: 17
Number of observations: 72
Variable description list:
* `Shark_ID`: contains the unique naming code for each whale shark observed at Ningaloo Reef between 2016 and 2022. Unique naming code are YYYY_WSXX where YYYY = Year of observation, WS = whale shark and XX is the observed whale shark that year.
* `host_d15n`: are the $\delta^{15}N$ values obtained from whale shark dermal tissues.
* `host_d13c`: are the $\delta^{13}C$ values obtained from whale shark dermal tissues.
* `host_n_percent`: are the nitrogen (N)% values for whale shark dermal tissues.
* `host_c_percent`: are the carbon (C)% values for whale shark dermal tissues.
* `host_cn_ratio`: contains the C:N ratio obtained from whale shark dermal tissues.
* `para_d15n`: are the $\delta^{15}N$ values obtained from untreated *P. rhincodonicus* tissues.
* `para_d13c`: are the $\delta^{13}C$ values obtained from untreated *P. rhincodonicus* tissues.
* `para_acid_d13c`: are the $\delta^{13}C$ values for *P. rhincodonicus* tissues corrected for acidification procedures.
* `para_n_percent`: are the nitrogen (N)% values for *P. rhincodonicus* tissues.
* `para_c_percent`: are the carbon (C)% values for *P. rhincodonicus* tissues.
* `para_cn_ratio`: are the C:N ratio values for *P. rhincodonicus* tissues.
* `length_est`: contains the fork-length estimates (m) for whale shark hosts.
* `Year`: contains the year of sampling as an integer value.
* `Sex`: contains string values for male and female whale shark host values.
* `latitude_DD`: are the latitude (in degree decimal) values for each whale shark observation at Ningaloo Reef.
* `longitude_DD`: are the longitude (in degree decimal) values for each whale shark observation at Ningaloo Reef.

## Data-specific information for `acid_treatment_data.csv`
The `acid_treatment_data.csv` dataset is a subsidiary dataset which was used to assess the effects of acidification procedures on *P. rhincodonicus* tissues.
This information about acidification effects was fed into the `isotopes.csv`, with the `para_acid_d13c` variable being calculated as $Parasite_{acid} = Parasite_{Untreated} - 0.3$. Many variables present in the `isotopes.csv` dataset are also present in the `acid_treatment_data.csv` and reflect the same information here as well.

Number of variables: 22
Number of observations 40 (5 x 8 whale sharks)
Variable descriptions:
* `Shark_ID`: contains the unique naming code for each whale shark observed at Ningaloo Reef between 2016 and 2022. Unique naming code are YYYY_WSXX where YYYY = Year of observation, WS = whale shark and XX is the observed whale shark that year.
* `Copepod_number`: reflects the copepod which was obtained from a single whale shark, being between C1 -> C5.
* `acid_para_d15n`: are the $\delta^{15}N$ values obtained from acidified *P. rhincodonicus* tissues.
* `acid_para_d13c`: are the $\delta^{13}C$ values obtained from acidified *P. rhincodonicus* tissues.
* `acid_para_n_percent`: are the nitrogen (N)% values from acidified *P. rhincodonicus* tissues.
* `acid_para_c_percent`: are the carbon (C)% values from acidified *P. rhincodonicus* tissues.
* `acid_para_cn_ratio`: are the C:N ratio values for acidified *P. rhincodonicus* tissues.
* `ntreat_para_d15n`: are the $\delta^{15}N$ values obtained from untreated *P. rhincodonicus* tissues.
* `ntreat_para_d13c`: are the $\delta^{13}C$ values obtained from untreated *P. rhincodonicus* tissues.
* `ntreat_para_n_percent`: are the nitrogen (N)% values from untreated *P. rhincodonicus* tissues.
* `ntreat_para_c_percent`: are the carbon (C)% values from untreated *P. rhincodonicus* tissues.
* `ntreat_para_cn_ratio`: are the C:N ratios from untreated *P. rhincodonicus* tissues.
