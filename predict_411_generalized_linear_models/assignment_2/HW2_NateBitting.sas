********************************************************
		Nate Bitting
		Assignment 2
		Predict 411
********************************************************;

* -----------------------------------------
* PHASE 1: Data Exploration
* -----------------------------------------;

libname MYDATA "/home/nathanielbitting/my_courses/mott/c_7416/SAS_Data" access=readonly;
data insurance;
set mydata.logit_insurance;
run;

* print the contents of the dataset;
proc contents data=insurance;
run;

* print the first 10 observations;
proc print data=insurance(obs=10);
run;

* explore the mean/spread and missing values of each numeric variable;
proc means data=insurance n nmiss mean median min p5 p50 p75 p90 p95 p99 max ndec=0; 
run;

data temp1;
set insurance;
if oldclaim = 0 then delete;
run;

proc means data=temp1 mean median min p5 p25 p50 p75 p90 p95 p99 max ndec=0;
run;

* investigate which variables might need a transformation;
proc univariate data=insurance;
histogram TARGET_FLAG TARGET_AMT KIDSDRIV AGE HOMEKIDS YOJ INCOME HOME_VAL TRAVTIME BLUEBOOK TIF
		  OLDCLAIM CLM_FREQ MVR_PTS CAR_AGE;
run;

* Frequency tables for categorical variables;
proc freq data=insurance;
tables CAR_TYPE CAR_USE EDUCATION JOB MSTATUS PARENT1 RED_CAR REVOKED SEX URBANICITY;
run;

data temp;
set insurance;
if TARGET_FLAG = 0 THEN DELETE;
run;

proc univariate data=temp;
histogram TARGET_AMT;
RUN;

* -----------------------------------------
* PHASE 2 Data Preparation
* -----------------------------------------;
proc means data=insurance noprint;
	output out=meanfile
	
	mean(KIDSDRIV) = U_KIDSDRIV
	stddev(KIDSDRIV) = S_KIDSDRIV
	P1(KIDSDRIV) = P1_KIDSDRIV
	P5(KIDSDRIV) = P5_KIDSDRIV
	P95(KIDSDRIV) = P95_KIDSDRIV
	P99(KIDSDRIV) = P99_KIDSDRIV
	
	mean(AGE) = U_AGE
	stddev(AGE) = S_AGE
	P1(AGE) = P1_AGE
	P5(AGE) = P5_AGE
	P95(AGE) = P95_AGE
	P99(AGE) = P99_AGE
	
	mean(YOJ) = U_YOJ
	stddev(YOJ) = S_YOJ
	P1(YOJ) = P1_YOJ
	P5(YOJ) = P5_YOJ
	P95(YOJ) = P95_YOJ
	P99(YOJ) = P99_YOJ
	
	mean(INCOME) = U_INCOME
	stddev(INCOME) = S_INCOME
	P1(INCOME) = P1_INCOME
	P5(INCOME) = P5_INCOME
	P95(INCOME) = P95_INCOME
	P99(INCOME) = P99_INCOME
	
	mean(HOME_VAL) = U_HOME_VAL
	stddev(HOME_VAL) = S_HOME_VAL
	P1(HOME_VAL) = P1_HOME_VAL
	P5(HOME_VAL) = P5_HOME_VAL
	P95(HOME_VAL) = P95_HOME_VAL
	P99(HOME_VAL) = P99_HOME_VAL
	
	mean(TRAVTIME) = U_TRAVTIME
	stddev(TRAVTIME) = S_TRAVTIME
	P1(TRAVTIME) = P1_TRAVTIME
	P5(TRAVTIME) = P5_TRAVTIME
	P95(TRAVTIME) = P95_TRAVTIME
	P99(TRAVTIME) = P99_TRAVTIME
	
	mean(BLUEBOOK) = U_BLUEBOOK
	stddev(BLUEBOOK) = S_BLUEBOOK
	P1(BLUEBOOK) = P1_BLUEBOOK
	P5(BLUEBOOK) = P5_BLUEBOOK
	P95(BLUEBOOK) = P95_BLUEBOOK
	P99(BLUEBOOK) = P99_BLUEBOOK
	
	mean(OLDCLAIM) = U_OLDCLAIM
	stddev(OLDCLAIM) = S_OLDCLAIM
	P1(OLDCLAIM) = P1_OLDCLAIM
	P5(OLDCLAIM) = P5_OLDCLAIM
	P95(OLDCLAIM) = P95_OLDCLAIM
	P99(OLDCLAIM) = P99_OLDCLAIM
	
	mean(CAR_AGE) = U_CAR_AGE
	stddev(CAR_AGE) = S_CAR_AGE
	P1(CAR_AGE) = P1_CAR_AGE
	P5(CAR_AGE) = P5_CAR_AGE
	P95(CAR_AGE) = P95_CAR_AGE
	P99(CAR_AGE) = P99_CAR_AGE
	
	mean(TIF) = U_TIF
	stddev(TIF) = S_TIF
	P1(TIF) = P1_TIF
	P5(TIF) = P5_TIF
	P95(TIF) = P95_TIF
	P99(TIF) = P99_TIF;
	
