********************************************************
		Nate Bitting
		Assignment 3
		Predict 411
********************************************************;

* -----------------------------------------
* PHASE 1: Data Exploration
* -----------------------------------------;
libname MYDATA "/folders/myfolders/PREDICT 411/data";

data wine;
set mydata.wine;
run;

* print the contents of the dataset;
proc contents data=wine;
run;

* print the first 10 observations;
proc print data=wine(obs=10);
run;

* explore the mean/spread and missing values of each numeric variable;
proc means data=wine(drop=INDEX) n nmiss mean median min p5 p50 p75 p90 p95 p99 max ndec=0; 
run;

* Frequency tables for categorical variables;
proc freq data=wine;
tables target labelappeal acidindex stars;
run;

data one;
   set mydata.wine;
   if residualsugar = "." then residualsugar = 5.42;
   if chlorides = "." then chlorides = 0.05;
   if freesulfurdioxide = "." then freesulfurdioxide = 31;
   if totalsulfurdioxide = "." then totalsulfurdioxide = 121;
   if ph = "."  then ph = 3.21;
   if sulphates = "." then sulphates = 0.53;
   if alcohol = "." then alcohol = 10.49;
   if stars = "." then stars = 0;
run;

* Boxplots of continuous variables;
proc sgplot data=one;
  vbox  alcohol  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  FixedAcidity  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  VolatileAcidity  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  CitricAcidity  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  ResidualSugar  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  Chlorides  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  FreeSulfurDioxide  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  TotalSulfurDioxide  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  Density  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  pH  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=one;
  vbox  Sulphates  /group=target;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;


data two;
   	set mydata.wine;
	fixedAcidity1=abs(fixedacidity);
   	volatileAcidity1=abs(volatileacidity);
   	citricAcid1=abs(citricacid);
   	freeSulfurDioxide1=abs(freesulfurdioxide);
   	totalSulfurDioxide1=abs(totalsulfurdioxide);
   	residualsugar1=abs(residualsugar);
   	alcohol1=abs(alcohol);
   	chlorides1=abs(chlorides);
   	sulphates1=abs(sulphates);
run;

proc means data=two(drop=INDEX fixedacidity volatileacidity citricacid chlorides residualsugar
						freesulfurdioxide totalsulfurdioxide alcohol sulphates)
				 nmiss min p5 p10 mean median P90 p95 max  ndec=2;
run;

data three;
   	set mydata.wine;
   	fixedAcidity1=abs(fixedacidity);
   	volatileAcidity1=abs(volatileacidity);
   	citricAcid1=abs(citricacid);
   	freeSulfurDioxide1=abs(freesulfurdioxide);
   	totalSulfurDioxide1=abs(totalsulfurdioxide);
   	residualsugar1=abs(residualsugar);
   	alcohol1=abs(alcohol);
   	chlorides1=abs(chlorides);
   	sulphates1=abs(sulphates);
	if residualsugar1 = "." then residualsugar1 = 5.42;
   	if chlorides1 = "." then chlorides1 = 0.05;
   	if freesulfurdioxide1 = "." then freesulfurdioxide1 = 31;
   	if totalsulfurdioxide1 = "." then totalsulfurdioxide1 = 121;
   	if ph = "."  then ph = 3.21;
   	if sulphates1 = "." then sulphates1 = 0.53;
   	if alcohol1 = "." then alcohol1 = 10.49;
   	if stars = "." then stars = 0;
run;

proc contents data=three;
run;

proc means data=three(drop=INDEX fixedacidity volatileacidity citricacid chlorides residualsugar
						freesulfurdioxide totalsulfurdioxide alcohol sulphates)
				 nmiss min p5 p25 median mean p75 p95 max ndec=2;
run;

* Boxplots of continuous variables;
proc sgplot data=three;
  vbox  alcohol1 / group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  FixedAcidity1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  VolatileAcidity1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  CitricAcid1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  ResidualSugar1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  Chlorides1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  FreeSulfurDioxide1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  TotalSulfurDioxide1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  Density  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  pH  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

proc sgplot data=three;
  vbox  Sulphates1  /group=stars;
  xaxis label="Wine Sales";
  keylegend / title="BoxPlot";
run;

*correlation matrix;
title 'Wine Data';
proc corr data=three(drop=INDEX fixedacidity volatileacidity citricacid  chlorides
						freesulfurdioxide totalsulfurdioxide alcohol sulphates residualsugar);
