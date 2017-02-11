
--Load JSON File

--loadjson = load '/home/bashyan-ubuntu/Documents/censusproject/Censusdata/sample' using 
--JsonLoader('Age: int,Education:chararray,MaritalStatus:chararray,Gender:chararray,TaxFilerStatus:chararray,Income: ----double,Parents:chararray,CountryOfBirth:chararray, Citizenship:chararray, WeeksWorked: int');

--Convert to CSV

--store loadjson into '/home/hduser/Documents/censusmapoutput' using org.apache.pig.piggybank.storage.CSVExcelStorage();


A = LOAD 'age' USING HCatLoader();
dump A;
