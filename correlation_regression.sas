/*proc correlation*/
/* we are trying to find out the corelation bw variables*/
ods graphics on;
proc corr data=exercise nosimple rank;
var rest_pulse max_pulse run_pulse age;
with pushups;
run;
ods graphics off;


/* to include more variable in panel*/
ods graphics on;
proc corr data=exercise nosimple rank plots=matrix(nvar=all);
var rest_pulse max_pulse run_pulse age;
with pushups;
run;
ods graphics off;
/* to display scatter plot on seprate page for each variable pair */
ods graphics on;
proc corr data=exercise nosimple rank plots(only)=scatter;
var rest_pulse max_pulse run_pulse age;
with pushups;
run;
ods graphics off;

/* creating a corelation matrix*/
ods graphics on;
proc corr data=exercise nosimple rank plots=matrix(histogram);
var pushups rest_pulse max_pulse run_pulse age;
run;
ods graphics off;

/*creating html output with data tips*/
ods graphics on / imagemap=on;
ods listing close;
ods html gpath='/home/x01shubham0/dataset'
         path='/home/x01shubham0/dataset'
         file='scatterplot.html'
         style=statistical;
         
  title="computing pearson coefficients";
  proc corr data=EXERCISE nosimple plots(only)=scatter(ellipse=none);
   var Rest_Pulse Max_pulse Run_Pulse Age;
   with pushups;
   id subj;
   run;
 
/*generating  spearman nonparametric correlations*/
  proc corr data=exercise nosimple spearman;
  var Rest_Pulse Max_pulse Run_pulse Age;
  with pushups;
  run;



/*Running a simple Linear regression model*/
ods graphics on;
proc reg data=exercise;
model pushups=Rest_pulse;
run;
quit;
ods graphics off;



/*using regression model to do prediction*/

data predictions;
input rest_pulse @@;
datalines;
50 60 70 80 90
;
data overall;
set exercise predictions;
run;


proc reg data=overall;
model pushups=Rest_pulse/p;
id rest_pulse;
run;
quit;
/*note some of the obs not used bcz of missing value however we still get predicted values for them


/*using outetst option and noprint to store regression parameters into a dataset*/
proc reg data=exercise noprint outest=betas;
model pushups=rest_pulse;
run;
quit;
proc print data=betas noobs;
run;

/*running proc score to compute predicted values from a regression  model*/
proc score data=predictions score=betas
out=predictions type=parms;
var rest_pulse;
run;
proc print data=predictions noobs;
run;
/*-------------------------------------------MULTIPLE REGRESSION---------------------------------------------------------*/
ods graphics on;
title "Demonstrating rsquare selection method";
/*note for n predictor variable this process genrates 2^n-1 possible modles*/
proc reg data=exercise plots(unpack)=(diagnostics residualplot);
model pushups=age rest_pulse max_pulse run_pulse /selection=rsquare cp adjrsq;
run;
quit;
ods graphics off; 
/*mallows cp helps you identify whether you have too few or too many predictor variable in model*/

ods graphics on;

proc reg data=exercise plots(only)=(rsquare adjrsq cp);
model pushups=age rest_pulse max_pulse run_pulse /selection=rsquare cp adjrsq best=3;
run;
quit;
ods graphics off; 

/*forward backward and stepwise selection*/
proc reg data-exercise;
forward: model pushups=age rest_pulse max_pulse run_pulse /selection=forward;
backward: model pushups=age rest_pulse max_pulse run_pulse /selection=backwards;
stepwise:model pushups=age rest_pulse max_pulse run_pulse /selection=stepwise;
run;
quit;

/* note forward slentry=.50
         backward slstay=.10
         stepwise slentry=.15 slstay=.15
  to modify use / selection=forward slentry=.15  */
 
 
 /*forcing selected variables into a model*/
/*use INCLUDE= */
PROC REG DATA=EXERCISE;
MODEL PUSHUPS= Max_pulse Age Rest_pulse Run_pulse / selection=stepwise include=1;
run;
quit;

/*Detecting colinearity*/
/*use VIF*/


PROC REG DATA=EXERCISE;
MODEL PUSHUPS= Max_pulse Age Rest_pulse Run_pulse / VIF;
run;
quit;
/*
 NOTE VALUES FOR VIF>10 ARE CONSIDERED LARGE
      VALUES FOR VIF>5 SHOULD ALSO BE PAID ATTENTION
 */


/*
 * INFLUENTIAL OBSERVATIONS IN MULTIPLE REGRESSION
 */
ods graphics on;
proc reg data=exercise plots(label only)=(cooksd rstudentbypredicted dffits dfbetas);
 id subj;
 model pushups=Age Max_pulse Run_pulse/influence;
 run;
 quit;
 ods graphics off;

