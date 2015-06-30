//macro to calculate images for Ba k-edge subtract using two energies
//Authors: M. Adam Webb

macro "Barium KES" {

	// this macro calculates k-edge subtraction for barium
	
	
	
	
	// global variables
	// this assumes 100 eV above and below the edge
	var barium_high = 0.042738;
	var barium_low = -0.04251;
	var water_high = -0.82944;
	var water_low = 4.340684;
	var pixel = 0.002224;
	
	// open files for barium image
	high_i = File.openDialog("High Energy Image");
	open(high_i);
	rename("high");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+barium_high);
	low_i = File.openDialog("Low Energy Image");
	open(low_i);
	rename("low");
	run("Divide...", "value="+pixel);
	run("Multiply...", "value="+barium_low);
	imageCalculator("Add create 32-bit", "high", "low");
	rename("barium");
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
	rename("barium_water");
	selectWindow("high");
	close();
	selectWindow("low");
	close();
	
}