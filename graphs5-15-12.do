clear																																																																																																																										
set more off
set mem 700m
cd "/Users/kathrynvasilaky/Documents/Thesis/data"

global data /Users/kathrynvasilaky/Documents/Thesis/data
*cd "C:\katya\prospectus\uganda\data"
*tempSOLD was created in dataSALES9-29-10.dta
*tempSOLDquiz was created in quizsndiff
use tempSOLDquiz, clear

*cf hhdid using "C:\katya\prospectus\uganda\data_redo\tempSOLDTEST1"


*TABLE 1: Means, TABLES.TEX
label variable sex "sex"
label variable SNI "SNI"
label variable TRAINING "Training"


eststo clear
estpost tabstat SNI TRAINING sex level yield GRADE BN4 BN5, by(year) listwise s(mean sd) columns(statistics)
*esttab using tables.tex, main(mean) aux(sd) nostar nodepvar unstack nomtitle nonumber noobs addnotes(""  "Mean of each variable with standard deviation in parentheses.") label title("Means over time") replace nonotes


log using 3rdchapter, text replace
******************************
*DD, Control for Training, ALL
******************************
use tempSOLDquiz, clear
gen Info = (infopt~=.)
gen Infoxt=Info*t

*No significant changes in yields across full sample 
diff yield, t(SNI) p(t) cov(TRAINING) bs rep(50)
diff yield, t(SNI) p(t) cov(TRAINING Info) bs rep(50)
*outtex, labels level below file(C:\katya\prospectus\uganda\tex\diff1.tex) replace

*did Social Networks Change considerably? or is it learning? 
*Social Networks don't seemed to have changed in size

*Perceived SN
diff BN4, t(SNI) p(t) cov(TRAINING) bs rep(50)
*Reported SN
diff BN5, t(SNI) p(t) cov(TRAINING) bs rep(50)
*I can't diff across GRADE since I don't have GRADE in 2009 for control groups
*diff GRADE, t(SNI) p(t) cov(TRAINING) bs rep(50)
*outtex, labels level below file(C:\katya\prospectus\uganda\tex\diff1.tex) replace


use tempSOLDquiz, clear
keep if sex==2
diff yield, t(SNI) p(t) cov(TRAINING) bs rep(50)
*outtex, labels level below file(C:\katya\prospectus\uganda\tex\diff1.tex) append

use tempSOLDquiz, clear
keep if sex==1
diff yield, t(SNI) p(t) cov(TRAINING) bs rep(50)
*outtex, labels level below file(C:\katya\prospectus\uganda\tex\diff1.tex) append



*****************************
*TD/DD F/M Linear Regressions
*****************************
clear																																																																																																																																																																																																																																																						
set more off
set mem 700m
cd "/Users/kathrynvasilaky/Documents/Thesis/data"
*cd "C:\katya\prospectus\uganda\data"
use tempSOLDquiz, clear
gen lnyield=ln(yield+1)
*gen spline 
quietly gen dummy400=(yield<401)
generate dummy400xSNI= dummy400*SNI
drop BN3
replace sex=0 if sex==1
replace sex=1 if sex==2
gen sexSNI=sex*SNI
gen per_mutual=(BN22==3)

ren BN7 per_growers
ren BN18 per_trained
ren AN1 important
ren BN4 size

