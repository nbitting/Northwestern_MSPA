********************************************************
		Nate Bitting
		Assignment 1
		Predict 411
********************************************************;

* -----------------------------------------
* PHASE 1: Data Exploration
* -----------------------------------------;

libname MYDATA "/folders/myfolders/PREDICT 411/data";

* read in the moneyball dataset;
data moneyball;
set MYDATA.MONEYBALL;
cvar=0; *variable to use for boxplots;
run;

* print the contents of the dataset;
proc contents data=moneyball;
run;

* print the first 10 observations;
proc print data=moneyball(obs=10);
run;

* explore the mean/spread and missing values of each numeric variable;
proc means data=moneyball n nmiss mean median min p5 p50 p90 p95 p99 max; 
var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB 
TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_BATTING_HBP TEAM_PITCHING_H
TEAM_PITCHING_HR TEAM_PITCHING_BB TEAM_PITCHING_SO TEAM_FIELDING_E TEAM_FIELDING_DP;
run;

* examine the extreme observations using the univarite procedure;
proc univariate data=moneyball;
histogram TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB 
TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_BATTING_HBP TEAM_PITCHING_H
TEAM_PITCHING_HR TEAM_PITCHING_BB TEAM_PITCHING_SO TEAM_FIELDING_E TEAM_FIELDING_DP;
run;

* boxplot of each numeric variable;
title 'Boxplot for each numeric variable';
proc boxplot data=moneyball;
	plot (TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB 
TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_BATTING_HBP TEAM_PITCHING_H
TEAM_PITCHING_HR TEAM_PITCHING_BB TEAM_PITCHING_SO TEAM_FIELDING_E TEAM_FIELDING_DP)*cvar;
run;

* explore the correlation matrix for the predictor and response variable;
proc corr data=moneyball;
var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB 
TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_BATTING_HBP TEAM_PITCHING_H
TEAM_PITCHING_HR TEAM_PITCHING_BB TEAM_PITCHING_SO TEAM_FIELDING_E TEAM_FIELDING_DP;
run;

* -----------------------------------------
* PHASE 2 Data Preparation
* -----------------------------------------;

* get the variables needed to perform the variable transformations;
proc means data=moneyball noprint;
	output out=meanfile
	
	mean(TEAM_BASERUN_SB) = U_TEAM_BASERUN_SB
	stddev(TEAM_BASERUN_SB) = S_TEAM_BASERUN_SB
	P1(TEAM_BASERUN_SB) = P1_TEAM_BASERUN_SB
	P5(TEAM_BASERUN_SB) = P5_TEAM_BASERUN_SB
	P95(TEAM_BASERUN_SB) = P95_TEAM_BASERUN_SB
	P99(TEAM_BASERUN_SB) = P99_TEAM_BASERUN_SB
	MIN(TEAM_BASERUN_SB) = MIN_TEAM_BASERUN_SB
	MAX(TEAM_BASERUN_SB) = MAX_TEAM_BASERUN_SB

	mean(TEAM_FIELDING_DP) = U_TEAM_FIELDING_DP
	stddev(TEAM_FIELDING_DP) = S_TEAM_FIELDING_DP
	P1(TEAM_FIELDING_DP) = P1_TEAM_FIELDING_DP
	P5(TEAM_FIELDING_DP) = P5_TEAM_FIELDING_DP
	P95(TEAM_FIELDING_DP) = P95_TEAM_FIELDING_DP
	P99(TEAM_FIELDING_DP) = P99_TEAM_FIELDING_DP
	MIN(TEAM_FIELDING_DP) = MIN_TEAM_FIELDING_DP
	MAX(TEAM_FIELDING_DP) = MAX_TEAM_FIELDING_DP

	mean(TEAM_PITCHING_HR) = U_TEAM_PITCHING_HR
	stddev(TEAM_PITCHING_HR) = S_TEAM_PITCHING_HR
	P1(TEAM_PITCHING_HR) = P1_TEAM_PITCHING_HR
	P5(TEAM_PITCHING_HR) = P5_TEAM_PITCHING_HR
	P95(TEAM_PITCHING_HR) = P95_TEAM_PITCHING_HR
	P99(TEAM_PITCHING_HR) = P99_TEAM_PITCHING_HR
	MIN(TEAM_PITCHING_HR) = MIN_TEAM_PITCHING_HR
	MAX(TEAM_PITCHING_HR) = MAX_TEAM_PITCHING_HR
	
	mean(TEAM_BATTING_HR) = U_TEAM_BATTING_HR
	stddev(TEAM_BATTING_HR) = S_TEAM_BATTING_HR
	P1(TEAM_BATTING_HR) = P1_TEAM_BATTING_HR
	P5(TEAM_BATTING_HR) = P5_TEAM_BATTING_HR
	P95(TEAM_BATTING_HR) = P95_TEAM_BATTING_HR
	P99(TEAM_BATTING_HR) = P99_TEAM_BATTING_HR
	MIN(TEAM_BATTING_HR) = MIN_TEAM_BATTING_HR
	MAX(TEAM_BATTING_HR) = MAX_TEAM_BATTING_HR
	
	mean(TEAM_BASERUN_CS) = U_TEAM_BASERUN_CS
	stddev(TEAM_BASERUN_CS) = S_TEAM_BASERUN_CS
	P1(TEAM_BASERUN_CS) = P1_TEAM_BASERUN_CS
	P5(TEAM_BASERUN_CS) = P5_TEAM_BASERUN_CS
	P95(TEAM_BASERUN_CS) = P95_TEAM_BASERUN_CS
	P99(TEAM_BASERUN_CS) = P99_TEAM_BASERUN_CS
	MIN(TEAM_BASERUN_CS) = MIN_TEAM_BASERUN_CS
	MAX(TEAM_BASERUN_CS) = MAX_TEAM_BASERUN_CS

	mean(TEAM_BATTING_H) = U_TEAM_BATTING_H
	stddev(TEAM_BATTING_H) = S_TEAM_BATTING_H
	P1(TEAM_BATTING_H) = P1_TEAM_BATTING_H
	P5(TEAM_BATTING_H) = P5_TEAM_BATTING_H
	P95(TEAM_BATTING_H) = P95_TEAM_BATTING_H
	P99(TEAM_BATTING_H) = P99_TEAM_BATTING_H
	MIN(TEAM_BATTING_H) = MIN_TEAM_BATTING_H
	MAX(TEAM_BATTING_H) = MAX_TEAM_BATTING_H

	mean(TEAM_BATTING_2B) = U_TEAM_BATTING_2B
	stddev(TEAM_BATTING_2B) = S_TEAM_BATTING_2B
	P1(TEAM_BATTING_2B) = P1_TEAM_BATTING_2B
	P5(TEAM_BATTING_2B) = P5_TEAM_BATTING_2B
	P95(TEAM_BATTING_2B) = P95_TEAM_BATTING_2B
	P99(TEAM_BATTING_2B) = P99_TEAM_BATTING_2B
	MIN(TEAM_BATTING_2B) = MIN_TEAM_BATTING_2B
	MAX(TEAM_BATTING_2B) = MAX_TEAM_BATTING_2B
	
	mean(TEAM_PITCHING_BB) = U_TEAM_PITCHING_BB
	stddev(TEAM_PITCHING_BB) = S_TEAM_PITCHING_BB
	P1(TEAM_PITCHING_BB) = P1_TEAM_PITCHING_BB
	P5(TEAM_PITCHING_BB) = P5_TEAM_PITCHING_BB
	P95(TEAM_PITCHING_BB) = P95_TEAM_PITCHING_BB
	P99(TEAM_PITCHING_BB) = P99_TEAM_PITCHING_BB
	MIN(TEAM_PITCHING_BB) = MIN_TEAM_PITCHING_BB
	MAX(TEAM_PITCHING_BB) = MAX_TEAM_PITCHING_BB
	
	mean(TEAM_PITCHING_H) = U_TEAM_PITCHING_H
	stddev(TEAM_PITCHING_H) = S_TEAM_PITCHING_H
	P1(TEAM_PITCHING_H) = P1_TEAM_PITCHING_H
	P5(TEAM_PITCHING_H) = P5_TEAM_PITCHING_H
	P95(TEAM_PITCHING_H) = P95_TEAM_PITCHING_H
	P99(TEAM_PITCHING_H) = P99_TEAM_PITCHING_H
	MIN(TEAM_PITCHING_H) = MIN_TEAM_PITCHING_H
	MAX(TEAM_PITCHING_H) = MAX_TEAM_PITCHING_H

	mean(TEAM_PITCHING_SO) = U_TEAM_PITCHING_SO
	stddev(TEAM_PITCHING_SO) = S_TEAM_PITCHING_SO
	P1(TEAM_PITCHING_SO) = P1_TEAM_PITCHING_SO
	P5(TEAM_PITCHING_SO) = P5_TEAM_PITCHING_SO
	P95(TEAM_PITCHING_SO) = P95_TEAM_PITCHING_SO
	P99(TEAM_PITCHING_SO) = P99_TEAM_PITCHING_SO
	MIN(TEAM_PITCHING_SO) = MIN_TEAM_PITCHING_SO
	MAX(TEAM_PITCHING_SO) = MAX_TEAM_PITCHING_SO
	
	mean(TEAM_BATTING_SO) = U_TEAM_BATTING_SO
	stddev(TEAM_BATTING_SO) = S_TEAM_BATTING_SO
	P1(TEAM_BATTING_SO) = P1_TEAM_BATTING_SO
	P5(TEAM_BATTING_SO) = P5_TEAM_BATTING_SO
	P95(TEAM_BATTING_SO) = P95_TEAM_BATTING_SO
	P99(TEAM_BATTING_SO) = P99_TEAM_BATTING_SO
	MIN(TEAM_BATTING_SO) = MIN_TEAM_BATTING_SO
	MAX(TEAM_BATTING_SO) = MAX_TEAM_BATTING_SO
	
	mean(TEAM_FIELDING_E) = U_TEAM_FIELDING_E
	stddev(TEAM_FIELDING_E) = S_TEAM_FIELDING_E
	P1(TEAM_FIELDING_E) = P1_TEAM_FIELDING_E
	P5(TEAM_FIELDING_E) = P5_TEAM_FIELDING_E
	P95(TEAM_FIELDING_E) = P95_TEAM_FIELDING_E
	P99(TEAM_FIELDING_E) = P99_TEAM_FIELDING_E
	MIN(TEAM_FIELDING_E) = MIN_TEAM_FIELDING_E
	MAX(TEAM_FIELDING_E) = MAX_TEAM_FIELDING_E;
run;

