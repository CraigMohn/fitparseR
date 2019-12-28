# fitparseR
An R wrapper for python-fitparse to read Garmin .fit data files

The python package fitparse seems to be the best-maintained and reasonably
current tool for reading the .fit files produced by Garmin devices.  Many 
thanks to the developers/maintainers of that package. 

This package was developed to read .fit files from the Edge 820 that replaced 
my old Edge 800 unit. Several alternative R packages were incapable of dealing
with the new format, and quick attempts at patching them were fruitless. 
In the end it was easiest to spend a couple of evenings learning enough Python 
to read and format the data, and passing it back to R using the reticulate 
package.  Reticulate had issues passing the resulting dataframes, and the 
easiest solution was to write then read a JSON tempfile.  

All data fields that are single-valued and have an intelligible name are
returned.  Variables whose names contain "unknown_", "_position", or "phase" 
are not returned.  If your device reports a single-valued field that you want
which fits that pattern, or it reports a multi-valued parameter that does not
and that throws an error, the code is in readfitffile.py, and you don't need 
to know much Python to figure out how to make it suit your needs.

You have to have a conda (either anaconda or miniconda) setup that R can find.
There are lots of resources to help you do that.  Use your search engine.  This
package requires python 2.X.  The environment needs a suitable version on pandas  
and numpy.  Python 2.7.15, pandas 0.24.1 and numpy 1.15.4 are known to work.  
Support for python 2.X ends with reticulate 1.14, so this package may become
a hassle to use in the future.

The first call to read a fit file triggers a time-consuming check that the
conda environment has the required packages installed, unless a flag to skip it
is TRUE.

