Readme
======

This project consists of a group of loosely connected scripts. They are developed at BMIT at the Canadian Light Source [link](http://www.lightsource.ca/). They are used with ImageJ or with Fiji. The details are listed below.

A lot of image processing related to CT has now been moved away from ImagJ to Python scripts and [UFO-KIT](https://github.com/ufo-kit). A number of these macros have become obsolete and are no longer beeing developed. 

Macros
------

To install these files create a BMIT folder under the plugins sub-folder. Copy these files into the BMIT folder and restart the program. The plugins should be automatically found.

normalize_one.ijm: This macro is used for normalizing one image. The input is an image, dark-field image and flat-field image. Options ar to take the negative logarithm to get absorption units and 16 bit output.

Vertical_Scan.ijm: This macro is for collecting a series of images to form a single image. This is used when there was a vertical scan of a sample with images taken at a know step size.


cxd
+++

Macros in this folder are intended to be used with files in the Hamamatsu cxd format. 

CXD_converter_N.ijm: Converts a group of cxd files into tiff format in the folder layout for the nrecon program. The macro expects files named dark_before.cxd, dark_after.cxd, flat_before.cxd, flat_after.cxd, tomo.cxd. Output goes into folders named dark, flat and tomo. 

CXD_converter_P.ijm: Converts a group of .cxd files into tiff format in a single folder layout which is used by programs such as Pitre and Xtract. The macro expects files named dark_before.cxd, dark_after.cxd, flat_before.cxd, flat_after.cxd, tomo.cxd. Output files are suitibly named with dark, flat and and tomo prefix in the output directory.

k-edge
++++++

Macros in this folder are related to k-edge subtraction measurements.

Micro-CT
++++++++

Macros in this folder are related to CT tasks such as pre-processing of images before reconstruction. The name micro-CT refers to the fact that some of these were made specifically for a micro-CT system. However, they can be used for CT in general.

Micro-CT_Processing.ijm: This was originally written by David Cooper and I have made some modifications. This macro is for making background corrections for a CT collection. Input are directories with CT projections, dark-field images and flat-field images. There is input for scaling needed for conversion to 16 bit images. Optionally a Sky Scan log file can be generated. This is needed in order to use the Nrecon program for the reconstruction. Defaults are provided based on typical BMIT parameters. Some parameters such as pixel size will need to be adjusted. The macro assumes 180 degree scan and must be adjusted if a 360 degree scan was used.

Micro-CT-Processing_cxd.ijm: This version of processing starts with a directory of cxd files and processes them as for use in nrecon.

Micro-CT-Processing_cxd_simple.ijm: Does the same thing as Micro-CT-Processing_cxd but uses a number of default values to simplify the input. Caution: The defaults may not be suitable for all data. 

specialized
+++++++++++

These macros were created for processing specific data for a project. These macros may be more difficult to use and require specific file inputs. See the macro for details.

360stitch180_pr.ijm: Stitch 360 degree scan results into 180 degree scan projections used for PITRE or XTRACT.

Combine_3_vertical_slices.ijm: Combining different vertical views and output a 32 bit tiff results in folder named "Results".
