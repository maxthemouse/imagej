//macro to calculate images for Ba k-edge subtract using two energies
//Authors: M. Adam Webb

macro "Iodine KES" {

	// this macro calculates k-edge subtraction for iodine
	
	
	
	
	// global variables
	// this assumes 100 eV above and below the edge
	var iodine_high = 0.034416;
	var iodine_low = -0.03417;
	var water_high = -0.69422;
	var water_low = 3.767653;
	var pixel = 0.002224;
	
	// open files for iodine image
	high_i = File.openDialog("High Energy Image");
	open(high_i);
	rename("high");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+iodine_high);
	low_i = File.openDialog("Low Energy Image");
	open(low_i);
	rename("low");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+iodine_low);
	imageCalculator("Add create 32-bit", "high", "low");
	rename("iodine");
	selectWindow("high");
	close();
	selectWindow("low");
	close();
	
	// open files for water image
	//high = File.openDialog("High Energy Image");
	open(high_i);
	rename("high");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+water_high);
	//low = File.openDialog("Low Energy Image");
	open(low_i);
	rename("low");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+water_low);
	imageCalculator("Add create 32-bit", "high", "low");
	rename("iodine_water");
	selectWindow("high");
	close();
	selectWindow("low");
	close();
	
}