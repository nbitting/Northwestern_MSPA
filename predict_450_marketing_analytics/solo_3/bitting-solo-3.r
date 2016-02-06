setwd('C:/Users/nbitting-pc/Google Drive/PREDICT 450/Solo3')
load('XYZ_complete_customer_data_frame.RData')
cust_df = complete.customer.data.frame
cust_16_df = cust_df[cust_df$ANY_MAIL_16 == 1,]
#write.csv(cust_16_df, 'test.csv', row.names = FALSE)

summary(cust_16_df)
str(cust_16_df)


##################################
# Create our own variables
##################################

# create a binary variable to indicate if customer purchased before 16th campaign
cust_16_df$TOTAMT_before_16 = cust_16_df$TOTAMT - cust_16_df$TOTAMT16
cust_16_df$previousPurchase = ifelse(cust_16_df$TOTAMT_before_16>0, 1, 0)

# create numeric variable to indicate how many times a customer has repsonded to previous compaigns
cust_16_df$previousResponseCount = (cust_16_df$RESPONSE0 + cust_16_df$RESPONSE1 + cust_16_df$RESPONSE2 + cust_16_df$RESPONSE3 + cust_16_df$RESPONSE4 + cust_16_df$RESPONSE5
+ cust_16_df$RESPONSE6 + cust_16_df$RESPONSE7 + cust_16_df$RESPONSE8 + cust_16_df$RESPONSE9 + cust_16_df$RESPONSE10 + cust_16_df$RESPONSE11 + cust_16_df$RESPONSE12
+ cust_16_df$RESPONSE13 + cust_16_df$RESPONSE14 + cust_16_df$RESPONSE15)

# create binary variable to dinicate if a customer responded to previous campaign
cust_16_df$previousResponse = ifelse(cust_16_df$previousResponseCount>0, 1, 0)

# create variable to indicate TOAMT in relation to mean TOAMT
cust_16_df$relativePurchase = cust_16_df$TOTAMT_before_16 / mean(cust_16_df$TOTAMT_before_16, na.rm=TRUE)

# Binary variables for buyer status
cust_16_df$active = ifelse(cust_16_df$BUYER_STATUS == 'ACTIVE', 1, 0)
cust_16_df$inactive = ifelse(cust_16_df$BUYER_STATUS == 'INACTIVE', 1, 0)

