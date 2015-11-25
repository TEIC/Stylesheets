#Stylesheets

TEI XSL Stylesheets

This is a family of XSLT 2.0 stylesheets to transform TEI XML documents to various formats, including XHTML, LaTeX, XSL Formatting Objects, ePub, plain text, RDF, JSON; and to/from Word OOXML (docx) and OpenOfice (odt).  They concentrate on the core TEI modules which are used for simple transcription and "born digital" writing. It is important to understand that they do _not_:

a) cover all TEI elements and possible attribute values
b) attempt to define a standard TEI processing or rendering model

and should not be treated as the definitive view of the TEI Consortium.

## Usage
The `bin/` directory contains several executable files, which can be run on Linux, OS X, or other Unix operating systems. These perform a variety of transformations and are very useful for, e.g., generating a schema from a TEI ODD. Some examples:

    bin/teitorelaxng --odd ../TEI/P5/Exemplars/tei_all.odd tei_all.rng
Assuming you have a copy of the TEI Guidelines repository alongside your copy of the Stylesheets, this will take the tei_all ODD and generate a RelaxNG XML schema for you. Similarly,

    bin/teitornc --odd ../TEI/P5/Exemplars/tei_lite.odd tei_lite.rnc
will produce a RelaxNG Compact Syntax schema for TEI Lite.
