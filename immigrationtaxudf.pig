register '/home/bashyan-ubuntu/Downloads/datafu-1.2.0/datafu-1.2.0.jar';

define Median datafu.pig.stats.Median();

census = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/part-m-00000' using PigStorage(',') as (Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income:double,Parents:chararray,
CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int);

age = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/agegroup' using PigStorage('\t') as (Age: int, Agegroup:chararray);

joinage = join census by Age, age by Age;

joinedbag = foreach joinage generate $0,$11 as Agegroup,$1,$2,$3,$4,$5 as Income,$6,$7,$8,$9;

ordercensus = order joinedbag by Income asc;

medianincome = foreach (group ordercensus all) generate FLATTEN(Median(ordercensus.Income)) as Median;

--describe medianincome;
--dump medianincome;


poverty = filter ordercensus by (Income<(medianincome.Median*0.60));


dump poverty;




