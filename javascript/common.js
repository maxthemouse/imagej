importClass(Packages.ij.IJ);
importClass(Packages.ij.plugin.ImageCalculator);


// basic background subtraction
function bkg_subtract(imp1, imp2, imp3) {
	var ic = new ImageCalculator();
	var imp4 = ic.run("Subtract create 32-bit", imp3, imp1);
	//imp4.show();
	imp4.setTitle("image_d");
	var imp5 = ic.run("Subtract create 32-bit", imp2, imp1);
	//imp5.show();
	imp5.setTitle("flat_d");
	var imp6 = ic.run("Divide create 32-bit", imp4, imp5);
	IJ.run(imp6, "Remove NaNs...", "radius=2");
	imp6.setTitle("image_norm");
	return imp6;
}

// zero fill a number to the number of digits
function zfill(number, size, pad) {
  var pad = typeof pad !== "undefined" ? pad : "0";
  number = number.toString();
  while (number.length < size) number = pad + number;
  return number;
}
