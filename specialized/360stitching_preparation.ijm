//Macro for preparation of stitching projections. It will do background correction for the "tomo" images from one pair in 360d degree scan, then it will save all images in a folder for stitching by using the Macro "Stitching".;
//It also can be used for the purpose of background correction. Created on July 20, 2015;
macro "Projections Stitching preparation for 360 degree scan , ver 1.0" {
a=6000;
b=1;

Dialog.create("Projections Stitching preparation for 360 degree scan"); 
Dialog.addNumber("Total number of projections:", a);
Dialog.addNumber("Select a projection for stitching:", b);
Dialog.show(); 
a= Dialog.getNumber();
b= Dialog.getNumber();
c=a/2;

//waitForUser("print.");
rawdatadir=getDirectory("Choose Raw Data Directory"); 
darkpath=rawdatadir+"\\Dark";
flatpath=rawdatadir+"\\Flat";
tomopath=rawdatadir+"\\Tomo";
savepath=rawdatadir+"\\Stitching";
File.makeDirectory(savepath);

setBatchMode(true);

run("Image Sequence...", "open=darkpath number=1 file=dark sort");
rename("dark");
run("Image Sequence...", "open=flatpath number=1 file=flat sort");
rename("flat");
run("Image Sequence...", "open=tomopath number=2 starting=b increment=c sort");
rename("tomo");
imageCalculator("Subtract create 32-bit", "flat","dark");
rename("flat1");
imageCalculator("Subtract create 32-bit stack", "tomo","dark");
rename("tomo1");
imageCalculator("Divide create 32-bit stack", "tomo1","flat1");
run("Image Sequence... ", "format=TIFF name=tile_ start=1 digits=2 save=savepath");

waitForUser("It is done.");
}
