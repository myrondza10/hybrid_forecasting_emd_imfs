
############################## IMPORT PACKAGES ############################

library(TSstudio)
library(data.table)
library(xts)
library(bsts)
library(forecast)

############################## PREPROCESSING TIMESERIES ############################

df_daily <- read.csv("Revenue.csv")
df_daily$date<-as.Date(df_daily$date, format="%Y-%m-%d")

df_daily<- xts(df_daily$Revenue,order.by = df_daily$date,frequency = 1)
df_weekly <- period.apply(df_daily, INDEX = endpoints(df_daily, on = "weeks"), FUN = mean)
df_monthly<- period.apply(df_daily, INDEX = endpoints(df_daily, on = "months"), FUN = mean)


############################## DECOMPOSE AND VISUALIZE TIMESERIES ############################

ts_seasonal(df_monthly, type = "box")

ts_seasonal(df_daily, type = "normal")
ts_seasonal(df_weekly, type = "normal")
ts_seasonal(df_monthly, type = "normal")


ts_surface(df_daily)
ts_surface(df_weekly)
ts_surface(df_monthly)

ts_heatmap(df_weekly)
ts_heatmap(df_monthly)

############################## CREATE TRAIN TEST SPLIT ############################

train_idx <- nrow(df_daily) *0.8

train_df <- df_daily[1:train_idx,]
test_df <- df_daily[-c(1:train_idx),]



############################## HILBERT - HUANG TRANSFORM (EMPIRICAL MODE DECOMPOSITION) ############################

library(hht)
tt  <-  seq_len(length(train_df)) * 0.01
noise.amp <- 6.4e-07
trials <- 100

train_df <- as.data.table(train_df)
test_df <- as.data.table(test_df)

EEMD(train_df$V1, tt, noise.amp, trials,nimf=5, trials.dir = "TRIALS", verbose = TRUE, 
     spectral.method = "arctan", diff.lag = 1, tol = 5, max.sift = 200,
     stop.rule = "type5", boundary = "wave", sm = "none",
     smlevels = c(1), spar = NULL, max.imf = 100, interm = NULL, 
     noise.type = "gaussian", noise.array = NULL)

EEMD.result <- EEMDCompile(trials.dir="TRIALS",trials, nimf=5)
EEMD.result$averaged.residue
EEMD.result$averaged.imfs

IMFS <- as.data.frame(EEMD.result$averaged.imf)
RESIDUE <- as.data.frame(EEMD.result$averaged.residue)

rownames(IMFS) <- train_df$index
rownames(RESIDUE) <- train_df$index

 
############################## BAYESIAN STRUCTURAL TIMESERIES ############################

BSTS_model <- function(x) {
  ss <- AddSemilocalLinearTrend(list(), x)
  ss <- AddSeasonal(ss, x,nseasons = 1)
  ss <- AddAutoAr(ss,x)
  bsts.model <- bsts(x, ss, niter = 2000,seed=8675309,expected.model.size=5)
  burn <- SuggestBurn(0.1, bsts.model)
  pred <- predict(bsts.model,horizon = 5,burn= burn,quantiles = c(.025, .975),InstantaneousFrequency_Pred)
  return(pred$mean)
}


IMFS_Pred <-lapply(IMFS, BSTS_model)
RESIDUE_Pred <-lapply(RESIDUE, BSTS_model)

IMFS_Pred <- as.data.frame(IMFS_Pred)
RESIDUE_Pred <- as.data.frame(RESIDUE_Pred)
colnames(RESIDUE_Pred) <- 'RESIDUE'

IMFS_RESIDUE_Pred <- cbind(IMFS_Pred,RESIDUE_Pred)

IMFS_RESIDUE_Pred$Output <- IMFS_RESIDUE_Pred$V1+IMFS_RESIDUE_Pred$V2+IMFS_RESIDUE_Pred$V3+IMFS_RESIDUE_Pred$V4+IMFS_RESIDUE_Pred$V5 + IMFS_RESIDUE_Pred$RESIDUE


############################## ACCURACY METRICS ############################

actuals <- as.data.frame(test_df$V1[0:5])
predictions <- IMFS_RESIDUE_Pred$Output
colnames(actuals)[1]<-"Actual"
final <- cbind(actuals,predictions)
colnames(final)[2]<-"Prediction"
accuracy(final$Prediction,x=final$Actual)