run;

*scatter plots to identify relationships;
proc sgplot data=three;
  scatter x=ph y=FreeSulfurDioxide1 / group=stars;
run;

*frequency crosstabs against target;
proc freq data=three;
  tables labelappeal*target / norow nocol;
run;

proc freq data=three;
  tables acidindex*target / norow nocol;
run;

proc freq data=three;
  tables stars*target / norow nocol;
run;

proc freq data=three;
  tables totalSO2Limit;
run;

proc freq data=three;
  tables freeSO2Limit;
run;

proc freq data=three;
  tables phfilter;
run;


* -----------------------------------------
* PHASE 2: Data Preparation
* -----------------------------------------;

data wine_2;
   	set mydata.wine;
   	fixedAcidity1=abs(fixedacidity);
   	volatileAcidity1=abs(volatileacidity);
   	citricAcid1=abs(citricacid);
   	freeSulfurDioxide1=abs(freesulfurdioxide);
   	totalSulfurDioxide1=abs(totalsulfurdioxide);
   	residualsugar1=abs(residualsugar);
   	alcohol1=abs(alcohol);
   	chlorides1=abs(chlorides);
   	sulphates1=abs(sulphates);
	if residualsugar1 = "." then residualsugar1 = 5.42;
   	if chlorides1 = "." then chlorides1 = 0.22; *0.22 mean after applying absolute values;
   	if freesulfurdioxide1 = "." then freesulfurdioxide1 = 56; *median after applying absolute values;
   	if totalsulfurdioxide1 = "." then totalsulfurdioxide1 = 154; *median after applying absolute values;
   	if ph = "."  then ph = 3.21;
   	if sulphates1 = "." then sulphates1 = 0.53;
   	if alcohol1 = "." then alcohol1 = 10.49;
   	if stars = "." then stars = 0;
   	
   	*handle unrealistic values as if they are missing values;
   	if totalsulfurdioxide1 > 250 then totalsulfurdioxide1 = 154; *illegal to exceed 350 in the US, lower in other countries;
   	if freesulfurdioxide1 > 188 then freesulfurdioxide1 = 56; *uusually 33-75% of total SO2;
   	if totalsulfurdioxide1 > freesulfurdioxide1 then totalsulfurdioxide1 = freesulfurdioxide1 / .5; *make sure free is always less than total;
   	if ph < 2.9 or ph > 4.1 then ph = 3.21; *most wines fall between 3 and 4;
   	if volatileAcidity1 > 1.2 then volatileAcidity1 = 0.41; *illegal to exceed 1.2 set to median of 0.41;
   	if fixedAcidity1 > 15 then fixedAcidity1 = 7; *usually does not exceed 14.5 set to median of 7;
   	if residualsugar1 > 25 then residualsugar1 = 5.42; *anything higher than 20% seems suspect as most sweet wines don't exceed 15%;
   	if alcohol1 > 23 then alcohol1 = 10.49; *wines generally dont exceed 22% alcohol content;
	if chlorides1 > 0.6 then chlorides1 = 0.22; *remove any values exceeding 95 percentile;
	if sulphates1 > 2.15 then sulphates1 = 0.53; *remove any values exceeding 95 percentile;
	if citricAcid1 > 1.88 then citricAcid1 = 0.44; *remove any values exceeding 95 percentile;
	
	if labelappeal = -2 then label_neg2 = 1; else label_neg2 = 0;
	if labelappeal = -1 then label_neg1 = 1; else label_neg1 = 0;
	if labelappeal = 1 then label_1 = 1; else label_1 = 0;
	if labelappeal = 0 then label_0 = 1; else label_0 = 0;
	
	if acidindex = 4 or acidindex = 5 then acidindex45 = 1; else acidindex45 = 0;
	if acidindex = 6 then acidindex6 = 1; else acidindex6 = 0;
	if acidindex = 7 then acidindex7 = 1; else acidindex7 = 0;
	if acidindex = 8 then acidindex8 = 1; else acidindex8 = 0;
	if acidindex = 9 then acidindex9 = 1; else acidindex9 = 0;
	
	if stars = 0 then stars0 = 1; else stars0 = 0;
	if stars = 1 then stars1 = 1; else stars1 = 0;
	if stars = 2 then stars2 = 1; else stars2 = 0;
	if stars = 3 then stars3 = 1; else stars3 = 0;
run;

