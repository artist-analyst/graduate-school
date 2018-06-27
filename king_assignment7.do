capture log close
log using "king_assignment7.log", replace

clear

/* PhD Research Practicum */
/* Assignment 6 */
/* Robb King */
/* 03/16/17 */

global ddir "../data/"

/*3. Depending on your assigned observational control group, replicate table 3, 
using the data on treatments, controls, and your observational control group. 
Replicate columns one and two for 1975 and 1978 earnings data, then replicate 
the column that corresponds to your assigned observational control group.*/

use ${ddir}nsw, clear

estpost tabstat re75 re78, by(treat) statistics(mean semean) 
ereturn li
esttab . using earnings2.rtf, cells("re75 re78") replace

use ${ddir}cps_controls2, clear

estpost tabstat re75 re78, stats(mean semean)
esttab . using earnings3.rtf, cells("re75 re78") replace

/*4. Depending on your assigned observational control group, replicate table 5, 
columns 1 through 9. Replicate row 1 of the table, then the row for your assigned 
observational control group. The resulting table or tables should have results 
from a total of 18 regression estimates, nine reporting the results when 
comparing the experimental treatment group with the experimental control group, 
and nine comparing the experimental treatment group with the observational control 
group. Your estimate for treatment should be the same as the estimate in the LaLonde 
paper reported in the table.*/

/*NUMBERS FOR NSW*/
use ${ddir}nsw, clear

/*Column 1*/
gen growth=re78-re75
eststo col_1: reg growth treat

/*Column 2*/
eststo col_2: reg re75 treat

/*Column 3*/
gen age_sq=age*age
eststo col_3: reg re75 treat age age_sq education black hispanic nodegree

/*Column 4*/
eststo col_4: reg re78 treat

/*Column 5*/
eststo col_5: reg re78 treat age age_sq education black hispanic nodegree

/*Column 6*/
eststo col_6: reg growth treat

/*Column 7*/
eststo col_7: reg growth treat age age_sq

/*Column 8*/
eststo col_8: reg re78 treat re75

/*Column 9*/
eststo col_9: reg re78 treat re75 age age_sq education black hispanic nodegree

esttab col_1 col_2 col_3 col_4 col_5 col_6 col_7 col_8 col_9 using controls.rtf, ///
	nostar ///
	b(0) ///
	se(0) ///
	replace

/* NUMBERS FOR CPS2*/
use ${ddir}cps_controls2, clear
merge m:m data_id using nsw

drop if _merge==2 & treat==0

/*Column 1*/
gen growth=re78-re75
eststo col_1: reg growth treat

/*Column 2*/
eststo col_2: reg re75 treat

/*Column 3*/
gen age_sq=age*age
eststo col_3: reg re75 treat age age_sq education black hispanic nodegree

/*Column 4*/
eststo col_4: reg re78 treat

/*Column 5*/
eststo col_5: reg re78 treat age age_sq education black hispanic nodegree

/*Column 6*/
eststo col_6: reg growth treat

/*Column 7*/
eststo col_7: reg growth treat age age_sq

/*Column 8*/
eststo col_8: reg re78 treat re75

/*Column 9*/
eststo col_9: reg re78 treat re75 age age_sq education black hispanic nodegree

esttab col_1 col_2 col_3 col_4 col_5 col_6 col_7 col_8 col_9 using cps2.rtf, ///
	nostar ///
	b(0) ///
	se(0) ///
	replace

log close
exit