run;
	
data;
set MEANFILE;
	call symput("U_AGE"	,U_AGE);
	call symput("S_AGE"	,S_AGE);
	call symput("P1_AGE"	,P1_AGE);
	call symput("P5_AGE"	,P5_AGE);
	call symput("P95_AGE"	,P95_AGE);
	call symput("P99_AGE"	,P99_AGE);
	
	call symput("U_YOJ"	,U_YOJ);
	call symput("S_YOJ"	,S_YOJ);
	call symput("P1_YOJ"	,P1_YOJ);
	call symput("P5_YOJ"	,P5_YOJ);
	call symput("P95_YOJ"	,P95_YOJ);
	call symput("P99_YOJ"	,P99_YOJ);
	
	call symput("U_INCOME"	,U_INCOME);
	call symput("S_INCOME"	,S_INCOME);
	call symput("P1_INCOME"	,P1_INCOME);
	call symput("P5_INCOME"	,P5_INCOME);
	call symput("P95_INCOME"	,P95_INCOME);
	call symput("P99_INCOME"	,P99_INCOME);
	
	call symput("U_HOME_VAL"	,U_HOME_VAL);
	call symput("S_HOME_VAL"	,S_HOME_VAL);
	call symput("P1_HOME_VAL"	,P1_HOME_VAL);
	call symput("P5_HOME_VAL"	,P5_HOME_VAL);
	call symput("P95_HOME_VAL"	,P95_HOME_VAL);
	call symput("P99_HOME_VAL"	,P99_HOME_VAL);
	
	call symput("U_TRAVTIME"	,U_TRAVTIME);
	call symput("S_TRAVTIME"	,S_TRAVTIME);
	call symput("P1_TRAVTIME"	,P1_TRAVTIME);
	call symput("P5_TRAVTIME"	,P5_TRAVTIME);
	call symput("P95_TRAVTIME"	,P95_TRAVTIME);
	call symput("P99_TRAVTIME"	,P99_TRAVTIME);
	
	call symput("U_BLUEBOOK"	,U_BLUEBOOK);
	call symput("S_BLUEBOOK"	,S_BLUEBOOK);
	call symput("P1_BLUEBOOK"	,P1_BLUEBOOK);
	call symput("P5_BLUEBOOK"	,P5_BLUEBOOK);
	call symput("P95_BLUEBOOK"	,P95_BLUEBOOK);
	call symput("P99_BLUEBOOK"	,P99_BLUEBOOK);
	
	call symput("U_TIF"	,U_TIF);
	call symput("S_TIF"	,S_TIF);
	call symput("P1_TIF"	,P1_TIF);
	call symput("P5_TIF"	,P5_TIF);
	call symput("P95_TIF"	,P95_TIF);
	call symput("P99_TIF"	,P99_TIF);
	
	call symput("U_OLDCLAIM"	,U_OLDCLAIM);
	call symput("S_OLDCLAIM"	,S_OLDCLAIM);
	call symput("P1_OLDCLAIM"	,P1_OLDCLAIM);
	call symput("P5_OLDCLAIM"	,P5_OLDCLAIM);
	call symput("P95_OLDCLAIM"	,P95_OLDCLAIM);
	call symput("P99_OLDCLAIM"	,P99_OLDCLAIM);
	
	call symput("U_CAR_AGE"	,U_CAR_AGE);
	call symput("S_CAR_AGE"	,S_CAR_AGE);
	call symput("P1_CAR_AGE"	,P1_CAR_AGE);
	call symput("P5_CAR_AGE"	,P5_CAR_AGE);
	call symput("P95_CAR_AGE"	,P95_CAR_AGE);
	call symput("P99_CAR_AGE"	,P99_CAR_AGE);
run;

data insurance_1;
	set insurance;
	
