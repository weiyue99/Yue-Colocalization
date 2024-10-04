csvPath = File.openDialog("Select CSV file with Z-slice information");
inputDir = getDirectory("Select folder containing TIFF files");
outputDir = inputDir + "subhyperstacks" + File.separator;
File.makeDirectory(outputDir);
csvContent = File.openAsString(csvPath);
lines = split(csvContent, "\n");
imageNames = newArray();
startSlices = newArray();
endSlices = newArray();
for (i = 1; i < lines.length; i++) {
    tokens = split(lines[i], ",");
    imageNames = Array.concat(imageNames, replace(tokens[0], "C2-", ""));
    startSlices = Array.concat(startSlices, parseInt(tokens[1]));
    endSlices = Array.concat(endSlices, parseInt(tokens[2]));
}
for (i = 0; i < imageNames.length; i++) {
    open(inputDir + imageNames[i]);
    run("Make Substack...", "channels=2-3 slices=" + startSlices[i] + "-" + endSlices[i]);
    saveAs("Tiff", outputDir + imageNames[i] + "_subhyperstack.tif");
    close("*");
    run("Collect Garbage");
}
print("Processing completed.");
