/**********************************

Problem Set 3
Due Date: 3/2/2017

Names: Mark Sieber and Robb King

PSET02_[LASTNAMES].do
PSET02_[LASTNAMES].log
*/
capture log close
log using "PSET03_SieberKing.txt", replace

clear all
set seed 81684

/*
QUESTION 1

A. 

X1 has a direct effect on Y, while X2 is correlated with Y. There is no relation between X1 and X2. 
Real world example: Y is student achievement. X1 is parental education and X2 is involvement in a curricular 
activity. X1 has a direct effect on Y, as educated parents make informed decisions about their child's
education that leads to better outcomes. X2 is correlated with Y, as research shows involvement in activities
such as music or sports is associated with improved achievement, but causality cannot be proven. X1 and X2 are
not related.

B.
X1 has a direct effect on Y but no relationship to X2. X2 has no relationship to Y. 
Real world example: Y is graduation rate, X1 is attendance, and X2 is physical fitness. Attendance is directly
related to graduation, but a student's physical fitness, while potentially an improtant gage of health, does not
have a relationship with either variable. 

C. 
X1 has a direct effect on Y, and is correlated with X2. However, X2 has no relatinship with Y.
Real world example: Y is graduation rate, X1 is attendance rate, X2 is parent's health. The health of a parent
is correlated with attendance since many young student rely on their parents to get them to school. However,
there is no relation between parent health and graduation rates.

D.
X1 has a direct effect on Y, which has a direct effect on X2. No relationship exists between X2 and X1.
Real world example: Y is school climate, X1 is the presence of an SRO, and X2 is graduation rate. The presence of
and SRO has a direct impact on the school climate, which in turn has a direct impact on graduation rates. However,
the presence of an SRO does not directly relate to graduation rates, and no research suggests the two variables are 
related.

E. 
X1 has a direct effect on both Y and X2. X2 is correlated with Y. Real World Example: Y is graduation rate, X1 is parent
education, and X2 is transportation availability. Parent education effects location of students to the school, which 
can drastically change what transportation is avaiable. Likewise, students with better educated parents are more
likely to graduate. While transportation is correlated with graduation, since transportation effects attendance, there is
no direct effect of transportation on graduation. 

F. 
X1 has a direct effect on X2, which has a direct effect on Y. No relationship exists between X1 and Y.
Real world example: X1 teacher feelings of safety, X2 is teacher response to misbehavior , and Y is student rention rate.
Whether or not a teacher feels safe effects how they respond to misbehavior, which in turn can effect student retention rate.
However, teacher feelings of safety are not directly linked, or correlated with, student retention rate.

G.
X1 directly effects both X2 and Y, while X2 directly effects Y. Real world example: X1 is parent education, X2 is school attendance, 
and Y is graduation rate. The better educated the parent, the more likely a child is to both attend school and graduate. Attendance, on its own,
also directly effect graduation rates. 

*/

/* Question 2

A.

*/ 

tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = u + z
	
	* DGP 
	g y = 1 + x1 + u 
	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b

exit
/* 
B
*/

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = z
	
	* DGP 
	g y = 1 + x1 + u 
	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b


/* 
C
*/

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = v + z
	
	* DGP 
	g y = 1 + x1 + u 
	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b


/* 
D
*/

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	
	* DGP 
	g y = 1 + x1 + u 
	
	g x2 = y + z
	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b


/* 
E
*/ 

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = u + x1
	
	* DGP 
	g y = 1 + x1 + u 

	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b


/* 
F
*/

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = z + x1
	
	* DGP 
	g y = 1 + x2 + u 

	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b

/*
G
*/

clear all
tempname mypost 
tempfile results

postfile `mypost' beta1a beta1b using `results'

forv i = 1/1000 {
quietly{
	clear
	set obs 500
	
	* Draw error terms
	drawnorm v u z e
	
	* Create variables
	g x1 = v + e
	g x2 = z + x1
	
	* DGP 
	g y = 1 + x1 + x2 + u 

	
	reg y x1
	sca b1a = _b[x1]
	
	reg y x1 x2
	sca b1b = _b[x1]
	
	post `mypost' (b1a) (b1b)
}
}

postclose `mypost'

u `results', clear 

sum beta1a beta1b



capture log close
exit
