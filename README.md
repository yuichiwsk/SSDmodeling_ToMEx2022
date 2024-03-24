# Bayesian SSD modeling using ToMEx 1.0 dataset

This repository contains R code and data used in Iwasaki et al. (2023).

Yuichi Iwasaki, Kazutaka M. Takeshita, Koji Ueda, Wataru Naito (2023) Estimating species sensitivity distributions for microplastics by quantitatively considering particle characteristics using a recently created ecotoxicity database. Microplastics and Nanoplastics. 3: 21.

Open access --> https://doi.org/10.1186/s43591-023-00070-6

**NOTE: The title of y-axis of Fig. 2 (Log10-transformed HC5 (μg/L)) is not accurate. The accurate title of y-axis is "HC5 (μg/L: log-scale)".**




## Data
Data_SSDmodeling_ToMEx2022_v1.xlsx

The "Data" sheet contains the data used for the analysis, and the "Notes_rows_names" sheet provides additional notes related to the "Data" sheet.

## R Code
Before getting started, please ensure that you have installed "RStan." For instructions, refer to the webpage at: https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started.

Running Bayesian SSD models using the R package “rstan” can be challenging due to compatibility issues with different versions of R and related R packages. 

For your information, we have run the SSD models using the following configurations:
- R version 3.6.3
- R package "rstan" version 2.21.2
- R package "loo" version 2.5.1

To proceed, please refer to the R code file "SSDmodeling_Fullmodel_v1.r" for further instructions and implementation details.


Please contact Yuichi Iwasaki at yuichi-iwasaki (at) aist.go.jp or yuichiwsk (at) gmail.com if you have any queries and questions.



