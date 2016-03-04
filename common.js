importClass(Packages.ij.IJ);
importClass(Packages.ij.plugin.ImageCalculator);

function bkg_subtract(imp1, imp2, imp3) {
	var ic = new ImageCalculator();
	var imp4 = ic.run("Subtract create", imp3, imp1);
	//imp4.show();
	imp4.setTitle("image_d");
	var imp5 = ic.run("Subtract create", imp2, imp1);
	//imp5.show();
	imp5.setTitle("flat_d");
	var imp6 = ic.run("Divide create 32-bit", imp4, imp5);
	imp6.setTitle("image_norm");
	return imp6;
}