# binary variables for categorical variables
cust_16_df$catalog = ifelse(cust_16_df$CHANNEL_ACQUISITION == 'CB', 1, 0)
cust_16_df$internet = ifelse(cust_16_df$CHANNEL_ACQUISITION == 'IB', 1, 0)
cust_16_df$homeowner = ifelse(cust_16_df$HOMEOWNR == 'Y', 1, 0)
cust_16_df$renter = ifelse(cust_16_df$RENTER == 'Y', 1, 0)
cust_16_df$children = ifelse(cust_16_df$NUM_CHILD>0, 1, 0)
cust_16_df$deceased = ifelse(cust_16_df$Deceased_Indicator == 'D', 1, 0)
cust_16_df$CHANNEL_DOMINANCE_A = ifelse(cust_16_df$CHANNEL_DOMINANCE == 'A', 1, 0)
cust_16_df$CHANNEL_DOMINANCE_C = ifelse(cust_16_df$CHANNEL_DOMINANCE == 'C', 1, 0)
cust_16_df$CHANNEL_DOMINANCE_E = ifelse(cust_16_df$CHANNEL_DOMINANCE == 'E', 1, 0)
cust_16_df$FIPSCNTY_97 = ifelse(cust_16_df$FIPSCNTY == '097', 1, 0)
cust_16_df$FIPSCNTY_111 = ifelse(cust_16_df$FIPSCNTY == '111', 1, 0)
cust_16_df$TRACT = as.numeric(cust_16_df$TRACT)
cust_16_df$MCD_CCD = as.numeric(cust_16_df$MCD_CCD)
cust_16_df$ADD_TYPE_A = ifelse(cust_16_df$ADD_TYPE == 'A', 1, 0)
cust_16_df$ADD_TYPE_M = ifelse(cust_16_df$ADD_TYPE == 'M', 1, 0)
cust_16_df$ADD_TYPE_S = ifelse(cust_16_df$ADD_TYPE == 'S', 1, 0)
cust_16_df$LOR1 = as.integer(cust_16_df$LOR1)
cust_16_df$OCC_GRP_I = ifelse(substr(cust_16_df$OCCUPATION_GROUP,1,1)=='I', 1, 0)
cust_16_df$OCC_GRP_K = ifelse(substr(cust_16_df$OCCUPATION_GROUP,1,1)=='K', 1, 0)
cust_16_df$M_HH_LEVEL_A = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'A', 1, 0)
cust_16_df$M_HH_LEVEL_B = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'B', 1, 0)
cust_16_df$M_HH_LEVEL_C = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'C', 1, 0)
cust_16_df$M_HH_LEVEL_D = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'D', 1, 0)
cust_16_df$M_HH_LEVEL_E = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'E', 1, 0)
cust_16_df$M_HH_LEVEL_F = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'F', 1, 0)
cust_16_df$M_HH_LEVEL_G = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'G', 1, 0)
cust_16_df$M_HH_LEVEL_H = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'H', 1, 0)
cust_16_df$M_HH_LEVEL_I = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'I', 1, 0)
cust_16_df$M_HH_LEVEL_J = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'J', 1, 0)
cust_16_df$M_HH_LEVEL_K = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'K', 1, 0)
cust_16_df$M_HH_LEVEL_L = ifelse(substr(cust_16_df$M_HH_LEVEL,1,1) == 'L', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_A = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'A', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_B = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'B', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_C = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'C', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_D = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'D', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_E = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'E', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_F = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'F', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_G = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'G', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_H = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'H', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_I = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'I', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_J = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'J', 1, 0)
cust_16_df$M_GRPTYPE_MEDIAN_K = ifelse(substr(cust_16_df$M_GRPTYPE_MEDIAN,1,1) == 'K', 1, 0)
cust_16_df$M_GLOBAL_Z4_A = ifelse(cust_16_df$M_GLOBAL_Z4 == 'A', 1, 0)
cust_16_df$M_GLOBAL_Z4_B = ifelse(cust_16_df$M_GLOBAL_Z4 == 'B', 1, 0)
cust_16_df$M_GLOBAL_Z4_C = ifelse(cust_16_df$M_GLOBAL_Z4 == 'C', 1, 0)
cust_16_df$M_GLOBAL_Z4_D = ifelse(cust_16_df$M_GLOBAL_Z4 == 'D', 1, 0)
cust_16_df$M_GLOBAL_Z4_E = ifelse(cust_16_df$M_GLOBAL_Z4 == 'E', 1, 0)
cust_16_df$M_GLOBAL_Z4_F = ifelse(cust_16_df$M_GLOBAL_Z4 == 'F', 1, 0)
cust_16_df$M_GLOBAL_Z4_G = ifelse(cust_16_df$M_GLOBAL_Z4 == 'G', 1, 0)
cust_16_df$M_GLOBAL_Z4_H = ifelse(cust_16_df$M_GLOBAL_Z4 == 'H', 1, 0)
cust_16_df$M_GLOBAL_Z4_I = ifelse(cust_16_df$M_GLOBAL_Z4 == 'I', 1, 0)
cust_16_df$AD_WEB = as.numeric(cust_16_df$AD_WEB)
cust_16_df$AD_WEB = ifelse(is.na(cust_16_df$AD_WEB), 0, cust_16_df$AD_WEB)
cust_16_df$AD_MAGAZINE = as.numeric(cust_16_df$AD_MAGAZINE)
cust_16_df$AD_MAGAZINE = ifelse(is.na(cust_16_df$AD_MAGAZINE), 0, cust_16_df$AD_MAGAZINE)
cust_16_df$AD_NEWSPAPER = as.numeric(cust_16_df$AD_NEWSPAPER)
cust_16_df$AD_NEWSPAPER = ifelse(is.na(cust_16_df$AD_NEWSPAPER), 0, cust_16_df$AD_NEWSPAPER)
cust_16_df$AD_RADIO = as.numeric(cust_16_df$AD_RADIO)
cust_16_df$AD_RADIO = ifelse(is.na(cust_16_df$AD_RADIO), 0, cust_16_df$AD_RADIO)
cust_16_df$AD_TV = as.numeric(cust_16_df$AD_TV)
cust_16_df$AD_TV = ifelse(is.na(cust_16_df$AD_TV), 0, cust_16_df$AD_TV)
cust_16_df$ZIP9_Supercode = as.numeric(cust_16_df$ZIP9_Supercode)

# create list for "Z" variables to keep.
z_vars = c('ZCREDIT', 'ZCRAFTS', 'ZGOURMET', 'ZCOMPUTR', 'ZHITECH', 'ZONLINE', 'ZSPENDER', 'PRESENCE_OF_SMOKER', 'ZGOLFERS', 'ZDONORS', 'ZPETS', 'ZARTS', 'ZMOB', 'ZFITNESS', 'ZOUTDOOR', 'ZTRAVANY', 'ZINVESTR', 'ZAUTOOWN', 'ZGARDEN', 'ZCOLLECT', 'ZCRUISE', 'ZSPORTS', 'ZSWEEPS', 'ZPOLITIC', 'ZMUSIC', 'ZREAD', 'ZCHLDPRD', 'ZDIY', 'ZSELFIMP', 'ZRELIGON', 'ZGRANDPR', 'ZCLOTHNG', 'ZDONENVR', 'ZMUTUAL', 'ZWGHTCON', 'ZPRCHPHN', 'ZPRCHTV', 'ZMOBMULT', 'ZCREDPLT', 'ZDOGS', 'ZCATS', 'ZHEALTH', 'ZAUTOINT', 'ZSKIING', 'ZASTRLGY', 'ZBOATS', 'ZCELL', 'ZCOMMCON', 'ZHMDECOR', 'ZHOMEENT', 'ZKITCHEN', 'ZMOBAV', 'ZMOBBOOK', 'ZMOBCLTH', 'ZMOBFIN', 'ZMOBGIFT', 'ZMOBGRDN', 'ZMOBJWL', 'ZMUSCLAS', 'ZMUSCNTR', 'ZMUSCRST', 'ZMUSOLDI', 'ZMUSROCK', 'ZPBCARE', 'ZPHOTO', 'ZPRCHONL', 'ZTENNIS', 'ZTRAVDOM', 'ZTRAVFOR', 'ZVOLUNTR')

