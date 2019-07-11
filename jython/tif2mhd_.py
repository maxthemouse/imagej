import os

def run():
    srcDir = DirectoryChooser("Choose Directory").getDirectory()
    if not srcDir:
        # user cancelled dialog
        return
    for root, directories, filenames in os.walk(srcDir):
        for dir in directories:
            path = os.path.join(root, dir)
            print path
            try:
                imp = IJ.run("Image Sequence...", 'open=' + path + ' number=[] starting=1 increment=1 scale=100 file=tif sort use')
                name = os.path.join(root, dir + '.mhd')
                print name
            except:
                continue
            if os.path.exists(name):
                imp = IJ.getImage()
                imp.close()
                continue  #  skip in case it already exits
            IJ.run(imp, "MetaImage Writer ...", '  metaimage=' + name)
            imp = IJ.getImage()
            imp.close()

run()
