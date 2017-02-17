
--1,73, High school graduate, Widowed, Female, Nonfiler,20401.08,2596.41 Not in universe, United-States, Native- Born in the United States,0

--which country immigrants contribute more to US?consider tax paid and tax filed// pig

loaddata = load '/home/bashyan-ubuntu/Documents/censusproject/TaxMapper.txt' using PigStorage(',') as (id, age, education:chararray, maritalstatus, gender, taxfilerstatus:chararray, income, tax:double, parents, country:chararray, citizenship:chararray, weeksworked);

immigrants = filter loaddata by (taxfilerstatus != ' Nonfiler') and ((citizenship == ' Foreign born- Not a citizen of U S ') OR (citizenship == ' Foreign born- U S citizen by naturalization')) and (country != ' ?');

taxcal = foreach (group immigrants by country) generate group, ROUND_TO(SUM(immigrants.tax),2) as taxes ;

listcountry = order taxcal by taxes desc;

topcountry = limit listcountry 1;

countrytaxper = foreach (group listcountry all) generate CONCAT('Tax Contribution : ', (chararray)topcountry.$0, CONCAT(' contributed more in income tax and accounted for about ', (chararray)ROUND_TO((topcountry.$1*100)/SUM(listcountry.$1),2)), '% of total tax revenue from immigrants');

educated = filter loaddata by ((education == ' Bachelors degree(BA AB BS)') or (education == ' Masters degree(MA MS MEng MEd MSW MBA)') or (education == ' Prof school degree (MD DDS DVM LLB JD)') or (education == ' Associates degree-academic program') or (education == ' Doctorate degree(PhD EdD)') or (education == ' Associates degree-occup /vocational') or (education == ' High school graduate') or (education == ' Some college but no degree')) and ((citizenship == ' Foreign born- Not a citizen of U S ') OR (citizenship == ' Foreign born- U S citizen by naturalization')) and (country != ' ?');

educal = foreach (group educated by country) generate group, COUNT(educated); 

listedu = order educal by $1 desc;

topedu = limit listedu 1;

topeduper = foreach (group listedu all) generate CONCAT('Educated Immigrants : ', (chararray)topedu.$0, CONCAT(' sources more educated immigrants and accountes ',(chararray)((topedu.$1*100)/SUM(listedu.$1))), '% of total educated immigrant population');

taxedu = union countrytaxper, topeduper;

dump taxedu;

/*
(Tax Contribution :  Mexico contributed more in income tax and accounted for about 31.77% of total tax revenue from immigrants)
(Educated Immigrants :  Mexico sources more educated immigrants and accountes 18% of total educated immigrant population)

*/

