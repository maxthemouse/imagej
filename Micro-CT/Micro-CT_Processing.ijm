// This macro performs dark and flat field corrections on CT projection files.
// Authors: David Cooper, M. Adam Webb

macro"SR Micro-CT Correction"{
    requires("1.43n");

// pad to 4 digits
function pad(num) {
	lead = "";
	if (num < 1000) {
		lead = "0";
	}
	if (num < 100) {
		lead = "00";
	}
	if (num < 10) {
		lead = "000";
	}
	text = lead+num;
	return text;
}

//////////////////////Global Variable Defaults



var Stackmin=-0.25;
var Stackmax=1.25;
var LogFile=true;
var Prefix="proj";

var Scanner="CLS_BMIT_05BM_1";
var OpticalAxis=1; /// needs to be set to 1/2 image height
var ObjectSourceDistance=20000; ///units of mm, set for BMIT BM line, >10 SkyScan assumes //
var ProjectionNumber=1800;  //needs to be linked to sub sampled number for tif output
var RowNumber=1000;	//image height
var ColumnNumber=1000; //Image width
//var PixelSize=8.75;  //units of microns
var PixelSize=100;  //units of microns for flat panel
var ExposureTime=6.66; //units of milliseconds
var RotationStep=0.1  //should be linked to 180/projectionNumber....


getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
//TimeString=" "+dayOfMonth+"/"+month+"/"+year;
TimeString="this is a test";

// sets intel byte order output
run("Input/Output...", "jpeg=75 gif=-1 file=.txt save copy_row save_column save_row");





setBatchMode(false);

////////////////////////////////////////////////////////////Dark
    Darkdir = getDirectory("Choose DarkField Directory ");
    Darklist = getFileList(Darkdir);
    setOption("display labels", true);
    Darkpath = Darkdir+Darklist[0];
    DarkOpenpath="open=["+Darkpath+"]";
    DarkFileCount=lengthOf(Darklist);

// run("Image Sequence...", DarkOpenpath+" number="+DarkFileCount+" starting=1 increment=1 scale=100 file=[] or=[] sort");

// load one at a time to get around bug in sequence loading for 12 bit files

NewIndex=0;////renumbering index to reduce to 4 numerical characters for SKYSCAN

 for (i=0; i<DarkFileCount; i++) {  /////////loop for loading the individual files from the selected folder
	SingleFilePath = Darkdir+Darklist[i];
	open(SingleFilePath);
	rename("Temp_Dark_" + pad(i));
	}//end for loop
	
run("Images to Stack", "name=[Raw Dark Fields] title=[Temp_Dark_] use");
	
// rename("Raw Dark Fields");

run("Z Project...", "start=1 stop="+DarkFileCount+" projection=[Average Intensity]");
rename("Average Dark Field");

selectWindow("Raw Dark Fields");
close();

////////////////////////////////////////////////////////////Flat

    Flatdir = getDirectory("Choose FlatField Directory ");
    Flatlist = getFileList(Flatdir);
    setOption("display labels", true);
    Flatpath = Flatdir+Flatlist[0];
    FlatOpenpath="open=["+Flatpath+"]";
    FlatFileCount=lengthOf(Flatlist);


// run("Image Sequence...", FlatOpenpath+" number="+FlatFileCount+" starting=1 increment=1 scale=100 file=[] or=[] sort");

// load one at a time to get around bug in sequence loading for 12 bit files

NewIndex=0;////renumbering index to reduce to 4 numerical characters for SKYSCAN

 for (i=0; i<FlatFileCount; i++) {  /////////loop for loading the individual files from the selected folder
	SingleFilePath = Flatdir+Flatlist[i];
	open(SingleFilePath);
	rename("Temp_Flat_" + pad(i));
	}//end for loop
	
run("Images to Stack", "name=[Raw Flat Fields] title=[Temp_Flat_] use");

// rename("Raw Flat Fields");

run("Z Project...", "start=1 stop="+FlatFileCount+" projection=[Average Intensity]");
rename("Average Flat Field");
//imageCalculator("Subtract", "Average Flat Field","Average Dark Field");//////REMOVED AS I THINK TWO CORRECTIONS WERE OCCURRING...

selectWindow("Raw Flat Fields");
close();

imageCalculator("Subtract create 32-bit", "Average Flat Field","Average Dark Field");
rename("Dark Corrected Average Flat Field");

selectWindow("Average Flat Field");
close();

////////////////////////////////////////////////////////////Data Projections

    Datadir = getDirectory("Choose Data Projections Directory ");
    Datalist = getFileList(Datadir);
	Datalist = Array.sort(Datalist);
    setOption("display labels", true);
    Datapath = Datadir+Datalist[0];
    DataOpenpath="open=["+Datapath+"]";
    DataFileCount=lengthOf(Datalist);


///////////////////////////////////////////////////save directory

Savepath=Datadir+"\\Corrected";
File.makeDirectory(Savepath);


Dialog.create("Options");

Dialog.addString("File Prefix", "SampleX");
Dialog.addNumber("Set Maximum Value", Stackmax);
Dialog.addNumber("Set Minimum Value", Stackmin);
Dialog.addCheckbox("Output SkyScan Log File", true);
Dialog.addCheckbox("Projection at 180 degrees", true);



Dialog.show();
Prefix=Dialog.getString();
Stackmax=Dialog.getNumber();
Stackmin=Dialog.getNumber();
LogFile=Dialog.getCheckbox();
Proj180=Dialog.getCheckbox();






if(LogFile==true){

TestFilePath = Datadir+Datalist[0];
open(TestFilePath);
getDimensions(width, height, channels, slices, frames);
close();



OpticalAxis=round(height/2);
ProjectionNumber=DataFileCount;

if (Proj180) {
	RotationStep=180/(ProjectionNumber - 1);
} else {
	RotationStep=180/ProjectionNumber;
}



Dialog.create("Log File Parameters");
Dialog.addMessage("Assumes 180 degree rotation");
Dialog.addString("Scanner", Scanner);
Dialog.addNumber("Optical Axis/Mid Slice", OpticalAxis);
Dialog.addNumber("Detector-source Distance (mm)", 26000);
Dialog.addNumber("Number of Projections", ProjectionNumber);
Dialog.addNumber("Row Number (height in pixels)", height);
Dialog.addNumber("Column Number (width in pixels)", width);
Dialog.addNumber("Pixel Size (um)", PixelSize);

//Dialog.addNumber("Exposure Time (ms)", ExposureTime);
  ///not necessary
Dialog.addNumber("Rotation Step (degrees)", RotationStep);


Dialog.show();
Scanner=Dialog.getString();
OpticalAxis=Dialog.getNumber();
ObjectSourceDistance=Dialog.getNumber();
ProjectionNumber=Dialog.getNumber();
RowNumber=Dialog.getNumber();
ColumnNumber=Dialog.getNumber();
PixelSize=Dialog.getNumber();
//ExposureTime=Dialog.getNumber(); ////not necessary
RotationStep=Dialog.getNumber();


LogFilePath=Savepath+"\\"+Prefix+"_.log";



LogFileString="# Begin of log file ########################################################################\r\n[System]\r\nScanner="+Scanner+"\r\nInstrument S/N=2\r\n[Acquisition]\r\nOptical Axis (line)="+OpticalAxis+"\r\nObject to Source (mm)="+ObjectSourceDistance+"\r\nNumber Of Files= "+ProjectionNumber+"\r\nNumber Of Rows= "+RowNumber+"\r\nNumber Of Columns= "+ColumnNumber+"\r\nImage Pixel Size (um)="+PixelSize+"\r\nLinear pixel value=0\r\nScaled Image Pixel Size (um)="+PixelSize+"\r\nExposure (ms)="+ExposureTime+"\r\nRotation Step (deg)="+RotationStep+"\r\nTable Feed (micron)=0.0\r\nUse 360 Rotation=NO\r\nFlat Field Correction=ON\r\nRotation Direction=CC\r\nType of Detector Motion=STEP AND SHOOT\r\nScanning Trajectory=ROUND\r\nStudy Date and Time="+TimeString+"\r\n# End of log file ########################################################################\r\n";


//print(LogFileString);

File.saveString(LogFileString, LogFilePath)
;



}//end logfile if statment


///////////////////////////////////////////////////correction

start = getTime();

NewIndex=0;////renumbering index to reduce to 4 numerical characters for SKYSCAN, max of 10,000 projections in this version....

 for (i=0; i<DataFileCount; i++) {  /////////loop for loading the individual files from the selected folder
	SingleFilePath = Datadir+Datalist[i];
	open(SingleFilePath);
	rename("Current Image");

	imageCalculator("Subtract create 32-bit", "Current Image","Average Dark Field");
	rename("Dark Corrected Image");
	imageCalculator("Divide create 32-bit", "Dark Corrected Image","Dark Corrected Average Flat Field");
	run("Remove NaNs...", "radius=2");


	setMinAndMax(Stackmin, Stackmax);
	run("16-bit");


	if(i>0){
		NewIndex=NewIndex+1;
		}

	SavePathFile=Savepath+"\\"+Prefix+"_"+pad(NewIndex);   //+".tif";
	saveAs("Tiff", SavePathFile);

	//saveAs("Tiff", Savepath+"\\"+Datalist[i]);
	close();


	selectWindow("Current Image");
	close();
	selectWindow("Dark Corrected Image");
	close();

	showProgress(i/DataFileCount);


}//end for loop

end = getTime();
timeDiff = (end - start) / 1000;
showStatus("Processed " + DataFileCount + " files in " + timeDiff + " seconds");




}//end macro


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