/* 	if YOJ = "." then delete; */
/* 	if INCOME = "." then delete; */
/* 	if AGE = "." then delete; */
/* 	if HOME_VAL = "." then delete; */
/* 	if CAR_AGE = "." then delete; */
/* 	if JOB = "." then delete; */
	
	* address missing values for YOJ using median;
	IMP_YOJ = YOJ;
	M_YOJ = 0;
	if YOJ = '.' OR YOJ ="" then do;
		IMP_YOJ = 11;
		M_YOJ = 1;
	end;
	
	* address missing values for INCOME using median;
	IMP_INCOME = INCOME;
	M_INCOME = 0;
	if INCOME = '.' OR INCOME = "" then do;
		IMP_INCOME = 54028.17;
		M_INCOME = 1;
	end;
	
	* address missing values for AGE using median;
	IMP_AGE = AGE;
	M_AGE = 0;
	if AGE = '.' OR AGE = "" then do;
		IMP_AGE = 45;
		M_AGE = 1;
	end;
	
	* address missing values for HOME_VAL using mean;
	IMP_HOME_VAL = HOME_VAL;
	M_HOME_VAL = 0;
	if HOME_VAL = '.' OR HOME_VAL = "" then do;
		IMP_HOME_VAL = 154867.29;
		M_HOME_VAL = 1;
	end;
	
	* address missing values for CAR_AGE using median;
	IMP_CAR_AGE = CAR_AGE;
	M_CAR_AGE = 0;
	if CAR_AGE = '.' OR CAR_AGE = "" then do;
		IMP_CAR_AGE = 8;
		M_CAR_AGE = 1;
	end;
	
	* address missing values for CAR_AGE using median;
	IMP_JOB = JOB;
	M_JOB = 0;
	if JOB = '.' or JOB = " " then do;
		IMP_JOB = 'z_Blue Collar';
		M_JOB = 1;
	end;
	
	* variable transformation options for age;
	T95_AGE 		= max(min(IMP_AGE,&P95_AGE.), &P5_AGE.);
	T99_AGE 		= max(min(IMP_AGE,&P99_AGE.), &P1_AGE.);
	STD_AGE 		= (IMP_AGE-&U_AGE.) / &S_AGE.;
	T_STD_AGE		= max(min(STD_AGE,3),-3);
	LN_AGE 			= sign(IMP_AGE) * log(abs(IMP_AGE)+1);
	LOG10_AGE 		= sign(IMP_AGE) * log10(abs(IMP_AGE)+1);
	
	* variable transformation options for income;
	T95_INCOME 		= max(min(IMP_INCOME,&P95_INCOME.), &P5_INCOME.);
	T99_INCOME 		= max(min(IMP_INCOME,&P99_INCOME.), &P1_INCOME.);
	STD_INCOME 		= (IMP_INCOME-&U_INCOME.) / &S_INCOME.;
	T_STD_INCOME	= max(min(STD_INCOME,3),-3);
	LN_INCOME 		= sign(IMP_INCOME) * log(abs(IMP_INCOME)+1);
	LOG10_INCOME 	= sign(IMP_INCOME) * log10(abs(IMP_INCOME)+1);
	
	* variable transformation options for HOME VALUE;
	T95_HOME_VAL 	= max(min(IMP_HOME_VAL,&P95_HOME_VAL.), &P5_HOME_VAL.);
	T99_HOME_VAL 	= max(min(IMP_HOME_VAL,&P99_HOME_VAL.), &P1_HOME_VAL.);
	STD_HOME_VAL 	= (IMP_HOME_VAL-&U_HOME_VAL.) / &S_HOME_VAL.;
	T_STD_HOME_VAL	= max(min(STD_HOME_VAL,3),-3);
	LN_HOME_VAL 	= sign(IMP_HOME_VAL) * log(abs(IMP_HOME_VAL)+1);
	LOG10_HOME_VAL 	= sign(IMP_HOME_VAL) * log10(abs(IMP_HOME_VAL)+1);
	
	* variable transformation options for TRAVEL TIME;
	T95_TRAVTIME	= max(min(TRAVTIME,&P95_TRAVTIME.), &P5_TRAVTIME.);
	T99_TRAVTIME	= max(min(TRAVTIME,&P99_TRAVTIME.), &P1_TRAVTIME.);
	STD_TRAVTIME	= (TRAVTIME-&U_TRAVTIME.) / &S_TRAVTIME.;
	T_STD_TRAVTIME	= max(min(STD_TRAVTIME,3),-3);
	LN_TRAVTIME		= sign(TRAVTIME) * log(abs(TRAVTIME)+1);
	LOG10_TRAVTIME	= sign(TRAVTIME) * log10(abs(TRAVTIME)+1);
	
	* variable transformation options for OLDCLAIM;
	T95_OLDCLAIM	= max(min(OLDCLAIM,&P95_OLDCLAIM.), &P5_OLDCLAIM.);
	T99_OLDCLAIM	= max(min(OLDCLAIM,&P99_OLDCLAIM.), &P1_OLDCLAIM.);
	STD_OLDCLAIM	= (OLDCLAIM-&U_OLDCLAIM.) / &S_OLDCLAIM.;
	T_STD_OLDCLAIM	= max(min(STD_OLDCLAIM,3),-3);
	LN_OLDCLAIM		= sign(OLDCLAIM) * log(abs(OLDCLAIM)+1);
	LOG10_OLDCLAIM	= sign(OLDCLAIM) * log10(abs(OLDCLAIM)+1);
	
	* variable transformation options for BLUEBOOK;
	T95_BLUEBOOK	= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_BLUEBOOK	= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_BLUEBOOK	= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_BLUEBOOK	= max(min(STD_BLUEBOOK,3),-3);
	LN_BLUEBOOK		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_BLUEBOOK	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for TIF;
	T95_BLUEBOOK	= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_BLUEBOOK	= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_BLUEBOOK	= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_BLUEBOOK	= max(min(STD_BLUEBOOK,3),-3);
	LN_BLUEBOOK		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_BLUEBOOK	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for TIF;
	T95_TIF		= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_TIF		= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_TIF		= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_TIF	= max(min(STD_BLUEBOOK,3),-3);
	LN_TIF		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_TIF	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for car age;
	T95_CAR_AGE		= max(min(IMP_CAR_AGE,&P95_CAR_AGE.), &P5_CAR_AGE.);
	T99_CAR_AGE		= max(min(IMP_CAR_AGE,&P99_CAR_AGE.), &P1_CAR_AGE.);
	STD_CAR_AGE		= (IMP_CAR_AGE-&U_CAR_AGE.) / &S_CAR_AGE.;
	T_STD_CAR_AGE	= max(min(STD_CAR_AGE,3),-3);
	LN_CAR_AGE		= sign(IMP_CAR_AGE) * log(abs(IMP_CAR_AGE)+1);
	LOG10_CAR_AGE	= sign(IMP_CAR_AGE) * log10(abs(IMP_CAR_AGE)+1);
	
	* variable transformation options for yoj;
	T95_YOJ 		= max(min(IMP_YOJ,&P95_YOJ.), &P5_YOJ.);
	T99_YOJ 		= max(min(IMP_YOJ,&P99_YOJ.), &P1_YOJ.);
	STD_YOJ 		= (IMP_YOJ-&U_YOJ.) / &S_YOJ.;
	T_STD_YOJ		= max(min(STD_YOJ,3),-3);
	LN_YOJ 			= sign(IMP_YOJ) * log(abs(IMP_YOJ)+1);
	LOG10_YOJ 		= sign(IMP_YOJ) * log10(abs(IMP_YOJ)+1);
	
	minivan = 0;
	sportscar = 0;
	pickup = 0;
	suv = 0;
	other_car = 0;
	bachelor = 0;
	high_edu = 0;
	highschool = 0;
	phd = 0;
	white_collar = 0;
	blue_collar = 0;
	job_other = 0;
	kidsdriv_1 = 0;
	kidsdriv_2 = 0;
	kidsdriv_3= 0;
	kidsdriv_4= 0;
	homekids_1 = 0;
	homekids_2 = 0;
	homekids_3= 0;
	homekids_4 = 0;
	homekids_5 = 0;
	tif_1 = 0;
	tif_24 = 0;
	tif_510 = 0;
	tif_11up = 0;
	clm_freq_1 = 0;
	clm_freq_2 = 0;
	clm_freq_3up = 0;
	mvr_pts_1 = 0;
	mvr_pts_25 = 0;
	mvr_pts_6up = 0;
	
	
	if CAR_TYPE = "Minivan" then minivan=1;
	if CAR_TYPE = "z_SUV" then suv = 1;
	if CAR_TYPE = "Sports Car" then sportscar = 1;
	if CAR_TYPE = "Pickup" then pickup = 1;
	if CAR_TYPE = "Panel Truck" or CAR_TYPE = "Van" then other_car = 1;
	
	if EDUCATION = "Bachelors" then bachelor = 1;
	if EDUCATION = "Masters" or EDUCATION = "PhD" then high_edu = 1;
	if EDUCATION = "z_High School" then highschool = 1;
	
	if imp_job = "Clerical" or imp_job = "z_Blue Collar" then blue_collar = 1;
	if imp_job = "Doctor" or imp_job = "Professional" or imp_job = "Lawyer" or imp_job = "Manager" then white_collar = 1;
	if imp_job = "Student" or imp_job = "Home Maker" then job_other = 1;
	
	if kidsdriv = 1 then kidsdriv_1 = 1;
	if kidsdriv = 2 then kidsdriv_2 = 1;
	if kidsdriv = 3 then kidsdriv_3 = 1;
	if kidsdriv >= 4 then kidsdriv_4 = 1;
	
	if homekids = 1 then homekids_1 = 1;
	if homekids = 2 then homekids_2 = 1;
	if homekids = 3 then homekids_3 = 1;
	if homekids = 4 then homekids_4 = 1;
	if homekids = 5 then homekids_5 = 1;
	
	if tif = 1 then tif_1 = 1;
	if tif >=2 and tif <=4 then tif_24 = 1;
	if tif >4 and tif <=10 then tif_510 = 1;
	if tif >10 then tif_11up = 1;
	
	if clm_freq = 1 then clm_freq_1 = 1;
	if clm_freq = 2 then clm_freq_2 = 1;
	if clm_freq >= 3 then clm_freq_3up = 1;
	
	if mvr_pts = 1 then mvr_pts_1 = 1;
	if mvr_pts > 1 and mvr_pts <= 5 then mvr_pts_25 = 1;
	if mvr_pts > 5 then mvr_pts_6up = 1;
	
	age_1 = 0;
	age_2 = 0;
	age_3 = 0;
	age_4 = 0;
	age_5 = 0;
	age_6 = 0;
	
	if imp_age >= 16 and imp_age <=18 then age_1 = 1;
	if imp_age > 18 and imp_age <=20 then age_2 = 1;
	if imp_age > 20 and imp_age <=30 then age_3 = 1;
	if imp_age > 30 and imp_age <=40 then age_4 = 1;
	if imp_age > 40 and imp_age <=50 then age_5 = 1;
	if imp_age > 50 and imp_age <=60 then age_6 = 1;
	
	oldclaim_low = 0;
	oldclaim_med = 0;
	oldclaim_high = 0;
	
	if oldclaim >0 and oldclaim <= 3662 then oldclaim_low = 1;
	if oldclaim > 3662 and oldclaim <= 9867 then oldclaim_med = 1;
	if oldclaim > 9867 then oldclaim_high = 1;
	
	home_owner = 0;
	if imp_home_val > 0 then home_owner = 1;
	
