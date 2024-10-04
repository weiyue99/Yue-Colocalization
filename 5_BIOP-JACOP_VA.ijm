setBatchMode(true);

inputDir = getDirectory("Select 4_substack folder");
list = getFileList(inputDir);

resultsDir = inputDir +File.separator+"5_Final_Results";
File.makeDirectory(resultsDir);

for (i = 0; i < list.length; i++) {
	open(inputDir+list[i]);
	
	basename = list[i];
	basename_no_ext = File.getNameWithoutExtension(list[i]);

	run("BIOP JACoP", "channel_a=1 channel_b=2 threshold_for_channel_a=Otsu threshold_for_channel_b=Otsu manual_threshold_a=0 manual_threshold_b=0 set_auto_thresholds_on_stack_histogram get_manders get_fluorogram costes_block_size=5 costes_number_of_shuffling=100");
	selectWindow(basename+" Report");
	saveAs("Tiff", resultsDir+File.separator+basename_no_ext+" Report.tif");
	close("*");
}

saveAs("Results", resultsDir+File.separator+"FinalAnalysisResults.csv");
selectWindow("Log");
saveAs("Text", resultsDir+File.separator+"FinalAnalysisLog.txt");