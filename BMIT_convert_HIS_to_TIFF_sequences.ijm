//This macro converts CT scans saved in HIS format to sequences of TIFF files (sorted into numbered folders, each of which contains flat, dark, and tomo subdirectories.
//This macro assumes that the HIS files have been produced form BMIT's on-the-fly image program.
//Author: Toby Bond (2018)

//
//Helper functions
//

// return a string with the input integer padded to three digits
function pad3(num) {
	lead = "";
	if (num < 100) {
		lead = "0";
	}
	if (num < 10) {
		lead = "00";
	}
	text = lead+num;
	return text;
}

//return the number of filenames contained in the array "Files" which end with the string "SubString"
function numFilesEndingWith(Files, SubString) {
	numMatches = 0;
	for (i=0; i<lengthOf(Files); i++) {
		if(endsWith(Files[i], SubString)) {
			numMatches++;
		}
	}

	return numMatches;
}

//return the number of filenames contained in the array "Files" which begin with the string "SubString"
function numFilesStartingWith(Files, SubString) {
	numMatches = 0;
	for (i=0; i<lengthOf(Files); i++) {
		if(startsWith(Files[i], SubString)) {
			numMatches++;
		}
	}

	return numMatches;
}


//
//Main body of macro
//

//Prompt user for directory containing series of HIS files
RootDir = getDirectory("Choose directory containing HIS files ");
FileList = getFileList(RootDir);
setOption("display labels", true);
FileCount=lengthOf(FileList);
numDatasets = numFilesStartingWith(FileList, "Image");


//Create directory structure
for (i=0; i<numDatasets; i++) {

	File.makeDirectory(RootDir+pad3(i));
	File.makeDirectory(RootDir+pad3(i)+"\\dark");
	File.makeDirectory(RootDir+pad3(i)+"\\flat");		
	File.makeDirectory(RootDir+pad3(i)+"\\tomo");		
}

//Cycle through all numbered scans and convert HIS files into TIFF sequences (populating each numbered scan's dark, flat, and tomo directories).
for (i=0; i<numDatasets; i++) {

	//Convert darks to sequence(s) (any file starting with "Dark" and ending in ".his")
	for (j=0; j<FileCount; j++) {
		
		if (startsWith(FileList[j], "Dark") && endsWith(FileList[j], i+".his")) {
			run("Bio-Formats Importer", "open=["+RootDir+FileList[j]+"] autoscale color_mode=Default concatenate_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_list=1-100000");
			run("Image Sequence... ", "format=TIFF name="+substring(FileList[j], 0, 11)+" save=["+RootDir+pad3(i)+"\\dark]");
			close();
		}
	}

	//Convert flats to sequence(s) (any file starting with "Flat" and ending in ".his")
	for (j=0; j<FileCount; j++) {
		
		if (startsWith(FileList[j], "Flat") && endsWith(FileList[j], i+".his")) {
			run("Bio-Formats Importer", "open=["+RootDir+FileList[j]+"] autoscale color_mode=Default concatenate_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_list=1-100000");
			run("Image Sequence... ", "format=TIFF name="+substring(FileList[j], 0, 11)+" save=["+RootDir+pad3(i)+"\\flat]");
			close();
		}
	}

	//Convert projections to sequence (any file starting with "Image" and ending in ".his")
	for (j=0; j<FileCount; j++) {
		
		if (startsWith(FileList[j], "Image") && endsWith(FileList[j], i+".his")) {
			run("Bio-Formats Importer", "open=["+RootDir+FileList[j]+"] autoscale color_mode=Default concatenate_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_list=1-100000");
			run("Image Sequence... ", "format=TIFF name="+substring(FileList[j], 0, 6)+" save=["+RootDir+pad3(i)+"\\tomo]");
			close();
		}
	}
}

//
//End of macro
//