log using IV, replace text
foreach var of varlist size important per_growers per_trained per_mutual {
	gen `var'xt=`var'*t
ivregress gmm yield t `var' TRAINING TrxSNI  TRxt dummy400xSNI sex (`var'xt = SNIxt), cluster(villcode) small
outreg2 using ivnetworks,  tstat tex append ctitle(`var')
}

/*BN7, BN18, BN22,AN1 sig

BN7             float  %9.0g                  if person grew cotton last year
BN18            float  %9.0g                  were they trained in growing cotton 1=y, 2=n
BN22            float  %9.0g                  who benefits most from relationship? 1=me, 2=them, 3=both
AN1             float  %9.0g                  # of people you regard important in village
BN4             float  %9.0g                  stated size of network
*/
log close



*so people forget INFORMATION!!! GOES DOWN
*yeah, but in 2009, I only have SNI people having taken the quiz
tab year, summ(GRADE)

*STANDARD REGRESSION
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt , robust cluster(villcode)
outreg2 using cross,  tstat tex replace ctitle(TRIPLE D: Yield)



************************************************************
*KAREN'S SPLINE WORKS JUST FINE, I DON'T HAVE TO DROP DATA
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt dummy400xSNI sex , robust cluster(villcode)
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt sex sexSNI if dummy400==1 , robust cluster(villcode)
outreg2 using cross,  tstat tex append ctitle(Yield) title(Learning or Networks?)
************************************************************
*NO EFFECT ON SOCIAL NETWORKS THEMSELVES
reg BN4  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt dummy400xSNI sex, robust cluster(villcode)
outreg2 using cross,  tstat tex append ctitle(Networks) 

************************************************************
*COMPARE SNI GUYS WHO GOT AND DIDN'T GET GAMES/MEETINGS
*PARSES OUT THE EFFECT OF IS IT LINKS OR LEARNING?
**************************************************
gen Info = (infopt~=.)
gen Infoxt=Info*t

reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt dummy400xSNI, robust cluster(villcode)

*reg lnyield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt , robust cluster(villcode)
/*Seems that, EVEN AFTER CONTROLLING FOR INFORMATION EFFECT, SNI STILL HAVS POWER. 
MAYBE JUST NOT THROUGH TYPICAL NETWORK SIZE. */
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt dummy400xSNI Info Infoxt, robust cluster(villcode)
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt dummy400xSNI Info Infoxt sex, robust cluster(villcode)

outreg2 using cross,  tstat tex append ctitle(Yield, Control for Info)
****************************************************





**********************************************
*SNI EFFECTS VIA LEARNING OR SN? 
*BY 2010 CROSS SECTION/IT SEEMS TO BE LEARNING
*********************************************
reg yield SNI TRAINING TrxSNI if year==2010 , robust cluster(villcode)
outreg2 using cross,  tstat tex append ctitle(Yield) title(Yield)
************************************************************
reg GRADE   SNI TRAINING TrxSNI  if year==2010, robust cluster(villcode)
outreg2 using cross,  tstat tex append ctitle(Information Learned)
************************************************************
reg BN4  SNI TRAINING TrxSNI if year==2010, robust cluster(villcode)
outreg2 using cross,  tstat tex append ctitle(Network Size)
************************************************************
*TTEST ACROSS PANEL AND CROSS SECTION
reg yield  t SNI SNIxt  TRAINING TRxt
est sto f
reg yield SNI TRAINING TrxSNI if year==2010 
est sto d
suest f d
test [f_mean]SNIxt = [d_mean]SNI
*************************************************************




*******************************************
*NOW CONTINUE WITH REGS OF YIELDS UNDER 400
*******************************************
use tempSOLDquiz, clear
quietly gen dummy500=(yield<500)
drop if dummy500==0
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt, robust cluster(villcode)
*outreg2 using triple,  tstat tex append ctitle(DD, Yield<500)
*GRADE CAN ONLY BE TESTED FOR IN 2010
reg yield   SNI TRAINING TrxSNI if year==2010, robust cluster(villcode)
reg GRADE   SNI TRAINING TrxSNI if year==2010, robust cluster(villcode)


****************
*BY AGE QUANTILE
****************
use "C:\katya\prospectus\uganda\data_redo\tempSOLDTEST1", clear
gen lnyield=ln(yield+1)
replace yrborn=. if yrborn<0
gen age=2011-yrborn
xtile quantile = age, nquantiles(99)
bysort quantile: summ(age)

*THE YOUNG AND OLD SEEM TO GAIN FROM SNI
reg lnyield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt , robust cluster(villcode)
bysort quantile: reg lnyield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt , robust cluster(villcode)

************************
*BY YIELD QUANTILE, ABBY
************************
cd "C:\katya\prospectus\uganda\data_redo"
*tempSOLD was created in dataSALES9-29-10.dta
use tempSOLD, clear

local quant=5
matrix bSNIfin = J(`quant', 1, 0)
matrix bTRfin = J(`quant', 1, 0)
matrix sSNIfin = J(`quant', 1, 0)
matrix sTRfin = J(`quant', 1, 0)

xtile quantile = yield if year==2009, nquantiles(`quant')
keep if year==2009
sort hhdid
save tempSOLDq, replace
use tempSOLD, clear
sort hhdid
merge hhdid using tempSOLDq
sort hhdid year
save tempSOLDq, replace


forval x=1(1)5 {
local B=50
matrix SNI`x' = J(`B', 1, 0)
matrix TR`x' = J(`B', 1, 0)
forvalues b = 1(1)`B' {
qui {
preserve
bsample, cluster(villcode) 
reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt if quantile==`x'


matrix e = e(b)
matrix SNI`x'[`b', 1] = e[1,5] 
matrix TR`x'[`b', 1] = e[1,6]
restore
 }
}
svmat SNI`x'
svmat TR`x'

qui sum SNI`x', d
mat bSNIfin[`x',1]=r(mean)
mat sSNIfin[`x',1]=r(sd)

qui sum TR`x', d
mat bTRfin[`x',1]=r(mean)
mat sTRfin[`x',1]=r(sd)
}


svmat bSNIfin
svmat sSNIfin
gen sSNIupper=bSNIfin1 +1.7*sSNIfin1
gen sSNIlower=bSNIfin1 -1.7*sSNIfin1

svmat bTRfin
svmat sTRfin
gen sTRupper=bTRfin1 +1.7*sTRfin1
gen sTRlower=bTRfin1 -1.7*sTRfin1

gen QUANTILE=_n
replace QUANTILE=. if QUANTILE>5
/*
---+------------------------------------
          1 |   51.802797   116.77368         144
          2 |   87.230537   116.53809         148
          3 |   139.21593   116.17902         108
          4 |   190.35121   239.59892         116
          5 |   463.36823   312.78695         126
------------+------------------------------------
      Total |   160.85698   223.62657         642
*/
replace QUANTILE=52 if QUANTILE==1
replace QUANTILE=87 if QUANTILE==2
replace QUANTILE=140 if QUANTILE==3
replace QUANTILE=190 if QUANTILE==4
replace QUANTILE=463 if QUANTILE==5


rename QUANTILE AvgYield

twoway (line  bSNIfin1 AvgYield, sort caption("X=Avg Yield per Quantile (20-100 %) ") legend(on) ) (line  sSNIupper  AvgYield, lpattern(longdash_shortdash) sort ) (line  sSNIlower  AvgYield, sort lpattern(longdash_shortdash) )
twoway (line  bTRfin1 AvgYield, sort caption("X=Avg Yield per Quantile (20-100 %) ") legend(on) ) (line  sTRupper  AvgYield, lpattern(longdash_shortdash) sort ) (line  sTRlower  AvgYield, sort lpattern(longdash_shortdash) )





drop if bSNIfin==.
list bSNIfin sSNIfin bTRfin sTRfin, clean







************************
*BY YIELD QUANTILE, ABBY
*SLIDING BAN WIDTHS
************************
set more off
clear
cd "C:\katya\prospectus\uganda\data_redo"
*create data files of dummies
*Max is 1620 kgs in yield
forvalues x = 100(200)1500 {
	use tempSOLD, clear
	keep if year==2009
	quietly gen dummy`x'=(yield>`x'-101 & yield<`x'+101)
	capture: keep if dummy`x'==1
	keep dummy`x' hhdid
	duplicates drop hhdid, force
	sort hhdid
	quietly save dummy`x', replace
}
 


*merge together
use tempSOLD, clear
forvalues x = 100(200)1500 {
	sort hhdid
	quietly merge hhdid using dummy`x'
	drop _merge
}
save tempSOLDTEST2, replace


rename dummy100 dummy1
*rename dummy200 dummy2
rename dummy300 dummy2
*rename dummy400 dummy4
rename dummy500 dummy3
*rename dummy600 dummy6
rename dummy700 dummy4
*rename dummy800 dummy8
rename dummy900 dummy5
*rename dummy1000 dummy10
rename dummy1100 dummy6
*rename dummy1200 dummy12
rename dummy1300 dummy7
*rename dummy1400 dummy14
rename dummy1500 dummy8




local row=4
matrix bSNIfin = J(`row', 1, 0)
matrix bTRfin = J(`row', 1, 0)
matrix sSNIfin = J(`row', 1, 0)
matrix sTRfin = J(`row', 1, 0)


forval x=1(1)`row' {
	local B=100
	matrix SNI`x' = J(`B', 1, 0)
	matrix TR`x' = J(`B', 1, 0)
	forvalues b = 1(1)`B' {
		qui {
			preserve
			bsample, cluster(villcode) 
			quietly reg yield  t SNI TRAINING TrxSNI SNIxt TRxt TRxSNIxt if dummy`x'==1


			matrix e = e(b)
			matrix SNI`x'[`b', 1] = e[1,5] 
			matrix TR`x'[`b', 1] = e[1,6]
			restore
				 }
		}

	svmat SNI`x'
	svmat TR`x'

	qui sum SNI`x', d
	mat bSNIfin[`x',1]=r(mean)
	mat sSNIfin[`x',1]=r(sd)

	qui sum TR`x', d
	mat bTRfin[`x',1]=r(mean)
	mat sTRfin[`x',1]=r(sd)
	
	}


svmat bSNIfin
svmat sSNIfin
gen sSNIupper=bSNIfin1 +1.7*sSNIfin1
gen sSNIlower=bSNIfin1 -1.7*sSNIfin1

svmat bTRfin
svmat sTRfin
gen sTRupper=bTRfin1 +1.7*sTRfin1
gen sTRlower=bTRfin1 -1.7*sTRfin1


 gen AvgYield= .
replace AvgYield=100 in 1
 replace AvgYield= 300 in 2
 replace AvgYield= 500 in 3
 replace AvgYield= 700 in 4
/* replace AvgYield= 900 in 5
 replace AvgYield= 1100 in 6
 replace AvgYield= 1300 in 7
 replace AvgYield= 1500 in 8
*/

twoway (line  bSNIfin1 AvgYield, sort caption("X=Avg Yield per Quantile (20-100 %) ") legend(on) ) (line  sSNIupper  AvgYield, lpattern(longdash_shortdash) sort ) (line  sSNIlower  AvgYield, sort lpattern(longdash_shortdash) )
twoway (line  bTRfin1 AvgYield, sort caption("X=Avg Yield per Quantile (20-100 %) ") legend(on) ) (line  sTRupper  AvgYield, lpattern(longdash_shortdash) sort ) (line  sTRlower  AvgYield, sort lpattern(longdash_shortdash) )

drop if bSNIfin==.
list bSNIfin sSNIfin bTRfin sTRfin, clean




