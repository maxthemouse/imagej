Readme
======

This project consists of a group of loosely connected scripts. They are developed at BMIT at the Canadian Light Source [link](http://www.lightsource.ca/). They are used with Fiji. The details are listed below.

Jython
------

Fiji is required in order to run Python scripts. To install them copy the sub-folder called Jython into the plugins folder. Copy the files into the folder and start Fiji. It might be necessary to run the "Refresh Jython Scripts" command under" Scripting in plugins. This is often needed the first time a plugin is installed.

mhd2tif_.py:  Converts mhd files to sub-folders of tif files. Input is a root directory and the script walks the directory looking for mhd files. Files are opened and folders created with the same name as the mhd file. Images are saved as tif with the name of name_number.tif.

tif2mhd_.py:  Converts folders of tif files to mhd files. Input is a root directory and the script walks the directory looking for tif files. The tif files are read and saved in a mhd file in the parent directory with the same name as the root name as the tif. The expected name is name_number.tif. The script may complain if a sub-folder does not have any tif files.