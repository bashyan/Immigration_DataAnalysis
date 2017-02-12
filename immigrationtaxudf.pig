register '/home/bashyan-ubuntu/Downloads/datafu-1.2.0/datafu-1.2.0.jar';

define Median datafu.pig.stats.Median();

census = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/part-m-00000' using PigStorage(',') as (Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income:double,Parents:chararray,
CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int);

age = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/agegroup' using PigStorage('\t') as (Age: int, Agegroup:chararray);

joinage = join census by Age, age by Age;

joinedbag = foreach joinage generate $0,$11 as Agegroup,$1,$2,$3,$4,$5 as Income,$6,$7,$8 as Citizenship,$9;

ordercensus = order joinedbag by Income asc;

medianincome = foreach (group ordercensus all) generate FLATTEN(Median(ordercensus.Income)) as Median;

--describe medianincome;
--dump medianincome;

poverty = filter ordercensus by (Income<(medianincome.Median*0.60));
--dump poverty;
--describe poverty;
totalpoverty = foreach (group poverty all) generate COUNT(poverty) as tot_poverty;  ------402-------
--dump totalpoverty;

            -- POVERTY IMMIGRANT--
immipov = filter poverty by (Citizenship == ' Foreign born- Not a citizen of U S ') OR (Citizenship == ' Foreign born- U S citizen by naturalization');

immipovcount = foreach (group immipov all) generate COUNT(immipov) as immigrant_poverty;  -----48--------

nativepov = cogroup totalpoverty by tot_poverty, immipovcount by immigrant_poverty;

nativepovcount = foreach nativepov generate SUBTRACT(tot_poverty, immigrant_poverty);
dump nativepovcount;




