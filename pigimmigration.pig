
--Load JSON File

--loadjson = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/sample' using 
--JsonLoader('Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income: ----double,Parents:chararray,CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int');

--Convert to CSV

--store loadjson into '/home/hduser/Documents/censusmapoutput' using org.apache.pig.piggybank.storage.CSVExcelStorage();

census = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/samplecsv' using PigStorage(',') as (Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income:double,Parents:chararray,
CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int);

age = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/agegroup' using PigStorage('\t') as (Age: int, Agegroup:chararray);

joinage = join census by Age, age by Age;

joinedbag = foreach joinage generate $0,$11,$1,$2,$3,$4,$5,$6,$7,$8,$9;

taxfiler = filter joinedbag by ($5 != ' Nonfiler'); 

immigrants = filter taxfiler by($9 == ' Foreign born- Not a citizen of U S ');

--groupimmi = group immigrants all;

--countimmi = foreach groupimmi generate COUNT_STAR(immigrants);

groupcountry = group immigrants by $8; 

--dump groupcountry;

showcountry = foreach groupcountry generate $0, COUNT(immigrants.$8);

--dump showcountry;

ordercountry = order showcountry by $1 desc;

filtercountry = filter ordercountry by ($0 != ' ?');

dump filtercountry;












