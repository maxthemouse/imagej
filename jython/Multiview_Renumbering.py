import os
import os.path
import shutil
import glob
from ij.gui import GenericDialog
from ij.io import OpenDialog
from ij.io import DirectoryChooser


def gen_seq(Nview=1, Nproj=900, Nimage=1, Nflat=1, Ndark=1, FDint=900,
            extra=False):
    """Generate name sequence.
    Generate a sequence of file names for CT scans. Names use Dark, Flat
    and Tomo as is commonly used by analysis programs.
    Input parameters:
        Nview   Number of views (default=1)
        Nproj   Number of projections (default=1)
        Nimage  Number of images for each projection (default=1)
        Nflat   Number of flat images (default=1)
        Ndark   Number of dark images (default=1)
        FDint   Interval for flats and darks. Images are taken at
                the beginning and end as well as between projections.
                Note that this must be an interger division of
                Nproj.
        extra   Flag to indicate if one or two sets of flats and darks are
                taken in between views (default = False)

    Output:
        seq     Sequence of new file names
        fd      Sequence of flats and darks from begining of each view

    The total number of images in the sequence is as follows:
        Nviews*(Nproj*Nimage + (Nproj/Fdint + 1)*(Nflat+Ndark))
        or
        Nviews*(Nproj*Nimage + (Nproj/Fdint)*(Nflat+Ndark)) + (Nflat+Ndark)
    """
    seq = []
    fd = []
    Idark = 0
    Iflat = 0
    Itomo = 0
    ext = ".tif"
    if Nproj % FDint != 0:
        return []
    for i in range(Nview):
        Idark = 0
        Iflat = 0
        Itomo = 0
        for m in range(Nflat):
            seq.append("Flat_%02d_%04d%s" % (i, Iflat, ext))
            if i > 0 and not(extra):
                fd.append("Flat_%02d_%04d%s" % (i, Iflat, ext))
            Iflat += 1
        for n in range(Ndark):
            seq.append("Dark_%02d_%04d%s" % (i, Idark, ext))
            if i > 0 and not(extra):
                fd.append("Dark_%02d_%04d%s" % (i, Idark, ext))
            Idark += 1
        for j in range(Nproj / FDint):
            for j in range(FDint):
                for k in range(Nimage):
                    seq.append("Tomo_%02d_%04d%s" % (i, Itomo, ext))
                    Itomo += 1
            if Itomo >= Nproj * Nimage:
                continue  # if at end of view skip F/D
            for m in range(Nflat):
                seq.append("Flat_%02d_%04d%s" % (i, Iflat, ext))
                Iflat += 1
            for n in range(Ndark):
                seq.append("Dark_%02d_%04d%s" % (i, Idark, ext))
                Idark += 1
        if extra or i == Nview - 1:  # if extra or at end add F/D
            for m in range(Nflat):
                seq.append("Flat2_%02d_%04d%s" % (i, Iflat, ext))
                Iflat += 1
            for n in range(Ndark):
                seq.append("Dark_%02d_%04d%s" % (i, Idark, ext))
                Idark += 1
    return seq, fd


