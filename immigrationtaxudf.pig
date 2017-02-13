register '/home/bashyan-ubuntu/Documents/censusproject/datafu-1.2.0.jar';

define Median datafu.pig.stats.Median();
define BagConcat datafu.pig.bags.BagConcat();
census = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/part-m-00000' using PigStorage(',') as (Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income:double,Parents:chararray,
CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int);

total = foreach (group census all) generate COUNT(census) as total; ------2000----------

totimmi = filter census by (Citizenship == ' Foreign born- Not a citizen of U S ') OR (Citizenship == ' Foreign born- U S citizen by naturalization');

immigrants = foreach (group totimmi all) generate COUNT(totimmi) as immigrants; -------199------

age = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/agegroup' using PigStorage('\t') as (Age: int, Agegroup:chararray);

joinage = join census by Age, age by Age;

joinedbag = foreach joinage generate $0,$11 as Agegroup,$1,$2,$3,$4,$5 as Income,$6,$7,$8 as Citizenship,$9;

ordercensus = order joinedbag by Income asc;

medianincome = foreach (group ordercensus all) generate FLATTEN(Median(ordercensus.Income)) as Median;

poverty = filter ordercensus by (Income<(medianincome.Median*0.60));

totalpoverty = foreach (group poverty all) generate COUNT(poverty) as tot_poverty;  ------402-------

            -- POVERTY IMMIGRANT--
immipov = filter poverty by (Citizenship == ' Foreign born- Not a citizen of U S ') OR (Citizenship == ' Foreign born- U S citizen by naturalization');

immipovcount = foreach (group immipov all) generate COUNT(immipov) as immigrant_poverty;  -----48--------

--nativepov = cogroup totalpoverty by tot_poverty, immipovcount by immigrant_poverty;

--nativecount = foreach nativepov generate $0;

--natcount = foreach nativecount generate (totalpoverty.tot_poverty - immipovcount.immigrant_poverty); 

--nativepoverty = limit natcount 1; --------*354*----------

joinbags = cogroup total by total, immigrants by immigrants, totalpoverty by tot_poverty, immipovcount by immigrant_poverty;
--describe joinbags;
--joibag = foreach joinbags generate $0;
--con = foreach joibag generate CONCAT(total.total, immigrants.immigrants, totalpoverty.tot_poverty, immipovcount.immigrant_poverty);
bagcon = foreach joinbags generate BagConcat(total,immigrants,totalpoverty,immipovcount);

re = foreach bagcon generate total.total, immigrants.immigrants, (total.total - immigrants.immigrants), totalpoverty.tot_poverty,  immipovcount.immigrant_poverty, (totalpoverty.tot_poverty - immipovcount.immigrant_poverty);
dump re;
--dump con;































