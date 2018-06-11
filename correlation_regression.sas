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
