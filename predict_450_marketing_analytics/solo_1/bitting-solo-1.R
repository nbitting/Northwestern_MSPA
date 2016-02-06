# Nate Bitting
# PREDICT 450
# Solo 1

# ----------------------------
# Project Setup and Data Prep
# ----------------------------
# set working directory
setwd('/Users/nbitting/Google Drive/PREDICT 450/Solo1') # Mac
setwd('C:/Users/nbitting-pc/Google Drive/PREDICT 450/Solo1') # Windows

# load in the app happy dataset
load('appHappyData-fa2015.RData')

# leverage the numeric represenation of the data
num.frame = apphappy.4.num.frame

# subset the data to just the attitudinal variables
att.frame = num.frame[,c(39:78)]

# check num of rows for dataset (1663)
dim(att.frame)

# confirm no missing values
dim(na.omit(att.frame)) 

# read in the labels dataframe
labs.frame = apphappy.4.labs.frame

# check for total # of observations
dim(labs.frame)

# see if there are any missing values (identified 585 observations with missing values)
dim(na.omit(labs.frame))

# ----------------------------
# K-Means Clustering
# ----------------------------

# Import all of the packages needed to perform the k-means clustering
library(cluster)
library(fpc)
library(stats)
library(plyr)
library(ggplot2)
library(NbClust)

par(mfrow=c(1,1))
par(mar=c(6, 6, 4.1, 1))

