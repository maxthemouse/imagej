import os

def get_options():
    gd = GenericDialog("Options")
    gd.addCheckbox("output 16-bit", False)
    gd.addNumericField("Maximum Value", 2.5, 2)
    gd.addNumericField("Minimum Value", -0.1, 2)
    gd.showDialog()
    #
    if gd.wasCanceled():
        return None
    scaling = gd.getNextBoolean()
    stackmax = gd.getNextNumber()
    stackmin = gd.getNextNumber()
    return scaling, stackmax, stackmin



def run():
    options = get_options()
    if options is None:
        return
    else:
        scaling, stackmax, stackmin = options
    srcDir = DirectoryChooser("Choose Directory").getDirectory()
    #srcDir = 'E:\\data\\18-5993-Tracy-Walker\\fish\\part1'
    if not srcDir:
        # user canceled dialog
        return
    for root, directories, filenames in os.walk(srcDir):
        for filename in filenames:
            if not filename.endswith(".mhd"):
                continue
            path = os.path.join(root, filename)
            print path
            imp = IJ.run("MetaImage Reader ...", 'open=' + path + ' use')
            name = os.path.join(root, filename[:-4])
            base = filename[:-4] + '_'
            print name
            if os.path.exists(name):
                imp = IJ.getImage()
                imp.close()
                continue  #  skip in case it already exits
            if not os.path.exists(name):
                os.makedirs(name)
            if scaling:
                IJ.setMinAndMax(stackmin, stackmax)
                IJ.run("16-bit")
                #IJ.saveAs(imp, "Tiff", os.path.join(root, base) + ".tif");
            IJ.run("Image Sequence... ",
                   'format=TIFF name=' + base + ' start=0 digits=4 save=' + name)
            # close the window but don't ask to save
            imp = IJ.getImage()
            win = imp.window
            win.removeNotify()

            
run()
