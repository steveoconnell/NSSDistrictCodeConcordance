************************************************************************
************************************************************************
clear
clear matrix
clear mata
cap log close
************************************************************************
************************************************************************


foreach i in 1987 1989 1994 1999 2001 2005 2007 2009 {
clear
import excel "NSSDistrictCodeConcordance_Dec2014.xlsx", sheet("NSS `i' AppendixII") firstrow case(preserve)
desc
compress
keep  StateName StateROCode Subregion Final Final1987consistent district1code FinalState

rename StateName state
rename StateROCode  staterocode
rename Subregion subregion
	replace subregion=trim(subregion)
rename Final district1name_old
rename Final1987consistent district1name
	replace district1name=trim(district1name)

tostring staterocode , replace
replace staterocode =substr("000"+staterocode ,length("000"+staterocode )-2,3)	
	g statecode=substr(staterocode, 1,2)
	drop staterocode 

g year=`i'

keep year state statecode subregion district1name district1code FinalState
rename district1name districtname
rename district1code district


drop if districtname=="blank" & district==0
tab district, mi
tab districtname, mi
drop if district==.
drop if districtname==""

							assert district!=.
							assert districtname!=""

							
replace district=district*-1
tostring district, replace
replace district=substr("00"+district,length("00"+district)-1,2)	


drop subregion	

tempfile `i'
save ``i''



}
append using `1987' 
append using `1989' 
append using `1994' 
append using `1999' 
append using `2001' 
append using `2005' 
append using `2007' 

	duplicates drop 
	egen panel=group(state districtname)
	bysort panel year: g rank=_N
	tab rank
	
	
destring year, replace
destring district, replace
drop statecode panel rank


replace state=upper(state)
replace state="A & N ISLANDS" if state=="ANDAMAN & NICOBAR ISLANDS"

g survey="NSS"
count

tab survey

rename state state_ORIGINAL


save "NSSDistrictCodesNames.dta", replace

