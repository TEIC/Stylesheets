#Stylesheets

Fork of TEI XSL Stylesheets repo

This is a forked copy of the TEI Stylesheets family, for preparing change proposals.


## Usage
The `bin/` directory contains several executable files, which can be run on Linux, OS X, or other Unix operating systems. These perform a variety of transformations and are very useful for, e.g., generating a schema from a TEI ODD. Some examples:

    bin/teitorelaxng --odd ../TEI/P5/Exemplars/tei_all.odd tei_all.rng
Assuming you have a copy of the TEI Guidelines repository alongside your copy of the Stylesheets, this will take the tei_all ODD and generate a RelaxNG XML schema for you. Similarly,

    bin/teitornc --odd ../TEI/P5/Exemplars/tei_lite.odd tei_lite.rnc
will produce a RelaxNG Compact Syntax schema for TEI Lite.
