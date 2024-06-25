## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----root_dir_url-----------------------------------------------------------------------------------------------------------------------------------------
root <- 'https://raw.githubusercontent.com/michabohealthscience/training-fsa/main'



## ----table, tidy=FALSE, echo=FALSE------------------------------------------------------------------------------------------------------------------------
data <- read.csv(file.path(root, 'data/cefic_matching_compounds.csv'), stringsAsFactors = FALSE, header = TRUE, check.names=FALSE)
knitr::kable((data), booktabs = TRUE,
caption = 'Table 5.1: Cefic MATCHING unblinded test substances')


## ----HCA--------------------------------------------------------------------------------------------------------------------------------------------------
# tstats <- read.csv('data/combined_male_tstats.csv', row.names = 1)
# tstats_scaled <- scale(tstats, center=FALSE, scale=TRUE)
# 
# 
# library(pvclust)
# pvclust_res <- pvclust(tstats_scaled, method.hclust = "ward.D2", nboot=1000)
# 
# 
#   
# plot(pvclust_res, c("si", "au", "bp"), hang=-1)
# pp = pvpick(pvclust_res, alpha=0.05, pv="si", type="geq", max.only=TRUE)