* -----------------------------------------
* PHASE 3: Model Building 
* -----------------------------------------;

* MODEL A: Poisson (shell);
proc genmod data=wine_2  ;
   class labelappeal acidindex   stars ;
   A: model target=  residualsugar1 freesulfurdioxide1 chlorides1
     totalsulfurdioxide1  ph density labelappeal sulphates1
     acidindex  stars volatileacidity1 alcohol1 citricAcid1
     fixedAcidity1
       / dist=poisson link=log  ;
   store out=poimodel_shell    ;
run;

* MODEL B: Poisson (adjusted);
proc genmod data=wine_2  ;
   class labelappeal acidindex   stars ;
   B: model target=  residualsugar1
     totalsulfurdioxide1 ph labelappeal
     acidindex  stars volatileacidity1 alcohol1
       / dist=poisson link=log  ;
   store out=poimodel_adj;
run;

* MODEL C: Negative Binomial;
proc genmod data=wine_2  ;
   class labelappeal acidindex   stars ;
   C: model target=  residualsugar1
     totalsulfurdioxide1 ph labelappeal
     acidindex  stars volatileacidity1 alcohol1
       / dist=nb link=log  ;
   store out=nbmodel;
run;

* MODEL D: Zero Inflated Poisson;
proc genmod data=wine_2  ;
   class labelappeal acidindex   stars ;
   D: model target=  residualsugar1
     totalsulfurdioxide1 ph labelappeal
     acidindex  stars volatileacidity1 alcohol1
       / dist=zip link=log  ;
       zeromodel labelappeal   /link=logit;
   store out=zipmodel;
run;

* MODEL E: Zero Inflated Negative Binomial;
proc genmod data=wine_2  ;
   class labelappeal acidindex   stars ;
   E: model target=  residualsugar1
     totalsulfurdioxide1 ph labelappeal
     acidindex  stars volatileacidity1 alcohol1
       / dist=zinb link=log  ;
       zeromodel labelappeal   /link=logit;
   store out=zinbmodel;
run;

* MODEL F: OLS Regression Model;
proc reg data=wine_2 outest=proc_reg_betas;
	F: model target= residualsugar1 totalsulfurdioxide1
				ph  alcohol1 label_neg2 
				label_neg1 label_1 label_0 acidindex45
				acidindex6 acidindex7 acidindex8 acidindex9
				stars0 stars1 stars2 stars3
				/ selection = forward adjrsq aic vif cp;
run;
				

* -----------------------------------------
* PHASE 4: Model Delployment
* -----------------------------------------;

data testdata;
	set mydata.wine_test;
	fixedAcidity1=abs(fixedacidity);
   	volatileAcidity1=abs(volatileacidity);
   	citricAcid1=abs(citricacid);
   	freeSulfurDioxide1=abs(freesulfurdioxide);
   	totalSulfurDioxide1=abs(totalsulfurdioxide);
   	residualsugar1=abs(residualsugar);
   	alcohol1=abs(alcohol);
   	chlorides1=abs(chlorides);
   	sulphates1=abs(sulphates);
	if residualsugar1 = "." then residualsugar1 = 5.42;
   	if chlorides1 = "." then chlorides1 = 0.22; *0.22 mean after applying absolute values;
   	if freesulfurdioxide1 = "." then freesulfurdioxide1 = 56; *median after applying absolute values;
   	if totalsulfurdioxide1 = "." then totalsulfurdioxide1 = 154; *median after applying absolute values;
   	if ph = "."  then ph = 3.21;
   	if sulphates1 = "." then sulphates1 = 0.53;
   	if alcohol1 = "." then alcohol1 = 10.49;
   	if stars = "." then stars = 0;
   	
   	*handle unrealistic values as if they are missing values;
   	if totalsulfurdioxide1 > 250 then totalsulfurdioxide1 = 154; *illegal to exceed 350 in the US, lower in other countries;
   	if freesulfurdioxide1 > 188 then freesulfurdioxide1 = 56; *uusually 33-75% of total SO2;
   	if totalsulfurdioxide1 > freesulfurdioxide1 then totalsulfurdioxide1 = freesulfurdioxide1 / .5; *make sure free is always less than total;
   	if ph < 2.9 or ph > 4.1 then ph = 3.21; *most wines fall between 3 and 4;
   	if volatileAcidity1 > 1.2 then volatileAcidity1 = 0.41; *illegal to exceed 1.2 set to median of 0.41;
   	if fixedAcidity1 > 15 then fixedAcidity1 = 7; *usually does not exceed 14.5 set to median of 7;
   	if residualsugar1 > 25 then residualsugar1 = 5.42; *anything higher than 20% seems suspect as most sweet wines don't exceed 15%;
   	if alcohol1 > 23 then alcohol1 = 10.49; *wines generally dont exceed 22% alcohol content;
	if chlorides1 > 0.6 then chlorides1 = 0.22; *remove any values exceeding 95 percentile;
	if sulphates1 > 2.15 then sulphates1 = 0.53; *remove any values exceeding 95 percentile;
	if citricAcid1 > 1.88 then citricAcid1 = 0.44; *remove any values exceeding 95 percentile;
	
	if labelappeal = -2 then label_neg2 = 1; else label_neg2 = 0;
	if labelappeal = -1 then label_neg1 = 1; else label_neg1 = 0;
	if labelappeal = 1 then label_1 = 1; else label_1 = 0;
	if labelappeal = 0 then label_0 = 1; else label_0 = 0;
	
	if acidindex = 4 or acidindex = 5 then acidindex45 = 1; else acidindex45 = 0;
	if acidindex = 6 then acidindex6 = 1; else acidindex6 = 0;
	if acidindex = 7 then acidindex7 = 1; else acidindex7 = 0;
	if acidindex = 8 then acidindex8 = 1; else acidindex8 = 0;
	if acidindex = 9 then acidindex9 = 1; else acidindex9 = 0;
	
	if stars = 0 then stars0 = 1; else stars0 = 0;
	if stars = 1 then stars1 = 1; else stars1 = 0;
	if stars = 2 then stars2 = 1; else stars2 = 0;
	if stars = 3 then stars3 = 1; else stars3 = 0;
