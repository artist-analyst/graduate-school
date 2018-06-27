capture log close
clear

/* PhD Research Practicum */
/* Assignment 10 */
/* Robb King */

set more off

use diss

/*1. Run a “pooled” regression, estimating the impact of percent of the population 
aged 18-24 on appropriations, with appropriate controls*/

/* COMMENT: Played around with this code. Wondered if this is what was meant by pooled data...
forvalues i=1984/1999 {
	generate y`i'=1 if year==`i'
	replace y`i'=0 if y`i'==.
	
	generate y`i'_legcomp=y`i'*legcomp_i
}

local controls citideo legideo legcomp y1984 y1985 y1986 y1987 y1988 y1989 y1990 y1991 y1992 ///
	y1993 y1994 y1995 y1996 y1997 y1998 y1999 ///
	y1984_legcomp y1985_legcomp y1986_legcomp y1987_legcomp y1988_legcomp y1989_legcomp y1990_legcomp y1991_legcomp y1992_legcomp ///
	y1993_legcomp y1994_legcomp y1995_legcomp y1996_legcomp y1997_legcomp y1998_legcomp y1999_legcomp 
*/
	
local y approps_i
local controls citideo legideo legcomp_i
reg `y' perc1824 `controls'

/*2. Run a separate regression for each year estimating the above relationship. 
Comment on any patterns you see.*/

reg `y' perc1824 `controls' i.year

/*COMMENTS: In 1991 and between 1993 and 1996, there was an associated decrease in appropriations.
City ideology also had a negative impact on appropriations.*/

/*3. Run a separate regression for each state, estimating the above relationship. 
Comment on any patterns you see.*/

reg `y' perc1824 `controls' i.state

/*COMMENTS: There is an associated decrease in appropiations for each state.*/

/*4. Run a model with state fixed effects, comment (in the do file) on the key estimate.*/

xtset state year, yearly

xtreg `y' perc1824 `controls', fe

reg `y' perc1824 `controls' i.state

/*COMMENTS: I did not see much difference in perc1824 once fixed effects were employed.*/

/*5. Run a model with year fixed effects, comment (in the do file) on the key estimate.*/

xtreg `y' perc1824 `controls', fe

reg `y' perc1824 `controls' i.year

/*COMMENTS: Same thing.*/

/*6. Run a model with state and year fixed effects, comment on the key estimate.*/

xtreg `y' perc1824 `controls', fe

reg `y' perc1824 `controls' i.state i.year

/*COMMENTS: There seems to be an associated decrease on appropriations for perc1824 when using this model.*/

/*7. Run a model with state fixed effects and an appropriate adjustment for autocorrelation.*/

xtregar `y' perc1824 `controls', fe rhotype (tsc) twostep lbi

xtpcse `y' perc1824 `controls' i.state, correlation (psar1) independent

/*8. Create a plot that demonstates the impact of percent of the population aged 
18-24 on appropriations, based on your preferred estimate.*/

reg `y' perc1824 `controls' i.state i.year
predict model, resid
graph box model, over(year, sort(1) descending label(labsize(tiny))) name(time_error)

log close
exit


