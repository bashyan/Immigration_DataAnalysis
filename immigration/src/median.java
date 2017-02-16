import java.io.IOException;   
import java.util.ArrayList;
import java.util.Collections;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.conf.Configuration;
//import org.apache.hadoop.mapreduce.Reducer.Context;
//import org.apache.hadoop.mapreduce.lib.input.MultipleInputs;
//import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class median
{
	public static class medianMapper extends Mapper<LongWritable, Text, Text, Text> 
	{
		ArrayList<Double> incomeAll = new ArrayList<Double>();
		/*int i = -1, j = -1, k = -1;
		double[] incomeAll = null;
		double[] incomeForeign = null;
		double[] incomeNative = null;
		double allmedian = 0;
		double foreignmedian = 0;
		double nativemedian = 0;*/
		public void map(LongWritable key, Text value, Context context)throws IOException, InterruptedException 
		{
			String[] line = value.toString().split(",");
			//String citizen = line[9];
			double tax = (Double.parseDouble(line[6]));
			incomeAll.add(tax);
			
			
				Collections.sort(incomeAll);
				context.write(null, new Text(Double.toString(tax)));
				
				/*double med = 0;
				int s = incomeAll.size();
				if(s % 2 == 0)
				{
					med = (incomeAll.get(s/2) + incomeAll.get(s/2 - 1))/2;
				}
				else
				{
					med = incomeAll.get(s/2);
				}*/
				
			
			
		}
			
				
			/*{
				k++;
				incomeAll[k] = income;
			}*/
			/*if(citizen.contains(" Foreign"))
			{				
				i++;
				incomeForeign[i] = income;	//populate immigrant income
			}
			else if(citizen.contains(" Native"))
			{				
				j++;
				incomeNative[j] = income;	//populate native income
			}
			if(i+j+1 == rowno)
			{
				Arrays.sort(incomeAll);		//sort ascending
				Arrays.sort(incomeForeign);
				Arrays.sort(incomeNative);
				//Find over all Median Income				
				{
					if (incomeAll.length % 2 == 0)
					{
						allmedian = (incomeAll[incomeAll.length/2] + incomeAll[incomeAll.length/2 - 1])/2;
					}				    
					else
					{
						allmedian = incomeAll[incomeAll.length/2];
					}					
				}
				//Find Foreign Median Income
				{
					if (incomeForeign.length % 2 == 0)
					{
						foreignmedian = (incomeForeign[incomeForeign.length/2] + incomeForeign[incomeForeign.length/2 - 1])/2;
					}				    
					else
					{
						foreignmedian = incomeForeign[incomeForeign.length/2];
					}
				}
				//Find Native Median Income
				{
					if (incomeNative.length % 2 == 0)
					{
						nativemedian = (incomeNative[incomeNative.length/2] + incomeNative[incomeNative.length/2 - 1])/2;
					}				    
					else
					{
						nativemedian = incomeNative[incomeNative.length/2];
					}
				}
				String write = "All-"+Double.toString(allmedian)+"\t"+"Immigrant-"+
								Double.toString(foreignmedian)+"\t"+"Native-"+Double.toString(nativemedian);
				
				//context.write(null, new Text("Median\t"+write));
			}
			
		}*/
	}
	
	public static class banReducer extends Reducer<LongWritable, Text, LongWritable, Text> 
	{
		public void reduce(LongWritable key, Iterable<Text> values, Context context)throws IOException, InterruptedException 
		{
			double tax = 0;
			double medi = 0;
			for (Text like : values) 
			{
				String parts[] = like.toString().split("\t");
				if (parts[0].equals("Tax")) 
				{
					String rows[] = parts[1].split(",");
					tax += Double.parseDouble(rows[6]);
				} 
				else if (parts[0].equals("Median")) 
				{
					medi = Double.parseDouble(parts[1]);
				}
				
			}
			
			String result = "Total Tax : "+tax+"\tMedianIncome : "+medi;
			context.write(null, new Text(result));
		}
	}
	
	public static void main(String[] args) throws Exception 
	{		
		Configuration conf = new Configuration();
		conf.set("mapred.textoutputformat.separator", ",");
		Job job = Job.getInstance(conf);
	    job.setJarByClass(immigrantban.class);
	    job.setJobName("Immigrant Ban");
	    job.setMapperClass(medianMapper.class);
		job.setReducerClass(banReducer.class);
	    //job.setNumReduceTasks(0);
		job.setOutputKeyClass(LongWritable.class);
		job.setOutputValueClass(Text.class);				
	    FileOutputFormat.setOutputPath(job, new Path(args[1]));
	    System.exit(job.waitForCompletion(true) ? 0 : 1);		
	}	
}

