#
# TEI Stylesheets repo original Test system
# 


################################
# global variable declarations #
################################

# Do we perform comparisons between the actual outputs and expected
# outputs now (and thus fail as soon as there is a difference), or
# not (in which case user is expected to compare them after we're
# done building them here)?
DIFFNOW=1			# 1 = do diff now; 0 = don't do diffs now

# Directories for holding outputs and expected outputs
# (NB—no ending slashes):
AR=actual-results
ER=expected-results

# The directory in whch the various `teitoXXX` and `XXXtotei` commands can
# be found:
BINDIR=../bin

# Path to the version of P5 source to use by default
# (Note this is the p5subset used to solve circularity -- see
# ???https://pointer.to.tei/doc/on/circularity/solution???):
DEFAULTSOURCE=../source/p5subset.xml

# Several XSLT programs have a parameter that allow the routine to output
# fixed date (and possibly version) information just to make comparison
# easier. At the time of this writing, those programs are:
#   ../common/functions.xsl,
#   ../docx/to/teitodocx.xsl,
#   ../odt/teitoodt.xsl, and
#   ../rdf/make-acdc.xsl.
SAXONOPT=useFixedDate=true

# Establish commands for `saxon` and `jing`. (Note: at present UP1SAXON is
# unused, just here to show the pattern).
JAVAPRE=java -Djava.awt.headless=true -jar
SAXON=$(JAVAPRE) ../lib/saxon10he.jar defaultSource=$(DEFAULTSOURCE)
UP1SAXON=$(JAVAPRE) ../../lib/saxon10he.jar defaultSource=$(DEFAULTSOURCE)
UP2SAXON=$(JAVAPRE) ../../../lib/saxon10he.jar defaultSource=$(DEFAULTSOURCE)
JING=$(JAVAPRE) ../lib/lib/jing-20120724.0.0.jar

# flags used for the commands running from $(BINDIR), e.g. `bin/teitorelaxng` 
FLAGS=--localsource=$(DEFAULTSOURCE)

# Location of oXygen. Only used in the test-pureant target, which is not run
# by any other target.
OXY=/usr/share/oxygen

# Lists of programs (in the $(BINDIR) directory) executed by the
# test-scripts target.
SCRIPTS=teitobibtex \
	teitodocbook \
	teitodocx \
	teitoepub \
	teitoepub3 \
	teitofo \
	teitohtml \
	teitohtml5 \
	teitojson \
	teitolatex \
	teitoodt \
	teitopdf \
	teitordf \
	teitotxt
SCHEMASCRIPTS=teitornc \
	teitorelaxng \
	teitoxsd \
	teitodtd


###############################
# First target is the default #
# (no matter what its name).  #
###############################

default: actual test.rng test-to-html test-p4top5 test-oddity test-scripts test-namespaces test-from-html test-latex test-fo test-to-docx test-from-docx test-xlsx test-rdf test-text test-odt test-markdown test-cocoa test-epub


###################
# rest of targets #
###################

help:
	@echo "Runs TEI Stylesheets repo original tests; for new and improved tests, see the"
	@echo "Test2/ directory."
	@echo ""
	@echo "Only the main 'default' target is briefly documented here."
	@echo ""
	@echo "Lots of tests are run by default. For the majority of them, the test generates"
	@echo "some output (put into $(AR)/) which is to be compared to the expected"
	@echo "output of that test (stored in $(ER)/). If the parameter DIFFNOW is"
	@echo "set to 1 (the default), the results of each test are compared to the expected"
	@echo "result immediately, and the process fails and stops if a difference is found."
	@echo "If the parameter DIFFNOW is set to 0 (or anything not '1', really), then the"
	@echo "comparison is deferred. This allows the user to compare them all at once after"
	@echo "the entire test has run. This DIFFNOW=0 is often easier for interactive use,"
	@echo "but DIFFNOW=1 better for running from another process that needs to know if"
	@echo "there is a failure."
	@echo ""
	@echo "Suggested sequence for interactive use is:"
	@echo "$$ make clean"
	@echo "$$ make DIFFNOW=0"
	@echo "$$ diff -C0 -r $(AR)/ $(ER)/ | perl -pe 's,^diff -C0," '\\n\\n#########\\ndiff' " -C0,;'"
	@echo "$$ # note: ignore differences in files ending in '.listing'; if there are any use:"
	@echo '$$ for f in $(AR)/*.listing ; do diff -C0 <(sort $$f) <(sort $(ER)/$$(basename $$f)); done'
	@echo "$$ # as the sort order is apparently inconsequential."
	@echo ""
	@echo "When the diff of the two directories is performed, the following files are"
	@echo "expected to be in only $(AR)/, not $(ER)/. (Listed here"
	@echo "in the likely order in which they will be listed by diff.)"
	@echo "  Only in $(AR)/: oddbyexample.dtd"
	@echo "  Only in $(AR)/: oddbyexample.rnc"
	@echo "  Only in $(AR)/: oddbyexample.xsd"
	@echo "  Only in $(AR)/: Pictures"
	@echo "  Only in $(AR)/: test34.combined.odd"
	@echo "  Only in $(AR)/: test_3.epub"
	@echo "  Only in $(AR)/: test3.html"
	@echo "  Only in $(AR)/: test4.html"
	@echo "  Only in $(AR)/: testoucscoursesp5.xml"
	@echo "  Only in $(AR)/: testoucscourses.xml.docx"
	@echo "  Only in $(AR)/: test-pages.epub"
	@echo "  Only in $(AR)/: test.processedodd"
	@echo "  Only in $(AR)/: xml.tmp"

actual:
	mkdir -p $(AR)

test.rng: actual
	$(BINDIR)/teitorelaxng $(FLAGS) --odd test.odd test.rng
	xmllint --format test.rng > $(AR)/test.rng && rm test.rng
	perl -i -pe 'BEGIN{undef $$/;} s/<!--\n ?Schema[^>]+>//smg' $(AR)/test.rng
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.rng $(ER)/test.rng; \
		else echo "==deferring: \`diff  $(AR)/test.rng $(ER)/test.rng\`"; fi

