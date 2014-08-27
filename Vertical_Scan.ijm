//Macro for making a vertical overall view of a sample.
// Authors: Ning Zhu

macro "Vertical Scan Image View" {

////////////////////////////////////////////////////////////////////////////Global setup;
pathflatimage=File.openDialog("Select a flat image");
pathdarkimage=File.openDialog("Select a dark image");
Imgdir=getDirectory("Choose Projections Directory");                                       ////////Get directory of projections;

pixelsize=8.7;
pixelsize=getNumber("pixelsize (micron)", pixelsize);
pixelsize=pixelsize*0.001;                                                                               //////switch to unit mm
                                                                  //////////////////////////Label each view;
setBatchMode(true);
//////////////////////////////////////////////////////////////////////////Projections processing;
open(pathflatimage);                                                                                     
singecolumnsize=getHeight();
singlerowsize=getWidth();
rename("flatimage");

open(pathdarkimage);                                                                                  
rename("darkimage");

imageCalculator("Subtrac createt", "flatimage","darkimage");
rename("Correctedflat");
//waitForUser("Pause", "Continue?");

Imglist=getFileList(Imgdir);
Imgcount=lengthOf(Imglist);

      for (i=0; i<Imgcount; i++) {                                                                         /////////loop for loading the individual files from the selected folder;
	Singleimgpath = Imgdir+Imglist[i];
	open(Singleimgpath);	
	imageCalculator("Subtract", Imglist[i],"darkimage");
	imageCalculator("Divide create 32-bit", Imglist[i],"Correctedflat");
            rename("correctedproj_"+i);
	run("16-bit");
       }                                                                        /////end loop;
run("Images to Stack", "name=ProjStack title=correctedproj_ use");
run("Make Montage...", "columns=1 rows="+Imgcount+" scale=1 first=1 last="+Imgcount+" increment=1 border=0 font=12");
rename("Vertical Scan");
setBatchMode(false);
/////selectWindow("Vertical Scan");

if(pixelsize==0){                                                    /////// No scales needed
exit();
}                                        

setColor(65535);
 if(pixelsize<0.012){                                             //////Change Font size based on difference detectors
     setFont("SansSerif", 48, "bold");      
  }else {
      setFont("SansSerif", 24, "bold");  
   }
       for(i=1; i<=Imgcount; i++){//loop for labeling each projection
         drawString("View "+i, singlerowsize-150, singecolumnsize*i);
       }                                                                           /////end loop;

////////////////////Draw scales (unit is mm);
columnpixels=getHeight();
rowpixels=getWidth();
 
i=0;                                                                               //////////minimum increment of the unit;
ix2=0;
pixelnum=0;                                                                  //////This is pixel numbers;
iinteger=0;
ix2integer=0;
unitmark=0;
vposition=columnpixels;

setLineWidth(2);
drawString("mm",160, columnpixels);

    for (a=1; pixelnum<columnpixels; a++) {
          if(i==iinteger) {
             drawLine(20, vposition, 100, vposition);
             drawString(unitmark,105, vposition);
             unitmark=unitmark+1;
             }  
         if (ix2==ix2integer){
             drawLine(20, vposition, 70, vposition);
             } else { 
                drawLine(20, vposition, 50, vposition);     
             }
          i=0.1*a;
          ix2=i*2;
          iinteger=round(i);
          ix2integer=round(ix2);
          pixelnum=round(i/pixelsize);                                   //////get an integer
          vposition=columnpixels-pixelnum;
     }                                                                                      //end loop

drawLine(20, columnpixels, 20, vposition);     
}                                                                                           //end macro
