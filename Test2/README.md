# Stylesheets Test2 Project

Test2 is a long-term project to replace the existing Test suite with a more comprehensible, better documented test suite that will run faster and be easier to modify and update.

Rather than Make it uses only Ant, and for the sake of speed, under normal conditions many of the tests are run in parallel, using more computing resources but running faster. Input, output and expected-results materials are also (hopefully) better organized, segregated, and named than in the original tests. 

For a detailed introduction to how it works, run "ant -projecthelp" in the Test2 directory.

Martin  Holmes (@martindholmes) and Syd Bauman (@sydb) are currently doing the work on this, but feel free to join the effort! Current work is focusing on ODD processing, in build_odd.xml. 


Example usages:

`ant test` runs all the tests in parallel, for optimal speed.

`ant testSeries` runs all the tests in series, which takes longer than in parallel, but can make it much easier to debug a failure because messages from different targets are interspersed.

`ant clean` removes results from previous runs of the tests.

`ant odt` runs only the odt tests. Similarly, `ant docx`, `ant fo`, `ant odd`, and others.

### How the tests are run

Some tests are run by invoking the bin/thing2thing symlinks, which call the universal bin/transformtei script. Others are run by directly invoking Saxon to do an XSLT tranformation. The latter approach is faster and simpler for transformation which involve only XSLT transformation; where other processes are used (such as FO to PDF conversion) the bin script is more straightforward. Read the ant files for more info.


### Tests not included

Note that the following tests that used to be run in Test are not [yet] covered in Test2:

 [TODO: @sydb and @martindholmes are working on this list.]