# create a for loop to generate new dummy variables for "Z" variables
for (i in 1:length(z_vars)){
  cust_16_df[paste(z_vars[i],"_B", sep="")] = as.numeric(ifelse(cust_16_df[z_vars[i]] == "Y", 1, 0))
}

keep_vars = c('ZIP9_Supercode','PRE2009_SALES','PRE2009_TRANSACTIONS','TOTAMT_before_16','previousPurchase','previousResponseCount','previousResponse','relativePurchase',
              'active','inactive','catalog','internet')

keep_vars2 = c('active', 'previousResponseCount', 'M_HH_LEVEL_D', 'ZPETS_B', 'ZCOMPUTR_B', 'ZMUSCLAS_B', 'PRE2009_TRANSACTIONS', 'ZSKIING_B', 'ZHMDECOR_B', 
               'ZMUSCRST_B', 'ZINVESTR_B', 'ZCRUISE_B', 'ZMOBGRDN_B', 'ZMUTUAL_B', 'ZMOBFIN_B', 'M_GLOBAL_Z4_B', 'ZSELFIMP_B', 'ZCRAFTS_B', 'ADD_TYPE_M', 
               'M_GRPTYPE_MEDIAN_B', 'ZMUSOLDI_B', 'AD_NEWSPAPER', 'OCC_GRP_I', 'ZAUTOINT_B', 'P_IND_AGRICULTUR', 'relativePurchase', 'AVG_COMMUTETIM', 
               'P_IND_ACCOMMOD', 'P_IND_OTHERSERV', 'P_HHINCOM40_44', 'P_HHINCOM150_199', 'PHHWHITE', 'TOTAMT_before_16', 'POP_RURNOFARM', 'P_IND_EDALSERVIC', 
               'inactive', 'MED_HOME', 'P_HHINCOM125_149', 'HOUSE_STABILITY', 'POP18_65', 'M_GRPTYPE_MEDIAN_H', 'FEMALE_LABOR_FOR', 'P_FEMALE', 'P_IND_PUBADMIS', 
               'P_HHINCOM100_124', 'HH_BLACK', 'ZMOBCLTH_B', 'P_HHINCOM45_49', 'POP55_64', 'previousResponse', 'M_GLOBAL_Z4_F', 'P_IND_TRANSPORT', 'P_IND_WHOLESALE', 
               'ZPRCHPHN_B', 'ZCOLLECT_B', 'children', 'M_HH_LEVEL_F', 'ZOUTDOOR_B', 'ZCELL_B', 'ZDONORS_B', 'ZMOBGIFT_B', 'CHANNEL_DOMINANCE_C', 
               'PRESENCE_OF_SMOKER_B', 'ZARTS_B', 'ZDOGS_B', 'previousPurchase')

# create a subsetted dataframe to be used in predictive models
pred.cust_16_df = cust_16_df[,c(keep_vars,'RESPONSE16')]
predictors = keep_vars

##################################
# RANDOM FOREST MODELING
##################################

library(randomForest)
library(caret)
library(ROCR)
library(ggplot2)

set.seed(111)

# train and test split
randraw = runif(nrow(pred.cust_16_df))
cust16train = pred.cust_16_df[randraw<=0.65,]
cust16test = pred.cust_16_df[randraw>0.65,]

rf = randomForest(as.factor(RESPONSE16) ~ ., data=cust16train, ntree=800, mtry=12)
varImpPlot(rf)

# Plot ROC Curve with In-Sample Data
in_resp = predict(rf, newdata=cust16train, type='response')
prob_in = predict(rf, newdata=cust16train, type='prob')
pred = prediction(prob_in[,2], cust16train$RESPONSE16)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc = performance(pred, measure='auc')
auc = auc@y.values[[1]]

roc.data = data.frame(fpr=unlist(perf@x.values),tpr = unlist(perf@y.values),model='RandomForest')
ggplot(roc.data,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('RandomForest In-Sample ROC Curve w/ AUC=', round(auc, digits=3)))

# Plot ROC Curve with Out-Of-Sample Data
responses1 = predict(rf, newdata=cust16test, type='response')
prob_out = predict(rf, newdata=cust16test, type='prob' )
pred2 = prediction(prob_out[,2], cust16test$RESPONSE16)
perf2 <- performance(pred2, measure = "tpr", x.measure = "fpr")
auc_rf = performance(pred2, measure='auc')
auc_rf = auc_rf@y.values[[1]]

