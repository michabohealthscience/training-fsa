## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----root_dir_url-----------------------------------------------------------------------------------------------------------------------------------------
root <- 'https://raw.githubusercontent.com/michabohealthscience/training-fsa/main'



## ----sample_metadata--------------------------------------------------------------------------------------------------------------------------------------
sample_metadata_all <- read.csv(file.path(root, 'data/HILIC_POS_male/0_sample_metadata.csv'))



## ----sample_metadata_view---------------------------------------------------------------------------------------------------------------------------------
head(sample_metadata_all)



## ----hilic_pos_intensity_unfiltered-----------------------------------------------------------------------------------------------------------------------
hilic_pos_all <- read.csv(file.path(root, 'data/HILIC_POS_male/1_unfiltered.csv'))


## ----hilic_pos_intensity_cols_rows, results = "hold"------------------------------------------------------------------------------------------------------
# feature count
feature_c_all = nrow(hilic_pos_all)
# sample count
samp_c_all = ncol(hilic_pos_all)-1

feature_c_all
samp_c_all



## ----hilic_pos_intensity_filtered, results = "hold"-------------------------------------------------------------------------------------------------------
hilic_pos_f <- read.csv(file.path(root, 'data/HILIC_POS_male/2_filtered.csv'))


## ----hilic_pos_intensity_filtered_cols_rows, results = "hold"---------------------------------------------------------------------------------------------

# feature count
feature_c_f = nrow(hilic_pos_f)
# sample count
samp_c_f = ncol(hilic_pos_f)-1


c('All samples:', samp_c_all)
c('Samples removed:', samp_c_all-samp_c_f)
c('Remaining samples:', samp_c_f)

c('All features:', feature_c_all)
c('Features removed:', feature_c_all-feature_c_f)
c('remaining features:', feature_c_f)


## ----hilic_pos_feature_metadata---------------------------------------------------------------------------------------------------------------------------
feature_meta <- read.csv(file.path(root, 'data/HILIC_POS_male/0_feature_metadata.csv'))

# only select a few columns
feature_meta_reduced <- feature_meta[,c(1, 3, 6)]

head(feature_meta_reduced)

