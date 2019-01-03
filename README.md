# fitparseR
An R wrapper for python-fitparse to read Garmin .fit data files

The python package fitparse seems to be the best-maintained and reasonably
current tool for reading the .fit files produced by Garmin devices.  Many 
thanks to the developers/maintainers of that package.

This package was developed to read .fit files from the Edge 820 that replaces 
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
to know Python to figure out how to make it suit your needs.

You have to have a conda (either anaconda or miniconda) setup that R can find.
There are lots of resources to help you do that.  Use your search engine.  In
theory it should require python 2.X, but I had no problems with python 3.X.  
The first python call triggers a check that requisite packages are installed.
This is slow so there is a flag to bypass this behavior if you know your conda
environment is current.

This package is not fast.  It's not terribly elegant.  But it is more likely to
stay current than other options, since python fitparse updates should be
seamlessly incorporated.