roc.data2 = data.frame(fpr=unlist(perf2@x.values),tpr = unlist(perf2@y.values),model='RandomForest')
ggplot(roc.data2,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('RandomForest Out-of-Sample ROC Curve w/ AUC=', round(auc_rf, digits=3)))

# confusion matrix for random forest
xtab1 = table(round(as.numeric(responses1,digits=0)),cust16test$RESPONSE16)
row.names(xtab1) = c(0,1)
confusionMatrix(xtab1, positive="1")

# Lift table for glm
library(gains)
gains(actual=cust16train$RESPONSE16, predicted = round(as.numeric(in_resp), digits=0), optimal=T)

##################################
# GLM MODELING
##################################
library(MASS)

bin.logit = glm(RESPONSE16 ~ ., family=binomial, data=cust16train)


# Plot ROC Curve with In-Sample Data
prob_in_glm = predict(bin.logit, newdata=cust16train, type='response')
pred = prediction(prob_in_glm, cust16train$RESPONSE16)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc_lr = performance(pred, measure='auc')
auc_lr = auc_lr@y.values[[1]]

roc.data = data.frame(fpr=unlist(perf@x.values),tpr = unlist(perf@y.values),model='LogisticRegression')
ggplot(roc.data,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('Logistic Regression In-Sample ROC Curve w/ AUC=', round(auc_lr, digits=3)))

# Plot ROC Curve with Out-Of-Sample Data
responses = predict(bin.logit, newdata=cust16test, type='response')
prob_out = predict(bin.logit, newdata=cust16test, type='response')
pred2 = prediction(prob_out, cust16test$RESPONSE16)
perf2 <- performance(pred2, measure = "tpr", x.measure = "fpr")
auc_lr = performance(pred2, measure='auc')
auc_lr = auc_lr@y.values[[1]]

roc.data2 = data.frame(fpr=unlist(perf2@x.values),tpr = unlist(perf2@y.values),model='LogisticRegression')
ggplot(roc.data2,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('Logistic Regression Out-of-Sample ROC Curve w/ AUC=', round(auc_lr, digits=3)))

# confustion matrix for glm
xtab = table(round(as.numeric(responses,digits=0)),cust16test$RESPONSE16)
row.names(xtab) = c(0,1)
confusionMatrix(xtab, positive="1")

preds = round(responses, digits=0)

# convert the coefficients back to probabilities
coef_lr = data.frame(coef(bin.logit))
coef_lr$prob = round(exp(coef_lr$coef.bin.logit.)/(1+exp(coef_lr$coef.bin.logit.)), digits=4)

responses = round(responses, digits=0)

# Lift table for glm
library(gains)
gains(actual=cust16test$RESPONSE, predicted = responses, groups=10)

##################################
# glmnet Modeling
##################################

library(caret)
library(glmnet)
library(pROC)

objControl <- trainControl(method='cv', number=3, returnResamp='none')
objModel = train(cust16train[,keep_vars],cust16train[,"RESPONSE16"], method='glmnet', metric='RMSE', trControl=objControl)

# In-Sample ROC and AUC
predictions <- predict(object=objModel, cust16train[,keep_vars])
auc = roc(cust16train[,'RESPONSE16'], predictions)
print(auc$auc)
pred = prediction(predictions, cust16train$RESPONSE16)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc = performance(pred, measure='auc')
auc = auc@y.values[[1]]

roc.data = data.frame(fpr=unlist(perf@x.values),tpr = unlist(perf@y.values),model='GLMNET')
ggplot(roc.data,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('GLMNET In-Sample ROC Curve w/ AUC=', round(auc, digits=3)))

# Out-of-Sample ROC and AUC
predictions <- predict(object=objModel, cust16test[,keep_vars])
auc = roc(cust16test[,'RESPONSE16'], predictions)
print(auc$auc)
pred = prediction(predictions, cust16test$RESPONSE16)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc = performance(pred, measure='auc')
auc = auc@y.values[[1]]

roc.data = data.frame(fpr=unlist(perf@x.values),tpr = unlist(perf@y.values),model='GLMNET')
ggplot(roc.data,aes(x=fpr,ymin=0,ymax=tpr)) + geom_ribbon(alpha=0.2) + geom_line(aes(y=tpr)) + ggtitle(paste0('GLMNET Out-of-Sample ROC Curve w/ AUC=', round(auc, digits=4)))

# variable importance plot
plot(varImp(objModel,scale=F))

varImp(objModel,scale=F)

# confustion matrix for glm
xtab = table(round(as.numeric(predictions,digits=0)),cust16test$RESPONSE16)
row.names(xtab) = c(0,1)
confusionMatrix(xtab, positive="1")

##################################
# Estimation of Net Revenue
##################################
library(miscTools)
cust_16_df$NETREV16 = (0.1 * cust_16_df$TOTAMT16)

pred.cust_16_df2 = cust_16_df[,c(keep_vars,'NETREV16')]
predictors2 = keep_vars