data;
set MEANFILE;
call symput("U_TEAM_BASERUN_SB"		,U_TEAM_BASERUN_SB);
call symput("S_TEAM_BASERUN_SB"		,S_TEAM_BASERUN_SB);
call symput("P1_TEAM_BASERUN_SB"	,P1_TEAM_BASERUN_SB);
call symput("P5_TEAM_BASERUN_SB"	,P5_TEAM_BASERUN_SB);
call symput("P95_TEAM_BASERUN_SB"	,P95_TEAM_BASERUN_SB);
call symput("P99_TEAM_BASERUN_SB"	,P99_TEAM_BASERUN_SB);
call symput("MIN_TEAM_BASERUN_SB"	,MIN_TEAM_BASERUN_SB);
call symput("MAX_TEAM_BASERUN_SB"	,MAX_TEAM_BASERUN_SB);

call symput("U_TEAM_FIELDING_DP"	,U_TEAM_FIELDING_DP);
call symput("S_TEAM_FIELDING_DP"	,S_TEAM_FIELDING_DP);
call symput("P1_TEAM_FIELDING_DP"	,P1_TEAM_FIELDING_DP);
call symput("P5_TEAM_FIELDING_DP"	,P5_TEAM_FIELDING_DP);
call symput("P95_TEAM_FIELDING_DP"	,P95_TEAM_FIELDING_DP);
call symput("P99_TEAM_FIELDING_DP"	,P99_TEAM_FIELDING_DP);
call symput("MIN_TEAM_FIELDING_DP"	,MIN_TEAM_FIELDING_DP);
call symput("MAX_TEAM_FIELDING_DP"	,MAX_TEAM_FIELDING_DP);

call symput("U_TEAM_PITCHING_HR"	,U_TEAM_PITCHING_HR);
call symput("S_TEAM_PITCHING_HR"	,S_TEAM_PITCHING_HR);
call symput("P1_TEAM_PITCHING_HR"	,P1_TEAM_PITCHING_HR);
call symput("P5_TEAM_PITCHING_HR"	,P5_TEAM_PITCHING_HR);
call symput("P95_TEAM_PITCHING_HR"	,P95_TEAM_PITCHING_HR);
call symput("P99_TEAM_PITCHING_HR"	,P99_TEAM_PITCHING_HR);
call symput("MIN_TEAM_PITCHING_HR"	,MIN_TEAM_PITCHING_HR);
call symput("MAX_TEAM_PITCHING_HR"	,MAX_TEAM_PITCHING_HR);

call symput("U_TEAM_BATTING_HR"	,U_TEAM_BATTING_HR);
call symput("S_TEAM_BATTING_HR"	,S_TEAM_BATTING_HR);
call symput("P1_TEAM_BATTING_HR"	,P1_TEAM_BATTING_HR);
call symput("P5_TEAM_BATTING_HR"	,P5_TEAM_BATTING_HR);
call symput("P95_TEAM_BATTING_HR"	,P95_TEAM_BATTING_HR);
call symput("P99_TEAM_BATTING_HR"	,P99_TEAM_BATTING_HR);
call symput("MIN_TEAM_BATTING_HR"	,MIN_TEAM_BATTING_HR);
call symput("MAX_TEAM_BATTING_HR"	,MAX_TEAM_BATTING_HR);

call symput("U_TEAM_BASERUN_CS"	,U_TEAM_BASERUN_CS);
call symput("S_TEAM_BASERUN_CS"	,S_TEAM_BASERUN_CS);
call symput("P1_TEAM_BASERUN_CS"	,P1_TEAM_BASERUN_CS);
call symput("P5_TEAM_BASERUN_CS"	,P5_TEAM_BASERUN_CS);
call symput("P95_TEAM_BASERUN_CS"	,P95_TEAM_BASERUN_CS);
call symput("P99_TEAM_BASERUN_CS"	,P99_TEAM_BASERUN_CS);
call symput("MIN_TEAM_BASERUN_CS"	,MIN_TEAM_BASERUN_CS);
call symput("MAX_TEAM_BASERUN_CS"	,MAX_TEAM_BASERUN_CS);

call symput("U_TEAM_BATTING_H"		,U_TEAM_BATTING_H);
call symput("S_TEAM_BATTING_H"		,S_TEAM_BATTING_H);
call symput("P1_TEAM_BATTING_H"		,P1_TEAM_BATTING_H);
call symput("P5_TEAM_BATTING_H"		,P5_TEAM_BATTING_H);
call symput("P95_TEAM_BATTING_H"	,P95_TEAM_BATTING_H);
call symput("P99_TEAM_BATTING_H"	,P99_TEAM_BATTING_H);
call symput("MIN_TEAM_BATTING_H"	,MIN_TEAM_BATTING_H);
call symput("MAX_TEAM_BATTING_H"	,MAX_TEAM_BATTING_H);

call symput("U_TEAM_BATTING_2B"		,U_TEAM_BATTING_2B);
call symput("S_TEAM_BATTING_2B"		,S_TEAM_BATTING_2B);
call symput("P1_TEAM_BATTING_2B"	,P1_TEAM_BATTING_2B);
call symput("P5_TEAM_BATTING_2B"	,P5_TEAM_BATTING_2B);
call symput("P95_TEAM_BATTING_2B"	,P95_TEAM_BATTING_2B);
call symput("P99_TEAM_BATTING_2B"	,P99_TEAM_BATTING_2B);
call symput("MIN_TEAM_BATTING_2B"	,MIN_TEAM_BATTING_2B);
call symput("MAX_TEAM_BATTING_2B"	,MAX_TEAM_BATTING_2B);

call symput("U_TEAM_PITCHING_BB"	,U_TEAM_PITCHING_BB);
call symput("S_TEAM_PITCHING_BB"	,S_TEAM_PITCHING_BB);
call symput("P1_TEAM_PITCHING_BB"	,P1_TEAM_PITCHING_BB);
call symput("P5_TEAM_PITCHING_BB"	,P5_TEAM_PITCHING_BB);
call symput("P95_TEAM_PITCHING_BB"	,P95_TEAM_PITCHING_BB);
call symput("P99_TEAM_PITCHING_BB"	,P99_TEAM_PITCHING_BB);
call symput("MIN_TEAM_PITCHING_BB"	,MIN_TEAM_PITCHING_BB);
call symput("MAX_TEAM_PITCHING_BB"	,MAX_TEAM_PITCHING_BB);

call symput("U_TEAM_PITCHING_H"		,U_TEAM_PITCHING_H);
call symput("S_TEAM_PITCHING_H"		,S_TEAM_PITCHING_H);
call symput("P1_TEAM_PITCHING_H"		,P1_TEAM_PITCHING_H);
call symput("P5_TEAM_PITCHING_H"		,P5_TEAM_PITCHING_H);
call symput("P95_TEAM_PITCHING_H"	,P95_TEAM_PITCHING_H);
call symput("P99_TEAM_PITCHING_H"	,P99_TEAM_PITCHING_H);
call symput("MIN_TEAM_PITCHING_H"	,MIN_TEAM_PITCHING_H);
call symput("MAX_TEAM_PITCHING_H"	,MAX_TEAM_PITCHING_H);

call symput("U_TEAM_PITCHING_SO"	,U_TEAM_PITCHING_SO);
call symput("S_TEAM_PITCHING_SO"	,S_TEAM_PITCHING_SO);
call symput("P1_TEAM_PITCHING_SO"	,P1_TEAM_PITCHING_SO);
call symput("P5_TEAM_PITCHING_SO"	,P5_TEAM_PITCHING_SO);
call symput("P95_TEAM_PITCHING_SO"	,P95_TEAM_PITCHING_SO);
call symput("P99_TEAM_PITCHING_SO"	,P99_TEAM_PITCHING_SO);
call symput("MIN_TEAM_PITCHING_SO"	,MIN_TEAM_PITCHING_SO);
call symput("MAX_TEAM_PITCHING_SO"	,MAX_TEAM_PITCHING_SO);

call symput("U_TEAM_BATTING_SO"		,U_TEAM_BATTING_SO);
call symput("S_TEAM_BATTING_SO"		,S_TEAM_BATTING_SO);
call symput("P1_TEAM_BATTING_SO"	,P1_TEAM_BATTING_SO);
call symput("P5_TEAM_BATTING_SO"	,P5_TEAM_BATTING_SO);
call symput("P95_TEAM_BATTING_SO"	,P95_TEAM_BATTING_SO);
call symput("P99_TEAM_BATTING_SO"	,P99_TEAM_BATTING_SO);
call symput("MIN_TEAM_BATTING_SO"	,MIN_TEAM_BATTING_SO);
call symput("MAX_TEAM_BATTING_SO"	,MAX_TEAM_BATTING_SO);

call symput("U_TEAM_FIELDING_E"		,U_TEAM_FIELDING_E);
call symput("S_TEAM_FIELDING_E"		,S_TEAM_FIELDING_E);
call symput("P1_TEAM_FIELDING_E"	,P1_TEAM_FIELDING_E);
call symput("P5_TEAM_FIELDING_E"	,P5_TEAM_FIELDING_E);
call symput("P95_TEAM_FIELDING_E"	,P95_TEAM_FIELDING_E);
call symput("P99_TEAM_FIELDING_E"	,P99_TEAM_FIELDING_E);
call symput("MIN_TEAM_FIELDING_E"	,MIN_TEAM_FIELDING_E);
call symput("MAX_TEAM_FIELDING_E"	,MAX_TEAM_FIELDING_E);
run;


