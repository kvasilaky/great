clear
set more off
cd "C:\katya\prospectus\uganda\experimental\the game\"
use 	"game1.dta"

*ASSIGN A NUMBER VALUE TO EACH VILLAGE
egen 	villnumber=group(village)
sum 	villnumber
*SAVE THE TOTAL NUMBER OF VILLAGES IN LOCAL VAR
local 	totvill=r(max)
sort villnumber person
save 	"temp\master.dta", replace
keep 	village villnumber person name hhdid infopt n1-n4 g*p*
for 	num 1/4: replace nX=. if nX>14 & nX!=.
for 	num 1/4: gen spillX=.
foreach 	V of num 1/`totvill' {
preserve
keep	if villnumber==`V' 
count 	
local 	nvill=r(N)
sort 	person
			*Z IS THE PERON NO. IN VILLAGE V
			foreach 	Z of num 1/`nvill' {
				
						* Pieces of info the i-th person should have obtained from j-th contact
						*b IS THE NTH CONNECTION TO PERSON Z, N1-N4, EVERYONE HAS AT LEAST N1~=.
						foreach b of num 1/4 {
						*IF nb IS NOT EMPTY	
							if n`b'[`Z']!=. {
							
							local 			a`b'=n`b'[`Z']
							qui sum 		infopt in `a`b'' 
							qui replace		spill`b'=r(mean) in `Z'
										
							}		
									
						}																 
										
			}				 


keep	village villnumber person spill*
save 	"temp\tempvill`V'.dta", replace

restore

}

use 	"temp\tempvill1.dta", clear
for 	num 2/`totvill' : append using "temp\tempvillX.dta"
sort villnumber person
merge	villnumber person using "temp\master.dta"

erase 	"temp\master.dta"
for 	num 1/`totvill' : erase "temp\tempvillX.dta"


*FIGURE OUT IF SPILL1-SPILL2 IS EQUAL TO G1-G10, IF YES, THEN ENTER A 1, IF NO ENTER 0
foreach x of numlist 1/4 {
	 gen effort`x'=.
}


foreach x of numlist 1/4 {
replace effort`x'=1 if (spill`x'==g1p1 | spill`x'==g1p2 | spill`x'==g1p3 | spill`x'==g1p4 | spill`x'==g1p5 | spill`x'==g1p6 | spill`x'==g1p7 | spill`x'==g1p8 | spill`x'==g1p9| spill`x'==g1p10) & spill`x'~=. 
replace effort`x'=0 if effort`x'==. 
}



*replace effort1=1 if (spill1==g1p1 | spill1==g1p2 | spill1==g1p3 | spill1==g1p4) & spill1~=.
*replace effort1=1 if spill1==g1p1 | spill1==g1p2 | spill1==g1p3 | spill1==g1p4 | spill1==g1p5 | spill1==g1p6 | spill1==g1p7 | spill1==g1p8 | spill1==g1p9| spill1==g1p10 & spill1~=.
*replace effort1=1 if (spill1==g1p1 | spill1==g1p2 | spill1==g1p3 | spill1==g1p4 | spill1==g1p5 | spill1==g1p6 | spill1==g1p7 | spill1==g1p8 | spill1==g1p9| spill1==g1p10) & spill1~=. 
*replace effort1=0 if effort1==. 




order effort1-effort4 spill1-spill4 g1p*
gen toteffort=effort1+effort2+effort3+effort4
foreach n of numlist 1/4{
	gen sum`n'=.
	replace sum`n'=1 if n`n'~=.
	replace n`n'=0 if n`n'==.
}
gen totsum=sum1+sum2+sum3+sum4
gen ntoteffort=toteffort/totsum
order toteffort ntoteffort totsum effort1-effort4 spill1-spill4 g1p*
drop sum1 sum2 sum3 sum4 
keep  toteffort  ntoteffort totsum effort1 effort2 effort3 effort4 spill1 spill2 spill3 spill4 vill id person villnumber g1p*
rename vill village
sort village person
save "C:\katya\prospectus\uganda\experimental\the game\effort.dta", replace