# train and test split
randraw = runif(nrow(pred.cust_16_df2))
cust16train = pred.cust_16_df2[randraw<=0.65,]
cust16test = pred.cust_16_df2[randraw>0.65,]

############################################
# Estimation of Net Revenue RANDOM FOREST
############################################

# model with all observations (no outliers removed)
rf_NETREV = randomForest(NETREV16 ~ ., data=cust16train, ntree=800, mtry=50)

resids = cust16train$NETREV16 - predict(rf_NETREV, cust16train)
r2_rf = rSquared(cust16train$NETREV16, cust16train$NETREV16 - predict(rf_NETREV, cust16train)) 
mse_rf = mean((cust16train$NETREV16 - predict(rf_NETREV,cust16train))^2)


resid_with_outliers = cbind(cust16train$NETREV16, predict(rf_NETREV, cust16train), resids)
write.csv(resid_with_outliers, 'resid_w_outliers.csv')

# plot the actual vs predicted and R2
p = ggplot(aes(x=actual,y=pred),
           data=data.frame(actual=cust16train$NETREV16, pred=predict(rf_NETREV, cust16train)))
p + geom_point() + geom_abline(color='red') + ggtitle(paste(paste('RandomForest Regression in R r^2=', round(r2_rf,digits=4), sep=""), paste(' MSE=', round(mse_rf, digits=1), sep=""), sep=""))

# remove outliers
cust16train$resid = abs(cust16train$NETREV16 - predict(rf_NETREV, cust16train))
cust16train_no_outlier = cust16train[cust16train$resid<95,]

# model with all observations (no outliers removed)
rf_NETREV_2 = randomForest(NETREV16 ~ ., data=cust16train_no_outlier[,c(keep_vars, 'NETREV16')], ntree=800, mtry=50)

resids2 = cust16train_no_outlier$NETREV16 - predict(rf_NETREV_2, cust16train_no_outlier[,c(keep_vars, 'NETREV16')])
r2_rf2 = rSquared(cust16train_no_outlier$NETREV16, cust16train_no_outlier$NETREV16 - predict(rf_NETREV_2, cust16train_no_outlier[,c(keep_vars, 'NETREV16')])) 
mse_rf2 = mean((cust16train_no_outlier$NETREV16 - predict(rf_NETREV_2,cust16train_no_outlier[,c(keep_vars, 'NETREV16')]))^2)

ssr_rf = sum(resids2^2)
mae_rf = mean(abs(resids))

# plot the actual vs predicted and R2
p2 = ggplot(aes(x=actual,y=pred),
           data=data.frame(actual=cust16train_no_outlier$NETREV16, pred=predict(rf_NETREV_2, cust16train_no_outlier[,c(keep_vars, 'NETREV16')])))
p2 + geom_point() + geom_abline(color='red') + ggtitle(paste(paste('RandomForest Regression w/o Outlier in R r^2=', round(r2_rf2,digits=4), sep=""), paste(' MSE=', round(mse_rf2, digits=1), sep=""), sep=""))

# plot the residuals vs the predicted
p = ggplot(aes(x=pred,y=resid_rf),
           data=data.frame(pred=predict(rf_NETREV_2, cust16train_no_outlier[,c(keep_vars, 'NETREV16')]), resid_rf=cust16train_no_outlier$NETREV16 - predict(rf_NETREV_2, cust16train_no_outlier[,c(keep_vars, 'NETREV16')])))
p + geom_point() + ggtitle('Random Forest Regression Residuals')

mse_rf_test = mean((cust16test$NETREV16 - predict(rf_NETREV_2,cust16test))^2)
mae_rf_test = mean(abs(cust16test$NETREV16 - predict(rf_NETREV_2,cust16test)))
rf_est_test = predict(rf_NETREV_2,cust16test)

rmse_rf_test = mse_rf_test^(1/2)

qqnorm((rf_est_test - cust16test$NETREV16)/sd(rf_est_test - cust16test$NETREV16))
qqline((rf_est_test - cust16test$NETREV16)/sd(rf_est_test - cust16test$NETREV16))

############################################
# Estimation of Net Revenue Linear Reg
############################################
library(MASS)
lm.fit = lm(NETREV16 ~ ., data=cust16train)
print(lm.fit)
anova(lm.fit)

# step = stepAIC(lm.fit, direction = 'both')
# step$anova