* dataset to transform variables, fix missing values, and create flags for imputed values;
data moneyball_clean;
	set moneyball;
	
	* drop the Batters hit by pitch because 92% of the observations have missing values;
	drop TEAM_BATTING_HBP; 
	
	* address missing values for TEAM_BATTING_SO;
	IMP_TEAM_BATTING_SO = TEAM_BATTING_SO;
	M_TEAM_BATTING_SO = 0;
	if TEAM_BATTING_SO = '.' then do;
		IMP_TEAM_BATTING_SO = 750;
		M_TEAM_BATTING_SO = 1;
	end;
	
	* address missing values for TEAM_BASERUN_SB;
	IMP_TEAM_BASERUN_SB = TEAM_BASERUN_SB;
	M_TEAM_BASERUN_SB = 0;
	if TEAM_BASERUN_SB ='.' then do;
		IMP_TEAM_BASERUN_SB = 101;
		M_TEAM_BASERUN_SB = 1;
	end;

	* address missing values for TEAM_BASERUN_CS;
	IMP_TEAM_BASERUN_CS = TEAM_BASERUN_CS;
	M_TEAM_BASERUN_CS = 0;
	if TEAM_BASERUN_CS = '.' then do;
		IMP_TEAM_BASERUN_CS = 49;
		M_TEAM_BASERUN_CS = 1;
	end;
	
	* address missing values for TEAM_PITCHING_SO;
	IMP_TEAM_PITCHING_SO = TEAM_PITCHING_SO;
	M_TEAM_PITCHING_SO = 0;
	if TEAM_PITCHING_SO = '.' then do;
		IMP_TEAM_PITCHING_SO = 813.5;
		M_TEAM_PITCHING_SO = 1;
	end;

	* address missing values for TEAM_FIELDING_DP;
	IMP_TEAM_FIELDING_DP = TEAM_FIELDING_DP;
	M_TEAM_FIELDING_DP = 0;
	if missing(TEAM_FIELDING_DP) then do;
		IMP_TEAM_FIELDING_DP = 149;
		M_TEAM_FIELDING_DP = 1;
	end;

	* create new variables;
	TEAM_BATTING_1B = TEAM_BATTING_H - TEAM_BATTING_HR - TEAM_BATTING_2B - TEAM_BATTING_3B;
	
	TEAM_BASES_EARNED = 	4*TEAM_BATTING_HR 
						+ 	3*TEAM_BATTING_3B 
						+ 	2*TEAM_BATTING_2B
						+ 	1*TEAM_BATTING_1B
						+	1*TEAM_BATTING_BB
						+	1*IMP_TEAM_BASERUN_SB
						-	1*IMP_TEAM_BASERUN_CS;
			
	* bin variable for team_baserun_cs;
	if imp_team_baserun_cs <= 27 then team_baserun_cs_1=1; else team_baserun_cs_1=0;
	if (imp_team_baserun_cs > 27) and (imp_team_baserun_cs <= 44) then team_baserun_cs_2=1; else team_baserun_cs_2=0;
	if (imp_team_baserun_cs > 44) and (imp_team_baserun_cs <= 49) then team_baserun_cs_3=1; else team_baserun_cs_3=0;
	if (imp_team_baserun_cs > 49) and (imp_team_baserun_cs <= 54.5) then team_baserun_cs_4=1; else team_baserun_cs_4=0;
	
	* bin variable for team_baserun_sb;
	if imp_team_baserun_sb <= 36 then team_baserun_sb_1=1; else team_baserun_sb_1=0;
	if (imp_team_baserun_sb > 36) and (imp_team_baserun_sb <= 67) then team_baserun_sb_2=1; else team_baserun_sb_2=0;
	if (imp_team_baserun_sb > 67) and (imp_team_baserun_sb <= 101) then team_baserun_sb_3=1; else team_baserun_sb_3=0;
	if (imp_team_baserun_sb > 101) and (imp_team_baserun_sb <= 151) then team_baserun_sb_4=1; else team_baserun_sb_4=0;
	
	* bin variable for team_batting_so;
	if IMP_TEAM_BATTING_SO <= 363 then TEAM_BATTING_SO_1=1; else TEAM_BATTING_SO_1=0;
	if (IMP_TEAM_BATTING_SO > 363) and (IMP_TEAM_BATTING_SO <= 556.5) then TEAM_BATTING_SO_2=1; else TEAM_BATTING_SO_2=0;
	if (IMP_TEAM_BATTING_SO > 556.5) and (IMP_TEAM_BATTING_SO <= 750) then TEAM_BATTING_SO_3=1; else TEAM_BATTING_SO_3=0;
	if (IMP_TEAM_BATTING_SO > 750) and (IMP_TEAM_BATTING_SO <= 925) then TEAM_BATTING_SO_4=1; else TEAM_BATTING_SO_4=0;
	
	* bin variable for team_fielding_dp;
	if IMP_TEAM_FIELDING_DP <= 100 then TEAM_FIELDING_DP_1=1; else TEAM_FIELDING_DP_1=0;
	if (IMP_TEAM_FIELDING_DP > 100) and (IMP_TEAM_FIELDING_DP <= 134) then TEAM_FIELDING_DP_2=1; else TEAM_FIELDING_DP_2=0;
	if (IMP_TEAM_FIELDING_DP > 134) and (IMP_TEAM_FIELDING_DP<= 149) then TEAM_FIELDING_DP_3=1; else TEAM_FIELDING_DP_3=0;
	if (IMP_TEAM_FIELDING_DP > 149) and (IMP_TEAM_FIELDING_DP<= 161.5) then TEAM_FIELDING_DP_4=1; else TEAM_FIELDING_DP_4=0;

	* bin variable for team_pitching_so;
	if IMP_TEAM_PITCHING_SO <= 423 then TEAM_PITCHING_SO_1=1; else TEAM_PITCHING_SO_1=0;
	if (IMP_TEAM_PITCHING_SO > 423) and (IMP_TEAM_PITCHING_SO <= 626) then TEAM_PITCHING_SO_2=1; else TEAM_PITCHING_SO_2=0;
	if (IMP_TEAM_PITCHING_SO > 626) and (IMP_TEAM_PITCHING_SO<= 813.5) then TEAM_PITCHING_SO_3=1; else TEAM_PITCHING_SO_3=0;
	if (IMP_TEAM_PITCHING_SO > 813.5) and (IMP_TEAM_PITCHING_SO<= 957) then TEAM_PITCHING_SO_4=1; else TEAM_PITCHING_SO_4=0;	
	
	* bin variable for team_bases_earned;
	if TEAM_BASES_EARNED <= 2257 then TEAM_BASES_EARNED_1=1; else TEAM_BASES_EARNED_1=0;
	if (TEAM_BASES_EARNED > 2257) and (TEAM_BASES_EARNED <= 2530) then TEAM_BASES_EARNED_2=1; else TEAM_BASES_EARNED_2=0;
	if (TEAM_BASES_EARNED > 2530) and (TEAM_BASES_EARNED <= 2720) then TEAM_BASES_EARNED_3=1; else TEAM_BASES_EARNED_3=0;
	if (TEAM_BASES_EARNED > 2720) and (TEAM_BASES_EARNED <= 2901) then TEAM_BASES_EARNED_4=1; else TEAM_BASES_EARNED_4=0;	

	* bin variable for team_batting_1b;
	if TEAM_BATTING_1B <= 919 then TEAM_BATTING_1B_1=1; else TEAM_BATTING_1B_1=0;
	if (TEAM_BATTING_1B > 919) and (TEAM_BATTING_1B <= 990.5) then TEAM_BATTING_1B_2=1; else TEAM_BATTING_1B_2=0;
	if (TEAM_BATTING_1B > 990.5) and (TEAM_BATTING_1B <= 1050) then TEAM_BATTING_1B_3=1; else TEAM_BATTING_1B_3=0;
	if (TEAM_BATTING_1B > 1050) and (TEAM_BATTING_1B <= 1129) then TEAM_BATTING_1B_4=1; else TEAM_BATTING_1B_4=0;

	* bin variable for team_batting_2b;
	if TEAM_BATTING_2B <= 167 then TEAM_BATTING_2B_1=1; else TEAM_BATTING_2B_1=0;
	if (TEAM_BATTING_2B > 167) and (TEAM_BATTING_2B <= 208) then TEAM_BATTING_2B_2=1; else TEAM_BATTING_2B_2=0;
	if (TEAM_BATTING_2B > 208) and (TEAM_BATTING_2B <= 238) then TEAM_BATTING_2B_3=1; else TEAM_BATTING_2B_3=0;
	if (TEAM_BATTING_2B > 238) and (TEAM_BATTING_2B <= 273) then TEAM_BATTING_2B_4=1; else TEAM_BATTING_2B_4=0;
	
	* bin variable for team_batting_3b;
	if TEAM_BATTING_3B <= 23 then TEAM_BATTING_3B_1=1; else TEAM_BATTING_3B_1=0;
	if (TEAM_BATTING_3B > 23) and (TEAM_BATTING_3B <= 34) then TEAM_BATTING_3B_2=1; else TEAM_BATTING_3B_2=0;
	if (TEAM_BATTING_3B > 34) and (TEAM_BATTING_3B <= 47) then TEAM_BATTING_3B_3=1; else TEAM_BATTING_3B_3=0;
	if (TEAM_BATTING_3B > 47) and (TEAM_BATTING_3B <= 72) then TEAM_BATTING_3B_4=1; else TEAM_BATTING_3B_4=0;

	* bin variable for team_batting_bb;
	if TEAM_BATTING_BB <= 246 then TEAM_BATTING_BB_1=1; else TEAM_BATTING_BB_1=0;
	if (TEAM_BATTING_BB > 246) and (TEAM_BATTING_BB <= 451) then TEAM_BATTING_BB_2=1; else TEAM_BATTING_BB_2=0;
	if (TEAM_BATTING_BB > 451) and (TEAM_BATTING_BB <= 512) then TEAM_BATTING_BB_3=1; else TEAM_BATTING_BB_3=0;
	if (TEAM_BATTING_BB > 512) and (TEAM_BATTING_BB <= 580) then TEAM_BATTING_BB_4=1; else TEAM_BATTING_BB_4=0;	
	
	* bin variable for team_batting_H;
	if TEAM_BATTING_H <= 1280 then TEAM_BATTING_H_1=1; else TEAM_BATTING_H_1=0;
	if (TEAM_BATTING_H > 1280) and (TEAM_BATTING_H <= 1383) then TEAM_BATTING_H_2=1; else TEAM_BATTING_H_2=0;
	if (TEAM_BATTING_H > 1383) and (TEAM_BATTING_H <= 1454) then TEAM_BATTING_H_3=1; else TEAM_BATTING_H_3=0;
	if (TEAM_BATTING_H > 1454) and (TEAM_BATTING_H <= 1537.5) then TEAM_BATTING_H_4=1; else TEAM_BATTING_H_4=0;	

	* bin variable for team_batting_HR;
	if TEAM_BATTING_HR <= 14 then TEAM_BATTING_HR_1=1; else TEAM_BATTING_HR_1=0;
	if (TEAM_BATTING_HR > 14) and (TEAM_BATTING_HR <= 42) then TEAM_BATTING_HR_2=1; else TEAM_BATTING_HR_2=0;
	if (TEAM_BATTING_HR > 42) and (TEAM_BATTING_HR <= 102) then TEAM_BATTING_HR_3=1; else TEAM_BATTING_HR_3=0;
	if (TEAM_BATTING_HR > 102) and (TEAM_BATTING_HR <= 147) then TEAM_BATTING_HR_4=1; else TEAM_BATTING_HR_4=0;	
	
	* bin variable for team_fielding_e;
	if TEAM_FIELDING_E <= 100 then TEAM_FIELDING_E_1=1; else TEAM_FIELDING_E_1=0;
	if (TEAM_FIELDING_E > 100) and (TEAM_FIELDING_E <= 127) then TEAM_FIELDING_E_2=1; else TEAM_FIELDING_E_2=0;
	if (TEAM_FIELDING_E > 127) and (TEAM_FIELDING_E  <= 159) then TEAM_FIELDING_E_3=1; else TEAM_FIELDING_E_3=0;
	if (TEAM_FIELDING_E > 159) and (TEAM_FIELDING_E <= 249.5) then TEAM_FIELDING_E_4=1; else TEAM_FIELDING_E_4=0;	
	
	* bin variable for team_pitching_bb;
	if TEAM_PITCHING_BB <= 377 then TEAM_PITCHING_BB_1=1; else TEAM_PITCHING_BB_1=0;
	if (TEAM_PITCHING_BB > 377) and (TEAM_PITCHING_BB <= 476) then TEAM_PITCHING_BB_2=1; else TEAM_PITCHING_BB_2=0;
	if (TEAM_PITCHING_BB > 476) and (TEAM_PITCHING_BB <= 536.5) then TEAM_PITCHING_BB_3=1; else TEAM_PITCHING_BB_3=0;
	if (TEAM_PITCHING_BB > 536.5) and (TEAM_PITCHING_BB <= 611) then TEAM_PITCHING_BB_4=1; else TEAM_PITCHING_BB_4=0;	

	* bin variable for team_pitching_h;
	if TEAM_PITCHING_H <= 1316 then TEAM_PITCHING_H_1=1; else TEAM_PITCHING_H_1=0;
	if (TEAM_PITCHING_H > 1316) and (TEAM_PITCHING_H <= 1419) then TEAM_PITCHING_H_2=1; else TEAM_PITCHING_H_2=0;
	if (TEAM_PITCHING_H > 1419) and (TEAM_PITCHING_H <= 1518) then TEAM_PITCHING_H_3=1; else TEAM_PITCHING_H_3=0;
	if (TEAM_PITCHING_H > 1518) and (TEAM_PITCHING_H <= 1683) then TEAM_PITCHING_H_4=1; else TEAM_PITCHING_H_4=0;

	* bin variable for team_pitching_hr;
	if TEAM_PITCHING_HR <= 18 then TEAM_PITCHING_HR_1=1; else TEAM_PITCHING_HR_1=0;
	if (TEAM_PITCHING_HR > 18) and (TEAM_PITCHING_HR <= 50) then TEAM_PITCHING_HR_2=1; else TEAM_PITCHING_HR_2=0;
	if (TEAM_PITCHING_HR > 50) and (TEAM_PITCHING_HR <= 107) then TEAM_PITCHING_HR_3=1; else TEAM_PITCHING_HR_3=0;
	if (TEAM_PITCHING_HR  > 107) and (TEAM_PITCHING_HR <= 150) then TEAM_PITCHING_HR_4=1; else TEAM_PITCHING_HR_4=0;		
	
