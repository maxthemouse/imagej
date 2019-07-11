Readme
======

This project consists of a group of loosely connected scripts. They are developed at BMIT at the Canadian Light Source [link](http://www.lightsource.ca/). They are used with Fiji. The details are listed below.

JavaScript
------

Fiji is required in order to run JavaScript scripts. To install them copy the sub-folder called JavaScript into the plugins folder. Copy the files into the folder and start Fiji. It might be necessary to run the "Refresh JavaScript Scripts" command under Scripting in plugins. This is often needed the first time a plugin is installed.

normalize_one: Converted the macro to JavaScript as a proof of principle to switch from using the macro language. This macro is used for normalizing one image. The input is an image, dark-field image and flat-field image. Options ar to take the negative logarithm to get absorption units and 16 bit output.