# run the kmeans clustering function
wss <- (nrow(att.frame)-1)*sum(apply(att.frame,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(att.frame,
                                     centers=i)$withinss)

# plot the SSE vs Clusters to determine number of clusters
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares", main="K-means WSS vs Number of Clusters")

# leverage NbClust package to determine number of clusters
nc = NbClust(att.frame, min.nc=2, max.nc=15, method="kmeans")
table(nc$Best.n[1,])

# plot the number of cluster recommendation from NbClust
barplot(table(nc$Best.n[1,]),
        xlab="Numer of Clusters", ylab="Number of Criteria",
        main="Kmeans - NbClust Number of Clusters")

# run the kmeans cluster function for 2 clusters (based NbClust and SSE vs Cluster results)
set.seed(999)
km = kmeans(att.frame, 2)
means = aggregate(att.frame, by=list(km$cluster), FUN=mean)

clusplot(att.frame, km$cluster, color=TRUE, shade=TRUE, labels=2, lines=o, main='K-means Cluster Plot')

# plot the clusters to see if there is good separation/pooling of observations
plotcluster(att.frame, km$cluster)

# create new cluster column with cluster labels
att.frame$cluster = km$cluster
labs.frame$cluster = km$cluster
num.frame$cluster = km$cluster

# explore the demographic and preference variables
with(labs.frame, table(q1, cluster)) # age (chi-squared result: difference)
with(labs.frame, table(q2r1, cluster)) # iPhone (chi-squared result: difference)
with(labs.frame, table(q2r2, cluster)) # iPod touch (chi-squared result: difference)
with(labs.frame, table(q2r3, cluster)) # Android (no difference between clusters)
with(labs.frame, table(q2r4, cluster)) # Blackberry (chi-squared result: difference)
with(labs.frame, table(q2r5, cluster)) # Nokia Phone (chi-squared result: difference)
with(labs.frame, table(q2r6, cluster)) # Windows Phone (chi-squared result: difference)
with(labs.frame, table(q2r7, cluster)) # Palm WebOS (chi-squared result: difference)
with(labs.frame, table(q2r8, cluster)) # Use tablets? (chi-squared result: difference)
with(labs.frame, table(q4r1, cluster)) # Music identification apps (chi-squared result: difference)
with(labs.frame, table(q4r2, cluster)) # TV check-in apps (chi-squared result: difference)
with(labs.frame, table(q4r3, cluster)) # Entertainment apps (chi-squared result: difference))
with(labs.frame, table(q4r4, cluster)) # TV show apps (chi-squared result: difference)
with(labs.frame, table(q4r5, cluster)) # gaming apps (chi-squared result: difference)
with(labs.frame, table(q4r6, cluster)) # social networking apps (chi-squared result: difference)
with(labs.frame, table(q4r7, cluster)) # general news apps (chi-squared result: difference)
with(labs.frame, table(q4r8, cluster)) # shopping apps (chi-squared result: difference)
with(labs.frame, table(q4r9, cluster)) # specific pub news apps (chi-squared result: difference)
with(labs.frame, table(q11, cluster)) # num of install apps (chi-squared result: difference)
with(labs.frame, table(q12, cluster)) # % of free apps (chi-squared result: difference)
with(labs.frame, table(q13r1, cluster)) # facebook (chi-squared result: difference)
with(labs.frame, table(q13r2, cluster)) # Twitter (chi-squared result: difference)
with(labs.frame, table(q13r3, cluster)) # Myspace (chi-squared result: difference)
with(labs.frame, table(q13r4, cluster)) # Pandora (chi-squared result: difference)
with(labs.frame, table(q13r5, cluster)) # Vevo (chi-squared result: difference)
with(labs.frame, table(q13r6, cluster)) # YouTube (chi-squared result: difference)
with(labs.frame, table(q13r7, cluster)) # AOL Radio (chi-squared result: difference)
with(labs.frame, table(q13r8, cluster)) # Last.fm (chi-squared result: difference)
with(labs.frame, table(q13r9, cluster)) # Yahoo (chi-squared result: difference)
with(labs.frame, table(q13r10, cluster)) # IMDB (chi-squared result: difference)
with(labs.frame, table(q13r11, cluster)) # LinkedIn (chi-squared result: difference)
with(labs.frame, table(q13r12, cluster)) # Netflix (chi-squared result: difference)
with(labs.frame, table(q48, cluster)) # education (chi-squared result: difference)
with(labs.frame, table(q49, cluster)) # marital_status (chi-squared result: difference)
with(labs.frame, table(q54, cluster)) # race (chi-squared result: difference)
with(labs.frame, table(q56, cluster)) # income (no difference between clusters)
with(labs.frame, table(q57, cluster)) # gender (no difference between clusters)

# explore attitudinal differences for Q24
with(labs.frame, table(q24r1, cluster)) # Keeping up w/ Tech developments (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r2, cluster)) # People ask me for advice on tech purchases (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r3, cluster)) # Enjoy purchsing new gadgets (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r4, cluster)) # Too much tech in everyday life (chi-squared result: difference) (t.test result: difference)
with(labs.frame, table(q24r5, cluster)) # tech gives more control (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r6, cluster)) # look for web apps to save time (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r7, cluster)) # Music important (chi-squared result: difference) (t.test result: no diff) (t.test result: no diff)
with(labs.frame, table(q24r8, cluster)) # Like learning about TV shows when not watching (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r9, cluster)) # Too much info out there (chi-squared result: difference) (t.test result: difference)
with(labs.frame, table(q24r10, cluster)) # Always checking on friends/fam facebook (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r11, cluster)) # Internet makes it easier to keep in touch (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q24r12, cluster)) # Internet makes it easier to avoid friends/fam (chi-squared result: difference) (t.test result: no diff)

# explore attitudinal differences for Q25
with(labs.frame, table(q25r1, cluster)) # consider myself opinion leader (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r2, cluster)) # i like to stand out from others (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r3, cluster)) # I like to give advice (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r4, cluster)) # I take lead in decision making (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r5, cluster)) # first of friend/fam to try new things (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r6, cluster)) # id rather be told what to do (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r7, cluster)) # I like being in control (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r8, cluster)) # I'm a risk taker (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r9, cluster)) # I think I'm creative (chi-squared result: difference) (t.test result: no diff)
with(labs.frame, table(q25r10, cluster)) 
with(labs.frame, table(q25r11, cluster))
with(labs.frame, table(q25r12, cluster))

# address missing values - calc means
q12_mean = round(mean(num.frame$q12, na.rm=T), 0)
q57_mode = mode(na.omit(num.frame)$q57)
num.frame$q12[is.na(num.frame$q12)] = q12_mean
num.frame$q57

# Cluster Profiling
profile_means = ddply(num.frame, .(num.frame$cluster), colwise(mean))
cluster1 = subset(num.frame, num.frame$cluster == 1)
cluster2 = subset(num.frame, num.frame$cluster == 2)

table(cluster1$q57)
table(cluster2$q57)

plot(profile_means$q1, type="b", main="Age by Cluster")
plot(profile_means$q11, type="b", main="# of Apps by Cluster")
plot(profile_means$q12, type="b", main="% of Free Apps by Cluster")
plot(profile_means$q48, type="b", main="Education by Cluster")
plot(profile_means$q49, type="b", main="Martial Status by Cluster")
plot(profile_means$q54, type="b", main="Ethnicity by Cluster")
plot(profile_means$q56, type="b", main="Income by Cluster")

# ----------------------------
# Hierarchical Clustering
# ----------------------------

hdata = dist(att.frame, method='euclidean')
tree = hclust(hdata, method='ward')
plot(tree, main='HClust Dendogram')
groups = cutree(tree, k=3)
rect.hclust(tree, k=3, border='red')

num.frame$hcluster = groups
labs.frame$hcluster = groups
att.frame$hcluster = groups

profile_means_hclust = ddply(num.frame, .(num.frame$hcluster), colwise(mean))

# QUESTION 2 - do you use any of these type of devices
anova(aov(q2r1~hcluster, data=num.frame)) # iphone (is a difference)
anova(aov(q2r2~hcluster, data=num.frame)) # iPod touch
anova(aov(q2r3~hcluster, data=num.frame)) # android
anova(aov(q2r4~hcluster, data=num.frame)) # blackberry
anova(aov(q2r5~hcluster, data=num.frame)) # nokia
anova(aov(q2r6~hcluster, data=num.frame)) # windows phone
anova(aov(q2r7~hcluster, data=num.frame)) # hp/palm
anova(aov(q2r8~hcluster, data=num.frame)) # tablet (is a difference)
anova(aov(q2r9~hcluster, data=num.frame)) # other

# QUESTION 4 - do you use any of these types of apps
anova(aov(q4r1~hcluster, data=num.frame)) # Music and Sound Identification (Difference)
anova(aov(q4r2~hcluster, data=num.frame)) # TV Check-in Apps (Difference)
anova(aov(q4r3~hcluster, data=num.frame)) # Entertainment Apps (Difference)
anova(aov(q4r4~hcluster, data=num.frame)) # TV Show Apps (Glee) (Difference)
anova(aov(q4r5~hcluster, data=num.frame)) # Gaming Apps (Difference)
anova(aov(q4r6~hcluster, data=num.frame)) # Social Networking Apps (Difference)
anova(aov(q4r7~hcluster, data=num.frame)) # General News apps (Yahoo! News) (Difference)
anova(aov(q4r8~hcluster, data=num.frame)) # Shopping Apps (Difference) (Difference)
anova(aov(q4r9~hcluster, data=num.frame)) # Special Pub News (NYT) (Difference)

# QUESTION 11 - How many apps
anova(aov(q11~hcluster, data=num.frame)) # is a difference

# QUESTION 12 - what percent were free to download?
anova(aov(q12~hcluster, data=num.frame)) # is a difference

# QUESTION 13 - how many times per week do you visit these sites?
anova(aov(q13r1~hcluster, data=num.frame)) # Facebook (Difference)
anova(aov(q13r2~hcluster, data=num.frame)) # Twitter (Difference)
anova(aov(q13r3~hcluster, data=num.frame)) # Myspace
anova(aov(q13r4~hcluster, data=num.frame)) # Pandora Radio(Difference)
anova(aov(q13r5~hcluster, data=num.frame)) # Vevo (Difference)
anova(aov(q13r6~hcluster, data=num.frame)) # YouTube (Difference)
anova(aov(q13r7~hcluster, data=num.frame)) # AOL Radio
anova(aov(q13r8~hcluster, data=num.frame)) # Last.fm
anova(aov(q13r9~hcluster, data=num.frame)) # Yahoo Entertainment/Music (Difference)
anova(aov(q13r10~hcluster, data=num.frame)) # IMDB (Difference)
anova(aov(q13r11~hcluster, data=num.frame)) # LinkedIn (Difference)
anova(aov(q13r12~hcluster, data=num.frame)) # Netflix (Difference)

# QUESTION 24
anova(aov(q24r1~hcluster, data=num.frame)) # keep up with tech developments
anova(aov(q24r2~hcluster, data=num.frame)) # peopel ask my advice when looking to buy new tech (Difference)
anova(aov(q24r3~hcluster, data=num.frame)) # enjoy purchasing new gadgets (Difference)
anova(aov(q24r4~hcluster, data=num.frame)) # think there is too much tech (Difference)
anova(aov(q24r5~hcluster, data=num.frame)) # enjoy using tech to give me more control (Difference)
anova(aov(q24r6~hcluster, data=num.frame)) # look for web tools that save time (Difference)
anova(aov(q24r7~hcluster, data=num.frame)) # music is important part of my life(Difference) 
anova(aov(q24r8~hcluster, data=num.frame)) # i like learning more about TV shows when I'm not watching (Difference)
anova(aov(q24r9~hcluster, data=num.frame)) # I think there is too much info from sites like FB (Difference)
anova(aov(q24r10~hcluster, data=num.frame)) # i'm always checking on friends on fb or other sites (Difference)
anova(aov(q24r11~hcluster, data=num.frame)) # the internet makes it easier to keep in touch with f&f (Difference)
anova(aov(q24r12~hcluster, data=num.frame)) # the internet makes it easier to avoid having to speak to F&F (Difference)

# QUESTION 25
anova(aov(q25r1~hcluster, data=num.frame)) # I consider myself an opinion leader (difference)
anova(aov(q25r2~hcluster, data=num.frame)) # i like to stand out (difference)
anova(aov(q25r3~hcluster, data=num.frame)) # i like to offer advice (difference)
anova(aov(q25r4~hcluster, data=num.frame)) # i like to take lead in decisions (difference)
anova(aov(q25r5~hcluster, data=num.frame)) # i'm the first of my f&f to try new things (difference)
anova(aov(q25r6~hcluster, data=num.frame)) # responsibility is overrated; I'd rather be told what to do (difference)
anova(aov(q25r7~hcluster, data=num.frame)) # i like being in control (difference)
anova(aov(q25r8~hcluster, data=num.frame)) # i'm a risk taker (difference)
anova(aov(q25r9~hcluster, data=num.frame)) # I think of myself as creative (difference)
anova(aov(q25r10~hcluster, data=num.frame)) # I'm an optimist (difference)
anova(aov(q25r11~hcluster, data=num.frame)) # I am very active and always on the go (difference)
anova(aov(q25r12~hcluster, data=num.frame)) # I always feel stretched for time (difference)

# QUESTION 26
anova(aov(q26r1~hcluster, data=num.frame)) # 
anova(aov(q26r2~hcluster, data=num.frame))
anova(aov(q26r3~hcluster, data=num.frame))
anova(aov(q26r4~hcluster, data=num.frame))
anova(aov(q26r5~hcluster, data=num.frame))
anova(aov(q26r6~hcluster, data=num.frame))
anova(aov(q26r7~hcluster, data=num.frame))
anova(aov(q26r8~hcluster, data=num.frame))
anova(aov(q26r9~hcluster, data=num.frame))
anova(aov(q26r10~hcluster, data=num.frame))

# DEFINE FUNCTION TO APPLY GLM TO EACH COLUMN AGAINST SEGMENT
apply.glm.f=function(y,class){return(glm(y~class)$aic)}
item.aic=data.frame(apply(num.frame, 2, apply.glm.f, class=num.frame$hcluster))
item.aic.att=data.frame(apply(att.frame, 2, apply.glm.f, class=att.frame$hcluster))

# DEFINE FUNCTION TO APPLY CHISQ TEST ASSUMING DATA IS CATEGORICAL
sim.chisq.pval.f=function(x,class){return(chisq.test(x,class,rescale.p=TRUE,simulate.p.value=TRUE)$p.value)}
item.chi.p=data.frame(apply(att.frame,2,sim.chisq.pval.f,class=att.frame$hcluster))

# ----------------------------
# CLUSTER PROFILING
# ----------------------------

cluster1 = subset(num.frame, num.frame$hcluster == 1)
cluster2 = subset(num.frame, num.frame$hcluster == 2)
cluster3 = subset(num.frame, num.frame$hcluster == 3)

# q2 phone proportions cluster 1
c1_iphone = sum(cluster1$q2r1)/nrow(cluster1)
c1_ipod = sum(cluster1$q2r2)/nrow(cluster1)
c1_android = sum(cluster1$q2r3)/nrow(cluster1)
c1_blackberry = sum(cluster1$q2r4)/nrow(cluster1)
c1_nokia = sum(cluster1$q2r5)/nrow(cluster1)
c1_windows = sum(cluster1$q2r6)/nrow(cluster1)
c1_webos = sum(cluster1$q2r7)/nrow(cluster1)
c1_tablet = sum(cluster1$q2r8)/nrow(cluster1)
c1_other_phone = sum(cluster1$q2r9)/nrow(cluster1)

# q2 phone proportions cluster 2
c2_iphone = sum(cluster2$q2r1)/nrow(cluster2)
c2_ipod = sum(cluster2$q2r2)/nrow(cluster2)
c2_android = sum(cluster2$q2r3)/nrow(cluster2)
c2_blackberry = sum(cluster2$q2r4)/nrow(cluster2)
c2_nokia = sum(cluster2$q2r5)/nrow(cluster2)
c2_windows = sum(cluster2$q2r6)/nrow(cluster2)
c2_webos = sum(cluster2$q2r7)/nrow(cluster2)
c2_tablet = sum(cluster2$q2r8)/nrow(cluster2)
c2_other_phone = sum(cluster2$q2r9)/nrow(cluster2)

# q2 phone proportions cluster 3
c3_iphone = sum(cluster3$q2r1)/nrow(cluster3)
c3_ipod = sum(cluster3$q2r2)/nrow(cluster3)
c3_android = sum(cluster3$q2r3)/nrow(cluster3)
c3_blackberry = sum(cluster3$q2r4)/nrow(cluster3)
c3_nokia = sum(cluster3$q2r5)/nrow(cluster3)
c3_windows = sum(cluster3$q2r6)/nrow(cluster3)
c3_webos = sum(cluster3$q2r7)/nrow(cluster3)
c3_tablet = sum(cluster3$q2r8)/nrow(cluster3)
c3_other_phone = sum(cluster3$q2r9)/nrow(cluster3)

# plot phone preferences
clus1_phone = data.frame(rbind(c1_iphone, c1_ipod, c1_android, c1_blackberry, c1_nokia, c1_windows, c1_webos, c1_tablet, c1_other_phone))
rownames(clus1_phone) = c('iphone', 'ipod', 'android', 'blackberry', 'nokia', 'windows', 'webos', 'tablet', 'other')

clus2_phone = data.frame(rbind(c2_iphone, c2_ipod, c2_android, c2_blackberry, c2_nokia, c2_windows, c2_webos, c2_tablet, c2_other_phone))
rownames(clus2_phone) = c('iphone', 'ipod', 'android', 'blackberry', 'nokia', 'windows', 'webos', 'tablet', 'other')

clus3_phone = data.frame(rbind(c3_iphone, c3_ipod, c3_android, c3_blackberry, c3_nokia, c3_windows, c3_webos, c3_tablet, c3_other_phone))
rownames(clus3_phone) = c('iphone', 'ipod', 'android', 'blackberry', 'nokia', 'windows', 'webos', 'tablet', 'other')

par(mar=c(6, 3, 4.1, 1))
par(mfrow=c(1,3))

x = barplot(clus1_phone[,1], names.arg=rownames(clus1_phone), las=2, main='Cluster 1 - Phone Prefs', ylim=c(0,0.6))

y = barplot(clus2_phone[,1], names.arg=rownames(clus2_phone), las=2, main='Cluster 2 - Phone Prefs', ylim=c(0,0.6))

z = barplot(clus3_phone[,1], names.arg=rownames(clus3_phone), las=2, main='Cluster 3 - Phone Prefs', ylim=c(0,0.6))

# q2 phone proportions cluster 1
c1_music = sum(cluster1$q4r1)/nrow(cluster1)
c1_tvcheckin = sum(cluster1$q4r2)/nrow(cluster1)
c1_entertainment = sum(cluster1$q4r3)/nrow(cluster1)
c1_tvshow = sum(cluster1$q4r4)/nrow(cluster1)
c1_gaming = sum(cluster1$q4r5)/nrow(cluster1)
c1_socialnet = sum(cluster1$q4r6)/nrow(cluster1)
c1_generalnews = sum(cluster1$q2r7)/nrow(cluster1)
c1_shopping = sum(cluster1$q4r8)/nrow(cluster1)
c1_specificpubnews = sum(cluster1$q4r9)/nrow(cluster1)
c1_otherapps = sum(cluster1$q4r10)/nrow(cluster1)
c1_none = sum(cluster1$q4r11)/nrow(cluster1)

# q2 phone proportions cluster 2
c2_music = sum(cluster2$q4r1)/nrow(cluster2)
c2_tvcheckin = sum(cluster2$q4r2)/nrow(cluster2)
c2_entertainment = sum(cluster2$q4r3)/nrow(cluster2)
c2_tvshow = sum(cluster2$q4r4)/nrow(cluster2)
c2_gaming = sum(cluster2$q4r5)/nrow(cluster2)
c2_socialnet = sum(cluster2$q4r6)/nrow(cluster2)
c2_generalnews = sum(cluster2$q2r7)/nrow(cluster2)
c2_shopping = sum(cluster2$q4r8)/nrow(cluster2)
c2_specificpubnews = sum(cluster2$q4r9)/nrow(cluster2)
c2_otherapps = sum(cluster2$q4r10)/nrow(cluster2)
c2_none = sum(cluster2$q4r11)/nrow(cluster2)

# q2 phone proportions cluster 2
c3_music = sum(cluster3$q4r1)/nrow(cluster3)
c3_tvcheckin = sum(cluster3$q4r2)/nrow(cluster3)
c3_entertainment = sum(cluster3$q4r3)/nrow(cluster3)
c3_tvshow = sum(cluster3$q4r4)/nrow(cluster3)
c3_gaming = sum(cluster3$q4r5)/nrow(cluster3)
c3_socialnet = sum(cluster3$q4r6)/nrow(cluster3)
c3_generalnews = sum(cluster3$q2r7)/nrow(cluster3)
c3_shopping = sum(cluster3$q4r8)/nrow(cluster3)
c3_specificpubnews = sum(cluster3$q4r9)/nrow(cluster3)
c3_otherapps = sum(cluster3$q4r10)/nrow(cluster3)
c3_none = sum(cluster3$q4r11)/nrow(cluster3)

# plot app preferences
clus1_apps = data.frame(rbind(c1_music, c1_tvcheckin, c1_entertainment, c1_tvshow, c1_gaming, c1_socialnet, c1_generalnews, c1_shopping, c1_specificpubnews, c1_otherapps, c1_none))
rownames(clus1_apps) = c('Music/Sound Identification', 'TV Check-in', 'Entertainment', 'TV Shows (i.e. Glee)', 'Gaming', 'Social Networking', 'General News', 'Shopping', 'Specific News Publications', 'Other', 'None')

clus2_apps = data.frame(rbind(c2_music, c2_tvcheckin, c2_entertainment, c2_tvshow, c2_gaming, c2_socialnet, c2_generalnews, c2_shopping, c2_specificpubnews, c2_otherapps, c2_none))
rownames(clus2_apps) = c('Music/Sound Identification', 'TV Check-in', 'Entertainment', 'TV Shows (i.e. Glee)', 'Gaming', 'Social Networking', 'General News', 'Shopping', 'Specific News Publications', 'Other', 'None')

clus3_apps = data.frame(rbind(c3_music, c3_tvcheckin, c3_entertainment, c3_tvshow, c3_gaming, c3_socialnet, c3_generalnews, c3_shopping, c3_specificpubnews, c3_otherapps, c3_none))
rownames(clus3_apps) = c('Music/Sound Identification', 'TV Check-in', 'Entertainment', 'TV Shows (i.e. Glee)', 'Gaming', 'Social Networking', 'General News', 'Shopping', 'Specific News Publications', 'Other', 'None')

par(mar=c(13, 3, 4.1, 1))
par(mfrow=c(1,3))

x = barplot(clus1_apps[,1], names.arg=rownames(clus1_apps), las=2, main='Cluster 1 - App Prefs', ylim=c(0,1))
y = barplot(clus2_apps[,1], names.arg=rownames(clus2_apps), las=2, main='Cluster 2 - App Prefs', ylim=c(0,1))
z = barplot(clus3_apps[,1], names.arg=rownames(clus3_apps), las=2, main='Cluster 3 - App Prefs', ylim=c(0,1))


# website visit breakdown cluster 1
c1_facebook = sum(cluster1$q13r1)/nrow(cluster1)
c1_twitter = sum(cluster1$q13r2)/nrow(cluster1)
c1_myspace = sum(cluster1$q13r3)/nrow(cluster1)
c1_pandora = sum(cluster1$q13r4)/nrow(cluster1)
c1_vevo = sum(cluster1$q13r5)/nrow(cluster1)
c1_youtube = sum(cluster1$q13r6)/nrow(cluster1)
c1_aol = sum(cluster1$q13r7)/nrow(cluster1)
c1_last.fm = sum(cluster1$q13r8)/nrow(cluster1)
c1_yahoo = sum(cluster1$q13r9)/nrow(cluster1)
c1_imdb = sum(cluster1$q13r10)/nrow(cluster1)
c1_linkedin = sum(cluster1$q13r11)/nrow(cluster1)
c1_netflix = sum(cluster1$q13r12)/nrow(cluster1)

# website visit breakdown cluster 2
c2_facebook = sum(cluster2$q13r1)/nrow(cluster2)
c2_twitter = sum(cluster2$q13r2)/nrow(cluster2)
c2_myspace = sum(cluster2$q13r3)/nrow(cluster2)
c2_pandora = sum(cluster2$q13r4)/nrow(cluster2)
c2_vevo = sum(cluster2$q13r5)/nrow(cluster2)
c2_youtube = sum(cluster2$q13r6)/nrow(cluster2)
c2_aol = sum(cluster2$q13r7)/nrow(cluster2)
c2_last.fm = sum(cluster2$q13r8)/nrow(cluster2)
c2_yahoo = sum(cluster2$q13r9)/nrow(cluster2)
c2_imdb = sum(cluster2$q13r10)/nrow(cluster2)
c2_linkedin = sum(cluster2$q13r11)/nrow(cluster2)
c2_netflix = sum(cluster2$q13r12)/nrow(cluster2)

# website visit breakdown cluster 3
c3_facebook = sum(cluster3$q13r1)/nrow(cluster3)
c3_twitter = sum(cluster3$q13r2)/nrow(cluster3)
c3_myspace = sum(cluster3$q13r3)/nrow(cluster3)
c3_pandora = sum(cluster3$q13r4)/nrow(cluster3)
c3_vevo = sum(cluster3$q13r5)/nrow(cluster3)
c3_youtube = sum(cluster3$q13r6)/nrow(cluster3)
c3_aol = sum(cluster3$q13r7)/nrow(cluster3)
c3_last.fm = sum(cluster3$q13r8)/nrow(cluster3)
c3_yahoo = sum(cluster3$q13r9)/nrow(cluster3)
c3_imdb = sum(cluster3$q13r10)/nrow(cluster3)
c3_linkedin = sum(cluster3$q13r11)/nrow(cluster3)
c3_netflix = sum(cluster3$q13r12)/nrow(cluster3)

# website visit breakdown cluster 1
c1_facebook = mean(cluster1$q13r1)
c1_twitter = mean(cluster1$q13r2)
c1_myspace = mean(cluster1$q13r3)
c1_pandora = mean(cluster1$q13r4)
c1_vevo = mean(cluster1$q13r5)
c1_youtube = mean(cluster1$q13r6)
c1_aol = mean(cluster1$q13r7)
c1_last.fm = mean(cluster1$q13r8)
c1_yahoo = mean(cluster1$q13r9)
c1_imdb = mean(cluster1$q13r10)
c1_linkedin = mean(cluster1$q13r11)
c1_netflix = mean(cluster1$q13r12)

# website visit breakdown cluster 2
c2_facebook = mean(cluster2$q13r1)
c2_twitter = mean(cluster2$q13r2)
c2_myspace = mean(cluster2$q13r3)
c2_pandora = mean(cluster2$q13r4)
c2_vevo = mean(cluster2$q13r5)
c2_youtube = mean(cluster2$q13r6)
c2_aol = mean(cluster2$q13r7)
c2_last.fm = mean(cluster2$q13r8)
c2_yahoo = mean(cluster2$q13r9)
c2_imdb = mean(cluster2$q13r10)
c2_linkedin = mean(cluster2$q13r11)
c2_netflix = mean(cluster2$q13r12)

# website visit breakdown cluster 3
c3_facebook = mean(cluster3$q13r1)
c3_twitter = mean(cluster3$q13r2)
c3_myspace = mean(cluster3$q13r3)
c3_pandora = mean(cluster3$q13r4)
c3_vevo = mean(cluster3$q13r5)
c3_youtube = mean(cluster3$q13r6)
c3_aol = mean(cluster3$q13r7)
c3_last.fm = mean(cluster3$q13r8)
c3_yahoo = mean(cluster3$q13r9)
c3_imdb = mean(cluster3$q13r10)
c3_linkedin = mean(cluster3$q13r11)
c3_netflix = mean(cluster3$q13r12)

# plot site visit breakdown (lower numbers means they visit the site more often)
clus1_sites = data.frame(rbind(c1_facebook, c1_twitter, c1_myspace, c1_pandora, c1_vevo, c1_youtube, c1_aol, c1_last.fm, c1_yahoo, c1_imdb, c1_linkedin, c1_netflix))
rownames(clus1_sites) = c('facebook', 'twitter', 'myspace', 'pandora', 'vevo', 'youtube', 'aol', 'last.fm', 'yahoo', 'imdb', 'linkedin', 'netflix')

clus2_sites = data.frame(rbind(c2_facebook, c2_twitter, c2_myspace, c2_pandora, c2_vevo, c2_youtube, c2_aol, c2_last.fm, c2_yahoo, c2_imdb, c2_linkedin, c2_netflix))
rownames(clus2_sites) = c('facebook', 'twitter', 'myspace', 'pandora', 'vevo', 'youtube', 'aol', 'last.fm', 'yahoo', 'imdb', 'linkedin', 'netflix')

clus3_sites = data.frame(rbind(c3_facebook, c3_twitter, c3_myspace, c3_pandora, c3_vevo, c3_youtube, c3_aol, c3_last.fm, c3_yahoo, c3_imdb, c3_linkedin, c3_netflix))
rownames(clus3_sites) = c('facebook', 'twitter', 'myspace', 'pandora', 'vevo', 'youtube', 'aol', 'last.fm', 'yahoo', 'imdb', 'linkedin', 'netflix')

par(mar=c(6, 3, 4.1, 1))
par(mfrow=c(1,3))

x = barplot(clus1_sites[,1], names.arg=rownames(clus1_sites), las=2, main='Cluster 1 - Site Visits', ylim=c(0,4.0))
y = barplot(clus2_sites[,1], names.arg=rownames(clus2_sites), las=2, main='Cluster 2 - Site Visits', ylim=c(0,4.0))
z = barplot(clus3_sites[,1], names.arg=rownames(clus3_sites), las=2, main='Cluster 2 - Site Visits', ylim=c(0,4.0))

library(gridExtra)

# plots for each cluster
x = ggplot(subset(labs.frame, labs.frame$hcluster == 1), aes(q12)) + geom_bar() + 
  theme(axis.text.x=element_text(angle=45,hjust=1)) + ggtitle('Cluster 1') + scale_y_continuous(limits = c(0, 250))

y = ggplot(subset(labs.frame, labs.frame$hcluster == 2), aes(q12)) + geom_bar() + 
  theme(axis.text.x=element_text(angle=45,hjust=1)) + ggtitle('Cluster 2') + scale_y_continuous(limits = c(0, 250))

z = ggplot(subset(labs.frame, labs.frame$hcluster == 3), aes(q12)) + geom_bar() + 
  theme(axis.text.x=element_text(angle=45,hjust=1)) + ggtitle('Cluster 3') + scale_y_continuous(limits = c(0, 250))

grid.arrange(x, y, z, ncol=3, top="q12: Of your Apps, what percent were free to download?")

labs.frame$hcluster = factor(labs.frame$hcluster)

ggplot(labs.frame, aes(hcluster)) + geom_bar() + ggtitle('Cluster Distribution')

table(labs.frame$hcluster)

c1_no_children = sum(subset(cluster1, q50r1 ==  1)$q50r1)/nrow(cluster1)
c1_under6 = sum(subset(cluster1, q50r2 ==  1)$q50r2)/nrow(cluster1)
c1_6_12 = sum(subset(cluster1, q50r3 ==  1)$q50r3)/nrow(cluster1)
c1_13_17 = sum(subset(cluster1, q50r4 ==  1)$q50r4)/nrow(cluster1)
c1_18up = sum(subset(cluster1, q50r5 ==  1)$q50r5)/nrow(cluster1)

c2_no_children = sum(subset(cluster2, q50r1 ==  1)$q50r1)/nrow(cluster2)
c2_under6 = sum(subset(cluster2, q50r2 ==  1)$q50r2)/nrow(cluster2)
c2_6_12 = sum(subset(cluster2, q50r3 ==  1)$q50r3)/nrow(cluster2)
c2_13_17 = sum(subset(cluster2, q50r4 ==  1)$q50r4)/nrow(cluster2)
c2_18up = sum(subset(cluster2, q50r5 ==  1)$q50r5)/nrow(cluster2)

c3_no_children = sum(subset(cluster3, q50r1 ==  1)$q50r1)/nrow(cluster3)
c3_under6 = sum(subset(cluster3, q50r2 ==  1)$q50r2)/nrow(cluster3)
c3_6_12 = sum(subset(cluster3, q50r3 ==  1)$q50r3)/nrow(cluster3)
c3_13_17 = sum(subset(cluster3, q50r4 ==  1)$q50r4)/nrow(cluster3)
c3_18up = sum(subset(cluster3, q50r5 ==  1)$q50r5)/nrow(cluster3)


c1_kids = data.frame(rbind(c1_no_children, c1_under6, c1_6_12, c1_13_17, c1_18up), rownames=c('No Children', 'Under 6', '6-12', '13-17', '18 & up'))
c2_kids = data.frame(rbind(c2_no_children, c2_under6, c2_6_12, c2_13_17, c2_18up), rownames=c('No Children', 'Under 6', '6-12', '13-17', '18 & up'))
c3_kids = data.frame(rbind(c3_no_children, c3_under6, c3_6_12, c3_13_17, c3_18up), rownames=c('No Children', 'Under 6', '6-12', '13-17', '18 & up'))

par(mar=c(6, 3, 4.1, 1))
par(mfrow=c(1,3))

barplot(c1_kids[,1], names.arg=c1_kids$rownames, las=2, main="Cluster 1 - Children", ylim=c(0,1))
barplot(c2_kids[,1], names.arg=c2_kids$rownames, las=2, main="Cluster 2 - Children", ylim=c(0,1))
barplot(c3_kids[,1], names.arg=c3_kids$rownames, las=2, main="Cluster 3 - Children", ylim=c(0,1))