run;

proc means data=moneyball_clean p1 p5 p25 p50 p75 p95 p99 ndec=3;
run;

proc reg data=moneyball_clean;
	model target_wins = imp_team_baserun_cs imp_team_baserun_sb imp_team_batting_so imp_team_fielding_dp imp_team_pitching_so
						m_team_baserun_cs m_team_baserun_sb m_team_batting_so m_team_fielding_dp m_team_pitching_so
						team_bases_earned team_batting_1b team_batting_2b team_batting_3b team_batting_bb team_batting_h
						team_batting_hr team_fielding_e team_pitching_bb team_pitching_h team_pitching_hr team_baserun_cs_1
						team_baserun_cs_2 team_baserun_cs_3 team_baserun_cs_4 team_baserun_sb_1 team_baserun_sb_2 team_baserun_sb_3
						team_baserun_sb_4 team_bases_earned_1 team_bases_earned_2 team_bases_earned_3 team_bases_earned_4
						team_batting_1b_1 team_batting_1b_2 team_batting_1b_3 team_batting_1b_4 team_batting_2b_1 team_batting_2b_2 
						team_batting_2b_3 team_batting_2b_4 team_batting_3b_1 team_batting_3b_2 team_batting_3b_3 team_batting_3b_4
						team_batting_bb_1 team_batting_bb_2 team_batting_bb_3 team_batting_bb_4 team_batting_h_1 team_batting_h_2 
						team_batting_h_3 team_batting_h_4 team_batting_hr_1 team_batting_hr_2 team_batting_hr_3 team_batting_hr_4
						team_batting_so_1 team_batting_so_2 team_batting_so_3 team_batting_so_4 team_fielding_dp_1 team_fielding_dp_2
						team_fielding_dp_3 team_fielding_dp_4 team_fielding_e_1 team_fielding_e_2 team_fielding_e_3 team_fielding_e_4
						team_pitching_bb_1 team_pitching_bb_2 team_pitching_bb_3 team_pitching_bb_4 team_pitching_h_1 team_pitching_h_2
						team_pitching_h_3 team_pitching_h_4 team_pitching_hr_1 team_pitching_hr_2 team_pitching_hr_3 team_pitching_hr_4
						team_pitching_so_1 team_pitching_so_2 team_pitching_so_3 team_pitching_so_4;
	output out=outdata (keep = target_wins imp_team_baserun_cs imp_team_baserun_sb imp_team_batting_so imp_team_fielding_dp imp_team_pitching_so
						m_team_baserun_cs m_team_baserun_sb m_team_batting_so m_team_fielding_dp m_team_pitching_so
						team_bases_earned team_batting_1b team_batting_2b team_batting_3b team_batting_bb team_batting_h
						team_batting_hr team_fielding_e team_pitching_bb team_pitching_h team_pitching_hr team_baserun_cs_1
						team_baserun_cs_2 team_baserun_cs_3 team_baserun_cs_4 team_baserun_sb_1 team_baserun_sb_2 team_baserun_sb_3
						team_baserun_sb_4 team_bases_earned_1 team_bases_earned_2 team_bases_earned_3 team_bases_earned_4
						team_batting_1b_1 team_batting_1b_2 team_batting_1b_3 team_batting_1b_4 team_batting_2b_1 team_batting_2b_2 
						team_batting_2b_3 team_batting_2b_4 team_batting_3b_1 team_batting_3b_2 team_batting_3b_3 team_batting_3b_4
						team_batting_bb_1 team_batting_bb_2 team_batting_bb_3 team_batting_bb_4 team_batting_h_1 team_batting_h_2 
						team_batting_h_3 team_batting_h_4 team_batting_hr_1 team_batting_hr_2 team_batting_hr_3 team_batting_hr_4
						team_batting_so_1 team_batting_so_2 team_batting_so_3 team_batting_so_4 team_fielding_dp_1 team_fielding_dp_2
						team_fielding_dp_3 team_fielding_dp_4 team_fielding_e_1 team_fielding_e_2 team_fielding_e_3 team_fielding_e_4
						team_pitching_bb_1 team_pitching_bb_2 team_pitching_bb_3 team_pitching_bb_4 team_pitching_h_1 team_pitching_h_2
						team_pitching_h_3 team_pitching_h_4 team_pitching_hr_1 team_pitching_hr_2 team_pitching_hr_3 team_pitching_hr_4
						team_pitching_so_1 team_pitching_so_2 team_pitching_so_3 team_pitching_so_4 studentr) rstudent=studentr;
run;

* Assess the plot of the studentized residuals to see how many exceed an absolute value of 2;
proc univariate data=outdata plot;
	var studentr;
run;