# store variables from final model in stepwise variable selection
# keep = c('LTD_SALES', 'LTD_TRANSACTIONS', 'INC_WOUTSCS_AMT_4', 'POP_ADPCHLDFAM', 'P_HHINCOLES10M', 'P_HHINCOM10_14', 
#          'P_HHINCOM25_29', 'P_IND_CONSTRUCT', 'P_IND_MANUFACT', 'P_IND_WHOLESALE', 'P_IND_RETAILTRD', 'P_IND_TRANSPORT', 
#          'P_IND_INFORMAT', 'P_IND_FINALNCE', 'P_IND_REALESTAT', 'P_IND_PROFFES', 'P_IND_ADM_SUPPOT', 'P_IND_EDALSERVIC', 
#          'P_IND_HEALTHCARE', 'P_IND_ACCOMMOD', 'P_IND_OTHERSERV', 'P_IND_PUBADMIS', 'AVG_COMMUTETIM', 'WRK_TRA_60_89', 
#          'MED_HOME', 'P_HH_SPAN_SPEAK', 'CUR_EST_MED_INC', 'AD_MAGAZINE', 'AD_NEWSPAPER', 'PRE2009_SALES', 
#          'PRE2009_TRANSACTIONS', 'TOTAMT_before_16', 'previousPurchase', 'previousResponseCount', 'active', 'children', 
#          'M_HH_LEVEL_I', 'M_GRPTYPE_MEDIAN_A', 'OCC_GRP_I', 'PRESENCE_OF_SMOKER_B', 'ZGOLFERS_B', 'ZTRAVANY_B', 'ZINVESTR_B', 
#          'ZPOLITIC_B', 'ZCHLDPRD_B', 'ZCLOTHNG_B', 'ZBOATS_B', 'ZMOBAV_B', 'ZMOBFIN_B', 'ZMOBGRDN_B', 'ZPHOTO_B', 'ZTRAVDOM_B', 
#          'NETREV16')

r2_lm1 = rSquared(cust16train$NETREV16, cust16train$NETREV16 - predict(lm.fit, cust16train))
mse_lm1 = mean((cust16train$NETREV16 - predict(lm.fit,cust16train))^2)

lm_resids = cust16train$NETREV16 - predict(lm.fit, cust16train)
lm_resid_out = cbind(cust16train$NETREV16, predict(lm.fit, cust16train), lm_resids)
write.csv(lm_resid_out, 'lm_resid.csv')

ssr = sum((cust16train$NETREV16 - predict(lm.fit, cust16train))^2)
mae_lm = mean(abs(lm_resids))

# plot the actual vs predicted and R2
p = ggplot(aes(x=actual,y=pred),
           data=data.frame(actual=cust16train$NETREV16, pred=predict(lm.fit, cust16train)))
p + geom_point() + geom_abline(color='red') + ggtitle(paste(paste('Mulitple Linear Regression in R r^2=', round(r2_lm1,digits=4), sep=""), paste(' MSE=', round(mse_lm1, digits=1), sep=""), sep=""))

abs_resid = abs(cust16train$NETREV16 - predict(lm.fit, cust16train))

cust16train2 = cust16train
cust16train2$abs_resid = abs_resid
cust16train2 = cust16train2[cust16train2$abs_resid<85,c(keep_vars,'NETREV16')]

lm2.fit = lm(NETREV16 ~ ., data=cust16train2)
r2_lm2 = rSquared(cust16train2$NETREV16, cust16train2$NETREV16 - predict(lm2.fit, cust16train2))
mse_lm2 = mean((cust16train2$NETREV16 - predict(lm.fit,cust16train2))^2)
ssr_lm2 = sum((cust16train2$NETREV16 - predict(lm.fit, cust16train2))^2)
mae_lm2 = mean(abs(cust16train2$NETREV16 - predict(lm.fit,cust16train2)))

# plot the actual vs predicted and R2
p = ggplot(aes(x=actual,y=pred),
           data=data.frame(actual=cust16train2$NETREV16, pred=predict(lm2.fit, cust16train2)))
p + geom_point() + geom_abline(color='red') + ggtitle(paste(paste('Mulitple Linear Regression w/o Outlier in R r^2=', round(r2_lm2,digits=4), sep=""), paste(' MSE=', round(mse_lm2, digits=1), sep=""), sep=""))

# plot the residuals vs the predicted
p = ggplot(aes(x=pred,y=resid_lm),
           data=data.frame(pred=predict(lm2.fit, cust16train2), resid_lm=cust16train2$NETREV16 - predict(lm2.fit, cust16train2)))
p + geom_point() + ggtitle('Mulitple Linear Regression Residuals')

mse_lm_test = mean((cust16test$NETREV16 - predict(lm2.fit,cust16test))^2)
mae_lm_test = mean(abs(cust16test$NETREV16 - predict(lm2.fit,cust16test)))
rmse_lm_test = mse_lm_test^(1/2)

############################################
# Creation of Customer Score
############################################

# create new dataset of all customers who were not targeted in the 16th campaign
cust_df_not16 = cust_df[cust_df$ANY_MAIL_16 == 0,]

# create all of the custom fields for the new dataset
# create a binary variable to indicate if customer purchased before 16th campaign
cust_df_not16$TOTAMT_before_16 = cust_df_not16$TOTAMT - cust_df_not16$TOTAMT16
cust_df_not16$previousPurchase = ifelse(cust_df_not16$TOTAMT_before_16>0, 1, 0)

