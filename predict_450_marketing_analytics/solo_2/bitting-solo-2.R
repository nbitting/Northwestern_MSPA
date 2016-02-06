# Nate Bitting
# Micro 2

setwd('/Users/nbitting/Google Drive/PREDICT 450/Solo2')
setwd('C:/Users/nbitting-pc/Google Drive/PREDICT 450/Solo2')
load('stc-cbc-respondents-v6.RData')
resp = resp.data.v5mod
task = read.csv('stc-dc-task-cbc-v6.csv')
scenarios = read.csv('stc-extra-scenarios-v6.csv')

library(dummies)

zowner = resp$STCowner = ifelse(resp$STCowner > 0, 1, 0)
zgender = resp$Gen = ifelse(resp$Gen == 1, 1, 0)

task.matrix = as.matrix(task[,3:7])
colnames(task.matrix) = colnames(task[,3:7])
X.mat = efcode.attmat.nate(task.matrix)
pricevec = task$price-mean(task$price)
X.brands = X.mat[,9:11]
colnames(X.brands) = colnames(X.mat[,9:11])
X.BrandByPrice = X.brands*pricevec
colnames(X.BrandByPrice) = c('brand1ByPrice', 'brand2ByPrice', 'brand3ByPrice')
X.matrix = cbind(X.mat,X.BrandByPrice)
dim(X.matrix)
det(t(X.matrix)%*%X.matrix)

## SET UP YDATA1 W/OUT STC OWNER / GENDER ##
ydata = resp[,3:38]
ydata = na.omit(ydata)
ydata = as.matrix(ydata)

lgtdata = NULL # a starter placeholder for your list
for (i in 1:360)  {
  lgtdata[[i]]=list(y=ydata[i,],X=X.matrix)
}

lgtdata[[3]] # look at the 3rd respondant's results

table(ydata)


# load bayesm library
library(bayesm)

## MODEL 1 WITHOUT GENDER OR STC OWNERSHIP ##
mcmctest = list(R=30000, keep=30)
Data1 = list(p=3, lgtdata=lgtdata)
testrun1 = rhierMnlDP(Data=Data1, Mcmc=mcmctest)
names(testrun1)
dim(testrun1$betadraw)
betadraw1 = testrun1$betadraw
dim(betadraw1)
dimnames(betadraw1) = list(NULL, colnames(X.matrix), NULL)
plot(betadraw1[3,2,])
abline(h=0)
plot(density(betadraw1[3,2,801:1000], width=2))
summary(betadraw1[3,2,801:1000])
meanBetas = apply(betadraw1[,,701:1000], 2, mean)
round(meanBetas,3)
plot(meanBetas, main="Mean Betas for Model 1")
abline(h=0, lty=2)
betameans = apply(testrun1$betadraw[,,701:1000], c(1,2), mean)
xbeta = X.matrix2%*%t(betameans)
xbeta2 = matrix(xbeta, ncol=3, byrow=TRUE)
expxbeta2=exp(xbeta2)
rsumvec = rowSums(expxbeta2)
pchoicemat = expxbeta2/rsumvec
round(apply(pchoicemat,2,quantile,probs=c(0.10,0.25,0.5,0.75,0.90)),4)
plot(meanBetas, main="Mean Betas for Model 1")
abline(h=0)
betaMeanChains1 = apply(betadraw1, c(2:3), mean)
plot(betaMeanChains1, type="p")
apply(betadraw1[,,801:1000],c(1,2),mean)
betamat=testrun1$betadraw[,14,701:1000]
zp=apply(betamat,1,getp.f)
betaDiffZero=rep(0,nrow(betamat))
betaDiffZero[zp <= 0.05 | zp>= 0.95] = 1
respDiffBetas=betamat[betaDiffZero==1,]
dim(respDiffBetas)

# Comparing Betas (looking at respondent 1's 7th and 8th coefficients - price attribute)
summary(betadraw1[1,7,801:1000]-betadraw1[1,8,801:1000])
plot(density(betadraw1[1,7,801:1000]-betadraw1[1,8,801:1000],width=2.5))
abline(v=mean(betadraw1[1,7,801:1000]-betadraw1[1,8,801:1000]),lty=2)
view(betadraw1[1])

# Correlation Matrix for X.matrix
cor.matrix = cor(X.matrix)

sum(lgtdata1[[10]]$y)
table(lgtdata1[[21]]$y)

table(testrun1$Istardraw)
zownerc=matrix(scale(zowner,scale=FALSE),ncol=1)
zgenderc=matrix(scale(zgender,scale=FALSE),ncol=1)
zmatrix = cbind(zownerc, zgenderc)