* Remove any observations with an absolute studentized residual greater than 2;
data clean_data;
	SET outdata;
	if abs(studentr) > 2 then delete;
	
	* variable transformations;
	T95_TEAM_BASERUN_SB 		= max(min(IMP_TEAM_BASERUN_SB,&P95_TEAM_BASERUN_SB.), &P5_TEAM_BASERUN_SB.);
	T99_TEAM_BASERUN_SB 		= max(min(IMP_TEAM_BASERUN_SB,&P99_TEAM_BASERUN_SB.), &P1_TEAM_BASERUN_SB.);
	STD_TEAM_BASERUN_SB 		= (IMP_TEAM_BASERUN_SB-&U_TEAM_BASERUN_SB.) / &S_TEAM_BASERUN_SB.;
	T_STD_TEAM_BASERUN_SB		= max(min(STD_TEAM_BASERUN_SB,3),-3);
	LN_TEAM_BASERUN_SB 			= sign(IMP_TEAM_BASERUN_SB) * log(abs(IMP_TEAM_BASERUN_SB)+1);
	LOG10_TEAM_BASERUN_SB 		= sign(IMP_TEAM_BASERUN_SB) * log10(abs(IMP_TEAM_BASERUN_SB)+1);

	T95_TEAM_FIELDING_DP 		= max(min(IMP_TEAM_FIELDING_DP,&P95_TEAM_FIELDING_DP.), &P5_TEAM_FIELDING_DP.);
	T99_TEAM_FIELDING_DP 		= max(min(IMP_TEAM_FIELDING_DP,&P99_TEAM_FIELDING_DP.), &P1_TEAM_FIELDING_DP.);
	STD_TEAM_FIELDING_DP 		= (IMP_TEAM_FIELDING_DP-&U_TEAM_FIELDING_DP.) / &S_TEAM_FIELDING_DP.;
	T_STD_TEAM_FIELDING_DP		= max(min(STD_TEAM_FIELDING_DP,3),-3);
	LN_TEAM_FIELDING_DP			= sign(IMP_TEAM_FIELDING_DP) * log(abs(IMP_TEAM_FIELDING_DP)+1);
	LOG10_TEAM_FIELDING_DP 		= sign(IMP_TEAM_FIELDING_DP) * log10(abs(IMP_TEAM_FIELDING_DP)+1);
	
	T95_TEAM_PITCHING_HR 		= max(min(TEAM_PITCHING_HR,&P95_TEAM_PITCHING_HR.),&P5_TEAM_PITCHING_HR.);
	T99_TEAM_PITCHING_HR 		= max(min(TEAM_PITCHING_HR,&P99_TEAM_PITCHING_HR.),&P1_TEAM_PITCHING_HR.);
	STD_TEAM_PITCHING_HR		= (TEAM_PITCHING_HR-&U_TEAM_PITCHING_HR.)/&S_TEAM_PITCHING_HR.;
	T_STD_TEAM_PITCHING_HR		= max(min(STD_TEAM_PITCHING_HR,3),-3);
	LN_TEAM_PITCHING_HR			= sign(TEAM_PITCHING_HR) * log(abs(TEAM_PITCHING_HR)+1);
	LOG10_TEAM_PITCHING_HR		= sign(TEAM_PITCHING_HR) * log10(abs(TEAM_PITCHING_HR)+1);
	
	T95_TEAM_BATTING_HR 		= max(min(TEAM_BATTING_HR ,&P95_TEAM_PITCHING_HR.),&P5_TEAM_PITCHING_HR.);
	T99_TEAM_BATTING_HR  		= max(min(TEAM_BATTING_HR ,&P99_TEAM_PITCHING_HR.),&P1_TEAM_PITCHING_HR.);
	STD_TEAM_BATTING_HR 		= (TEAM_BATTING_HR -&U_TEAM_PITCHING_HR.)/&S_TEAM_PITCHING_HR.;
	T_STD_TEAM_BATTING_HR 		= max(min(STD_TEAM_BATTING_HR,3),-3);
	LN_TEAM_BATTING_HR 			= sign(TEAM_BATTING_HR ) * log(abs(TEAM_BATTING_HR )+1);
	LOG10_TEAM_BATTING_HR 		= sign(TEAM_BATTING_HR ) * log10(abs(TEAM_BATTING_HR )+1);
	
	T95_TEAM_BASERUN_CS			= max(min(TEAM_BASERUN_CS ,&P95_TEAM_BASERUN_CS.),&P5_TEAM_BASERUN_CS.);
	T99_TEAM_BASERUN_CS  		= max(min(TEAM_BASERUN_CS,&P99_TEAM_BASERUN_CS.),&P1_TEAM_BASERUN_CS.);
	STD_TEAM_BASERUN_CS			= (TEAM_BASERUN_CS-&U_TEAM_BASERUN_CS.)/&S_TEAM_BASERUN_CS.;
	T_STD_TEAM_BASERUN_CS 		= max(min(STD_TEAM_BASERUN_CS,3),-3);
	LN_TEAM_BASERUN_CS 			= sign(TEAM_BASERUN_CS) * log(abs(TEAM_BASERUN_CS)+1);
	LOG10_TEAM_BASERUN_CS		= sign(TEAM_BASERUN_CS) * log10(abs(TEAM_BASERUN_CS)+1);

	T95_TEAM_BATTING_H 		= max(min(TEAM_BATTING_H ,&P95_TEAM_BATTING_H.),&P5_TEAM_BATTING_H.);
	T99_TEAM_BATTING_H  		= max(min(TEAM_BATTING_H ,&P99_TEAM_BATTING_H.),&P1_TEAM_BATTING_H.);
	STD_TEAM_BATTING_H 		= (TEAM_BATTING_H -&U_TEAM_BATTING_H.)/&S_TEAM_BATTING_H.;
	T_STD_TEAM_BATTING_H 		= max(min(STD_TEAM_BATTING_H,3),-3);
	LN_TEAM_BATTING_H 			= sign(TEAM_BATTING_H ) * log(abs(TEAM_BATTING_H )+1);
	LOG10_TEAM_BATTING_H 		= sign(TEAM_BATTING_H ) * log10(abs(TEAM_BATTING_H )+1);

	T95_TEAM_BATTING_2B 		= max(min(TEAM_BATTING_2B ,&P95_TEAM_BATTING_2B.),&P5_TEAM_BATTING_2B.);
	T99_TEAM_BATTING_2B  		= max(min(TEAM_BATTING_2B ,&P99_TEAM_BATTING_2B.),&P1_TEAM_BATTING_2B.);
	STD_TEAM_BATTING_2B 		= (TEAM_BATTING_2B -&U_TEAM_BATTING_2B.)/&S_TEAM_BATTING_2B.;
	T_STD_TEAM_BATTING_2B 		= max(min(STD_TEAM_BATTING_2B,3),-3);
	LN_TEAM_BATTING_2B 			= sign(TEAM_BATTING_2B ) * log(abs(TEAM_BATTING_2B )+1);
	LOG10_TEAM_BATTING_2B 		= sign(TEAM_BATTING_2B ) * log10(abs(TEAM_BATTING_2B )+1);

	T95_TEAM_PITCHING_BB 		= max(min(TEAM_PITCHING_BB,&P95_TEAM_PITCHING_BB.),&P5_TEAM_PITCHING_BB.);
	T99_TEAM_PITCHING_BB 		= max(min(TEAM_PITCHING_BB,&P99_TEAM_PITCHING_BB.),&P1_TEAM_PITCHING_BB.);
	STD_TEAM_PITCHING_BB		= (TEAM_PITCHING_BB-&U_TEAM_PITCHING_BB.)/&S_TEAM_PITCHING_BB.;
	T_STD_TEAM_PITCHING_BB		= max(min(STD_TEAM_PITCHING_BB,3),-3);
	LN_TEAM_PITCHING_BB			= sign(TEAM_PITCHING_BB) * log(abs(TEAM_PITCHING_BB)+1);
	LOG10_TEAM_PITCHING_BB		= sign(TEAM_PITCHING_BB) * log10(abs(TEAM_PITCHING_BB)+1);

	T95_TEAM_PITCHING_H 		= max(min(TEAM_PITCHING_H ,&P95_TEAM_PITCHING_H.),&P5_TEAM_PITCHING_H.);
	T99_TEAM_PITCHING_H  		= max(min(TEAM_PITCHING_H ,&P99_TEAM_PITCHING_H.),&P1_TEAM_PITCHING_H.);
	STD_TEAM_PITCHING_H 		= (TEAM_PITCHING_H -&U_TEAM_PITCHING_H.)/&S_TEAM_PITCHING_H.;
	T_STD_TEAM_PITCHING_H 		= max(min(STD_TEAM_PITCHING_H,3),-3);
	LN_TEAM_PITCHING_H 			= sign(TEAM_PITCHING_H ) * log(abs(TEAM_PITCHING_H )+1);
	LOG10_TEAM_PITCHING_H 		= sign(TEAM_PITCHING_H ) * log10(abs(TEAM_PITCHING_H )+1);

	T95_TEAM_PITCHING_SO 		= max(min(IMP_TEAM_PITCHING_SO,&P95_TEAM_PITCHING_SO.),&P5_TEAM_PITCHING_SO.);
	T99_TEAM_PITCHING_SO 		= max(min(IMP_TEAM_PITCHING_SO,&P99_TEAM_PITCHING_SO.),&P1_TEAM_PITCHING_SO.);
	STD_TEAM_PITCHING_SO		= (IMP_TEAM_PITCHING_SO-&U_TEAM_PITCHING_SO.)/&S_TEAM_PITCHING_SO.;
	T_STD_TEAM_PITCHING_SO		= max(min(STD_TEAM_PITCHING_SO,3),-3);
	LN_TEAM_PITCHING_SO			= sign(IMP_TEAM_PITCHING_SO) * log(abs(IMP_TEAM_PITCHING_SO)+1);
	LOG10_TEAM_PITCHING_SO		= sign(IMP_TEAM_PITCHING_SO) * log10(abs(IMP_TEAM_PITCHING_SO)+1);

	T95_TEAM_BATTING_SO 		= max(min(IMP_TEAM_BATTING_SO,&P95_TEAM_BATTING_SO.),&P5_TEAM_BATTING_SO.);
	T99_TEAM_BATTING_SO 		= max(min(IMP_TEAM_BATTING_SO,&P99_TEAM_BATTING_SO.),&P1_TEAM_BATTING_SO.);
	STD_TEAM_BATTING_SO		= (IMP_TEAM_BATTING_SO-&U_TEAM_BATTING_SO.)/&S_TEAM_BATTING_SO.;
	T_STD_TEAM_BATTING_SO		= max(min(STD_TEAM_BATTING_SO,3),-3);
	LN_TEAM_BATTING_SO			= sign(IMP_TEAM_BATTING_SO) * log(abs(IMP_TEAM_BATTING_SO)+1);
	LOG10_TEAM_BATTING_SO		= sign(IMP_TEAM_BATTING_SO) * log10(abs(IMP_TEAM_BATTING_SO)+1);

	T95_TEAM_FIELDING_E			= max(min(TEAM_FIELDING_E,&P95_TEAM_FIELDING_E.),&P5_TEAM_FIELDING_E.);
	T99_TEAM_FIELDING_E 		= max(min(TEAM_FIELDING_E,&P99_TEAM_FIELDING_E.),&P1_TEAM_FIELDING_E.);
	STD_TEAM_FIELDING_E			= (TEAM_FIELDING_E-&U_TEAM_FIELDING_E.)/&S_TEAM_FIELDING_E.;
	T_STD_TEAM_FIELDING_E		= max(min(STD_TEAM_FIELDING_E,3),-3);
	LN_TEAM_FIELDING_E			= sign(TEAM_FIELDING_E) * log(abs(TEAM_FIELDING_E)+1);
	LOG10_TEAM_FIELDING_E		= sign(TEAM_FIELDING_E) * log10(abs(TEAM_FIELDING_E)+1);
	
	LN_TEAM_BATTING_BB			= sign(TEAM_BATTING_BB) * log(abs(TEAM_BATTING_BB)+1);
	LN_TEAM_BASERUN_CS			= sign(IMP_TEAM_BASERUN_CS) * log(abs(IMP_TEAM_BASERUN_CS)+1);
	LN_TEAM_FIELDING_DP			= sign(IMP_TEAM_FIELDING_DP) * log(abs(IMP_TEAM_FIELDING_DP)+1);
	LN_TEAM_BATTING_3B			= sign(TEAM_BATTING_3B) * log(abs(TEAM_BATTING_3B)+1);
	
run;

* -----------------------------------------
* PHASE 3 Model Building
* -----------------------------------------;

* MODEL A: Simple Model using only raw input variables and with missing values imputed;
proc reg data=clean_data outest=model_a_betas;
A: model TARGET_WINS = TEAM_BATTING_H 
					TEAM_BATTING_2B 
					TEAM_BATTING_3B 
					TEAM_BATTING_HR 
					TEAM_BATTING_BB 
					IMP_TEAM_BATTING_SO 
					IMP_TEAM_BASERUN_SB 
					IMP_TEAM_BASERUN_CS 
					TEAM_FIELDING_E 
					IMP_TEAM_FIELDING_DP 
					TEAM_PITCHING_BB
					TEAM_PITCHING_H 
					TEAM_PITCHING_HR 
					IMP_TEAM_PITCHING_SO / vif adjrsq aic cp; 
run;

* MODEL B: Addition of new calculated variables and binning techniques;
proc reg data=clean_data outest=model_b_betas;
B: model TARGET_WINS = 	IMP_TEAM_BASERUN_CS
						IMP_TEAM_BASERUN_SB
						IMP_TEAM_BATTING_SO
						IMP_TEAM_FIELDING_DP
						IMP_TEAM_PITCHING_SO
						M_TEAM_BASERUN_CS
						M_TEAM_BASERUN_SB
						M_TEAM_BATTING_SO
						M_TEAM_FIELDING_DP
						M_TEAM_PITCHING_SO
						TEAM_BASES_EARNED
						TEAM_BATTING_1B
						TEAM_BATTING_2B
						TEAM_BATTING_3B
						TEAM_BATTING_BB
						TEAM_BATTING_H
						TEAM_FIELDING_E
						TEAM_PITCHING_BB
						TEAM_PITCHING_H
						TEAM_BATTING_HR_1
						TEAM_BATTING_HR_2
						TEAM_BATTING_HR_3
						TEAM_BATTING_HR_4
						TEAM_PITCHING_HR_1
						TEAM_PITCHING_HR_2
						TEAM_PITCHING_HR_3
						TEAM_PITCHING_HR_4
		/ selection = forward adjrsq aic vif cp; 
run;

