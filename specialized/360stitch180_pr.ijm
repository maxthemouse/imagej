//Macro for stitch 360 scan results to 180 projections used for PITRE or XTRACT.
macro "360stitch180PR, ver2.1" {//Correct one error in version 2.0, 2015-10-20

Dialog.create("Before runing this macro:"); 
Dialog.addMessage("1. Make sure you already have four folders (Dark, Flat, Tomo, Stitching) with images;");
Dialog.addMessage("2. Make sure the cropped area is at left side of the image;");
Dialog.addMessage("3. Make sure there are three images (tile_01.tif, tile_02.tif, Combination.tif) in the folder 'Stitching';");
Dialog.addMessage(" ");
Dialog.addNumber("Total number of projections:", 6000);
Dialog.show(); 
nproj = Dialog.getNumber()/2;
nproj2 = nproj+1;

rawdatadir=getDirectory("Choose Raw Data Directory"); 
darkpath=rawdatadir+"\\Dark";
flatpath=rawdatadir+"\\Flat";
tomopath=rawdatadir+"\\Tomo";
savepath=rawdatadir+"\\Combination";
stitchpath=rawdatadir+"\\Stitching";
File.makeDirectory(savepath);

setBatchMode(true);

//Read the size of the combination image after stitching;
run("Image Sequence...", "open=stitchpath file=ombi sort");
comcolumnpixels=getWidth();
comrowpixels=getHeight();

//Read the size of the combination image after stitching;
run("Image Sequence...", "open=stitchpath file=tile_01 sort");
tilecolumnpixels=getWidth();
tilerowpixels=getHeight();

//Size of the croped image;
cropcollumnpixels=round((tilecolumnpixels+tilecolumnpixels-comcolumnpixels)/2);
croprowpixels=floor((comrowpixels-tilerowpixels)/2);


run("Image Sequence...", "open=tomopath number=1 sort");
tomocolumnpixels=getWidth();
tomorowpixels=getHeight();
finalwidth=tomocolumnpixels-cropcollumnpixels;
finalheight=tomorowpixels-croprowpixels;
close();

//Stitch Dark images
run("Image Sequence...", "open=darkpath");
makeRectangle(cropcollumnpixels, croprowpixels, finalwidth, finalheight);
run("Crop");
rename("1");
run("Flip Horizontally", "stack");
run("Image Sequence...", "open=darkpath");
makeRectangle(cropcollumnpixels, 0, finalwidth, finalheight);
run("Crop");
rename("2");
run("Combine...", "stack1=1 stack2=2");
//save the result
run("Image Sequence... ", "format=TIFF name=dark_ save=[savepath]");
close();

//Stitch Flat images
run("Image Sequence...", "open=flatpath");
makeRectangle(cropcollumnpixels, croprowpixels, finalwidth, finalheight);
run("Crop");
run("Flip Horizontally", "stack");
rename("1");
run("Image Sequence...", "open=flatpath");
makeRectangle(cropcollumnpixels, 0, finalwidth, finalheight);
run("Crop");
rename("2");
run("Combine...", "stack1=1 stack2=2");
//save the result
run("Image Sequence... ", "format=TIFF name=flat_ save=[savepath]");
close();

//Stitch Tomo images
run("Image Sequence...", "open=tomopath number=nproj  sort");
makeRectangle(cropcollumnpixels, croprowpixels, finalwidth, finalheight);
run("Crop");
rename("1");
run("Flip Horizontally", "stack");
run("Image Sequence...", "open=tomopath number=nproj starting=nproj2 sort");
makeRectangle(cropcollumnpixels, 0, finalwidth, finalheight);
run("Crop");
rename("2");
run("Combine...", "stack1=1 stack2=2");
//save the result
run("Image Sequence... ", "format=TIFF name=tomo_ save=[savepath]");
close();

waitForUser("It is done.");
}