def rename(basename, seq, fd=None, path1=None, path2=None, Nview=1):
    """Rename files
    Rename the files from basename using the names of seq. The files are
    in the path. The number of files have to match the number of names
    in the sequence.
    """
    if path1 is None:
        path1 = os.getcwd()
    if path2 is None:
        path2 = os.getcwd()
    if fd is None:
        fd = []
    files = glob.glob(os.path.join(path1, "%s*" % basename))
    if len(files) != len(seq):
        return ("Error: Wrong sequence. Files = %d vs sequence = %d." %
                (len(files), len(seq)))
    files.sort()
    for i in range(Nview):
        # make empty folders for views
        viewPath = os.path.join(path2, "%02d" % i)

        # make empty folders for flat, dark, and tomo in each view folder
        flatPath = os.path.join(viewPath, "flats")
        os.makedirs(flatPath)
        flat2Path = os.path.join(viewPath, "flats2")
        os.makedirs(flat2Path)
        darkPath = os.path.join(viewPath, "darks")
        os.makedirs(darkPath)
        tomoPath = os.path.join(viewPath, "tomo")
        os.makedirs(tomoPath)
        # due to renaming, build a dict to match file names and the folders
        name_dict = {"Flat": "flats",
                     "Flat2": "flats2",
                     "Dark": "darks",
                     "Tomo": "tomo"}
    for new, old in zip(seq, files):
        view = new.split("_")[1]
        root = name_dict[new.split("_")[0]]
        print "move %s to %s" % (os.path.join(path1, old),
                                 os.path.join(path2, view, root, new))
        shutil.move(os.path.join(path1, old),
                     os.path.join(path2, view, root, new))
    for new_cp in fd:
        view = new_cp.split("_")[1]
        root = name_dict[new_cp.split("_")[0]]
        if root.startswith("f"):
            root2 = name_dict["Flat2"]
        else:
            root2 = root
        view2 = int(view) - 1
        print "copy %s to %s" % (os.path.join(path2, view, root, new_cp),
                                 os.path.join(path2, "%02d" % view2, root2,
                                              new_cp))
        shutil.copy2(os.path.join(path2, view, root, new_cp),
                     os.path.join(path2, "%02d" % view2, root2, new_cp))
    return "%d files were renamed." % len(files)


def short(s):
    """return the first part of the string s up to a number."""
    result = []
    for d in list(s):
        if d.isdigit():
            break
        else:
            result.append(d)
    return ''.join(result)


def main():

    # start with the sequence parameters
    fieldNames = ["Number of views", "Number of projections for each view",
                  "Number of images for each projection (normally 1)",
                  "Number of flats in each set", "Number of darks in each set",
                  "Number of projections between each set of flats/darks"]
    fieldValues = []  # we start with zeros for the values

    # get user variables with imageJ dialog
    dialog = GenericDialog("Enter Scan Information")
    for i in range(6):
        dialog.addNumericField(fieldNames[i], 0, 0)
    dialog.addCheckbox("Two sets flats/darks between views?", False)
    dialog.showDialog()
    if dialog.wasCanceled():
        return  # exit function
    for i in range(6):
        fieldValues.append(int(dialog.getNextNumber()))
    extra = dialog.getNextBoolean()
    # make sure that none of the fields was left blank
    errmsg = ""
    for i in range(len(fieldNames)):
        if fieldValues[i] == "":
            errmsg += ('"%s" is a required field.\n\n' % fieldNames[i])
        try:
            int(fieldValues[i])
        except ValueError:
            errmsg += ('"%s" has to be an integer value.\n\n' %
                       fieldNames[i])
    if fieldValues[1] and fieldValues[5]:
        if int(fieldValues[1]) % int(fieldValues[5]) != 0:
            errmsg += ('Flat/Dark interval must divide evenly into projections\n\n')
    if errmsg != "":
        err_msg = GenericDialog("Error in Input")
        err_msg.addMessage(errmsg)
        err_msg.showDialog()
        return  # exit
    if fieldValues is None:
        return  # exit function
    fieldValues = [int(i) for i in fieldValues]
    # get the first item of the sequence using an imageJ dialog
    openFile = OpenDialog(
        "Select the first file of the sequence to rename.", None)
    fileName = openFile.getFileName()
    if fileName is None:
        return  # exit function
    fileDir = openFile.getDirectory()
    first = fileDir + fileName
    path1, filename = os.path.split(first)
    basename = short(filename)
    # get directory for new files using imageJ dialog
    openOutDir = DirectoryChooser("Select directory for new files.")
    path2 = openOutDir.getDirectory()
    if path2 is None:
        return  # exit function
    new_seq, fd_seq = gen_seq(fieldValues[0], fieldValues[1], fieldValues[2],
                              fieldValues[3], fieldValues[4], fieldValues[5],
                              extra)
    result = rename(basename, new_seq, fd_seq, path1, path2, fieldValues[0])
    print result


# Call the main function (initial point of execution)
main()
