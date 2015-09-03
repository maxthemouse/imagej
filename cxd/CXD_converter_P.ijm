//Macro for convert .cxd files from CT raw data to the TIFF fiels ready for Xtract or PITRE programs.
macro "CXD CT data converter for Xtract/PITRE, ver1.3" {


Dialog.create("Before runing this macro:"); 
Dialog.addMessage("How many CXD files?");
Dialog.addMessage("1. Please enter '5', if you have dark_before, dark_after, flat_before, flat_after, and tomo;");
Dialog.addMessage("2. Please enter '3', if you have dark, flat, and tomo;");
//Dialog.addMessage(" ");
Dialog.addNumber("Number of CXD files:", 5);
Dialog.show(); 
ncxd= Dialog.getNumber();

if(ncxd==5) {

    rawdatadir=getDirectory("Choose Raw Data Directory"); 
    darkbepath=rawdatadir+"dark_before.cxd";
    darkafpath=rawdatadir+"dark_after.cxd";
    flatbepath=rawdatadir+"flat_before.cxd";
    flatafpath=rawdatadir+"flat_after.cxd";
    tomopath=rawdatadir+"tomo.cxd";

    savepath=rawdatadir+"\\Tomo";
    File.makeDirectory(savepath);

    run("Bio-Formats", "open=[darkbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=dark_ save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[darkafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=dark_ start=10 save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[flatbepath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=flat_ save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[flatafpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=flat_ start=10 save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[tomopath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=tomo_ save=[savepath]");
    run("Close All");
    waitForUser("It is done.");

} else {

    rawdatadir=getDirectory("Choose Raw Data Directory"); 
    darkpath=rawdatadir+"dark.cxd";
    flatpath=rawdatadir+"flat.cxd";
    tomopath=rawdatadir+"tomo.cxd";

    savepath=rawdatadir+"\\Tomo";
    File.makeDirectory(savepath);

    run("Bio-Formats", "open=[darkpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=dark_ save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[flatpath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=flat_ save=[savepath]");
    run("Close");

    run("Bio-Formats", "open=[tomopath]" + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT" use_virtual_stack");
    run("Image Sequence... ", "format=TIFF name=tomo_ save=[savepath]");
    run("Close All");
    waitForUser("It is done.");
    }
}