run;

* boxplots for numeric variables by target_flag;
proc sgplot data=insurance_1;
  vbox  age  /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for AGE";
run;

proc sgplot data=insurance_1;
  vbox  HOMEKIDS /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for #CHILDREN @HOME";
run;

proc sgplot data=insurance_1;
  vbox  YOJ /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for YEARS ON JOB";
run;

proc sgplot data=insurance_1;
  vbox  INCOME /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for INCOME";
run;

proc sgplot data=insurance_1;
  vbox  HOME_VAL /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for HOME VALUE";
run;

proc sgplot data=insurance_1;
  vbox  TRAVTIME /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for DISTANCE TO WORK";
run;

proc sgplot data=insurance_1;
  vbox  BLUEBOOK /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for VALUE OF VEHICLE";
run;

proc sgplot data=insurance_1;
  vbox  TIF /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for TIME IN FORCE";
run;

proc sgplot data=insurance_1;
  vbox  OLDCLAIM /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for TOTAL CLAIMS (PAST 5 YRS)";
run;

proc sgplot data=insurance_1;
  vbox  CLM_FREQ /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for #CLAIMS (PAST 5 YEARS)";
run;

proc sgplot data=insurance_1;
  vbox  MVR_PTS /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for MOTOR VEHICLE RECORD PTS";
