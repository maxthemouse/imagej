//Macro to convert .cxd files from CT raw data to TIFF files ready for Xtract or PITRE programs.
//Authors: Ning Zhu
macro "CXD CT data converter for Xtract/PITRE, ver1.1" {

rawdatadir=getDirectory("Choose Raw Data Directory"); 
darkbepath=rawdatadir+"dark_before.cxd";
darkafpath=rawdatadir+"dark_after.cxd";
flatbepath=rawdatadir+"flat_before.cxd";
flatafpath=rawdatadir+"flat_after.cxd";
tomopath=rawdatadir+"tomo.cxd";

savepath=rawdatadir+"\\Tomo";
File.makeDirectory(savepath);

run("Bio-Formats", "open=[darkbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Image Sequence... ", "format=TIFF name=dark_ save=[savepath]");
//run("Close");

run("Bio-Formats", "open=[darkafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Image Sequence... ", "format=TIFF name=dark_ start=10 save=[savepath]");
///run("Close");

run("Bio-Formats", "open=[flatbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Image Sequence... ", "format=TIFF name=flat_ save=[savepath]");
///run("Close");

run("Bio-Formats", "open=[flatafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Image Sequence... ", "format=TIFF name=flat_ start=10 save=[savepath]");
///run("Close");

run("Bio-Formats", "open=[tomopath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Image Sequence... ", "format=TIFF name=tomo_ save=[savepath]");
run("Close All");

waitForUser("It is done.");
}
