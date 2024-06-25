## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----root_dir_url-----------------------------------------------------------------------------------------------------------------------------------------
root <- 'https://raw.githubusercontent.com/michabohealthscience/training-fsa/main'



## ----read_in_data_grouping--------------------------------------------------------------------------------------------------------------------------------
tstats <- read.csv(file.path(root, 'data/combined_male_tstats.csv'), row.names = 1)




## ----rscaling---------------------------------------------------------------------------------------------------------------------------------------------
tstats_scaled <- scale(tstats, center=FALSE, scale=TRUE)


## ----HCA--------------------------------------------------------------------------------------------------------------------------------------------------
library(pvclust)
pvclust_res <- pvclust(tstats_scaled, method.hclust = "ward.D2", nboot=100)


  
plot(pvclust_res, c("si", "au", "bp"), hang=-1)
pp = pvpick(pvclust_res, alpha=0.05, pv="si", type="geq", max.only=TRUE)


