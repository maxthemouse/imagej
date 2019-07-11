// @File(label = "dark image") d_file
// @File(label = "flat image") f_file
// @File(label = "sample image") i_file
// @boolean(label = "Calculate negative Logarithm?") dolog
// @boolean(label = "Output 16-bit tiff") do16bit


importClass(Packages.ij.IJ);
importClass(Packages.ij.WindowManager);
importClass(Packages.ij.plugin.ImageCalculator);
importClass(Packages.java.io.File);
load(IJ.getDirectory("plugins") + "JavaScript" + File.separator + "common.js");

var imp1 = IJ.openImage(d_file);
var imp2 = IJ.openImage(f_file);
var imp3 = IJ.openImage(i_file);
var ic = new ImageCalculator();
var imp6 = bkg_subtract(imp1, imp2, imp3);

if (dolog) {
	IJ.run(imp6, "Log", "");
	IJ.run(imp6, "Multiply...", "value=-1");
	imp6.setTitle("image_log_norm");
}
if (do16bit) {
	//	IJ.run(imp6, "getStatistics(min, max)", "");
	//	IJ.run(setMinAndMax(min,max), "");
	IJ.run(imp6, "16-bit", "");
}
IJ.run(imp6, "Enhance Contrast", "saturated=0.35");
imp6.show();
