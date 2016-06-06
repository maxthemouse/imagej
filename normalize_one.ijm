//Macro for normalizing a single image using dark and flat images.
// Authors: M. Adam Webb

macro "Normalize Image" {

	// this macro does a normalization
	// this is calculated by subtracting the dark from the image and the flat
	// then the image is divided by the flat

	// Get options for what will be done
	Dialog.create("Normalization Options");
	Dialog.addMessage("Select options for doing normalization of data.");
	Dialog.addCheckbox("Calculate negative Logarithm?", true);
	Dialog.addCheckbox("Output 16-bit tiff", false);
	Dialog.show()
	dolog = Dialog.getCheckbox();
	do16bit = Dialog.getCheckbox();

	// open files
	dark = File.openDialog("Dark Image");
	open(dark);
	rename("dark");
	//dark = File.name;
	dark = "dark";
	flat = File.openDialog("Flat Image");
	open(flat);
	rename("flat");
	//flat = File.name;
	flat = "flat";
	image = File.openDialog("Image");
	open(image);
	rename("image");
	//image = File.name;
	image = "image";

	// normalize data, rename results to more friendly names
	imageCalculator("Subtract create 32-bit", image, dark);
	rename("Image_minus_Dark");
	imageCalculator("Subtract create 32-bit", flat, dark);
	rename("Flat_minus_Dark");
	imageCalculator("Divide create 32-bit", "Image_minus_Dark", "Flat_minus_Dark");
	rename("Image_norm");
	run("Remove NaNs...", "radius=2");

	// take the -log to get an absorption image when selected
	if (dolog) {
		run("Log");
		run("Multiply...", "value=-1");
		rename("Image_log_norm");
	}
	if (do16bit) {
		getStatistics(area, mean, min, max);
		setMinAndMax(min, max);
		run("16-bit");
	}
	
	// close the original and temporary images
	selectWindow(image);
	close();
	selectWindow(flat);
	close();
	selectWindow(dark);
	close();
	selectWindow("Image_minus_Dark");
	close();
	selectWindow("Flat_minus_Dark");
	close();
}
