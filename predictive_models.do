/**********************************

Problem Set 4
Due Date: 3/27/2017

Names: Mark Sieber and Robb King

PSET04_[LASTNAMES].do
PSET04_[LASTNAMES].log
*/
capture log close
log using "PSET05_SieberKing.txt", replace

set more off
set trace off

clear all

use promote_data_rev, clear

/*1.0 Estimate a linear probability model in which the probability of serving 
in a managerial position depends on sex, on education level, and on experience.  
What is the predicted effect of going from a high school education to a college 
degree?  Test whether it is statistically significant and report its p-value. */

reg manager educ i.sex c.exper
est store lpm1

test educ


/* It is significant, p vale us _ */

/*2.0 Calculate the predicted probability of serving in a managerial position for each observation. 
Are there observations for whom these predictions take impossible values?  How many? */

estimates restore lpm1

margins, atmeans
/* When all parameters are held at the mean, obervations that have binary indicators
can take impossible outcomes. For instance, an observation that is really female would be marked
in the middle - which is impossible. Therefore, when all parameters are held at the
mean, all observations have predictions with impossible values. */

/* What is the predicted probability for a female high school dropout with 0 experience?  
(Use the margins command with the at( ) option.) */

margins, predict(xb) ///
	at( sex=1 exper=0 educ=1)
	
/*3.0 Re-estimate the model using the logit command and repeat question */

logit manager educ i.sex c.exper

est store logit1

margins, atmeans

margins, predict(xb) ///
	at( sex=1 exper=0 educ=1)

/*4.0 What is the effect of an additional year of experience on this employee's 
probability of serving as a manager? */


est restore logit1

margins, predict(xb) ///
	at(sex=(1) educ=(1) ///
	exper=(0,1))

/* What is the effect for a male college graduate with 20 years of experience? */

estimates restore logit1

margins, predict(xb) ///
	at(sex=(0) educ=(4) ///
	exper=(20)) 

	
/* 5.0 Modify the model to allow the effects of education and experience to vary 
by sex and re-estimate. */

logit manager i.educ##i.sex c.exper##i.sex
est store logitinteract

/* a.  What is the average probability of serving as a manager for the men in the sample? */
est restore logitinteract

margins, predict(xb) ///
	at((mean) educ exper sex=(0))

/* b.  What would be the average probability of a promotion if everyone in the sample were a man? */
est restore logitinteract

margins sex if sex==0

/* c.  Why do these answers differ?  (Be specific - what is it in this data set that causes the difference?)
The difference in these codes is that the first, where sex is held at male, does not exclude female observations. 
Instead, it assumes that all of the observations are male, and predicts an average effect for the entire population
holding this assumption. The second command isolates only male observations, and drops female observations. 
Therefore, the prediction is only for males. 

d.  Calculate the probability that men would be managers, if men had the characteristics of the women in this sample. */
est restore logitinteract

margins, over(sex) at(sex=(0 1))

/* e.  What do the foregoing answers suggest about the hypothesis that women are 
discriminated against when considered for promotion to managerial positions? */

/* Men as women and men as men have the highest probability of being promoted, over 
both categorizations of women. This shows that, with the data given and holding
all other paramaters constant, that men are more likely to be promoted due to sex
than women. */

/*6.0 Calculate the marginal effect of a change in experience on the probability of
serving as a manager, averaged over the entire sample.  
Compare this to the marginal effect of experience for a female high school dropout 
with zero experience. Then compare it to the marginal effect of experience for 
a male college graduate with 20 years of experience. */

est restore logitinteract 

margins, at(exper=(0 1))

margins, at( sex=1 exper=0 educ=1)

margins, at(sex=(0) educ=(4) exper=(20)) 

/* The change in one year of experience has a higher probability of resulting
in a promotion that the female observation. However, the male observation has 
a much high probability than either other predicted effect */

/* 7.0 Who has the greater probability of serving as a manager: a female 
college graduate with 20 years experience, or a male college graduate with 20 years experience)?
Is the difference statistically significant?  
(Hint: use margins with the contrast option.  You can read about 
it in the margins,contrast section of the manual. */

margins sex, contrast at(exper=20 educ=4)

/* The male observation has the higher probability, and the difference is statistically
significant */

/* 8.0 Using the data set choice, estimate a multinomial logit model in which the choice of 
school type depends on father's education, an index of household religiosity (religval), 
and household income (measured in $000). */
use choice, clear

label define choice 1 "Private" 2 "Charter" 3 "Public"
label value choice choice 


mlogit choice fathered religval income, baseoutcome(1) nolog
est store mlogit1


mlogit choice fathered religval income, baseoutcome(2) nolog
est store mlogit2

mlogit choice fathered religval income, baseoutcome(3) nolog
est store mlogit3

/* What is the predicted probability that a household with a high level of religiosity (.9) 
and mean levels of father's education and income sends their child to a private school?  
Compare that to a household with a low level of religiosity (.1).  
Approximate the difference using the derivative of the probability with respect to 
religval.  How accurate is the approximation?  Does it under or over-predict?  Why? */

estimates restore mlogit3

margins, dydx(religval) predict(outcome(1)) at(religval=(.1,.9) (mean) fathered income)

/* I am unclear how accurate the approximation would be, however it would probably
over-predict? */

/*9.0 Test the joint hypothesis that the coefficients you have estimated in the charter school equation
all equal 0. (Hint: use the test command, as explained in the mlogit postestimation help
file.)*/

estimates restore mlogit1

test [Charter]

/* Do you reject the null hypothesis at the 5 percent level? */

/*Null rejected*/

/*10.0 Test the hypothesis that the coefficient on fathered in the private school equation equals its
coefficient in the public school equation. What is the result? */

estimates restore mlogit2

test [Private=Public]: fathered

/* It is significant. */


/* 11.0 Reshape your data set using the restructure.do Stata program. (If the restructure.do file
is in the same folder as the choice.dta data set, all you need to do is enter the command run
restructure at the Stata command prompt.) */

run restructure

/* Estimate a model in which the probability of choosing these three school types depends on
tuition, school quality, and household income. You will be using the asclogit command to
estimate this model. */

asclogit choice tuition quality, case(id) alternatives(school) casevar(income) basealternative(public)

est store asclogitpublic

/*Because the margins command is not available as a post-estimation command for the alternativespecific
conditional logit model, use the estat mfx command to calculate the following:

(a) the marginal effect of a change in income on the probability that a household selects a
charter school, assuming quality of all 3 types is the same (=100), income = 60, and
private school tuition = 10. */

estat mfx, at(tuition=10 income=60 quality=100)


/* (b) the marginal effect of a change in private school tuition on the probability that a household
selects a traditional public school, at the same values of the covariates */

estat mfx, at(public:tuition=10 income=60 quality=100)

/* 12.0 Suppose you request marginal effects with the following command: estat mfx, at(mean).
What is odd about these predictions? */

estat mfx, at(mean)

/* I honestly have no clue what is odd about the outcomes */




exit
