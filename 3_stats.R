## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----root_dir_url-----------------------------------------------------------------------------------------------------------------------------------------
root <- 'https://raw.githubusercontent.com/michabohealthscience/training-fsa/main'



## ----hilic_pos_glog---------------------------------------------------------------------------------------------------------------------------------------
# Read in the sample metadata and processed data matrix
sample_metadata <- read.csv(file.path(root, 'data/HILIC_POS_male/0_sample_metadata_filtered.csv'))
glog <- read.csv(file.path(root, 'data/HILIC_POS_male/5_glog.csv'))



## ----hilic_pos_glog_rm------------------------------------------------------------------------------------------------------------------------------------
# Remove the feature names (not required for this analysis)
glog <- glog[,-1]



## ----hilic_pos_glog_transpose-----------------------------------------------------------------------------------------------------------------------------
# transpose 
glog_t <- t(glog)



## ----hilic_pos_glog_qc_remove-----------------------------------------------------------------------------------------------------------------------------
qc_names <- sample_metadata[,1][sample_metadata$Class=='QC']
sample_metadata_no_qcs <- sample_metadata[sample_metadata$Class!='QC',]

glog_t_no_qcs <- glog_t[!rownames(glog_t) %in% qc_names,]



## ----hilic_pos_glog_pca-----------------------------------------------------------------------------------------------------------------------------------
pca_no_qcs <- prcomp(glog_t_no_qcs, center = TRUE, scale. = TRUE)


## ----hilic_pos_glog_pca_plot------------------------------------------------------------------------------------------------------------------------------
library(ggfortify)
# the x and y variable can be adjusted to show compare different principal components

autoplot(pca_no_qcs, x=1, y=2, data=sample_metadata_no_qcs, colour="test_substance",  shape="dose_group", frame=TRUE, frame.colour = 'test_substance')+
  scale_colour_manual(values=c("khaki","black","blue", 'red', "grey",'orange', 'magenta', 'yellow', 'green', 'brown', 'purple'))+
  scale_fill_manual(values=c("khaki","black","blue", 'red', "grey",'orange', 'magenta', 'yellow', 'green', 'brown', 'purple'))+
  scale_shape_manual(values=c(4,8,2))+
  theme_bw()



## ----t-test_data------------------------------------------------------------------------------------------------------------------------------------------
pqn <- read.csv(file.path(root, 'data/HILIC_POS_male/3_pqn.csv'))



## ----t-test_data_one_feature------------------------------------------------------------------------------------------------------------------------------
# Get all the control samples (i.e. all those with dose 0)
control_samples <- sample_metadata[,1][sample_metadata$dose_group==0]

# Get the high dose group (2) for test substance 1
ts1_dose_2_samples <- sample_metadata[,1][sample_metadata$dose_group==2 & sample_metadata$test_substance==1]

# Select the 2000th feature as an example
f2000 <- pqn[2000,]

# Perform a t-test for this feature subset based on the chosen samples
ttest_out <- t.test(f2000[,control_samples], f2000[,ts1_dose_2_samples])

ttest_out


## ----t-test_data_one_assay--------------------------------------------------------------------------------------------------------------------------------
library(reshape2)

ttest_per_test_substance <- function(pqn, sample_metadata, test_substance=1){
    pqn_t <- data.frame(t(pqn[,-1]))
    colnames(pqn_t) <- pqn$feature_name
    pqn_t$sample_name <- rownames(pqn_t)
  
    pqn_long <- melt(pqn_t, id.vars=c('sample_name'))
    pqn_long <- merge(pqn_long, sample_metadata[,c('sample_name', 'test_substance', 'dose_group')], on='sample_name')
    
    pqn_long <- pqn_long[pqn_long$test_substance != "QC",]
    pqn_long$test_substance <- as.numeric(pqn_long$test_substance)
    pqn_long$dose <- as.numeric(pqn_long$dose)
    pqn_long$value <- as.numeric(pqn_long$value)
    
    # Just check test substance 1
    pqn_long <- pqn_long[pqn_long$test_substance == test_substance | pqn_long$dose_group == 0, ]
    ttest_l = list()
    feature_names <- pqn$feature_name
    doses <- c(1,2)
    
    n = 0
    for (dose in doses){
      
      for (feature in feature_names){
        
        n = n + 1
        
        if (n %% 1000 == 0 || n == 1){
          print(c(n, 'of', length(feature_names)*length(doses)))
        }
        
        treated <- pqn_long[pqn_long$dose_group == dose &
                            pqn_long$variable == feature,]
            
        control <- pqn_long[pqn_long$dose_group == 0 &
                            pqn_long$variable == feature,]
          
        # Specify that we need 3 or more samples in both the treated and control condition
        if (sum(!is.na(treated$value)) > 2 && sum(!is.na(control$value)) > 2){
              ttest_out <- t.test(treated$value, control$value)
              
              ttest_l[[n]] <- c(feature, dose, ttest_out$p.value, ttest_out$statistic)
        }else{
          ttest_l[[n]] <- c(feature, dose, NA, NA)
        }
            
      }
    }
    ttest_df <- data.frame(Reduce(rbind, ttest_l))
    colnames(ttest_df) <- c('feature_name', 'dose', 'pvalue', 'tstat')
    
    ttest_df$pvalue <- as.numeric(ttest_df$pvalue)
    ttest_df$tstat <- as.numeric(ttest_df$tstat)
    
    ttest_df$pvalue
    return(ttest_df)
}



