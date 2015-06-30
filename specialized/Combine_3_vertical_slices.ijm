//Macro for combining different vertical views and output a 32 bit tiff results in folder named "Results"
   //Before running:
      //1. create a folder called "Combine";
      //2. move all three view slices into Combine folder;
      //3. rename these three folder names to "1", "2", and "3";
      //4. make sure having alll parameters for croping (choose a ROI) and stitching, then modifiy this Macro,

  //After running:
     //1. manually crop the ROI;
     //2. based on the best image contrast in the ROI area, convert the results to 8 bit tiff files.

rawdatadir=getDirectory("Choose Raw Data Directory"); 
pathsliceone=rawdatadir+"\\1";
pathslicetwo=rawdatadir+"\\2";
pathslicethree=rawdatadir+"\\3";
savepath=rawdatadir+"\\Results";
File.makeDirectory(savepath);

////Working on view1;
run("Image Sequence...", "open=pathsliceone");
makeRectangle(2, 0, 3998, 3995); ///Align this image sequence;
run("Crop");
//run("Rotate... ", "angle=55 grid=1 interpolation=Bilinear stack");
//makeRectangle(936, 980, 772, 1652);////get ROI;
//run("Crop");
run("Image Sequence... ", "format=TIFF name=slice_ save=[savepath]");
close();

////Working on view2;
run("Image Sequence...", "open=pathslicetwo");
makeRectangle(1, 3, 3998, 3995); ///Align this image sequence;
run("Crop");
//run("Rotate... ", "angle=55 grid=1 interpolation=Bilinear stack");
//makeRectangle(936, 980, 772, 1652); ////get ROI;
//run("Crop");
run("Image Sequence... ", "format=TIFF name=slice_ start=489 save=[savepath]");
close();

////Working on view3;
run("Image Sequence...", "open=pathslicethree");
makeRectangle(0, 5, 3998, 3995); ///Align this image sequence;
run("Crop");
//run("Rotate... ", "angle=55 grid=1 interpolation=Bilinear stack");
//makeRectangle(936, 980, 772, 1652); ////get ROI;
//run("Crop");
run("Image Sequence... ", "format=TIFF name=slice_ start=970 save=[savepath]");
close();

run("Image Sequence...", "open=savepath");