# I believe the css: target does nothing except ensure that there are symlinks here
# in the Stylesheets/ directory to each CSS file in the Stylesheets/css/ directory.
# I do not understand why.
# They are removed by the clean: target, BTW. —Syd, 2020-08-11
css:
	(cd ..; for i in css/*; do test -f `basename $$i` || ln -s $$i `basename $$i`;done)

test-to-html: actual css
	@echo BUILD: testing html
	$(SAXON)  test.xml ../html/html.xsl cssFile=../tei.css $(SAXONOPT) | tidy -config config_tidy.txt - > $(AR)/test.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.html $(ER)/test.html; \
		else echo "==deferring: \` diff  $(AR)/test.html $(ER)/test.html \`"; fi

	$(SAXON) $(AR)/test.html checklinks.xsl
	$(SAXON) test.xml ../html/html.xsl cssFile=../tei.css pageLayout=Complex  $(SAXONOPT)  | tidy -config config_tidy.txt - > $(AR)/test-complex.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-complex.html $(ER)/test-complex.html; \
		else echo "==deferring: \` diff  $(AR)/test-complex.html $(ER)/test-complex.html \`"; fi

	$(SAXON) test.xml ../profiles/ota/html/to.xsl cssFile=../tei.css $(SAXONOPT)  | tidy -config config_tidy.txt - | perl cleanup.pl > $(AR)/test-ota.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-ota.html $(ER)/test-ota.html; \
		else echo "==deferring: \` diff  $(AR)/test-ota.html $(ER)/test-ota.html \`"; fi

	$(BINDIR)/teitohtml5 $(FLAGS) test.xml $(AR)/test.html5
	tidy -config config_tidy.txt $(AR)/test.html5 | perl cleanup.pl > test.temp
	mv test.temp $(AR)/test.html5
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.html5 $(ER)/test.html5; \
		else echo "==deferring: \` diff  $(AR)/test.html5 $(ER)/test.html5 \`"; fi

	$(SAXON) test20.xml ../html/html.xsl $(SAXONOPT) | tidy -config config_tidy.txt - > $(AR)/test20.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test20.html $(ER)/test20.html; \
		else echo "==deferring: \` diff  $(AR)/test20.html $(ER)/test20.html \`"; fi

	$(SAXON) -versionmsg:off  test3.xml ../html/html.xsl $(SAXONOPT)| tidy -config config_tidy.txt - > $(AR)/test3.html
	$(SAXON) -versionmsg:off  test4.xml ../html/html.xsl $(SAXONOPT)| tidy -config config_tidy.txt - > $(AR)/test4.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test4.html $(AR)/test3.html; \
		else echo "==deferring: \` diff  $(AR)/test4.html $(AR)/test3.html \`"; fi

	$(SAXON) test5.xml ../html/html.xsl  autoBlockQuote=true $(SAXONOPT)  | tidy -config config_tidy.txt - > $(AR)/test5.xhtml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test5.xhtml $(ER)/test5.xhtml; \
		else echo "==deferring: \` diff  $(AR)/test5.xhtml $(ER)/test5.xhtml \`"; fi
#	$(JING) -c xhtml.rnc $(AR)/test5.xhtml
# The xhtml.rnc schema previously used for validation is not actually an XHTML5 schema, but rather an XHTML 1.1 schema. 
# Notably, it does not permit @lang, which we need. Thus I have provisionally commented-out the validation against it 
# until we can set up proper XHTML5 validation. — hbs 2021-09-15.
	$(SAXON) test6.xml ../html/html.xsl  autoBlockQuote=true $(SAXONOPT)  | tidy -config config_tidy.txt - > $(AR)/test6.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test6.html $(ER)/test6.html; \
		else echo "==deferring: \` diff  $(AR)/test6.html $(ER)/test6.html \`"; fi
#	$(JING) -c xhtml.rnc $(AR)/test6.html

	$(SAXON) test14.xml ../html/html.xsl $(SAXONOPT)| tidy -config config_tidy.txt - > $(AR)/test14.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test14.html $(ER)/test14.html; \
		else echo "==deferring: \` diff  $(AR)/test14.html $(ER)/test14.html \`"; fi

	$(SAXON) test22.xml ../html/html.xsl $(SAXONOPT)| tidy -config config_tidy.txt - > $(AR)/test22.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test22.html $(ER)/test22.html; \
		else echo "==deferring: \` diff  $(AR)/test22.html $(ER)/test22.html \`"; fi

	$(SAXON) test23.xml ../html/html.xsl $(SAXONOPT)| tidy -config config_tidy.txt - > $(AR)/test23.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test23.html $(ER)/test23.html; \
		else echo "==deferring: \` diff  $(AR)/test23.html $(ER)/test23.html \`"; fi

	( \
		mkdir -p $(AR)/testnotes; \
		cd $(AR)/testnotes; \
		$(UP2SAXON) ../../testnotes1.xml ../../../html/html.xsl \
			splitLevel=4 useFixedDate=true STDOUT=false \
			cssFile=../../../tei.css \
	)
	tidy -config config_tidy.txt $(AR)/testnotes/index.html > x ; mv x $(AR)/testnotes/index.html
	tidy -config config_tidy.txt $(AR)/testnotes/one.html > x ; mv x $(AR)/testnotes/one.html
	tidy -config config_tidy.txt $(AR)/testnotes/two.html > x ; mv x $(AR)/testnotes/two.html
	tidy -config config_tidy.txt $(AR)/testnotes/three.html > x ; mv x $(AR)/testnotes/three.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  -r  $(AR)/testnotes/ $(ER)/testnotes; \
		else echo "==deferring: \` diff  -r  $(AR)/testnotes/ $(ER)/testnotes \`"; fi

	(mkdir -p $(AR)/testnotes2; cd $(AR)/testnotes2;$(UP2SAXON) ../../testnotes2.xml ../../../html/html.xsl splitLevel=0 useFixedDate=true STDOUT=false cssFile=../../../tei.css)
	tidy -config config_tidy.txt $(AR)/testnotes2/index.html > x ; mv x $(AR)/testnotes2/index.html
	tidy -config config_tidy.txt $(AR)/testnotes2/one.html > x ; mv x $(AR)/testnotes2/one.html
	tidy -config config_tidy.txt $(AR)/testnotes2/three.html > x ; mv x $(AR)/testnotes2/three.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  -r  $(AR)/testnotes2 $(ER)/testnotes2; \
		else echo "==deferring: \` diff  -r  $(AR)/testnotes2 $(ER)/testnotes2 \`"; fi

	(mkdir -p $(AR)/testnotes3; cd $(AR)/testnotes3;$(UP2SAXON) ../../testnotes2.xml ../../../html/html.xsl splitLevel=4 useFixedDate=true STDOUT=false cssFile=../../../tei.css)
	tidy -config config_tidy.txt $(AR)/testnotes3/index.html > x ; mv x $(AR)/testnotes3/index.html
	tidy -config config_tidy.txt $(AR)/testnotes3/one.html > x ; mv x $(AR)/testnotes3/one.html
	tidy -config config_tidy.txt $(AR)/testnotes3/two.html > x ; mv x $(AR)/testnotes3/two.html
	tidy -config config_tidy.txt $(AR)/testnotes3/three.html > x ; mv x $(AR)/testnotes3/three.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  -r  $(AR)/testnotes3 $(ER)/testnotes3; \
		else echo "==deferring: \` diff  -r  $(AR)/testnotes3 $(ER)/testnotes3 \`"; fi

	$(SAXON) test24.xml ../html/html.xsl $(SAXONOPT) | tidy -config config_tidy.txt - > $(AR)/test24.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test24.html $(ER)/test24.html; \
		else echo "==deferring: \` diff  $(AR)/test24.html $(ER)/test24.html \`"; fi
	$(SAXON) test25.xml ../html/html.xsl $(SAXONOPT) | tidy -config config_tidy.txt - > $(AR)/test25.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test25.html $(ER)/test25.html; \
		else echo "==deferring: \` diff  $(AR)/test25.html $(ER)/test25.html \`"; fi
	$(SAXON) test27.xml ../html/html.xsl $(SAXONOPT) cssFile=../tei.css cssSecondaryFile=../css/msdescription.css  | tidy -config config_tidy.txt - > $(AR)/test27.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test27.html $(ER)/test27.html; \
		else echo "==deferring: \` diff  $(AR)/test27.html $(ER)/test27.html \`"; fi

	$(SAXON) test28.xml ../html/html.xsl splitLevel=0  STDOUT=false $(SAXONOPT)
	tidy -config config_tidy.txt index.html > $(AR)/test28.html ; rm index.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test28.html $(ER)/test28.html; \
		else echo "==deferring: \` diff  $(AR)/test28.html $(ER)/test28.html \`"; fi

	$(SAXON) test31.xml ../html/html.xsl cssFile="" cssInlineFiles=../tei.css $(SAXONOPT)  | tidy -config config_tidy.txt - > $(AR)/test31.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test31.html $(ER)/test31.html; \
		else echo "==deferring: \` diff  $(AR)/test31.html $(ER)/test31.html \`"; fi

	$(SAXON) test32.xml ../html/html.xsl cssFile="" cssInlineFiles=../tei.css $(SAXONOPT)  | tidy -config config_tidy.txt - > $(AR)/test32.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test32.html $(ER)/test32.html; \
		else echo "==deferring: \` diff  $(AR)/test32.html $(ER)/test32.html \`"; fi

test-from-html: actual
	$(SAXON) test38.htm ../html/html2tei.xsl $(SAXONOPT)  | xmllint --format - > $(AR)/test38.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test38.xml $(ER)/test38.xml; \
		else echo "==deferring: \` diff  $(AR)/test38.xml $(ER)/test38.xml \`"; fi

test-markdown: actual
	@echo BUILD: testing markdown

	@echo BUILD: markdown to tei
	$(BINDIR)/markdowntotei $(FLAGS) mdtest1.md $(AR)/mdtest1.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/mdtest1.xml $(ER)/mdtest1.xml; \
		else echo "==deferring: \` diff  $(AR)/mdtest1.xml $(ER)/mdtest1.xml \`"; fi

	@echo BUILD: tei to markdown
	$(BINDIR)/teitomarkdown $(FLAGS) test.xml $(AR)/mdtest2.md
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/mdtest2.md $(ER)/mdtest2.md; \
		else echo "==deferring: \` diff  $(AR)/mdtest2.md $(ER)/mdtest2.md \`"; fi

test-cocoa: actual
	@echo BUILD: testing cocoa to TEI
	$(BINDIR)/cocoatotei $(FLAGS) cocoatest.txt $(AR)/cocoatest.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/cocoatest.xml $(ER)/cocoatest.xml; \
		else echo "==deferring: \` diff  $(AR)/cocoatest.xml $(ER)/cocoatest.xml \`"; fi
	$(BINDIR)/cocoatotei $(FLAGS) cocoatest2.txt $(AR)/cocoatest2.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/cocoatest2.xml $(ER)/cocoatest2.xml; \
		else echo "==deferring: \` diff  $(AR)/cocoatest2.xml $(ER)/cocoatest2.xml \`"; fi

test-p4top5: actual
	@echo BUILD: testing p4top5
	$(SAXON) -o:$(AR)/test17.tei test17.xml ../profiles/default/p4/from.xsl
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test17.tei $(ER)/test17.tei; \
		else echo "==deferring: \` diff  $(AR)/test17.tei $(ER)/test17.tei \`"; fi
	$(SAXON) A54031.tcp ../tcp/tcp2tei.xsl | xmllint --format - > $(AR)/A54031.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/A54031.xml $(ER)/A54031.xml; \
		else echo "==deferring: \` diff  $(AR)/A54031.xml $(ER)/A54031.xml \`"; fi

testsplit:
	$(SAXON) test6.xml ../html/html.xsl STDOUT=false verbose=true splitLevel=1 useFixedDate=true

test-latex: actual
	@echo BUILD: testing latex
	$(SAXON) -o:$(AR)/test.tex test.xml ../latex/latex.xsl  $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.tex $(ER)/test.tex; \
		else echo "==deferring: \` diff  $(AR)/test.tex $(ER)/test.tex \`"; fi
	$(SAXON) -o:$(AR)/testnotes1.tex testnotes1.xml ../latex/latex.xsl  $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/testnotes1.tex $(ER)/testnotes1.tex; \
		else echo "==deferring: \` diff  $(AR)/testnotes1.tex $(ER)/testnotes1.tex \`"; fi
	$(SAXON) -o:$(AR)/test5.tex test5.xml ../latex/latex.xsl  $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test5.tex $(ER)/test5.tex; \
		else echo "==deferring: \` diff  $(AR)/test5.tex $(ER)/test5.tex \`"; fi
	$(SAXON) -o:$(AR)/test6.tex test6.xml ../slides/teilatex-slides.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test6.tex $(ER)/test6.tex; \
		else echo "==deferring: \` diff  $(AR)/test6.tex $(ER)/test6.tex \`"; fi
	$(SAXON) -o:$(AR)/test20.tex test20.xml ../latex/latex.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test20.tex $(ER)/test20.tex; \
		else echo "==deferring: \` diff  $(AR)/test20.tex $(ER)/test20.tex \`"; fi
	$(SAXON) -o:$(AR)/test23.tex test23.xml ../latex/latex.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test23.tex $(ER)/test23.tex; \
		else echo "==deferring: \` diff  $(AR)/test23.tex $(ER)/test23.tex \`"; fi
	$(SAXON) -o:$(AR)/test24.tex test24.xml ../latex/latex.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test24.tex $(ER)/test24.tex; \
		else echo "==deferring: \` diff  $(AR)/test24.tex $(ER)/test24.tex \`"; fi
	$(SAXON) -o:$(AR)/test25.tex test25.xml ../latex/latex.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test25.tex $(ER)/test25.tex; \
		else echo "==deferring: \` diff  $(AR)/test25.tex $(ER)/test25.tex \`"; fi
	$(SAXON) -o:$(AR)/test27.tex test27.xml ../latex/latex.xsl $(SAXONOPT)
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test27.tex $(ER)/test27.tex; \
		else echo "==deferring: \` diff  $(AR)/test27.tex $(ER)/test27.tex \`"; fi

test-fo: actual
	@echo BUILD: testing fo
	$(SAXON) -o:$(AR)/test.fo test.xml ../fo/fo.xsl  $(SAXONOPT)
	@echo "Debug:"
	find . -name 'oddbyexample.*'
	@echo ":gudeD"
	$(JING) fo.xsd $(AR)/test.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.fo $(ER)/test.fo; \
		else echo "==deferring: \` diff  $(AR)/test.fo $(ER)/test.fo \`"; fi

	$(SAXON)  test5.xml ../fo/fo.xsl  $(SAXONOPT)  | xmllint --format - > $(AR)/test5.fo
	$(JING) fo.xsd $(AR)/test5.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test5.fo $(ER)/test5.fo; \
		else echo "==deferring: \` diff  $(AR)/test5.fo $(ER)/test5.fo \`"; fi

	$(SAXON) testnotes1.xml ../fo/fo.xsl  $(SAXONOPT)   | xmllint --format - > $(AR)/testnotes1.fo
	$(JING) fo.xsd $(AR)/testnotes1.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/testnotes1.fo $(ER)/testnotes1.fo; \
		else echo "==deferring: \` diff  $(AR)/testnotes1.fo $(ER)/testnotes1.fo \`"; fi

	$(SAXON) -o:$(AR)/test24.fo test24.xml ../fo/fo.xsl $(SAXONOPT)
	$(JING) fo.xsd $(AR)/test24.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test24.fo $(ER)/test24.fo; \
		else echo "==deferring: \` diff  $(AR)/test24.fo $(ER)/test24.fo \`"; fi

	$(SAXON) -o:$(AR)/test25.fo test25.xml ../fo/fo.xsl $(SAXONOPT)
	$(JING) fo.xsd $(AR)/test25.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test25.fo $(ER)/test25.fo; \
		else echo "==deferring: \` diff  $(AR)/test25.fo $(ER)/test25.fo \`"; fi

	$(SAXON) test27.xml ../fo/fo.xsl $(SAXONOPT) | xmllint --format - > $(AR)/test27.fo
	$(JING) fo.xsd $(AR)/test27.fo
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test27.fo $(ER)/test27.fo; \
		else echo "==deferring: \` diff  $(AR)/test27.fo $(ER)/test27.fo \`"; fi

test-epub: actual css
	@echo BUILD: testing epub
	$(BINDIR)/teitoepub3 $(FLAGS) test.xml $(AR)/test_3.epub
	$(JAVAPRE) ../lib/epubcheck3.jar $(AR)/test_3.epub

	$(BINDIR)/teitoepub $(FLAGS) test.xml $(AR)/test.epub
	$(JAVAPRE) ../lib/epubcheck3.jar $(AR)/test.epub

	unzip -t $(AR)/test.epub > $(AR)/test.epub.listing
	if [ $(DIFFNOW) -eq 1 ]; \
		then bash -c 'diff  <(sort $(AR)/test.epub.listing) <(sort $(ER)/test.epub.listing)'; \
		else echo "==deferring: \` bash -c 'diff  <(sort $(AR)/test.epub.listing) <(sort $(ER)/test.epub.listing)' \`"; fi

	$(BINDIR)/teitoepub $(FLAGS) --fileperpage test.xml $(AR)/test-pages.epub
	unzip -t $(AR)/test-pages.epub > $(AR)/test.epub.listing2
	if [ $(DIFFNOW) -eq 1 ]; \
		then bash -c 'diff  <(sort $(AR)/test.epub.listing2) <(sort $(ER)/test.epub.listing2)'; \
		else echo "==deferring: \` bash -c 'diff  <(sort $(AR)/test.epub.listing2) <(sort $(ER)/test.epub.listing2)' \`"; fi

test-rdf: actual
	@echo BUILD: testing rdf
	$(SAXON) -o:$(AR)/test12.rdf test12.xml ../profiles/default/rdf/to.xsl
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test12.rdf $(ER)/test12.rdf; \
		else echo "==deferring: \` diff  $(AR)/test12.rdf $(ER)/test12.rdf \`"; fi

test-text: actual
	@echo BUILD: testing text
	$(BINDIR)/teitotxt $(FLAGS) test14.xml $(AR)/test.text
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.text $(ER)/test.text; \
		else echo "==deferring: \` diff  $(AR)/test.text $(ER)/test.text \`"; fi

test-xlsx: actual
	@echo BUILD: testing xlsx
	$(BINDIR)/xlsxtotei $(FLAGS) test.xlsx $(AR)/test.xlsx.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.xlsx.xml $(ER)/test.xlsx.xml; \
		else echo "==deferring: \` diff  $(AR)/test.xlsx.xml $(ER)/test.xlsx.xml \`"; fi

test-odt:   test.rng
	(cd ..; $(MAKE) names)
	@echo BUILD: testing odt

	$(BINDIR)/teitoodt $(FLAGS) test.xml $(AR)/test.xml.odt
	unzip -t $(AR)/test.xml.odt | sort > $(AR)/test.xml.odt.listing
	if [ $(DIFFNOW) -eq 1 ]; \
		then bash -c 'diff  <(sort $(AR)/test.xml.odt.listing) <(sort $(ER)/test.xml.odt.listing)'; \
		else echo "==deferring: \` bash -c 'diff  <(sort $(AR)/test.xml.odt.listing) <(sort $(ER)/test.xml.odt.listing)' \`"; fi

	unzip -o -q $(AR)/test.xml.odt content.xml
	xmllint --format content.xml > $(AR)/test.xml.odt_content.xml
	rm content.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.xml.odt_content.xml $(ER)/test.xml.odt_content.xml; \
		else echo "==deferring: \` diff  $(AR)/test.xml.odt_content.xml $(ER)/test.xml.odt_content.xml \`"; fi

	$(BINDIR)/odttotei $(FLAGS) test7.odt $(AR)/test7.xml
	$(JING) $(AR)/test.rng $(AR)/test7.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test7.xml $(ER)/test7.xml; \
		else echo "==deferring: \` diff  $(AR)/test7.xml $(ER)/test7.xml \`"; fi

test-from-docx: test.rng
	@echo BUILD: testing from-docx

	$(BINDIR)/docxtotei $(FLAGS) test-indexes.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test-indexes.xml  && rm temp.xml
	$(JING) $(AR)/test.rng $(AR)/test-indexes.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-indexes.xml $(ER)/test-indexes.xml; \
		else echo "==deferring: \` diff  $(AR)/test-indexes.xml $(ER)/test-indexes.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) test11.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl> $(AR)/test11.xml  && rm temp.xml
	$(JING) $(AR)/test.rng $(AR)/test11.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test11.xml $(ER)/test11.xml; \
		else echo "==deferring: \` diff  $(AR)/test11.xml $(ER)/test11.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) --profile=sciencejournal test11.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl> $(AR)/test11a.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test11a.xml $(ER)/test11a.xml; \
		else echo "==deferring: \` diff  $(AR)/test11a.xml $(ER)/test11a.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) test19.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test19.xml  && rm temp.xml
	$(JING) $(AR)/test.rng $(AR)/test19.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test19.xml $(ER)/test19.xml; \
		else echo "==deferring: \` diff  $(AR)/test19.xml $(ER)/test19.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) test18.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test18.xml  && rm temp.xml
	$(JING) $(AR)/test.rng $(AR)/test18.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test18.xml $(ER)/test18.xml; \
		else echo "==deferring: \` diff  $(AR)/test18.xml $(ER)/test18.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) test39.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test39.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test39.xml $(ER)/test39.xml; \
		else echo "==deferring: \` diff  $(AR)/test39.xml $(ER)/test39.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) hyperlinktest.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/hyperlinktest.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/hyperlinktest.xml $(ER)/hyperlinktest.xml; \
		else echo "==deferring: \` diff  $(AR)/hyperlinktest.xml $(ER)/hyperlinktest.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) --profile=transcription test-rtf2tei.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test-rtf2tei.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-rtf2tei.xml $(ER)/test-rtf2tei.xml; \
		else echo "==deferring: \` diff  $(AR)/test-rtf2tei.xml $(ER)/test-rtf2tei.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) --profile=transcription test29.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test29.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test29.xml $(ER)/test29.xml; \
		else echo "==deferring: \` diff  $(AR)/test29.xml $(ER)/test29.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) --profile=tei test37.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test37.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test37.xml $(ER)/test37.xml; \
		else echo "==deferring: \` diff  $(AR)/test37.xml $(ER)/test37.xml \`"; fi

	$(BINDIR)/docxtotei $(FLAGS) --profile=tei test40.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > $(AR)/test40.xml  && rm temp.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test40.xml $(ER)/test40.xml; \
		else echo "==deferring: \` diff  $(AR)/test40.xml $(ER)/test40.xml \`"; fi

test-to-docx:
	@echo BUILD: testing to-docx

	$(BINDIR)/teitodocx $(FLAGS) test.xml
	unzip -p test.xml.docx word/document.xml | xmllint --format - > $(AR)/test.xml.docx_document.xml
	unzip -p test.xml.docx docProps/core.xml | xmllint --format - | sed 's/>20.*Z</>20Z</' > $(AR)/test.xml.docx_core.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.xml.docx_document.xml $(ER)/test.xml.docx_document.xml; \
		else echo "==deferring: \` diff  $(AR)/test.xml.docx_document.xml $(ER)/test.xml.docx_document.xml \`"; fi
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.xml.docx_core.xml $(ER)/test.xml.docx_core.xml; \
		else echo "==deferring: \` diff  $(AR)/test.xml.docx_core.xml $(ER)/test.xml.docx_core.xml \`"; fi

	$(BINDIR)/teitodocx $(FLAGS) test6.xml
	unzip -p test6.xml.docx word/document.xml | xmllint --format - > $(AR)/test6.xml.docx_document.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test6.xml.docx_document.xml $(ER)/test6.xml.docx_document.xml; \
		else echo "==deferring: \` diff  $(AR)/test6.xml.docx_document.xml $(ER)/test6.xml.docx_document.xml \`"; fi

	$(BINDIR)/teitodocx $(FLAGS) testnotes1.xml
	unzip -p testnotes1.xml.docx word/document.xml | xmllint --format - > $(AR)/testnotes1.xml.docx_document.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/testnotes1.xml.docx_document.xml $(ER)/testnotes1.xml.docx_document.xml; \
		else echo "==deferring: \` diff  $(AR)/testnotes1.xml.docx_document.xml $(ER)/testnotes1.xml.docx_document.xml \`"; fi

	$(SAXON) testoucscourses.xml ../profiles/default/p4/from.xsl > $(AR)/testoucscoursesp5.xml
	$(BINDIR)/teitodocx $(FLAGS) --profile=oucscourses $(AR)/testoucscoursesp5.xml $(AR)/testoucscourses.xml.docx

test-oddity: actual css
	@echo BUILD: testing oddity

	$(BINDIR)/teitohtml5 $(FLAGS) --summaryDoc --odd test.odd $(AR)/test.odd.html
	tidy -config config_tidy.txt $(AR)/test.odd.html | perl cleanup.pl> test.temp ; mv test.temp $(AR)/test.odd.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.odd.html $(ER)/test.odd.html; \
		else echo "==deferring: \` diff  $(AR)/test.odd.html $(ER)/test.odd.html \`"; fi

	$(BINDIR)/teitoodd $(FLAGS) test.odd $(AR)/test.processedodd
	$(SAXON) $(AR)/test.processedodd ../odds/extract-isosch.xsl > $(AR)/test.isosch
	perl -i -p -e 's/This file generated [0-9T:Z-]+ by .extract-isosch.xsl./DELETED TIMESTAMP/' $(AR)/test.isosch
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test.isosch $(ER)/test.isosch; \
		else echo "==deferring: \` diff  $(AR)/test.isosch $(ER)/test.isosch \`"; fi

	$(BINDIR)/teitornc $(FLAGS) test21.odd $(AR)/test21.odd.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test21.odd.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test21.odd.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test21.odd.rnc $(ER)/test21.odd.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test21.odd.rnc $(ER)/test21.odd.rnc \`"; fi

	$(BINDIR)/teitornc  $(FLAGS) test15.odd $(AR)/test15.odd.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test15.odd.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test15.odd.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test15.odd.rnc $(ER)/test15.odd.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test15.odd.rnc $(ER)/test15.odd.rnc \`"; fi

	$(BINDIR)/teitohtml5 $(FLAGS) --summaryDoc --lang=es --profile=tei --odd test15.odd $(AR)/test15.odd.html
	tidy -config config_tidy.txt $(AR)/test15.odd.html | perl cleanup.pl> test.temp ; mv test.temp $(AR)/test15.odd.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test15.odd.html $(ER)/test15.odd.html; \
		else echo "==deferring: \` diff  $(AR)/test15.odd.html $(ER)/test15.odd.html \`"; fi

	$(SAXON) -it:main  -xsl:../tools/oddbyexample.xsl corpus=`pwd`/bare | sed 's/<p>Derived from.*/<p\/>/' >  $(AR)/oddbyexample.odd
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/oddbyexample.odd $(ER)/oddbyexample.odd; \
		else echo "==deferring: \` diff  $(AR)/oddbyexample.odd $(ER)/oddbyexample.odd \`"; fi
	$(BINDIR)/teitoxsd  $(FLAGS) $(AR)/oddbyexample.odd  $(AR)/oddbyexample.xsd
	$(BINDIR)/teitornc  $(FLAGS) $(AR)/oddbyexample.odd  $(AR)/oddbyexample.rnc
	$(BINDIR)/teitodtd  $(FLAGS) $(AR)/oddbyexample.odd  $(AR)/oddbyexample.dtd
	$(JING) -c $(AR)/oddbyexample.rnc bare/test2.xml
	$(JING) $(AR)/oddbyexample.xsd bare/test2.xml
	xmllint --noout --dtdvalid $(AR)/oddbyexample.dtd bare/test2.xml
	$(JING) -c $(AR)/oddbyexample.rnc bare/test.xml
	$(JING) $(AR)/oddbyexample.xsd bare/test.xml
	xmllint --noout --dtdvalid $(AR)/oddbyexample.dtd bare/test.xml

	$(SAXON) -s:testdrama.odd -xsl:../odds/odd2odd.xsl -o:$(AR)/testdrama.compiled.xml
	perl -p -i -e 's+ xml:base=".*testdrama.odd"++' $(AR)/testdrama.compiled.xml
	perl -i -pe 'BEGIN{undef $$/;} s/<\?TEIVERSION[^?]+\?>//smg' $(AR)/testdrama.compiled.xml
	perl -i -pe 's+(schemaSpec.*source=")$(DEFAULTSOURCE)+$$1https://www.tei-c.org/Vault/P5/current/xml/tei/odd/p5subset.xml+' $(AR)/testdrama.compiled.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/testdrama.compiled.xml $(ER)/testdrama.compiled.xml; \
		else echo "==deferring: \` diff  $(AR)/testdrama.compiled.xml $(ER)/testdrama.compiled.xml \`"; fi

	$(BINDIR)/teitornc $(FLAGS) test30.odd $(AR)/test30.rnc
	$(BINDIR)/teitodtd $(FLAGS) test30.odd $(AR)/test30.dtd
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test30.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test30.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test30.dtd
	perl -i -pe 'BEGIN{undef $$/;} s/<!--\nDTD[^>]*-->\n//smg' $(AR)/test30.dtd
	$(JING) -c $(AR)/test30.rnc test36.xml
	xmllint --noout --dtdvalid $(AR)/test30.dtd test36.xml
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test30.rnc $(ER)/test30.rnc; \
		else echo "==deferring: -bBw \` diff  $(AR)/test30.rnc $(ER)/test30.rnc \`"; fi
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test30.dtd $(ER)/test30.dtd; \
		else echo "==deferring: \` diff  $(AR)/test30.dtd $(ER)/test30.dtd \`"; fi

# MDH 2017-01-07: THE FOLLOWING LINES WILL integrate LB's new pure ODD 
# master test to replace originals, BUT ONLY WHEN THINGS ARE WORKING PROPERLY.
# Generate DTD from ODD.
#	$(BINDIR)/teitodtd $(FLAGS) testODD.odd testODD.dtd
# Generate RNC from the same file.
#	$(BINDIR)/teitornc $(FLAGS) testODD.odd testODD.rnc
# Trim all sorts of piffle out of the DTD and RNC before we compare them with the expected results.
#	perl -p -i -e 's/generated from ODD source .*//' testODD.dtd
#	perl -i -pe 'BEGIN{undef $$/;} s/<!--\nDTD[^>]*-->\n//smg' testODD.dtd
#	perl -p -i -e 's/generated from ODD source .*//' testODD.rnc
#	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' testODD.rnc
# diff against expected results.
#	if [ $(DIFFNOW) -eq 1 ]; \
#		then diff  testODD.dtd $(ER)/testODD.dtd; fi
#	if [ $(DIFFNOW) -eq 1 ]; \
#		then diff  testODD.rnc $(ER)/testODD.rnc; fi
# NOTE: THERE SHOULD BE VALIDATION OF AN INSTANCE FILE AGAINST THE DTD HERE.	
# OLD ORIGINAL CODE STILL BEING USED FOR THE MOMENT.
	$(BINDIR)/teitodtd $(FLAGS) test-pure.odd $(AR)/test-pure.dtd
	$(BINDIR)/teitornc $(FLAGS) test-pure.odd $(AR)/test-pure.rnc
	xmllint --noout --dtdvalid $(AR)/test-pure.dtd test-pure.xml
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test-pure.dtd
	perl -i -pe 'BEGIN{undef $$/;} s/<!--\nDTD[^>]*-->\n//smg' $(AR)/test-pure.dtd
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test-pure.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test-pure.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test-pure.rnc $(ER)/test-pure.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test-pure.rnc $(ER)/test-pure.rnc \`"; fi
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-pure.dtd $(ER)/test-pure.dtd; \
		else echo "==deferring: \` diff  $(AR)/test-pure.dtd $(ER)/test-pure.dtd \`"; fi
	$(BINDIR)/teitohtml $(FLAGS) --odd test-pure.odd $(AR)/test-pure.odd.html
	tidy -config config_tidy.txt $(AR)/test-pure.odd.html | perl cleanup.pl> test.temp ; mv test.temp $(AR)/test-pure.odd.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-pure.odd.html $(ER)/test-pure.odd.html; \
		else echo "==deferring: \` diff  $(AR)/test-pure.odd.html $(ER)/test-pure.odd.html \`"; fi

	$(BINDIR)/teitodtd $(FLAGS) test-pure2.odd $(AR)/test-pure2.dtd
	$(BINDIR)/teitornc $(FLAGS) test-pure2.odd $(AR)/test-pure2.rnc
	$(BINDIR)/teitohtml $(FLAGS) --odd test-pure2.odd $(AR)/test-pure2.odd.html
	xmllint --noout --dtdvalid $(AR)/test-pure2.dtd test-pure2.xml
	tidy -config config_tidy.txt $(AR)/test-pure2.odd.html | perl cleanup.pl> test.temp ; mv test.temp $(AR)/test-pure2.odd.html
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test-pure2.dtd
	perl -i -pe 'BEGIN{undef $$/;} s/<!--\nDTD[^>]*-->\n//smg' $(AR)/test-pure2.dtd
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test-pure2.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test-pure2.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test-pure2.rnc $(ER)/test-pure2.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test-pure2.rnc $(ER)/test-pure2.rnc \`"; fi
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-pure2.dtd $(ER)/test-pure2.dtd; \
		else echo "==deferring: \` diff  $(AR)/test-pure2.dtd $(ER)/test-pure2.dtd \`"; fi
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test-pure2.odd.html $(ER)/test-pure2.odd.html; \
		else echo "==deferring: \` diff  $(AR)/test-pure2.odd.html $(ER)/test-pure2.odd.html \`"; fi

	$(SAXON) test.odd ../odds/odd2odd.xsl > $(AR)/test.odd2odd
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2dtd.xsl > $(AR)/test.odd2dtd
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2html.xsl > $(AR)/test.odd2html
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2json.xsl > $(AR)/test.odd2json
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2lite.xsl > $(AR)/test.odd2lite
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2relax.xsl > $(AR)/test.odd2relax
	$(SAXON) $(AR)/test.odd2odd ../odds/odd2xslstripspace.xsl > $(AR)/test.odd2xslstripspace
	rm $(AR)/test.odd2odd
	rm $(AR)/test.odd2dtd
	rm $(AR)/test.odd2html
	rm $(AR)/test.odd2json
	rm $(AR)/test.odd2lite
	rm $(AR)/test.odd2relax
	rm $(AR)/test.odd2xslstripspace

moreoddity: actual
	$(BINDIR)/teitoxsd $(FLAGS) test.odd $(AR)/test.xsd
	$(BINDIR)/teitodtd $(FLAGS) test.odd $(AR)/test.dtd
	$(BINDIR)/teitornc $(FLAGS) test.odd $(AR)/test.rnc

test-namespaces: actual
	@echo BUILD: testing namespaces
# This test checks the rnc files so that to make sure we are testing
# what we think we are testing.
	$(BINDIR)/teitornc $(FLAGS) test33.odd $(AR)/test33.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test33.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test33.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test33.rnc $(ER)/test33.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test33.rnc $(ER)/test33.rnc \`"; fi
	$(SAXON) test33.odd ../odds/odd2json.xsl > $(AR)/test33.json
	perl -p -i -e 's/"date" : "\d+-\d+\-\d+T\d+:\d+:\d+Z",//' $(AR)/test33.json
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test33.json $(ER)/test33.json; \
		else echo "==deferring: \` diff  $(AR)/test33.json $(ER)/test33.json \`"; fi

	$(BINDIR)/teitornc $(FLAGS) test34.odd $(AR)/test34.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test34.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test34.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test34.rnc $(ER)/test34.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test34.rnc $(ER)/test34.rnc \`"; fi
	$(SAXON) test34.odd ../odds/odd2json.xsl > $(AR)/test34.json
	perl -p -i -e 's/"date" : "\d+-\d+\-\d+T\d+:\d+:\d+Z",//' $(AR)/test34.json
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test34.json $(ER)/test34.json; \
		else echo "==deferring: \` diff  $(AR)/test34.json $(ER)/test34.json \`"; fi
	$(SAXON) test34.odd ../odds/odd2odd.xsl > $(AR)/test34.combined.odd
	$(SAXON) $(AR)/test34.combined.odd ../odds/odd2json.xsl > $(AR)/test34.combined.json
	perl -p -i -e 's/"date" : "\d+-\d+\-\d+T\d+:\d+:\d+Z",//' $(AR)/test34.combined.json
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test34.combined.json $(ER)/test34.combined.json; \
		else echo "==deferring: \` diff  $(AR)/test34.combined.json $(ER)/test34.combined.json \`"; fi
	$(BINDIR)/teitohtml $(FLAGS) --odd --summaryDoc test34.odd $(AR)/test34.odd.html
	tidy -config config_tidy.txt $(AR)/test34.odd.html | perl cleanup.pl> test.temp ; mv test.temp $(AR)/test34.odd.html
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff  $(AR)/test34.odd.html $(ER)/test34.odd.html; \
		else echo "==deferring: \` diff  $(AR)/test34.odd.html $(ER)/test34.odd.html \`"; fi

	$(BINDIR)/teitornc $(FLAGS) test35.odd $(AR)/test35.rnc
	perl -p -i -e 's/generated from ODD source .*//' $(AR)/test35.rnc
	perl -i -pe 'BEGIN{undef $$/;} s/# ?Schema[^#]+#[^#]+#[^#]+#[^#]+#\n//smg' $(AR)/test35.rnc
	if [ $(DIFFNOW) -eq 1 ]; \
		then diff -bBw $(AR)/test35.rnc $(ER)/test35.rnc; \
		else echo "==deferring: \` diff -bBw $(AR)/test35.rnc $(ER)/test35.rnc \`"; fi

test-scripts:
	for i in $(SCRIPTS); do $(BINDIR)/$$i $(FLAGS) maria.xml $$i.result && rm $$i.result; done
	$(BINDIR)/teitoodd $(FLAGS) test16.odd temp.odd
	for i in $(SCHEMASCRIPTS) ; do $(BINDIR)/$$i $(FLAGS) temp.odd $$i.result && rm $$i.result; done
	rm temp.odd

test-pureant:
	java -Djava.awt.headless=true -Xmx256m \
	-classpath  "$(OXY)/tools/ant/lib/ant-launcher.jar" \
	-Dant.home=$(OXY)/tools/ant \
	org.apache.tools.ant.launch.Launcher \
	-f ../docx/build-to.xml \
	-lib $(OXY)/lib/saxon9ee.jar \
	-DoutputFile=`pwd`/test7.docx \
	-DinputFile=`pwd`/test7.xml -Dprofile=default
	java -Djava.awt.headless=true -Xmx256m \
	-classpath  "$(OXY)/tools/ant/lib/ant-launcher.jar" \
	-Dant.home=$(OXY)/tools/ant \
	org.apache.tools.ant.launch.Launcher \
	-f ../docx/build-from.xml \
	-lib $(OXY)/lib/saxon9ee.jar \
	-DoutputFile=`pwd`/test29.xml \
	-DinputFile=`pwd`/test29.docx -Dprofile=default

test-oxgarage:
	@echo BUILD: testing oxgarage
	curl -s -F upload=@test.odd  -o test.rng http://oxgarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng
	curl -s -F upload=@test.odd  -o test.zip http://oxgarage.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/xsd%3Aapplication%3Axml-xsd/

test-oxgarage-tei:
	@echo BUILD: testing oxgarage-tei
	curl -s  -F upload=@test.odd  -o test.rng http://www.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng
	curl -s  -F upload=@test.odd  -o test.zip http://www.tei-c.org/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/xsd%3Aapplication%3Axml-xsd/

profile:
	$(SAXON) -o:/dev/null	-TP test.xml ../html/html.xsl >& profile1.html
	$(SAXON) -o:/dev/null	-TP test.xml ../latex/latex.xsl >& profile2.html
	$(SAXON) test.odd ../odds/odd2odd.xsl > test.odd2odd
	$(SAXON) -o:/dev/null -TP test.odd2odd ../odds/odd2relax.xsl >& profile3.html

clean:
	(cd ..; for i in css/*; do rm -f `basename $$i`;done)
	rm -f teitopdf.result.* test*.xml.docx *~
	rm -f dcr.tmp xml.tmp
	rm -fr $(AR)/ charts/ embeddings/ media/ Pictures/

oddtree:
	$(SAXON) -s:http://www.tei-c.org/release/xml/tei/odd/p5subset.xml -xsl:../tools/odd-to-tree.xsl -o:oddtree.xml
	../bin/teitohtml --profile=oxford oddtree.xml oddtree.html