run;

proc sgplot data=insurance_1;
  vbox  CAR_AGE /group=target_flag;
  xaxis label="Crash";
  keylegend / title="BoxPlot for VEHICLE AGE";
run;
	
* -----------------------------------------
* PHASE 3 Model Building
* -----------------------------------------;
* MODEL A - Shell Model;
proc logistic data=insurance_1 outmodel=insmodel_a plots(only)=roc;
   class car_type (param=ref) car_use (param=ref) education (param=ref) imp_job (param=ref)
     mstatus (param=ref) parent1 (param=ref) red_car (param=ref) urbanicity (param=ref) revoked (param=ref);
   A: model target_flag(event='1')=car_type car_use education imp_job mstatus parent1 red_car urbanicity
     imp_age bluebook imp_car_age clm_freq homekids imp_home_val imp_income kidsdriv mvr_pts oldclaim tif 
     travtime imp_yoj  
       / selection=backward sls=.05 include=0 link=logit;
   output out=pred_a p=phat  ;
run;

proc npar1way data = pred_a wilcoxon edf;
class target_flag;
var phat; 
run;

* MODEL B - Variable Transformations;
proc logistic data=insurance_1 outmodel=insmodel_b plots(only)=roc;
   class car_type (param=ref) car_use (param=ref) education (param=ref) job (param=ref)
     mstatus (param=ref) parent1 (param=ref) red_car (param=ref) urbanicity (param=ref) revoked (param=ref);
   B: model target_flag(event='1')=car_type car_use education job mstatus parent1 red_car urbanicity
     t95_age t95_bluebook t95_car_age clm_freq homekids t95_income kidsdriv mvr_pts ln_oldclaim t95_tif 
     t95_travtime imp_yoj  
       / selection=backward sls=.05 include=0 link=logit;
   output out=pred_b p=phat  ;
run;

proc npar1way data = pred_b wilcoxon edf;
class target_flag;
var phat; 
run;

* MODEL C - Final Model;
proc logistic data=insurance_1 outmodel=insmodel_c plots(only)=roc;
   class car_use (param=ref) mstatus (param=ref) parent1 (param=ref) red_car (param=ref) urbanicity (param=ref) revoked (param=ref);
   C: model target_flag(event='1')= car_use mstatus parent1 red_car urbanicity revoked minivan suv sportscar pickup other_car
   		bachelor high_edu highschool blue_collar white_collar job_other kidsdriv_1 kidsdriv_2 kidsdriv_3 kidsdriv_4 homekids_1
   		homekids_2 homekids_3 homekids_4 homekids_5 tif_1 tif_24 tif_510 tif_11up clm_freq_1 clm_freq_2 clm_freq_3up mvr_pts_1
   		mvr_pts_25 mvr_pts_6up age_1 age_2 age_3 age_4 age_5 age_6 oldclaim_low oldclaim_med oldclaim_high home_owner t95_bluebook
		t95_car_age	t95_income t95_travtime std_yoj m_yoj m_income m_age m_home_val m_car_age m_job
       / selection=backward sls=.05 include=0 link=logit;
   output out=pred_c p=phat  ;
