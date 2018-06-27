cap log close

********** OVERVIEW OF mus15multinomial.do **********

* NOTE: Code adapted from 
* "Microeconometrics Using Stata, Revised Edition" 
* by A. Colin Cameron and Pravin K. Trivedi (2010)
* Stata Press

* TOPIC COVERED: 
* 1. MULTINOMIAL EXAMPLE: CHOICE OF FISHING MODE
* 2. MULTINOMIAL LOGIT MODEL
* 3. CONDITIONAL LOGIT MODEL
* 4. ORDERED OUTCOME MODELS

* To run you need files
*   mus15data.dta 
*   mus18data.dta 
* in your "data" directory
* Stata user-written commands esttab and estadd are used

********** SETUP **********

set more off
version 14.1
clear all
set linesize 82
set scheme s1mono  /* Graphics scheme */

********** DATA FILE DESCRIPTION **********

* File mus15data is from 
* J. A. Herriges and C. L. Kling, 
* "Nonlinear Income Effects in Random Utility Models", 
* Review of Economics and Statistics, 81(1999): 62-72

* File mus18data.dta is from
* Rand Health Insurance Experiment data 
* Essentially same data as in P. Deb and P.K. Trivedi (2002)
* "The Structure of Demand for Medical Care: Latent Class versus
* Two-Part Models", Journal of Health Economics, 21, 601-625
* except that paper used different outcome (counts rather than $)
* Each observation is for an individual over a year.
* Individuals may appear in up to five years.
* All available sample is used except only fee for service plans included.
* If panel data used then clustering is on id (person id)

********** TOPIC 1: MULTINOMIAL EXAMPLE: CHOICE OF FISHING MODE

* Read in dataset and describe dependent variable and regressors
use ../data/mus15data.dta, clear
describe

* Summarize dependent variable and regressors
summarize, separator(0) 

* Tabulate the dependent variable
tabulate mode

* Table of income by fishing mode
table mode, contents(N income mean income sd income)

* Table of fishing price by fishing mode
table mode, contents(mean pbeach mean ppier mean pprivate mean pcharter) format(%6.0f)

* Table of fishing catch rate by fishing mode
table mode, contents(mean qbeach mean qpier mean qprivate mean qcharter) format(%6.2f)

********** TOPIC 2: MULTINOMIAL LOGIT MODEL

* Multinomial logit with base outcome alternative 1
mlogit mode income, baseoutcome(1) nolog

* Wald test of the joint significance of income
test income

* Relative-risk option reports exp(b) rather than b
mlogit mode income, rr baseoutcome(1) nolog

// Following used below
estimates store MNL

* Predict probabilities of choice of each mode and compare to actual freqs
predict pmlogit1 pmlogit2 pmlogit3 pmlogit4, pr
summarize pmlogit* dbeach dpier dprivate dcharter, separator(4)

* Sample average predicted probability of the third outcome
margins, predict(outcome(3)) noatlegend

* Marginal effect at mean of income change for outcome 3
margins, dydx(*) predict(outcome(3)) atmean noatlegend

* Average marginal effect of income change for outcome 3
margins, dydx(*) predict(outcome(3)) noatlegend

********** TOPIC 3: CONDITIONAL LOGIT 

* Data are in wide form
list mode price pbeach ppier pprivate pcharter in 1, clean

* Convert data from wide form to long form
generate id = _n
reshape long d p q, i(id) j(fishmode beach pier private charter) string
save mus15datalong.dta, replace

* List data for the first case after reshape
list in 1/4, clean noobs

* Conditional logit with alternative-specific and case-specific regressors
asclogit d p q, case(id) alternatives(fishmode) casevars(income) basealternative(beach) nolog 

// Following used below
estimates store CL

* Predicted probabilities of choice of each mode and compare to actual freqs
predict pasclogit, pr
table fishmode, contents(mean d mean pasclogit sd pasclogit) cellwidth(15)

// Display summary statistics about the alternatives in the estimation sample.
estat alternatives

* Marginal effect at mean of change in price
estat mfx, varlist(p)
exit
* Alternative-specific example: AME of beach price change computed manually
preserve
quietly summarize p
generate delta = r(sd)/1000
quietly replace p = p + delta if fishmode == "beach"
predict pnew, pr
generate dpdbeach = (pnew - pasclogit)/delta
tabulate fishmode, summarize(dpdbeach)
restore

********** TOPIC 4: ORDERED OUTCOME MODEL

* Create multinomial ordered outcome variables takes values y = 1, 2, 3
use mus18data.dta, clear
quietly keep if year==2
generate hlthpf = hlthp + hlthf
generate hlthe = (1 - hlthpf - hlthg)
quietly generate hlthstat = 1 if hlthpf == 1
quietly replace hlthstat = 2 if hlthg == 1
quietly replace hlthstat = 3 if hlthe == 1
label variable hlthstat "health status"
label define hsvalue 1 poor_or_fair 2 good 3 excellent
label values hlthstat hsvalue
tabulate hlthstat

* Summarize dependent and explanatory variables
summarize hlthstat age linc ndisease

* Ordered logit estimates
ologit hlthstat age linc ndisease, nolog

* Calculate predicted probability that y=1, 2, or 3 for each person
predict p1ologit p2ologit p3ologit, pr
summarize hlthpf hlthg hlthe p1ologit p2ologit p3ologit, separator(0)

* Marginal effect at mean for 3rd outcome (health status excellent)
margins, dydx(*) predict(outcome(3)) atmean noatlegend

********** CLOSE OUTPUT
