# Bayesian SSD modeling using ToMEx 1.0 dataset
Author: Yuichi Iwasaki; yuichiwsk (at) gmail.com or yuichi-iwasaki (at) aist.go.jp 

This repository contains R code and data used in Iwasaki et al. (under review), "Estimating species sensitivity distributions for microplastics by quantitatively considering particle characteristics using a recently created ecotoxicity database."

## Data
Data_SSDmodeling_ToMEx2022_v1.xlsx

The "Data" sheet contains the data used for the analysis, and the "Notes_rows_names" sheet provides additional notes related to the "Data" sheet.

## R Code
Before stating, you need to install "rstan." Please see this webpage at https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started. Running Bayesian SSD models using the R package “rstan” can be challenging due to compatibility issues with different versions of R and related R packages. 
For your information, we have run the SSD models using:
- R version 3.6.3
- R package "rstan" version 2.21.2
- R package "loo" version 2.5.1

Then, please see the R code "SSDmodeling_Fullmodel_v1.r"