# create numeric variable to indicate how many times a customer has repsonded to previous compaigns
cust_df_not16$previousResponseCount = (cust_df_not16$RESPONSE0 + cust_df_not16$RESPONSE1 + cust_df_not16$RESPONSE2 + cust_df_not16$RESPONSE3 + cust_df_not16$RESPONSE4 + cust_df_not16$RESPONSE5
                                       + cust_df_not16$RESPONSE6 + cust_df_not16$RESPONSE7 + cust_df_not16$RESPONSE8 + cust_df_not16$RESPONSE9 + cust_df_not16$RESPONSE10 + cust_df_not16$RESPONSE11 + cust_df_not16$RESPONSE12
                                       + cust_df_not16$RESPONSE13 + cust_df_not16$RESPONSE14 + cust_df_not16$RESPONSE15)

# create binary variable to dinicate if a customer responded to previous campaign
cust_df_not16$previousResponse = ifelse(cust_df_not16$previousResponseCount>0, 1, 0)

# create variable to indicate TOAMT in relation to mean TOAMT
cust_df_not16$relativePurchase = cust_df_not16$TOTAMT_before_16 / mean(cust_df_not16$TOTAMT_before_16, na.rm=TRUE)

# Binary variables for buyer status
cust_df_not16$active = ifelse(cust_df_not16$BUYER_STATUS == 'ACTIVE', 1, 0)
cust_df_not16$inactive = ifelse(cust_df_not16$BUYER_STATUS == 'INACTIVE', 1, 0)

# binary variables for categorical variables
cust_df_not16$catalog = ifelse(cust_df_not16$CHANNEL_ACQUISITION == 'CB', 1, 0)
cust_df_not16$internet = ifelse(cust_df_not16$CHANNEL_ACQUISITION == 'IB', 1, 0)
cust_df_not16$homeowner = ifelse(cust_df_not16$HOMEOWNR == 'Y', 1, 0)
cust_df_not16$renter = ifelse(cust_df_not16$RENTER == 'Y', 1, 0)
cust_df_not16$children = ifelse(cust_df_not16$NUM_CHILD>0, 1, 0)
cust_df_not16$deceased = ifelse(cust_df_not16$Deceased_Indicator == 'D', 1, 0)
cust_df_not16$CHANNEL_DOMINANCE_A = ifelse(cust_df_not16$CHANNEL_DOMINANCE == 'A', 1, 0)
cust_df_not16$CHANNEL_DOMINANCE_C = ifelse(cust_df_not16$CHANNEL_DOMINANCE == 'C', 1, 0)
cust_df_not16$CHANNEL_DOMINANCE_E = ifelse(cust_df_not16$CHANNEL_DOMINANCE == 'E', 1, 0)
cust_df_not16$FIPSCNTY_97 = ifelse(cust_df_not16$FIPSCNTY == '097', 1, 0)
cust_df_not16$FIPSCNTY_111 = ifelse(cust_df_not16$FIPSCNTY == '111', 1, 0)
cust_df_not16$TRACT = as.numeric(cust_df_not16$TRACT)
cust_df_not16$MCD_CCD = as.numeric(cust_df_not16$MCD_CCD)
cust_df_not16$ADD_TYPE_A = ifelse(cust_df_not16$ADD_TYPE == 'A', 1, 0)
cust_df_not16$ADD_TYPE_M = ifelse(cust_df_not16$ADD_TYPE == 'M', 1, 0)
cust_df_not16$ADD_TYPE_S = ifelse(cust_df_not16$ADD_TYPE == 'S', 1, 0)
cust_df_not16$LOR1 = as.integer(cust_df_not16$LOR1)
cust_df_not16$OCC_GRP_I = ifelse(substr(cust_df_not16$OCCUPATION_GROUP,1,1)=='I', 1, 0)
cust_df_not16$OCC_GRP_K = ifelse(substr(cust_df_not16$OCCUPATION_GROUP,1,1)=='K', 1, 0)
cust_df_not16$M_HH_LEVEL_A = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'A', 1, 0)
cust_df_not16$M_HH_LEVEL_B = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'B', 1, 0)
cust_df_not16$M_HH_LEVEL_C = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'C', 1, 0)
cust_df_not16$M_HH_LEVEL_D = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'D', 1, 0)
cust_df_not16$M_HH_LEVEL_E = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'E', 1, 0)
cust_df_not16$M_HH_LEVEL_F = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'F', 1, 0)
cust_df_not16$M_HH_LEVEL_G = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'G', 1, 0)
cust_df_not16$M_HH_LEVEL_H = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'H', 1, 0)
cust_df_not16$M_HH_LEVEL_I = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'I', 1, 0)
cust_df_not16$M_HH_LEVEL_J = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'J', 1, 0)
cust_df_not16$M_HH_LEVEL_K = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'K', 1, 0)
cust_df_not16$M_HH_LEVEL_L = ifelse(substr(cust_df_not16$M_HH_LEVEL,1,1) == 'L', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_A = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'A', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_B = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'B', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_C = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'C', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_D = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'D', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_E = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'E', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_F = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'F', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_G = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'G', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_H = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'H', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_I = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'I', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_J = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'J', 1, 0)
cust_df_not16$M_GRPTYPE_MEDIAN_K = ifelse(substr(cust_df_not16$M_GRPTYPE_MEDIAN,1,1) == 'K', 1, 0)
cust_df_not16$M_GLOBAL_Z4_A = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'A', 1, 0)
cust_df_not16$M_GLOBAL_Z4_B = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'B', 1, 0)
cust_df_not16$M_GLOBAL_Z4_C = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'C', 1, 0)
cust_df_not16$M_GLOBAL_Z4_D = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'D', 1, 0)
cust_df_not16$M_GLOBAL_Z4_E = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'E', 1, 0)
cust_df_not16$M_GLOBAL_Z4_F = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'F', 1, 0)
cust_df_not16$M_GLOBAL_Z4_G = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'G', 1, 0)
cust_df_not16$M_GLOBAL_Z4_H = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'H', 1, 0)
cust_df_not16$M_GLOBAL_Z4_I = ifelse(cust_df_not16$M_GLOBAL_Z4 == 'I', 1, 0)
cust_df_not16$AD_WEB = as.numeric(cust_df_not16$AD_WEB)
cust_df_not16$AD_WEB = ifelse(is.na(cust_df_not16$AD_WEB), 0, cust_df_not16$AD_WEB)
cust_df_not16$AD_MAGAZINE = as.numeric(cust_df_not16$AD_MAGAZINE)
cust_df_not16$AD_MAGAZINE = ifelse(is.na(cust_df_not16$AD_MAGAZINE), 0, cust_df_not16$AD_MAGAZINE)
cust_df_not16$AD_NEWSPAPER = as.numeric(cust_df_not16$AD_NEWSPAPER)
cust_df_not16$AD_NEWSPAPER = ifelse(is.na(cust_df_not16$AD_NEWSPAPER), 0, cust_df_not16$AD_NEWSPAPER)
cust_df_not16$AD_RADIO = as.numeric(cust_df_not16$AD_RADIO)
cust_df_not16$AD_RADIO = ifelse(is.na(cust_df_not16$AD_RADIO), 0, cust_df_not16$AD_RADIO)
cust_df_not16$AD_TV = as.numeric(cust_df_not16$AD_TV)
cust_df_not16$AD_TV = ifelse(is.na(cust_df_not16$AD_TV), 0, cust_df_not16$AD_TV)

