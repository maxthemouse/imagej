// This macro performs dark and flat field corrections on CT projection (cxd) files using default values.  

macro"SR Micro-CT Correction - APS 2012 Edition"{
    requires("1.43n");

////////Version V2.2.1simple by Ning Zhu

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
var PixelSize=8.75;  //units of microns
//var PixelSize=100;  //units of microns for flat panel
var ExposureTime=6.66; //units of milliseconds
var RotationStep=0.1  //should be linked to 180/projectionNumber....


getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
//TimeString=" "+dayOfMonth+"/"+month+"/"+year;
TimeString="this is a test";

// sets intel byte order output
run("Input/Output...", "jpeg=75 gif=-1 file=.txt save copy_row save_column save_row");


/////////////////////////////////////////////////////////////////////////////////////////////////Convert .cxd files for Nrecon
rawdatadir=getDirectory("Choose Raw Data Directory"); 

PixelSize=getNumber("pixelsize (micron)", PixelSize);

darkbepath=rawdatadir+"dark_before.cxd";
darkafpath=rawdatadir+"dark_after.cxd";
flatbepath=rawdatadir+"flat_before.cxd";
flatafpath=rawdatadir+"flat_after.cxd";
tomopath=rawdatadir+"tomo.cxd";

savetomopath=rawdatadir+"\\Tomo";
File.makeDirectory(savetomopath);
savedarkpath=rawdatadir+"\\Dark";
File.makeDirectory(savedarkpath);
saveflatpath=rawdatadir+"\\Flat";
File.makeDirectory(saveflatpath);

run("Bio-Formats", "open=[darkbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=dark_ save=[savedarkpath]");
run("Close");

run("Bio-Formats", "open=[darkafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=dark_ start=10 save=[savedarkpath]");
run("Close");

run("Bio-Formats", "open=[flatbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=flat_ save=[saveflatpath]");
run("Close");

run("Bio-Formats", "open=[flatafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=flat_ start=10 save=[saveflatpath]");
run("Close");

run("Bio-Formats", "open=[tomopath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=tomo_ save=[savetomopath]");
run("Close");

//////////////////////convert end


setBatchMode(true);

////////////////////////////////////////////////////////////Dark 
    Darkdir =rawdatadir+"\\Dark\\";
    Darklist = getFileList(Darkdir);
    setOption("display labels", true);
    Darkpath = Darkdir+Darklist[0];
    DarkOpenpath="open=["+Darkpath+"]";
    DarkFileCount=lengthOf(Darklist);    

run("Image Sequence...", DarkOpenpath+" number="+DarkFileCount+" starting=1 increment=1 scale=100 file=[] or=[] sort");
rename("Raw Dark Fields");

run("Z Project...", "start=1 stop="+DarkFileCount+" projection=[Average Intensity]");
rename("Average Dark Field");

selectWindow("Raw Dark Fields");
close();

////////////////////////////////////////////////////////////Flat

    Flatdir = rawdatadir+"\\Flat\\";
    Flatlist = getFileList(Flatdir);
    setOption("display labels", true);
    Flatpath = Flatdir+Flatlist[0];
    FlatOpenpath="open=["+Flatpath+"]";
    FlatFileCount=lengthOf(Flatlist);
    

run("Image Sequence...", FlatOpenpath+" number="+FlatFileCount+" starting=1 increment=1 scale=100 file=[] or=[] sort");

rename("Raw Flat Fields");



run("Z Project...", "start=1 stop="+FlatFileCount+" projection=[Average Intensity]");
rename("Average Flat Field");
//imageCalculator("Subtract", "Average Flat Field","Average Dark Field");//////REMOVED AS I THINK TWO CORRECTIONS WERE OCCURRING...

selectWindow("Raw Flat Fields");
close();

imageCalculator("Subtract create", "Average Flat Field","Average Dark Field");
rename("Dark Corrected Average Flat Field");

selectWindow("Average Flat Field");
close();

////////////////////////////////////////////////////////////Data Projections

    Datadir = rawdatadir+"\\Tomo\\";
    Datalist = getFileList(Datadir);
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



//Dialog.show();
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


//Dialog.show();
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

NewIndex=0;////renumbering index to reduce to 4 numerical characters for SKYSCAN

 for (i=0; i<DataFileCount; i++) {  /////////loop for loading the individual files from the selected folder
	SingleFilePath = Datadir+Datalist[i];
	open(SingleFilePath);
	
	imageCalculator("Subtract", Datalist[i],"Average Dark Field");
	imageCalculator("Divide create 32-bit", Datalist[i],"Dark Corrected Average Flat Field");


	setMinAndMax(Stackmin, Stackmax);
	run("16-bit");


	if(i>0){
		NewIndex=NewIndex+1;
		}

	///determine indexing number //max of 10,000 projections in this version....
	
	if (NewIndex>=0 && NewIndex<10){
	IndexNumber="000"+NewIndex;
	}
	if (NewIndex>=10 && NewIndex<100){
	IndexNumber="00"+NewIndex;
	}
	if (NewIndex>=100 && NewIndex<1000){
	IndexNumber="0"+NewIndex;
	}
	if (NewIndex>=1000 && NewIndex<10000){
	IndexNumber=NewIndex;
	}


	SaveName=Prefix+"_"+IndexNumber;	
	SavePathFile=Savepath+"\\"+SaveName;   //+".tif";
	saveAs("Tiff", SavePathFile);

	//saveAs("Tiff", Savepath+"\\"+Datalist[i]);	
	close();


	selectWindow(Datalist[i]);
	close();

	showProgress(i/DataFileCount);


}//end for loop


waitForUser("It is done.");
	
}//end macro


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