run;

* SCORE the Poisson Model;
proc plm source=poimodel_adj;
        score data=testdata out=wine_data pred=p_target_poi/ ilink;
run;

data wine_poi;
   set wine_data;
   keep index p_target_poi;
run;

* SCORE the Negative Binomial Model;
proc plm source=nbmodel;
        score data=testdata out=wine_data pred=p_target_nb/ ilink;
run;

data wine_nb;
   set wine_data;
   keep index p_target_nb;
run;

* SCORE the Zero Inflated Poisson Model;
proc plm source=zipmodel;
        score data=testdata out=wine_data pred=p_target_zip/ ilink;
run;

data wine_zip;
   set wine_data;
   keep index p_target_zip;
run;

* SCORE the Zero Inflated Negative Binomial Model;
proc plm source=zinbmodel;
        score data=testdata out=wine_data pred=p_target_zinb/ ilink;
run;

data wine_zinb;
   set wine_data;
   keep index p_target_zinb;
run;

* SCORE the OLS Model;
proc score data=testdata score=proc_reg_betas
   out=predictions type=parms;
   var residualsugar1 totalsulfurdioxide1
		ph  alcohol1 label_neg2 
		label_neg1 label_1 label_0 acidindex45
		acidindex6 acidindex7 acidindex8 acidindex9
		stars0 stars1 stars2 stars3;
run;

data wine_ols;
	set testdata;
	P_TARGET_OLS = + 5.83422
		+ residualsugar1 		* 0.00527
		+ totalSulfurDioxide1 	* 0.00113
		+ pH					* -0.26433
		+ alcohol1				* 0.01447
		+ label_neg2			* -1.89001
		+ label_neg1			* -1.52118
		+ label_1				* -0.59037
		+ label_0				* -1.05441
		+ acidindex45			* 0.97674
		+ acidindex6			* 1.05499
		+ acidindex7			* 0.94134
		+ acidindex8			* 0.83087
		+ acidindex9			* 0.52533
		+ stars0				* -3.64919
		+ stars1				* -2.29690
		+ stars2				* -1.25747
		+ stars3				* -0.69862;
		P_TARGET_OLS = abs(P_TARGET_OLS);
		keep INDEX P_TARGET_OLS;
run;

data wine_all;
merge wine_poi(in=ina) wine_nb(in=inb) 
   wine_zip wine_zinb wine_ols;
by INDEX;
if ina;
run;

*///final datastep to retain index and model results///;
data wine_all;
   set wine_all;
   keep index p_target_poi p_target_nb p_target_zip p_target_zinb p_target_ols;
run;