#create netrev feature
cust_df_not16$NETREV16 = (0.1 * cust_df_not16$TOTAMT16)

# create list for "Z" variables to keep.
z_vars = c('ZCREDIT', 'ZCRAFTS', 'ZGOURMET', 'ZCOMPUTR', 'ZHITECH', 'ZONLINE', 'ZSPENDER', 'PRESENCE_OF_SMOKER', 'ZGOLFERS', 'ZDONORS', 'ZPETS', 'ZARTS', 'ZMOB', 'ZFITNESS', 'ZOUTDOOR', 'ZTRAVANY', 'ZINVESTR', 'ZAUTOOWN', 'ZGARDEN', 'ZCOLLECT', 'ZCRUISE', 'ZSPORTS', 'ZSWEEPS', 'ZPOLITIC', 'ZMUSIC', 'ZREAD', 'ZCHLDPRD', 'ZDIY', 'ZSELFIMP', 'ZRELIGON', 'ZGRANDPR', 'ZCLOTHNG', 'ZDONENVR', 'ZMUTUAL', 'ZWGHTCON', 'ZPRCHPHN', 'ZPRCHTV', 'ZMOBMULT', 'ZCREDPLT', 'ZDOGS', 'ZCATS', 'ZHEALTH', 'ZAUTOINT', 'ZSKIING', 'ZASTRLGY', 'ZBOATS', 'ZCELL', 'ZCOMMCON', 'ZHMDECOR', 'ZHOMEENT', 'ZKITCHEN', 'ZMOBAV', 'ZMOBBOOK', 'ZMOBCLTH', 'ZMOBFIN', 'ZMOBGIFT', 'ZMOBGRDN', 'ZMOBJWL', 'ZMUSCLAS', 'ZMUSCNTR', 'ZMUSCRST', 'ZMUSOLDI', 'ZMUSROCK', 'ZPBCARE', 'ZPHOTO', 'ZPRCHONL', 'ZTENNIS', 'ZTRAVDOM', 'ZTRAVFOR', 'ZVOLUNTR')

# create a for loop to generate new dummy variables for "Z" variables
for (i in 1:length(z_vars)){
  cust_df_not16[paste(z_vars[i],"_B", sep="")] = as.numeric(ifelse(cust_df_not16[z_vars[i]] == "Y", 1, 0))
}

# glmnet model for probability of response
cust_df_not16$ResponseProb = predict(object=objModel, cust_df_not16[,keep_vars])

# random forest model for expected net revenue
cust_df_not16$NETREV_EST = predict(rf_NETREV_2, cust_df_not16[,c(keep_vars, 'NETREV16')])

# create final score
cust_df_not16$Score = cust_df_not16$ResponseProb * cust_df_not16$NETREV_EST - 1

write.csv(cust_df_not16, 'final_score.csv')