## MODEL 2 WITH GENDER OR STC OWNERSHIP ##
mcmctest = list(R=30000, keep=30)
Data2 = list(p=3, lgtdata=lgtdata, Z=zmatrix)
testrun2 = rhierMnlDP(Data=Data2, Mcmc=mcmctest)
names(testrun2)
dim(testrun2$betadraw)
betadraw2 = testrun1$betadraw
dim(betadraw2)
dimnames(betadraw2) = list(NULL, colnames(X.matrix), NULL)
plot(betadraw2[3,2,])
abline(h=0)
plot(density(betadraw2[,1,801:1000], width=2), main='Betas for 16 Gb Ram')
abline(v=0, lty=2)
summary(betadraw2[3,2,801:1000])
apply(betadraw2[,,801:1000], 2, mean)
meanBetas2 = apply(betadraw2[,,801:1000], 2, mean)
trace<-t(apply(betadraw2,c(2,3),mean))
matplot(trace, type="l", main='Betadraw Plot')
plot(testrun2$loglike, type='l', main='Log Likelihood Plot')
plot(meanBetas2, main="Mean Betas for Model 2")
abline(h=0, lty=2)
plot(apply(testrun2$Deltadraw[801:1000,1:14],2,mean), main="STCOwner impact Mean DeltaDraws", ylab='Mean DeltaDraws') # see the mean for STCOwner
abline(h=0, lty=2)
plot(apply(testrun2$Deltadraw[801:1000,15:28],2,mean), main="Gender impact Mean DeltaDraws", ylab='Mean DeltaDraws') # see the mean for STCOwner
abline(h=0, lty=2)
round(apply(testrun2$Deltadraw[801:1000,],2,quantile,probs=c(0.10,0.25,0.5,0.75,0.90)),4)
betaMeanChains2 = apply(betadraw2, c(2:3), mean)
plot(betaMeanChains2)
apply(betadraw2[,,801:1000],c(1,2),mean)
dim(testrun2$Deltadraw)
deltaDraws = testrun2$Deltadraw
apply(deltaDraws[,1:14])

# Comparing Betas (looking at respondent 1's 7th and 8th coefficients - price attribute)
summary(betadraw2[1,7,801:1000]-betadraw2[1,8,801:1000])
plot(density(betadraw2[1,7,801:1000]-betadraw2[1,8,801:1000],width=2.5))
abline(v=mean(betadraw2[1,7,801:1000]-betadraw2[1,8,801:1000]),lty=2)

# Correlation Matrix for X.matrix
cor.matrix = cor(X.matrix)

sum(lgtdata2[[10]]$y)
table(lgtdata2[[21]]$y)

table(testrun2$Istardraw)

#################################
# ESTIMATE NEW SCENARIO SHARES
#################################

task.matrix2 = as.matrix(scenarios[,2:6])
colnames(task.matrix2) = colnames(scenarios[,2:6])
X.mat2 = efcode.attmat.nate(task.matrix)
pricevec2 = scenarios$price-mean(scenarios$price)
X.brands2 = X.mat2[,9:11]
colnames(X.brands2) = colnames(X.mat2[,9:11])
X.BrandByPrice2 = X.brands2*pricevec
colnames(X.BrandByPrice2) = c('brand2ByPrice', 'brand3ByPrice', 'brand4ByPrice')
X.matrix2 = cbind(X.mat2,X.BrandByPrice2)
x.mat2.df = data.frame(X.matrix2)

predict.hb.mnl(testrun1$betadraw, data.frame(X.matrix))

##################################
# FUNCTIONS
##################################

efcode.att.nate = function(xvec, colname=""){
  
  require(dummies)    # throw exception if not available
  att.mat=dummy(xvec)    # att.mat is dummy code mat
  ref.ndx=att.mat[,1]    # 1st col used to locate ref level
  att.mat=att.mat[,-1]   # drop 1st col
  if(!is.matrix(att.mat)){
    att.mat=matrix(att.mat,ncol=1)  # in case att is two level
  }
  att.mat[ref.ndx==1,]=-1  # set ref level to -1's.
  
  natts=ncol(att.mat)
  name.list = c(NA)
  for (j in 1:natts){    # attribs loop
    name.list = cbind(name.list, paste(colname,j+1))
  }
  colnames(att.mat) = name.list[,-1]
  return(att.mat)   
}

efcode.attmat.nate = function(attmat){
  
  require(dummies)
  if(!is.matrix(attmat)){
    cat("Oops! attmat input should be type matrix.\n")
    return()
  }
  natts=ncol(attmat)   #no. of attributes
  efmat=matrix(data=NA,ncol=1,nrow=nrow(attmat))  #placeholder
  for (j in 1:natts){    # attribs loop
    dummat=efcode.att.nate(as.numeric(attmat[,j]), colnames(attmat)[j])
    efmat=cbind(efmat,dummat)
  }
  efmat=efmat[,-1] #drop 1st col that has NA's
  return(efmat)
}

getp.f=function(x,y=0){
  pfcn=ecdf(x)
  return(pfcn(y))
}

predict.hb.mnl <- function(betadraws, data) {
  # Function for predicting shares from a hierarchical multinomial logit model
  # betadraws: matrix of betadraws returned by ChoiceModelIR
  # data: a data frame containing the set of designs for which you want to
  # predict shares. Same format at the data used to estimate model.
  data.model <- model.matrix(~ RAM.2 + RAM.3 + processor.2 + processor.3 + screen.2 + screen.3 + price.2 + price.3 + brand.2 + brand.3 + brand1ByPrice + brand2ByPrice + brand3ByPrice, data = data)
  data.model <- data.model[,-1] # remove the intercept
  nresp <- dim(betadraws)[1]
  ndraws <- dim(betadraws)[3]
  shares <- array(dim=c(nresp, nrow(data), ndraws))
  for (d in 1:ndraws) {
    for (i in 1:nresp) {
      utility <- data.model%*%betadraws[i,,d]
      shares[i,,d] = exp(utility)/sum(exp(utility))
    }
  }
  shares.agg <- apply(shares, 2:3, mean)
  cbind(share=apply(shares.agg, 1, mean), pct=t(apply(shares.agg, 1, quantile, probs=c(0.05, 0.95))), data)
}
