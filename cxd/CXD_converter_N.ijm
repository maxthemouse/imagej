//Macro to convert .cxd files from CT raw data to TIFF files ready for Nrecon program.
//Authors: Ning Zhu
macro "CXD CT data converter for Nrecon, ver1.1" {

rawdatadir=getDirectory("Choose Raw Data Directory"); 
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
//run("Close");

run("Bio-Formats", "open=[darkafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=dark_ start=10 save=[savedarkpath]");
///run("Close");

run("Bio-Formats", "open=[flatbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=flat_ save=[saveflatpath]");
///run("Close");

run("Bio-Formats", "open=[flatafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=flat_ start=10 save=[saveflatpath]");
///run("Close");

run("Bio-Formats", "open=[tomopath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Image Sequence... ", "format=TIFF name=tomo_ save=[savetomopath]");
run("Close All");

waitForUser("It is done.");
}