* MODEL C: A combination of multiple variable transformation techniques;
proc reg data=clean_data outest=model_c_betas;
C: model TARGET_WINS = 	LN_TEAM_BASERUN_SB
						IMP_TEAM_BATTING_SO
						M_TEAM_BASERUN_SB
						M_TEAM_BATTING_SO
						TEAM_BASES_EARNED
						T95_TEAM_FIELDING_E
						T95_TEAM_PITCHING_H
						TEAM_BASES_EARNED_1
						TEAM_BASES_EARNED_2
						TEAM_BATTING_H_1
						TEAM_BATTING_H_2
						TEAM_BATTING_H_4
						TEAM_BATTING_1B_1
						TEAM_BATTING_1B_2
						TEAM_BATTING_1B_3
						TEAM_BATTING_1B_4
						TEAM_BATTING_2B_2
						TEAM_BATTING_2B_3
						TEAM_BATTING_3B_1
						TEAM_BATTING_3B_2
						TEAM_BATTING_3B_3
						TEAM_BATTING_3B_4
						TEAM_BATTING_BB_1
						TEAM_BATTING_BB_2
						TEAM_BATTING_HR_1
						TEAM_BATTING_HR_4
						TEAM_PITCHING_HR_1
						TEAM_PITCHING_HR_2
						TEAM_PITCHING_HR_3
						TEAM_FIELDING_E_1
						TEAM_FIELDING_E_4
						TEAM_PITCHING_H_1
						TEAM_PITCHING_H_3
						TEAM_PITCHING_H_4
						TEAM_BASERUN_SB_1
						TEAM_BASERUN_SB_3
						TEAM_BASERUN_SB_4
						TEAM_BASERUN_CS_1
						TEAM_BASERUN_CS_3
						TEAM_BASERUN_CS_4
		/ selection = forward adjrsq aic vif cp; 
run;


* -----------------------------------------
* PHASE 4 Model Deployment
* -----------------------------------------;