run;

proc npar1way data = pred_c wilcoxon edf;
class target_flag;
var phat; 
run;

* LIFT CHART for Model A;
proc rank data=pred_a out=training_scores_a descending groups=10;
var phat;
ranks score_decile;
run;

proc means data=training_scores_a sum;
class score_decile;
var target_flag;
output out=pm_out_a sum(target_flag)=Y_Sum;
run;

proc print data=pm_out_a; run;

data lift_chart_a;
	set pm_out_a (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	
	* 2148 represents the number of successes; 
	* This value will need to be changed with different samples;
	pred_rate=model_pred/2153; 
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart_a; run;

ods graphics on;
title 'Model A Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart_a;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;

* LIFT CHART for Model B;
proc rank data=pred_b out=training_scores_b descending groups=10;
var phat;
ranks score_decile;
run;

proc means data=training_scores_b sum;
class score_decile;
var target_flag;
output out=pm_out_b sum(target_flag)=Y_Sum;
run;

proc print data=pm_out_b; run;

data lift_chart_b;
	set pm_out_b (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	
	* 2148 represents the number of successes; 
	* This value will need to be changed with different samples;
	pred_rate=model_pred/2153; 
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart_b; run;

ods graphics on;
title 'Model B Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart_b;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;

* LIFT CHART for Model C;
proc rank data=pred_c out=training_scores_c descending groups=10;
var phat;
ranks score_decile;
run;

proc means data=training_scores_c sum;
class score_decile;
var target_flag;
output out=pm_out_c sum(target_flag)=Y_Sum;
run;

proc print data=pm_out_c; run;

data lift_chart_c;
	set pm_out_c (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	
	* 2148 represents the number of successes; 
	* This value will need to be changed with different samples;
	pred_rate=model_pred/2153; 
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart_c; run;

ods graphics on;
title 'Model C Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart_c;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;

* -----------------------------------------
* PHASE 4 Model Deployment
* -----------------------------------------;
DATA TEST_INS;
	set mydata.logit_insurance_test;

	* address missing values for YOJ using median;
	IMP_YOJ = YOJ;
	M_YOJ = 0;
	if YOJ = '.' OR YOJ ="" then do;
		IMP_YOJ = 11;
		M_YOJ = 1;
	end;
	
	* address missing values for INCOME using median;
	IMP_INCOME = INCOME;
	M_INCOME = 0;
	if INCOME = '.' OR INCOME = "" then do;
		IMP_INCOME = 54028.17;
		M_INCOME = 1;
	end;
	
	* address missing values for AGE using median;
	IMP_AGE = AGE;
	M_AGE = 0;
	if AGE = '.' OR AGE = "" then do;
		IMP_AGE = 45;
		M_AGE = 1;
	end;
	
	* address missing values for HOME_VAL using mean;
	IMP_HOME_VAL = HOME_VAL;
	M_HOME_VAL = 0;
	if HOME_VAL = '.' OR HOME_VAL = "" then do;
		IMP_HOME_VAL = 154867.29;
		M_HOME_VAL = 1;
	end;
	
	* address missing values for CAR_AGE using median;
	IMP_CAR_AGE = CAR_AGE;
	M_CAR_AGE = 0;
	if CAR_AGE = '.' OR CAR_AGE = "" then do;
		IMP_CAR_AGE = 8;
		M_CAR_AGE = 1;
	end;
	
	* address missing values for CAR_AGE using median;
	IMP_JOB = JOB;
	M_JOB = 0;
	if JOB = '.' or JOB = " " then do;
		IMP_JOB = 'z_Blue Collar';
		M_JOB = 1;
	end;
	
	* variable transformation options for age;
	T95_AGE 		= max(min(IMP_AGE,&P95_AGE.), &P5_AGE.);
	T99_AGE 		= max(min(IMP_AGE,&P99_AGE.), &P1_AGE.);
	STD_AGE 		= (IMP_AGE-&U_AGE.) / &S_AGE.;
	T_STD_AGE		= max(min(STD_AGE,3),-3);
	LN_AGE 			= sign(IMP_AGE) * log(abs(IMP_AGE)+1);
	LOG10_AGE 		= sign(IMP_AGE) * log10(abs(IMP_AGE)+1);
	
	* variable transformation options for income;
	T95_INCOME 		= max(min(IMP_INCOME,&P95_INCOME.), &P5_INCOME.);
	T99_INCOME 		= max(min(IMP_INCOME,&P99_INCOME.), &P1_INCOME.);
	STD_INCOME 		= (IMP_INCOME-&U_INCOME.) / &S_INCOME.;
	T_STD_INCOME	= max(min(STD_INCOME,3),-3);
	LN_INCOME 		= sign(IMP_INCOME) * log(abs(IMP_INCOME)+1);
	LOG10_INCOME 	= sign(IMP_INCOME) * log10(abs(IMP_INCOME)+1);
	
	* variable transformation options for HOME VALUE;
	T95_HOME_VAL 	= max(min(IMP_HOME_VAL,&P95_HOME_VAL.), &P5_HOME_VAL.);
	T99_HOME_VAL 	= max(min(IMP_HOME_VAL,&P99_HOME_VAL.), &P1_HOME_VAL.);
	STD_HOME_VAL 	= (IMP_HOME_VAL-&U_HOME_VAL.) / &S_HOME_VAL.;
	T_STD_HOME_VAL	= max(min(STD_HOME_VAL,3),-3);
	LN_HOME_VAL 	= sign(IMP_HOME_VAL) * log(abs(IMP_HOME_VAL)+1);
	LOG10_HOME_VAL 	= sign(IMP_HOME_VAL) * log10(abs(IMP_HOME_VAL)+1);
	
	* variable transformation options for TRAVEL TIME;
	T95_TRAVTIME	= max(min(TRAVTIME,&P95_TRAVTIME.), &P5_TRAVTIME.);
	T99_TRAVTIME	= max(min(TRAVTIME,&P99_TRAVTIME.), &P1_TRAVTIME.);
	STD_TRAVTIME	= (TRAVTIME-&U_TRAVTIME.) / &S_TRAVTIME.;
	T_STD_TRAVTIME	= max(min(STD_TRAVTIME,3),-3);
	LN_TRAVTIME		= sign(TRAVTIME) * log(abs(TRAVTIME)+1);
	LOG10_TRAVTIME	= sign(TRAVTIME) * log10(abs(TRAVTIME)+1);
	
	* variable transformation options for OLDCLAIM;
	T95_OLDCLAIM	= max(min(OLDCLAIM,&P95_OLDCLAIM.), &P5_OLDCLAIM.);
	T99_OLDCLAIM	= max(min(OLDCLAIM,&P99_OLDCLAIM.), &P1_OLDCLAIM.);
	STD_OLDCLAIM	= (OLDCLAIM-&U_OLDCLAIM.) / &S_OLDCLAIM.;
	T_STD_OLDCLAIM	= max(min(STD_OLDCLAIM,3),-3);
	LN_OLDCLAIM		= sign(OLDCLAIM) * log(abs(OLDCLAIM)+1);
	LOG10_OLDCLAIM	= sign(OLDCLAIM) * log10(abs(OLDCLAIM)+1);
	
	* variable transformation options for BLUEBOOK;
	T95_BLUEBOOK	= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_BLUEBOOK	= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_BLUEBOOK	= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_BLUEBOOK	= max(min(STD_BLUEBOOK,3),-3);
	LN_BLUEBOOK		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_BLUEBOOK	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for TIF;
	T95_BLUEBOOK	= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_BLUEBOOK	= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_BLUEBOOK	= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_BLUEBOOK	= max(min(STD_BLUEBOOK,3),-3);
	LN_BLUEBOOK		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_BLUEBOOK	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for TIF;
	T95_TIF		= max(min(BLUEBOOK,&P95_BLUEBOOK.), &P5_BLUEBOOK.);
	T99_TIF		= max(min(BLUEBOOK,&P99_BLUEBOOK.), &P1_BLUEBOOK.);
	STD_TIF		= (BLUEBOOK-&U_BLUEBOOK.) / &S_BLUEBOOK.;
	T_STD_TIF	= max(min(STD_BLUEBOOK,3),-3);
	LN_TIF		= sign(BLUEBOOK) * log(abs(BLUEBOOK)+1);
	LOG10_TIF	= sign(BLUEBOOK) * log10(abs(BLUEBOOK)+1);
	
	* variable transformation options for car age;
	T95_CAR_AGE		= max(min(IMP_CAR_AGE,&P95_CAR_AGE.), &P5_CAR_AGE.);
	T99_CAR_AGE		= max(min(IMP_CAR_AGE,&P99_CAR_AGE.), &P1_CAR_AGE.);
	STD_CAR_AGE		= (IMP_CAR_AGE-&U_CAR_AGE.) / &S_CAR_AGE.;
	T_STD_CAR_AGE	= max(min(STD_CAR_AGE,3),-3);
	LN_CAR_AGE		= sign(IMP_CAR_AGE) * log(abs(IMP_CAR_AGE)+1);
	LOG10_CAR_AGE	= sign(IMP_CAR_AGE) * log10(abs(IMP_CAR_AGE)+1);
	
	* variable transformation options for yoj;
	T95_YOJ 		= max(min(IMP_YOJ,&P95_YOJ.), &P5_YOJ.);
	T99_YOJ 		= max(min(IMP_YOJ,&P99_YOJ.), &P1_YOJ.);
	STD_YOJ 		= (IMP_YOJ-&U_YOJ.) / &S_YOJ.;
	T_STD_YOJ		= max(min(STD_YOJ,3),-3);
	LN_YOJ 			= sign(IMP_YOJ) * log(abs(IMP_YOJ)+1);
	LOG10_YOJ 		= sign(IMP_YOJ) * log10(abs(IMP_YOJ)+1);
	
	minivan = 0;
	sportscar = 0;
	pickup = 0;
	suv = 0;
	other_car = 0;
	bachelor = 0;
	high_edu = 0;
	highschool = 0;
	phd = 0;
	white_collar = 0;
	blue_collar = 0;
	job_other = 0;
	kidsdriv_1 = 0;
	kidsdriv_2 = 0;
	kidsdriv_3= 0;
	kidsdriv_4= 0;
	homekids_1 = 0;
	homekids_2 = 0;
	homekids_3= 0;
	homekids_4 = 0;
	homekids_5 = 0;
	tif_1 = 0;
	tif_24 = 0;
	tif_510 = 0;
	tif_11up = 0;
	clm_freq_1 = 0;
	clm_freq_2 = 0;
	clm_freq_3up = 0;
	mvr_pts_1 = 0;
	mvr_pts_25 = 0;
	mvr_pts_6up = 0;
	
	
	if CAR_TYPE = "Minivan" then minivan=1;
	if CAR_TYPE = "z_SUV" then suv = 1;
	if CAR_TYPE = "Sports Car" then sportscar = 1;
	if CAR_TYPE = "Pickup" then pickup = 1;
	if CAR_TYPE = "Panel Truck" or CAR_TYPE = "Van" then other_car = 1;
	
	if EDUCATION = "Bachelors" then bachelor = 1;
	if EDUCATION = "Masters" or EDUCATION = "PhD" then high_edu = 1;
	if EDUCATION = "z_High School" then highschool = 1;
	
	if imp_job = "Clerical" or imp_job = "z_Blue Collar" then blue_collar = 1;
	if imp_job = "Doctor" or imp_job = "Professional" or imp_job = "Lawyer" or imp_job = "Manager" then white_collar = 1;
	if imp_job = "Student" or imp_job = "Home Maker" then job_other = 1;
	
	if kidsdriv = 1 then kidsdriv_1 = 1;
	if kidsdriv = 2 then kidsdriv_2 = 1;
	if kidsdriv = 3 then kidsdriv_3 = 1;
	if kidsdriv >= 4 then kidsdriv_4 = 1;
	
	if homekids = 1 then homekids_1 = 1;
	if homekids = 2 then homekids_2 = 1;
	if homekids = 3 then homekids_3 = 1;
	if homekids = 4 then homekids_4 = 1;
	if homekids = 5 then homekids_5 = 1;
	
	if tif = 1 then tif_1 = 1;
	if tif >=2 and tif <=4 then tif_24 = 1;
	if tif >4 and tif <=10 then tif_510 = 1;
	if tif >10 then tif_11up = 1;
	
	if clm_freq = 1 then clm_freq_1 = 1;
	if clm_freq = 2 then clm_freq_2 = 1;
	if clm_freq >= 3 then clm_freq_3up = 1;
	
	if mvr_pts = 1 then mvr_pts_1 = 1;
	if mvr_pts > 1 and mvr_pts <= 5 then mvr_pts_25 = 1;
	if mvr_pts > 5 then mvr_pts_6up = 1;
	
	age_1 = 0;
	age_2 = 0;
	age_3 = 0;
	age_4 = 0;
	age_5 = 0;
	age_6 = 0;
	
	if imp_age >= 16 and imp_age <=18 then age_1 = 1;
	if imp_age > 18 and imp_age <=20 then age_2 = 1;
	if imp_age > 20 and imp_age <=30 then age_3 = 1;
	if imp_age > 30 and imp_age <=40 then age_4 = 1;
	if imp_age > 40 and imp_age <=50 then age_5 = 1;
	if imp_age > 50 and imp_age <=60 then age_6 = 1;
	
	oldclaim_low = 0;
	oldclaim_med = 0;
	oldclaim_high = 0;
	
	if oldclaim >0 and oldclaim <= 3662 then oldclaim_low = 1;
	if oldclaim > 3662 and oldclaim <= 9867 then oldclaim_med = 1;
	if oldclaim > 9867 then oldclaim_high = 1;
	
	home_owner = 0;
	if imp_home_val > 0 then home_owner = 1;

run;

*SCORE the test data;
proc logistic inmodel=insmodel_c;
   score data=TEST_INS out=testscore;
run;

data demo_ins_prob;
   set testscore;
   p_target_flag= p_1;
   keep index p_target_flag;
run;

data demo_ins_amt;
   set testscore;
   * SET THE ESTIMATED TARGET AMOUNT TO THE MEAN OF THE TARGET_AMT FROM THE TRAINING SET;
   p_target_amt = 5702.17996;
   keep index p_target_amt;
run;

* merge the datasets for the final submission;
data demo_ins;
merge demo_ins_prob(in=ina) demo_ins_amt(in=inb);
by INDEX;
if ina;
run;