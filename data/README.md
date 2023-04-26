# Data dictionary

This README.md file contains the pertinent information for each dataset and the variables held within `data/` folder.
There are 6 data files which are shown below:

```
├── data
│   ├── acid_treatment_data.csv
│   ├── isotopes.csv
│   ├── mcmc_output
│   │   ├── parasite_mcmc_draws.csv
│   │   ├── parasite_mf_draws.csv
│   │   ├── whale_mcmc_draws.csv
│   │   └── whale_mf_draws.csv
│   └── README.md
```
## isotopes.csv

`isotopes.csv` contains 17 variables and 72 observations of whale shark and parasite isotopes obtained at Ningaloo Reef between 2016-2022.
`isotopes.csv` is the main pertinent data frame which was used in the report, and was used for the main statistical analysis.
Each row indicates a single paired shark-parasite observation.
Variable information are shown as:

| Variable | Description | Data type |
| :--      | :--         | :--       |
| Shark_ID| Contains the ID of whale sharks observed between 2016-2022. ID conventions are YYYY_WSXX where YYYY = year, WS = whale shark, XX = whale shark \# from the year | string |
| host_d15n | Contains the $\delta^{15}N$ values from whale shark tissue | float |
| host_d13c | Contains the $\delta^{13}C$ values from whale shark tissue | float |
| host_n_percent | Contains the nitrogen (N) \% from whale shark tissue | float |
| host_c_percent | Contains the carbon (C) \% from whale shark tissue | float |
| host_cn_ratio | Contains the carbon-to-nitrogen (C:N) ratio in whale shark tissues | float | 
| para_d15n | Contains the $\delta^{15}N$ values from parasite tissues | float |
| para_d13c | Contains the $\delta^{13}C$ values from parasite tissues | float |
| para_acid_d13c | Contains the $\delta^{13}C values from parasite tissues corrected for acidification (see below) | float |
| para_n_percent | Contains the nitrogen (N) \% from parasite tissue | float |
| para_c_percent | Contains the carbon (C) \% from parasite tissue | float |
| para_cn_ratio | Contains the carbon-to-nitrogen (C:N) ratio in parasite tissues | float |
| length_est | Contains the fork length observations of whale sharks | float |
| Year | Contains the year of observation | int |
| Sex | Contains the sex of the observed whale shark host (M = male, F = female) | string |
| latitude_DD | Contains the latitude GPS location of whale shark observation (in degree-decimal format, WGS = 1984)| float |
| longitude_DD | Contains the longitude GPS location of whale shark observations (in degree-decimal format, WGS = 1984 | float |

## acid_treatment_data.csv

`acid_treatment_data.csv` contains 22 variables and 40 observations of whale shark and parasite isotopes at Ningloo between 2016-2022.
The purpose of this dataset was to determine the correction for acidification procedures on $\delta^{13}C$ values on parasite tissues.
It is important to note that values in `acid_treatment_data.csv` are NOT present in the `isotopes.csv` file. 
Variable information is below:

| Variable | Description | Data type |
| :--      | :--         | :--       |
| Shark_ID| Contains the ID of whale sharks observed between 2016-2022. ID conventions are YYYY_WSXX where YYYY = year, WS = whale shark, XX = whale shark \# from the year | string |
| Copepod_number | Reflects the copepod which was obtained from its whale shark host (ranging from C1 -> C5, where C = copepod | string |
| host_d15n | Contains the $\delta^{15}N$ values from whale shark tissue | float |
| host_d13c | Contains the $\delta^{13}C$ values from whale shark tissue | float |
| host_n_percent | Contains the nitrogen (N) \% from whale shark tissue | float |
| host_c_percent | Contains the carbon (C) \% from whale shark tissue | float |
| host_cn_ratio | Contains the carbon-to-nitrogen (C:N) ratio in whale shark tissues | float | 
| ntreat_para_d15n | Contains the $\delta^{15}N$ values from untreated parasite tissues | float |
| ntreat_para_d13c | Contains the $\delta^{13}C$ values from untreated parasite tissues | float |
| ntreat_para_n_percent | Contains the nitrogen (N) \% from untreated parasite tissue | float |
| ntreat_para_c_percent | Contains the carbon (C) \% from untreated parasite tissue | float |
| ntreat_para_cn_ratio | Contains the carbon-to-nitrogen (C:N) ratio from untreated parasite tissue | float |
| acid_para_d15n | Contains the $\delta^{15}N$ values from acidified parasite tissues | float |
| acid_para_d13c | Contains the $\delta^{13}C$ values from acidified parasite tissues | float |
| acid_para_n_percent | Contains the nitrogen (N) \% from acidified parasite tissues | float |
| acid_para_c_percent | Contains the carbon (C) \% from acidified parasite tissues | float |
| acid_para_cn_ratio | Contains the carbon-to-nitrogen (C:N) ratio from acidified parasite tissue | float |
| length_est | Contains the fork length observations of whale sharks | float |
| Year | Contains the year of observation | int |
| Sex | Contains the sex of the observed whale shark host (M = male, F = female) | string |
| latitude_DD | Contains the latitude GPS location of whale shark observation (in degree-decimal format, WGS = 1984)| float |
| longitude_DD | Contains the longitude GPS location of whale shark observations (in degree-decimal format, WGS = 1984 | float |

## mcmc_output/

The mcmc_output file contains four data files which are the Markov Chain Monte Carlo (MCMC) draws of posterior estimates of stable ellipse areas (SEA) and isotopic niche overlap from the `SIBER` package. These are:

| Data frame | Number of rows | Description |
| :-- | :-- | :-- |
| parasite_mcmc_draws |  40,000 rows (2 MCMC chains, 20,000 length) | Contains the posterior estimates of isotopic niche size based on standard ellipse areas for parasites|
| whale_mcmc_draws | 40,000 rows (2 MCMC chains, 20,000 length) | Contains the posterior estimates of isotopic niche size based on standard ellipse areas for whale sharks |
| parasite_mf_draws | 1000 rows (obtained from first 1000 parasite_mcmc_draws) | Contains the bayesian overlap estimates of isotopic niches between male and female whale shark hosts, as determined using parasite isotopic compositions |
| whale_mf_draws | 1000 rows (obtained from the first 1000 parasite_mcmc_draws) | Contains the bayesian overlap estimates of isotopic niches between male and female whale sharks, as determined using whale shark host isotopic values |