* final data step to score the test dataset provided;
data need_predictions;
	set mydata.moneyball_test;
	* drop the Batters hit by pitch because 92% of the observations have missing values;
	drop TEAM_BATTING_HBP; 
	
	* address missing values for TEAM_BATTING_SO;
	IMP_TEAM_BATTING_SO = TEAM_BATTING_SO;
	M_TEAM_BATTING_SO = 0;
	if TEAM_BATTING_SO = '.' then do;
		IMP_TEAM_BATTING_SO = 750;
		M_TEAM_BATTING_SO = 1;
	end;
	
	* address missing values for TEAM_BASERUN_SB;
	IMP_TEAM_BASERUN_SB = TEAM_BASERUN_SB;
	M_TEAM_BASERUN_SB = 0;
	if TEAM_BASERUN_SB ='.' then do;
		IMP_TEAM_BASERUN_SB = 101;
		M_TEAM_BASERUN_SB = 1;
	end;

	* address missing values for TEAM_BASERUN_CS;
	IMP_TEAM_BASERUN_CS = TEAM_BASERUN_CS;
	M_TEAM_BASERUN_CS = 0;
	if TEAM_BASERUN_CS = '.' then do;
		IMP_TEAM_BASERUN_CS = 49;
		M_TEAM_BASERUN_CS = 1;
	end;
	
	* address missing values for TEAM_PITCHING_SO;
	IMP_TEAM_PITCHING_SO = TEAM_PITCHING_SO;
	M_TEAM_PITCHING_SO = 0;
	if TEAM_PITCHING_SO = '.' then do;
		IMP_TEAM_PITCHING_SO = 813.5;
		M_TEAM_PITCHING_SO = 1;
	end;

	* address missing values for TEAM_FIELDING_DP;
	IMP_TEAM_FIELDING_DP = TEAM_FIELDING_DP;
	M_TEAM_FIELDING_DP = 0;
	if missing(TEAM_FIELDING_DP) then do;
		IMP_TEAM_FIELDING_DP = 149;
		M_TEAM_FIELDING_DP = 1;
	end;

	* create new variables;
	TEAM_BATTING_1B = TEAM_BATTING_H - TEAM_BATTING_HR - TEAM_BATTING_2B - TEAM_BATTING_3B;
	
	TEAM_BASES_EARNED = 	4*TEAM_BATTING_HR 
						+ 	3*TEAM_BATTING_3B 
						+ 	2*TEAM_BATTING_2B
						+ 	1*TEAM_BATTING_1B
						+	1*TEAM_BATTING_BB
						+	1*IMP_TEAM_BASERUN_SB
						-	1*IMP_TEAM_BASERUN_CS;
			
	* bin variable for team_baserun_cs;
	if imp_team_baserun_cs <= 27 then team_baserun_cs_1=1; else team_baserun_cs_1=0;
	if (imp_team_baserun_cs > 27) and (imp_team_baserun_cs <= 44) then team_baserun_cs_2=1; else team_baserun_cs_2=0;
	if (imp_team_baserun_cs > 44) and (imp_team_baserun_cs <= 49) then team_baserun_cs_3=1; else team_baserun_cs_3=0;
	if (imp_team_baserun_cs > 49) and (imp_team_baserun_cs <= 54.5) then team_baserun_cs_4=1; else team_baserun_cs_4=0;
	
	* bin variable for team_baserun_sb;
	if imp_team_baserun_sb <= 36 then team_baserun_sb_1=1; else team_baserun_sb_1=0;
	if (imp_team_baserun_sb > 36) and (imp_team_baserun_sb <= 67) then team_baserun_sb_2=1; else team_baserun_sb_2=0;
	if (imp_team_baserun_sb > 67) and (imp_team_baserun_sb <= 101) then team_baserun_sb_3=1; else team_baserun_sb_3=0;
	if (imp_team_baserun_sb > 101) and (imp_team_baserun_sb <= 151) then team_baserun_sb_4=1; else team_baserun_sb_4=0;
	
	* bin variable for team_batting_so;
	if IMP_TEAM_BATTING_SO <= 363 then TEAM_BATTING_SO_1=1; else TEAM_BATTING_SO_1=0;
	if (IMP_TEAM_BATTING_SO > 363) and (IMP_TEAM_BATTING_SO <= 556.5) then TEAM_BATTING_SO_2=1; else TEAM_BATTING_SO_2=0;
	if (IMP_TEAM_BATTING_SO > 556.5) and (IMP_TEAM_BATTING_SO <= 750) then TEAM_BATTING_SO_3=1; else TEAM_BATTING_SO_3=0;
	if (IMP_TEAM_BATTING_SO > 750) and (IMP_TEAM_BATTING_SO <= 925) then TEAM_BATTING_SO_4=1; else TEAM_BATTING_SO_4=0;
	
	* bin variable for team_fielding_dp;
	if IMP_TEAM_FIELDING_DP <= 100 then TEAM_FIELDING_DP_1=1; else TEAM_FIELDING_DP_1=0;
	if (IMP_TEAM_FIELDING_DP > 100) and (IMP_TEAM_FIELDING_DP <= 134) then TEAM_FIELDING_DP_2=1; else TEAM_FIELDING_DP_2=0;
	if (IMP_TEAM_FIELDING_DP > 134) and (IMP_TEAM_FIELDING_DP<= 149) then TEAM_FIELDING_DP_3=1; else TEAM_FIELDING_DP_3=0;
	if (IMP_TEAM_FIELDING_DP > 149) and (IMP_TEAM_FIELDING_DP<= 161.5) then TEAM_FIELDING_DP_4=1; else TEAM_FIELDING_DP_4=0;

	* bin variable for team_pitching_so;
	if IMP_TEAM_PITCHING_SO <= 423 then TEAM_PITCHING_SO_1=1; else TEAM_PITCHING_SO_1=0;
	if (IMP_TEAM_PITCHING_SO > 423) and (IMP_TEAM_PITCHING_SO <= 626) then TEAM_PITCHING_SO_2=1; else TEAM_PITCHING_SO_2=0;
	if (IMP_TEAM_PITCHING_SO > 626) and (IMP_TEAM_PITCHING_SO<= 813.5) then TEAM_PITCHING_SO_3=1; else TEAM_PITCHING_SO_3=0;
	if (IMP_TEAM_PITCHING_SO > 813.5) and (IMP_TEAM_PITCHING_SO<= 957) then TEAM_PITCHING_SO_4=1; else TEAM_PITCHING_SO_4=0;	
	
	* bin variable for team_bases_earned;
	if TEAM_BASES_EARNED <= 2257 then TEAM_BASES_EARNED_1=1; else TEAM_BASES_EARNED_1=0;
	if (TEAM_BASES_EARNED > 2257) and (TEAM_BASES_EARNED <= 2530) then TEAM_BASES_EARNED_2=1; else TEAM_BASES_EARNED_2=0;
	if (TEAM_BASES_EARNED > 2530) and (TEAM_BASES_EARNED <= 2720) then TEAM_BASES_EARNED_3=1; else TEAM_BASES_EARNED_3=0;
	if (TEAM_BASES_EARNED > 2720) and (TEAM_BASES_EARNED <= 2901) then TEAM_BASES_EARNED_4=1; else TEAM_BASES_EARNED_4=0;	

	* bin variable for team_batting_1b;
	if TEAM_BATTING_1B <= 919 then TEAM_BATTING_1B_1=1; else TEAM_BATTING_1B_1=0;
	if (TEAM_BATTING_1B > 919) and (TEAM_BATTING_1B <= 990.5) then TEAM_BATTING_1B_2=1; else TEAM_BATTING_1B_2=0;
	if (TEAM_BATTING_1B > 990.5) and (TEAM_BATTING_1B <= 1050) then TEAM_BATTING_1B_3=1; else TEAM_BATTING_1B_3=0;
	if (TEAM_BATTING_1B > 1050) and (TEAM_BATTING_1B <= 1129) then TEAM_BATTING_1B_4=1; else TEAM_BATTING_1B_4=0;

	* bin variable for team_batting_2b;
	if TEAM_BATTING_2B <= 167 then TEAM_BATTING_2B_1=1; else TEAM_BATTING_2B_1=0;
	if (TEAM_BATTING_2B > 167) and (TEAM_BATTING_2B <= 208) then TEAM_BATTING_2B_2=1; else TEAM_BATTING_2B_2=0;
	if (TEAM_BATTING_2B > 208) and (TEAM_BATTING_2B <= 238) then TEAM_BATTING_2B_3=1; else TEAM_BATTING_2B_3=0;
	if (TEAM_BATTING_2B > 238) and (TEAM_BATTING_2B <= 273) then TEAM_BATTING_2B_4=1; else TEAM_BATTING_2B_4=0;
	
	* bin variable for team_batting_3b;
	if TEAM_BATTING_3B <= 23 then TEAM_BATTING_3B_1=1; else TEAM_BATTING_3B_1=0;
	if (TEAM_BATTING_3B > 23) and (TEAM_BATTING_3B <= 34) then TEAM_BATTING_3B_2=1; else TEAM_BATTING_3B_2=0;
	if (TEAM_BATTING_3B > 34) and (TEAM_BATTING_3B <= 47) then TEAM_BATTING_3B_3=1; else TEAM_BATTING_3B_3=0;
	if (TEAM_BATTING_3B > 47) and (TEAM_BATTING_3B <= 72) then TEAM_BATTING_3B_4=1; else TEAM_BATTING_3B_4=0;

	* bin variable for team_batting_bb;
	if TEAM_BATTING_BB <= 246 then TEAM_BATTING_BB_1=1; else TEAM_BATTING_BB_1=0;
	if (TEAM_BATTING_BB > 246) and (TEAM_BATTING_BB <= 451) then TEAM_BATTING_BB_2=1; else TEAM_BATTING_BB_2=0;
	if (TEAM_BATTING_BB > 451) and (TEAM_BATTING_BB <= 512) then TEAM_BATTING_BB_3=1; else TEAM_BATTING_BB_3=0;
	if (TEAM_BATTING_BB > 512) and (TEAM_BATTING_BB <= 580) then TEAM_BATTING_BB_4=1; else TEAM_BATTING_BB_4=0;	
	
	* bin variable for team_batting_H;
	if TEAM_BATTING_H <= 1280 then TEAM_BATTING_H_1=1; else TEAM_BATTING_H_1=0;
	if (TEAM_BATTING_H > 1280) and (TEAM_BATTING_H <= 1383) then TEAM_BATTING_H_2=1; else TEAM_BATTING_H_2=0;
	if (TEAM_BATTING_H > 1383) and (TEAM_BATTING_H <= 1454) then TEAM_BATTING_H_3=1; else TEAM_BATTING_H_3=0;
	if (TEAM_BATTING_H > 1454) and (TEAM_BATTING_H <= 1537.5) then TEAM_BATTING_H_4=1; else TEAM_BATTING_H_4=0;	

	* bin variable for team_batting_HR;
	if TEAM_BATTING_HR <= 14 then TEAM_BATTING_HR_1=1; else TEAM_BATTING_HR_1=0;
	if (TEAM_BATTING_HR > 14) and (TEAM_BATTING_HR <= 42) then TEAM_BATTING_HR_2=1; else TEAM_BATTING_HR_2=0;
	if (TEAM_BATTING_HR > 42) and (TEAM_BATTING_HR <= 102) then TEAM_BATTING_HR_3=1; else TEAM_BATTING_HR_3=0;
	if (TEAM_BATTING_HR > 102) and (TEAM_BATTING_HR <= 147) then TEAM_BATTING_HR_4=1; else TEAM_BATTING_HR_4=0;	
	
	* bin variable for team_fielding_e;
	if TEAM_FIELDING_E <= 100 then TEAM_FIELDING_E_1=1; else TEAM_FIELDING_E_1=0;
	if (TEAM_FIELDING_E > 100) and (TEAM_FIELDING_E <= 127) then TEAM_FIELDING_E_2=1; else TEAM_FIELDING_E_2=0;
	if (TEAM_FIELDING_E > 127) and (TEAM_FIELDING_E  <= 159) then TEAM_FIELDING_E_3=1; else TEAM_FIELDING_E_3=0;
	if (TEAM_FIELDING_E > 159) and (TEAM_FIELDING_E <= 249.5) then TEAM_FIELDING_E_4=1; else TEAM_FIELDING_E_4=0;	
	
	* bin variable for team_pitching_bb;
	if TEAM_PITCHING_BB <= 377 then TEAM_PITCHING_BB_1=1; else TEAM_PITCHING_BB_1=0;
	if (TEAM_PITCHING_BB > 377) and (TEAM_PITCHING_BB <= 476) then TEAM_PITCHING_BB_2=1; else TEAM_PITCHING_BB_2=0;
	if (TEAM_PITCHING_BB > 476) and (TEAM_PITCHING_BB <= 536.5) then TEAM_PITCHING_BB_3=1; else TEAM_PITCHING_BB_3=0;
	if (TEAM_PITCHING_BB > 536.5) and (TEAM_PITCHING_BB <= 611) then TEAM_PITCHING_BB_4=1; else TEAM_PITCHING_BB_4=0;	

	* bin variable for team_pitching_h;
	if TEAM_PITCHING_H <= 1316 then TEAM_PITCHING_H_1=1; else TEAM_PITCHING_H_1=0;
	if (TEAM_PITCHING_H > 1316) and (TEAM_PITCHING_H <= 1419) then TEAM_PITCHING_H_2=1; else TEAM_PITCHING_H_2=0;
	if (TEAM_PITCHING_H > 1419) and (TEAM_PITCHING_H <= 1518) then TEAM_PITCHING_H_3=1; else TEAM_PITCHING_H_3=0;
	if (TEAM_PITCHING_H > 1518) and (TEAM_PITCHING_H <= 1683) then TEAM_PITCHING_H_4=1; else TEAM_PITCHING_H_4=0;

	* bin variable for team_pitching_hr;
	if TEAM_PITCHING_HR <= 18 then TEAM_PITCHING_HR_1=1; else TEAM_PITCHING_HR_1=0;
	if (TEAM_PITCHING_HR > 18) and (TEAM_PITCHING_HR <= 50) then TEAM_PITCHING_HR_2=1; else TEAM_PITCHING_HR_2=0;
	if (TEAM_PITCHING_HR > 50) and (TEAM_PITCHING_HR <= 107) then TEAM_PITCHING_HR_3=1; else TEAM_PITCHING_HR_3=0;
	if (TEAM_PITCHING_HR  > 107) and (TEAM_PITCHING_HR <= 150) then TEAM_PITCHING_HR_4=1; else TEAM_PITCHING_HR_4=0;
	
	* variable transformations;
	T95_TEAM_BASERUN_SB 		= max(min(IMP_TEAM_BASERUN_SB,&P95_TEAM_BASERUN_SB.), &P5_TEAM_BASERUN_SB.);
	T99_TEAM_BASERUN_SB 		= max(min(IMP_TEAM_BASERUN_SB,&P99_TEAM_BASERUN_SB.), &P1_TEAM_BASERUN_SB.);
	STD_TEAM_BASERUN_SB 		= (IMP_TEAM_BASERUN_SB-&U_TEAM_BASERUN_SB.) / &S_TEAM_BASERUN_SB.;
	T_STD_TEAM_BASERUN_SB		= max(min(STD_TEAM_BASERUN_SB,3),-3);
	LN_TEAM_BASERUN_SB 			= sign(IMP_TEAM_BASERUN_SB) * log(abs(IMP_TEAM_BASERUN_SB)+1);
	LOG10_TEAM_BASERUN_SB 		= sign(IMP_TEAM_BASERUN_SB) * log10(abs(IMP_TEAM_BASERUN_SB)+1);

	T95_TEAM_FIELDING_DP 		= max(min(IMP_TEAM_FIELDING_DP,&P95_TEAM_FIELDING_DP.), &P5_TEAM_FIELDING_DP.);
	T99_TEAM_FIELDING_DP 		= max(min(IMP_TEAM_FIELDING_DP,&P99_TEAM_FIELDING_DP.), &P1_TEAM_FIELDING_DP.);
	STD_TEAM_FIELDING_DP 		= (IMP_TEAM_FIELDING_DP-&U_TEAM_FIELDING_DP.) / &S_TEAM_FIELDING_DP.;
	T_STD_TEAM_FIELDING_DP		= max(min(STD_TEAM_FIELDING_DP,3),-3);
	LN_TEAM_FIELDING_DP			= sign(IMP_TEAM_FIELDING_DP) * log(abs(IMP_TEAM_FIELDING_DP)+1);
	LOG10_TEAM_FIELDING_DP 		= sign(IMP_TEAM_FIELDING_DP) * log10(abs(IMP_TEAM_FIELDING_DP)+1);
	
	T95_TEAM_PITCHING_HR 		= max(min(TEAM_PITCHING_HR,&P95_TEAM_PITCHING_HR.),&P5_TEAM_PITCHING_HR.);
	T99_TEAM_PITCHING_HR 		= max(min(TEAM_PITCHING_HR,&P99_TEAM_PITCHING_HR.),&P1_TEAM_PITCHING_HR.);
	STD_TEAM_PITCHING_HR		= (TEAM_PITCHING_HR-&U_TEAM_PITCHING_HR.)/&S_TEAM_PITCHING_HR.;
	T_STD_TEAM_PITCHING_HR		= max(min(STD_TEAM_PITCHING_HR,3),-3);
	LN_TEAM_PITCHING_HR			= sign(TEAM_PITCHING_HR) * log(abs(TEAM_PITCHING_HR)+1);
	LOG10_TEAM_PITCHING_HR		= sign(TEAM_PITCHING_HR) * log10(abs(TEAM_PITCHING_HR)+1);
	
	T95_TEAM_BATTING_HR 		= max(min(TEAM_BATTING_HR ,&P95_TEAM_PITCHING_HR.),&P5_TEAM_PITCHING_HR.);
	T99_TEAM_BATTING_HR  		= max(min(TEAM_BATTING_HR ,&P99_TEAM_PITCHING_HR.),&P1_TEAM_PITCHING_HR.);
	STD_TEAM_BATTING_HR 		= (TEAM_BATTING_HR -&U_TEAM_PITCHING_HR.)/&S_TEAM_PITCHING_HR.;
	T_STD_TEAM_BATTING_HR 		= max(min(STD_TEAM_BATTING_HR,3),-3);
	LN_TEAM_BATTING_HR 			= sign(TEAM_BATTING_HR ) * log(abs(TEAM_BATTING_HR )+1);
	LOG10_TEAM_BATTING_HR 		= sign(TEAM_BATTING_HR ) * log10(abs(TEAM_BATTING_HR )+1);
	
	T95_TEAM_BASERUN_CS			= max(min(TEAM_BASERUN_CS ,&P95_TEAM_BASERUN_CS.),&P5_TEAM_BASERUN_CS.);
	T99_TEAM_BASERUN_CS  		= max(min(TEAM_BASERUN_CS,&P99_TEAM_BASERUN_CS.),&P1_TEAM_BASERUN_CS.);
	STD_TEAM_BASERUN_CS			= (TEAM_BASERUN_CS-&U_TEAM_BASERUN_CS.)/&S_TEAM_BASERUN_CS.;
	T_STD_TEAM_BASERUN_CS 		= max(min(STD_TEAM_BASERUN_CS,3),-3);
	LN_TEAM_BASERUN_CS 			= sign(TEAM_BASERUN_CS) * log(abs(TEAM_BASERUN_CS)+1);
	LOG10_TEAM_BASERUN_CS		= sign(TEAM_BASERUN_CS) * log10(abs(TEAM_BASERUN_CS)+1);

	T95_TEAM_BATTING_H 		= max(min(TEAM_BATTING_H ,&P95_TEAM_BATTING_H.),&P5_TEAM_BATTING_H.);
	T99_TEAM_BATTING_H  		= max(min(TEAM_BATTING_H ,&P99_TEAM_BATTING_H.),&P1_TEAM_BATTING_H.);
	STD_TEAM_BATTING_H 		= (TEAM_BATTING_H -&U_TEAM_BATTING_H.)/&S_TEAM_BATTING_H.;
	T_STD_TEAM_BATTING_H 		= max(min(STD_TEAM_BATTING_H,3),-3);
	LN_TEAM_BATTING_H 			= sign(TEAM_BATTING_H ) * log(abs(TEAM_BATTING_H )+1);
	LOG10_TEAM_BATTING_H 		= sign(TEAM_BATTING_H ) * log10(abs(TEAM_BATTING_H )+1);

	T95_TEAM_BATTING_2B 		= max(min(TEAM_BATTING_2B ,&P95_TEAM_BATTING_2B.),&P5_TEAM_BATTING_2B.);
	T99_TEAM_BATTING_2B  		= max(min(TEAM_BATTING_2B ,&P99_TEAM_BATTING_2B.),&P1_TEAM_BATTING_2B.);
	STD_TEAM_BATTING_2B 		= (TEAM_BATTING_2B -&U_TEAM_BATTING_2B.)/&S_TEAM_BATTING_2B.;
	T_STD_TEAM_BATTING_2B 		= max(min(STD_TEAM_BATTING_2B,3),-3);
	LN_TEAM_BATTING_2B 			= sign(TEAM_BATTING_2B ) * log(abs(TEAM_BATTING_2B )+1);
	LOG10_TEAM_BATTING_2B 		= sign(TEAM_BATTING_2B ) * log10(abs(TEAM_BATTING_2B )+1);

	T95_TEAM_PITCHING_BB 		= max(min(TEAM_PITCHING_BB,&P95_TEAM_PITCHING_BB.),&P5_TEAM_PITCHING_BB.);
	T99_TEAM_PITCHING_BB 		= max(min(TEAM_PITCHING_BB,&P99_TEAM_PITCHING_BB.),&P1_TEAM_PITCHING_BB.);
	STD_TEAM_PITCHING_BB		= (TEAM_PITCHING_BB-&U_TEAM_PITCHING_BB.)/&S_TEAM_PITCHING_BB.;
	T_STD_TEAM_PITCHING_BB		= max(min(STD_TEAM_PITCHING_BB,3),-3);
	LN_TEAM_PITCHING_BB			= sign(TEAM_PITCHING_BB) * log(abs(TEAM_PITCHING_BB)+1);
	LOG10_TEAM_PITCHING_BB		= sign(TEAM_PITCHING_BB) * log10(abs(TEAM_PITCHING_BB)+1);

	T95_TEAM_PITCHING_H 		= max(min(TEAM_PITCHING_H ,&P95_TEAM_PITCHING_H.),&P5_TEAM_PITCHING_H.);
	T99_TEAM_PITCHING_H  		= max(min(TEAM_PITCHING_H ,&P99_TEAM_PITCHING_H.),&P1_TEAM_PITCHING_H.);
	STD_TEAM_PITCHING_H 		= (TEAM_PITCHING_H -&U_TEAM_PITCHING_H.)/&S_TEAM_PITCHING_H.;
	T_STD_TEAM_PITCHING_H 		= max(min(STD_TEAM_PITCHING_H,3),-3);
	LN_TEAM_PITCHING_H 			= sign(TEAM_PITCHING_H ) * log(abs(TEAM_PITCHING_H )+1);
	LOG10_TEAM_PITCHING_H 		= sign(TEAM_PITCHING_H ) * log10(abs(TEAM_PITCHING_H )+1);

	T95_TEAM_PITCHING_SO 		= max(min(IMP_TEAM_PITCHING_SO,&P95_TEAM_PITCHING_SO.),&P5_TEAM_PITCHING_SO.);
	T99_TEAM_PITCHING_SO 		= max(min(IMP_TEAM_PITCHING_SO,&P99_TEAM_PITCHING_SO.),&P1_TEAM_PITCHING_SO.);
	STD_TEAM_PITCHING_SO		= (IMP_TEAM_PITCHING_SO-&U_TEAM_PITCHING_SO.)/&S_TEAM_PITCHING_SO.;
	T_STD_TEAM_PITCHING_SO		= max(min(STD_TEAM_PITCHING_SO,3),-3);
	LN_TEAM_PITCHING_SO			= sign(IMP_TEAM_PITCHING_SO) * log(abs(IMP_TEAM_PITCHING_SO)+1);
	LOG10_TEAM_PITCHING_SO		= sign(IMP_TEAM_PITCHING_SO) * log10(abs(IMP_TEAM_PITCHING_SO)+1);

	T95_TEAM_BATTING_SO 		= max(min(IMP_TEAM_BATTING_SO,&P95_TEAM_BATTING_SO.),&P5_TEAM_BATTING_SO.);
	T99_TEAM_BATTING_SO 		= max(min(IMP_TEAM_BATTING_SO,&P99_TEAM_BATTING_SO.),&P1_TEAM_BATTING_SO.);
	STD_TEAM_BATTING_SO		= (IMP_TEAM_BATTING_SO-&U_TEAM_BATTING_SO.)/&S_TEAM_BATTING_SO.;
	T_STD_TEAM_BATTING_SO		= max(min(STD_TEAM_BATTING_SO,3),-3);
	LN_TEAM_BATTING_SO			= sign(IMP_TEAM_BATTING_SO) * log(abs(IMP_TEAM_BATTING_SO)+1);
	LOG10_TEAM_BATTING_SO		= sign(IMP_TEAM_BATTING_SO) * log10(abs(IMP_TEAM_BATTING_SO)+1);

	T95_TEAM_FIELDING_E			= max(min(TEAM_FIELDING_E,&P95_TEAM_FIELDING_E.),&P5_TEAM_FIELDING_E.);
	T99_TEAM_FIELDING_E 		= max(min(TEAM_FIELDING_E,&P99_TEAM_FIELDING_E.),&P1_TEAM_FIELDING_E.);
	STD_TEAM_FIELDING_E			= (TEAM_FIELDING_E-&U_TEAM_FIELDING_E.)/&S_TEAM_FIELDING_E.;
	T_STD_TEAM_FIELDING_E		= max(min(STD_TEAM_FIELDING_E,3),-3);
	LN_TEAM_FIELDING_E			= sign(TEAM_FIELDING_E) * log(abs(TEAM_FIELDING_E)+1);
	LOG10_TEAM_FIELDING_E		= sign(TEAM_FIELDING_E) * log10(abs(TEAM_FIELDING_E)+1);
	
	LN_TEAM_BATTING_BB			= sign(TEAM_BATTING_BB) * log(abs(TEAM_BATTING_BB)+1);
	LN_TEAM_BASERUN_CS			= sign(IMP_TEAM_BASERUN_CS) * log(abs(IMP_TEAM_BASERUN_CS)+1);
	LN_TEAM_FIELDING_DP			= sign(IMP_TEAM_FIELDING_DP) * log(abs(IMP_TEAM_FIELDING_DP)+1);
	LN_TEAM_BATTING_3B			= sign(TEAM_BATTING_3B) * log(abs(TEAM_BATTING_3B)+1);
run;

* score the test data;
proc score data=need_predictions score=model_c_betas
   out=predictions type=parms;
   var 	LN_TEAM_BASERUN_SB
		IMP_TEAM_BATTING_SO
		M_TEAM_BASERUN_SB
		M_TEAM_BATTING_SO
		TEAM_BASES_EARNED
		T95_TEAM_FIELDING_E
		T95_TEAM_PITCHING_H
		TEAM_BASES_EARNED_1
		TEAM_BASES_EARNED_2
		TEAM_BATTING_H_1
		TEAM_BATTING_H_2
		TEAM_BATTING_H_4
		TEAM_BATTING_1B_1
		TEAM_BATTING_1B_2
		TEAM_BATTING_1B_3
		TEAM_BATTING_1B_4
		TEAM_BATTING_2B_2
		TEAM_BATTING_2B_3
		TEAM_BATTING_3B_1
		TEAM_BATTING_3B_2
		TEAM_BATTING_3B_3
		TEAM_BATTING_3B_4
		TEAM_BATTING_BB_1
		TEAM_BATTING_BB_2
		TEAM_BATTING_HR_1
		TEAM_BATTING_HR_4
		TEAM_PITCHING_HR_1
		TEAM_PITCHING_HR_2
		TEAM_PITCHING_HR_3
		TEAM_FIELDING_E_1
		TEAM_FIELDING_E_4
		TEAM_PITCHING_H_1
		TEAM_PITCHING_H_3
		TEAM_PITCHING_H_4
		TEAM_BASERUN_SB_1
		TEAM_BASERUN_SB_3
		TEAM_BASERUN_SB_4
		TEAM_BASERUN_CS_1
		TEAM_BASERUN_CS_3
		TEAM_BASERUN_CS_4;
run;

* final data step to produce the predictions using the test dataset;
data mydata.forward2;
set need_predictions;
	P_TARGET_WINS = 		+ 0.72234
	+LN_TEAM_BASERUN_SB		* 6.46467
	+IMP_TEAM_BATTING_SO	* -0.01856
	+M_TEAM_BASERUN_SB		* 37.01918
	+M_TEAM_BATTING_SO		* 11.43922
	+TEAM_BASES_EARNED		* 0.03295
	+T95_TEAM_FIELDING_E	* -0.06754
	+T95_TEAM_PITCHING_H	* -0.00576
	+TEAM_BASES_EARNED_1	* -2.96731
	+TEAM_BATTING_1B_1		* -2.63365
	+TEAM_BATTING_1B_2		* -1.68035
	+TEAM_BATTING_2B_2		* 3.99684
	+TEAM_BATTING_2B_3		* 4.29464
	+TEAM_BATTING_3B_1		* -7.76377
	+TEAM_BATTING_3B_2		* -5.44978
	+TEAM_BATTING_3B_3		* -5.57251
	+TEAM_BATTING_3B_4		* -3.23268
	+TEAM_BATTING_BB_1		* 12.82368
	+TEAM_BATTING_BB_2		* 2.55878
	+TEAM_FIELDING_E_4		* -2.19646
	+TEAM_PITCHING_H_1		* 4.52152
	+TEAM_PITCHING_H_4		* -1.91656
	+TEAM_BASERUN_SB_1		* 5.40011
	+TEAM_BASERUN_SB_3		* -2.02191
	+TEAM_BASERUN_SB_4		* -3.20413
	+TEAM_BASERUN_CS_3		* 1.161579
	;
	P_TARGET_WINS = round(P_TARGET_WINS,1);
	P_TARGET_WINS = min( P_TARGET_WINS, 162 );
	P_TARGET_WINS = max( P_TARGET_WINS, 0 );
	keep INDEX P_TARGET_WINS;
run;