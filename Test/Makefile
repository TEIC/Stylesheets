VERSION=`cat VERSION`
FLAG=
BINDIR=../bin
SAXONOPT=useFixedDate=true
SAXON=java -Djava.awt.headless=true -jar ../lib/saxon9he.jar
DOTDOTSAXON=java -Djava.awt.headless=true -jar ../../lib/saxon9he.jar
JING=java -Djava.awt.headless=true -jar lib/jing-20120724.0.0.jar 
OXY=/usr/share/oxygen
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

default: test.rng test-to-html test-p4top5 test-oddity test-scripts test-namespaces test-from-html test-latex test-fo test-to-docx test-from-docx test-xlsx test-rdf test-text test-odt  test-markdown test-cocoa test-epub 

test.rng:
	$(BINDIR)/teitorelaxng --odd test.odd test.rng
	perl -p -e 's/generated from ODD source.*//' test.rng | xmllint --format - > temp; mv temp test.rng
	diff test.rng expected-results/test.rng

css:
	(cd ..; for i in css/*; do test -f `basename $$i` || ln -s $$i `basename $$i`;done)

test-to-html: css
	@echo BUILD: testing html
	$(SAXON)  test.xml ../html/html.xsl cssFile=../tei.css $(SAXONOPT) | xmllint --format - > test.html
	diff test.html expected-results/test.html
	$(SAXON) test.html checklinks.xsl
	$(SAXON) test.xml ../html/html.xsl cssFile=../tei.css pageLayout=Complex  $(SAXONOPT)  | xmllint --format - > test-complex.html
	diff test-complex.html expected-results/test-complex.html
	$(SAXON) test.xml ../profiles/ota/html/to.xsl cssFile=../tei.css $(SAXONOPT)  | xmllint --format - | perl cleanup.pl > test-ota.html
	diff test-ota.html expected-results/test-ota.html
	$(BINDIR)/teitohtml5 test.xml test.html5
	xmllint --encode utf-8 --format test.html5 | perl cleanup.pl > test.temp
	mv test.temp test.html5
	diff test.html5 expected-results/test.html5
	$(SAXON) test20.xml ../html/html.xsl $(SAXONOPT) | xmllint --format - > test20.html
	diff test20.html expected-results/test20.html
	$(SAXON) -versionmsg:off  test3.xml ../html/html.xsl $(SAXONOPT)| xmllint --format - > test3.html
	$(SAXON) -versionmsg:off  test4.xml ../html/html.xsl $(SAXONOPT)| xmllint --format - > test4.html
	diff test4.html test3.html
	$(SAXON) test5.xml ../html/html.xsl  autoBlockQuote=true $(SAXONOPT)  | xmllint --format - > test5.xhtml
	diff test5.xhtml expected-results/test5.xhtml
	$(JING) -c xhtml.rnc test5.xhtml
	$(SAXON) test6.xml ../html/html.xsl  autoBlockQuote=true $(SAXONOPT)  | xmllint --format - > test6.html
	diff test6.html expected-results/test6.html
	$(JING) -c xhtml.rnc test6.html
	$(SAXON) test14.xml ../html/html.xsl $(SAXONOPT)| xmllint --format - > test14.html
	diff test14.html expected-results/test14.html
	$(SAXON) test22.xml ../html/html.xsl $(SAXONOPT)| xmllint --format - > test22.html
	diff test22.html expected-results/test22.html
	$(SAXON) test23.xml ../html/html.xsl $(SAXONOPT)| xmllint --format - > test23.html
	diff test23.html expected-results/test23.html
	(mkdir files; cd files;$(DOTDOTSAXON) ../testnotes1.xml ../../html/html.xsl splitLevel=4 useFixedDate=true STDOUT=false cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/two.html > x ; mv x files/two.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes
	rm -rf files
	(mkdir files; cd files;$(DOTDOTSAXON) ../testnotes2.xml ../../html/html.xsl splitLevel=0 useFixedDate=true STDOUT=false cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes2
	rm -rf files
	(mkdir files; cd files;$(DOTDOTSAXON) ../testnotes2.xml ../../html/html.xsl splitLevel=4 useFixedDate=true STDOUT=false  cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/two.html > x ; mv x files/two.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes3
	$(SAXON) test24.xml ../html/html.xsl $(SAXONOPT) | xmllint --format - > test24.html
	diff test24.html expected-results/test24.html
	$(SAXON) test25.xml ../html/html.xsl $(SAXONOPT) | xmllint --format - > test25.html 
	diff test25.html expected-results/test25.html
	$(SAXON) test27.xml ../html/html.xsl $(SAXONOPT) cssFile=../tei.css cssSecondaryFile=../css/msdescription.css  | xmllint --format - > test27.html
	diff test27.html expected-results/test27.html
	rm -rf files
	$(SAXON) test28.xml ../html/html.xsl splitLevel=0  STDOUT=false $(SAXONOPT) 
	xmllint --format index.html > x ; mv x index.html
	diff index.html expected-results/test28.html
	$(SAXON) test31.xml ../html/html.xsl cssFile="" cssInlineFiles=../tei.css $(SAXONOPT)  | xmllint --format - > test31.html
	diff test31.html expected-results/test31.html
	$(SAXON) test32.xml ../html/html.xsl cssFile="" cssInlineFiles=../tei.css $(SAXONOPT)  | xmllint --format - > test32.html
	diff test32.html expected-results/test32.html

test-from-html:
	$(SAXON) test38.htm ../html/html2tei.xsl $(SAXONOPT)  | xmllint --format - > test38.xml
	diff test38.xml expected-results/test38.xml

test-markdown: 
	@echo BUILD: testing markdown 
	@echo BUILD: markdown to tei 
	$(BINDIR)/markdowntotei mdtest1.md mdtest1.xml
	diff mdtest1.xml expected-results/mdtest1.xml
	@echo BUILD: tei to markdown
	$(BINDIR)/teitomarkdown test.xml mdtest2.md
	diff mdtest2.md expected-results/mdtest2.md

test-cocoa: 
	@echo BUILD: testing cocoa  to TEI
	$(BINDIR)/cocoatotei cocoatest.txt cocoatest.xml
	diff cocoatest.xml expected-results/cocoatest.xml
	$(BINDIR)/cocoatotei cocoatest2.txt cocoatest2.xml
	diff cocoatest2.xml expected-results/cocoatest2.xml

test-p4top5: 
	@echo BUILD: testing p4top5
	$(SAXON) -o:test17.tei test17.xml ../profiles/default/p4/from.xsl
	diff test17.tei expected-results/test17.tei
	$(SAXON) A54031.tcp ../tcp/tcp2tei.xsl | xmllint --format - > A54031.xml
	diff A54031.xml expected-results/A54031.xml

testsplit:
	$(SAXON) test6.xml ../html/html.xsl STDOUT=false verbose=true splitLevel=1 useFixedDate=true


test-latex:
	@echo BUILD: testing latex
	$(SAXON) -o:test.tex test.xml ../latex/latex.xsl  $(SAXONOPT)
	diff test.tex expected-results/test.tex
	$(SAXON) -o:testnotes1.tex testnotes1.xml ../latex/latex.xsl  $(SAXONOPT)
	diff testnotes1.tex expected-results/testnotes1.tex
	$(SAXON) -o:test5.tex test5.xml ../latex/latex.xsl  $(SAXONOPT)
	diff test5.tex expected-results/test5.tex
	$(SAXON) -o:test6.tex test6.xml ../slides/teilatex-slides.xsl $(SAXONOPT)
	diff test6.tex expected-results/test6.tex
	$(SAXON) -o:test20.tex test20.xml ../latex/latex.xsl $(SAXONOPT)
	diff test20.tex expected-results/test20.tex
	$(SAXON) -o:test23.tex test23.xml ../latex/latex.xsl $(SAXONOPT)
	diff test23.tex expected-results/test23.tex
	$(SAXON) -o:test24.tex test24.xml ../latex/latex.xsl $(SAXONOPT)
	diff test24.tex expected-results/test24.tex
	$(SAXON) -o:test25.tex test25.xml ../latex/latex.xsl $(SAXONOPT)
	diff test25.tex expected-results/test25.tex
	$(SAXON) -o:test27.tex test27.xml ../latex/latex.xsl $(SAXONOPT)
	diff test27.tex expected-results/test27.tex

test-fo:
	@echo BUILD: testing fo
	$(SAXON) -o:test.fo test.xml ../fo/fo.xsl  $(SAXONOPT)
	$(JING) fo.xsd test.fo
	diff test.fo expected-results/test.fo
	$(SAXON)  test5.xml ../fo/fo.xsl  $(SAXONOPT)  | xmllint --format - > test5.fo
	$(JING) fo.xsd test5.fo
	diff test5.fo expected-results/test5.fo
	$(SAXON) testnotes1.xml ../fo/fo.xsl  $(SAXONOPT)   | xmllint --format - > testnotes1.fo
	$(JING) fo.xsd testnotes1.fo
	diff testnotes1.fo expected-results/testnotes1.fo 
	$(SAXON) -o:test24.fo test24.xml ../fo/fo.xsl $(SAXONOPT)
	$(JING) fo.xsd test24.fo 
	diff test24.fo expected-results/test24.fo
	$(SAXON) -o:test25.fo test25.xml ../fo/fo.xsl $(SAXONOPT)
	diff test25.fo expected-results/test25.fo
	$(SAXON) test27.xml ../fo/fo.xsl $(SAXONOPT) | xmllint --format - > test27.fo 
	diff test27.fo expected-results/test27.fo

test-epub:
	@echo BUILD: testing epub
	$(BINDIR)/teitoepub3  test.xml test.epub
	java -Djava.awt.headless=true -jar epubcheck3.jar test.epub
	$(BINDIR)/teitoepub  test.xml test.epub
	java -Djava.awt.headless=true -jar epubcheck3.jar  test.epub
	unzip -t test.epub > test.epub.listing
	diff test.epub.listing expected-results/test.epub.listing
	rm test.epub.listing
	$(BINDIR)/teitoepub  --fileperpage test.xml test-pages.epub
	unzip -t test-pages.epub > test.epub.listing2
	diff test.epub.listing2 expected-results/test.epub.listing2
	rm test.epub.listing2

test-rdf:
	@echo BUILD: testing rdf
	$(SAXON) -o:test12.rdf test12.xml ../profiles/default/rdf/to.xsl
	diff test12.rdf expected-results/test12.rdf

test-text:
	@echo BUILD: testing text
	$(BINDIR)/teitotxt test14.xml test.text
	diff test.text expected-results/test.text

test-xlsx:
	@echo BUILD: testing xlsx
	$(BINDIR)/xlsxtotei test.xlsx test.xlsx.xml
	diff test.xlsx.xml expected-results/test.xlsx.xml

test-odt:   test.rng
	(cd ..; $(MAKE) names)
	@echo BUILD: testing odt
	$(BINDIR)/teitoodt test.xml 
	unzip -t test.xml.odt > test.xml.odt.listing
	unzip -o -q test.xml.odt content.xml
	xmllint --format content.xml > content.xml.odt.listing
	diff test.xml.odt.listing expected-results/test.xml.odt.listing
	diff content.xml.odt.listing expected-results/content.xml.odt.listing
	$(BINDIR)/odttotei test7.odt test7.xml
	$(JING) test.rng test7.xml
	diff test7.xml expected-results/test7.xml

test-from-docx: test.rng
	@echo BUILD: testing from-docx
	$(BINDIR)/docxtotei test-indexes.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test-indexes.xml  && rm temp.xml
	$(JING) test.rng test-indexes.xml
	diff test-indexes.xml expected-results/test-indexes.xml
	$(BINDIR)/docxtotei test11.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl> test11.xml  && rm temp.xml
	$(JING) test.rng test11.xml
	diff test11.xml expected-results/test11.xml
	$(BINDIR)/docxtotei --profile=sciencejournal test11.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl> test11a.xml  && rm temp.xml
	diff test11a.xml expected-results/test11a.xml
	$(BINDIR)/docxtotei test19.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test19.xml  && rm temp.xml
	$(JING) test.rng test19.xml
	diff test19.xml expected-results/test19.xml
	$(BINDIR)/docxtotei test18.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test18.xml  && rm temp.xml
	$(JING) test.rng test18.xml
	diff test18.xml expected-results/test18.xml
	$(BINDIR)/docxtotei test39.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test39.xml  && rm temp.xml
	diff test39.xml expected-results/test39.xml
	$(BINDIR)/docxtotei --profile=transcription test-rtf2tei.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test-rtf2tei.xml  && rm temp.xml
	diff test-rtf2tei.xml expected-results/test-rtf2tei.xml
	$(BINDIR)/docxtotei --profile=transcription test29.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test29.xml  && rm temp.xml
	diff test29.xml expected-results/test29.xml
	$(BINDIR)/docxtotei --profile=tei test37.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test37.xml  && rm temp.xml
	diff test37.xml expected-results/test37.xml
	$(BINDIR)/docxtotei --profile=tei test40.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test40.xml  && rm temp.xml
	diff test40.xml expected-results/test40.xml

test-to-docx:
	@echo BUILD: testing to-docx
	$(BINDIR)/teitodocx test.xml 
	unzip -p test.xml.docx word/document.xml | xmllint --format - > test.xml.docx.document
	unzip -p test.xml.docx docProps/core.xml | xmllint --format - | sed 's/>20.*Z</>20Z</' > test.xml.docx.core
	diff test.xml.docx.document expected-results/test.xml.docx.document
	diff test.xml.docx.core expected-results/test.xml.docx.core
	rm test.xml.docx.document
	$(BINDIR)/teitodocx test6.xml 
	unzip -p test6.xml.docx word/document.xml | xmllint --format - > test6.xml.docx.document
	diff test6.xml.docx.document expected-results/test6.xml.docx.document
	rm test6.xml.docx.document
	$(BINDIR)/teitodocx testnotes1.xml 
	unzip -p testnotes1.xml.docx word/document.xml | xmllint --format - > testnotes1.xml.docx.document
	diff testnotes1.xml.docx.document expected-results/testnotes1.xml.docx.document
	rm testnotes1.xml.docx.document
	$(SAXON) testoucscourses.xml ../profiles/default/p4/from.xsl > testoucscoursesp5.xml
	$(BINDIR)/teitodocx --profile=oucscourses testoucscoursesp5.xml testoucscourses.xml.docx
	rm testoucscourses.xml.docx testoucscoursesp5.xml

test-oddity: css
	@echo BUILD: testing oddity
	$(BINDIR)/teitohtml5 $(FLAG) --summaryDoc --odd test.odd test.odd.html
	xmllint --encode utf-8 --format test.odd.html | perl cleanup.pl> test.temp ; mv test.temp test.odd.html
	diff test.odd.html expected-results/test.odd.html
	$(BINDIR)/teitoodd test.odd test.processedodd
	$(SAXON) test.processedodd ../odds/extract-isosch.xsl > test.isosch
	perl -i -p -e 's/generated .* by /generated by /' test.isosch
	diff test.isosch expected-results/test.isosch
	$(BINDIR)/teitornc  $(FLAG) test21.odd test21.odd.rnc
	perl -p -i -e 's/generated from ODD source.*//' test21.odd.rnc
	diff test21.odd.rnc expected-results/test21.odd.rnc 
	$(BINDIR)/teitornc  $(FLAG) test15.odd test15.odd.rnc
	perl -p -i -e 's/generated from ODD source.*//' test15.odd.rnc
	diff test15.odd.rnc expected-results/test15.odd.rnc 
	$(BINDIR)/teitohtml5 $(FLAG) --summaryDoc --lang=es --profile=tei --odd test15.odd test15.odd.html
	xmllint --encode utf-8 --format test15.odd.html | perl cleanup.pl> test.temp ; mv test.temp test15.odd.html
	diff test15.odd.html expected-results/test15.odd.html
	$(SAXON) -it:main  -xsl:../tools/oddbyexample.xsl corpus=`pwd`/bare | sed 's/<p>Derived from.*/<p\/>/' >  oddbyexample.odd
	diff oddbyexample.odd expected-results/oddbyexample.odd
	$(BINDIR)/teitoxsd  $(FLAG) oddbyexample.odd  oddbyexample.xsd
	$(BINDIR)/teitornc  $(FLAG) oddbyexample.odd  oddbyexample.rnc
	$(BINDIR)/teitodtd  $(FLAG) oddbyexample.odd  oddbyexample.dtd
	$(JING) -c oddbyexample.rnc bare/test2.xml
	$(JING) oddbyexample.xsd bare/test2.xml
	xmllint --noout --dtdvalid oddbyexample.dtd bare/test2.xml
	$(JING) -c oddbyexample.rnc bare/test.xml
	$(JING) oddbyexample.xsd bare/test.xml
	#xmllint --noout --dtdvalid oddbyexample.dtd bare/test.xml
	$(SAXON) -s:testdrama.odd -xsl:../odds/odd2odd.xsl -o:testdrama.compiled.xml \
	localsource=`pwd`/p5subset.xml $(SAXONOPT) 
	perl -p -i -e 's+ xml:base=".*testdrama.odd"++' testdrama.compiled.xml
	diff testdrama.compiled.xml expected-results/testdrama.compiled.xml
	$(BINDIR)/teitornc $(FLAG) test30.odd test30.rnc
	$(BINDIR)/teitodtd $(FLAG) test30.odd test30.dtd
	perl -p -i -e 's/generated from ODD source .*//' test30.rnc
	perl -p -i -e 's/generated from ODD source .*//' test30.dtd
	$(JING) -c test30.rnc test36.xml
	xmllint --noout --dtdvalid test30.dtd test36.xml
	diff test30.rnc expected-results/test30.rnc
	diff test30.dtd expected-results/test30.dtd
	$(BINDIR)/teitodtd $(FLAG) test-pure.odd test-pure.dtd
	$(BINDIR)/teitornc $(FLAG) test-pure.odd test-pure.rnc
	xmllint --noout --dtdvalid test-pure.dtd test-pure.xml
	perl -p -i -e 's/generated from ODD source .*//' test-pure.dtd
	perl -p -i -e 's/generated from ODD source .*//' test-pure.rnc
	diff test-pure.rnc expected-results/test-pure.rnc
	diff test-pure.dtd expected-results/test-pure.dtd
	$(BINDIR)/teitohtml $(FLAG) --odd test-pure.odd test-pure.odd.html
	xmllint --encode utf-8 --format test-pure.odd.html | perl cleanup.pl> test.temp ; mv test.temp test-pure.odd.html
	diff test-pure.odd.html expected-results/test-pure.odd.html
	$(BINDIR)/teitodtd $(FLAG) test-pure2.odd test-pure2.dtd
	$(BINDIR)/teitornc $(FLAG) test-pure2.odd test-pure2.rnc
	$(BINDIR)/teitohtml $(FLAG) --odd test-pure2.odd test-pure2.odd.html
	xmllint --noout --dtdvalid test-pure2.dtd test-pure2.xml
	xmllint --encode utf-8 --format test-pure2.odd.html | perl cleanup.pl> test.temp ; mv test.temp test-pure2.odd.html
	perl -p -i -e 's/generated from ODD source .*//' test-pure2.dtd
	perl -p -i -e 's/generated from ODD source .*//' test-pure2.rnc
	diff test-pure2.rnc expected-results/test-pure2.rnc
	diff test-pure2.dtd expected-results/test-pure2.dtd
	diff test-pure2.odd.html expected-results/test-pure2.odd.html
	$(SAXON) test.odd ../odds/odd2odd.xsl > test.odd2odd
	$(SAXON) test.odd2odd ../odds/odd2dtd.xsl > test.odd2dtd
	$(SAXON) test.odd2odd ../odds/odd2html.xsl > test.odd2html
	$(SAXON) test.odd2odd ../odds/odd2json.xsl > test.odd2json
	$(SAXON) test.odd2odd ../odds/odd2lite.xsl > test.odd2lite
	$(SAXON) test.odd2odd ../odds/odd2relax.xsl > test.odd2relax
	$(SAXON) test.odd2odd ../odds/odd2xslstripspace.xsl > test.odd2xslstripspace
	rm test.odd2odd
	rm test.odd2dtd
	rm test.odd2html
	rm test.odd2json
	rm test.odd2lite
	rm test.odd2relax
	rm test.odd2xslstripspace

moreoddity:
	$(BINDIR)/teitoxsd test.odd test.xsd
	$(BINDIR)/teitodtd test.odd test.dtd
	$(BINDIR)/teitornc test.odd test.rnc

test-namespaces:
	@echo BUILD: testing namespaces
# This test checks the rnc files so that to make sure we are testing
# what we think we are testing.
	$(BINDIR)/teitornc test33.odd test33.rnc
	perl -p -i -e 's/generated from ODD source .*//' test33.rnc
	diff test33.rnc expected-results/test33.rnc
	$(SAXON) test33.odd ../odds/odd2json.xsl > test33.json
	perl -p -i -e 's/"date":"\d+-\d+\-\d+T\d+:\d+:\d+Z",//' test33.json
	diff test33.json expected-results/test33.json
	$(BINDIR)/teitornc test34.odd test34.rnc
	perl -p -i -e 's/generated from ODD source .*//' test34.rnc
	diff test34.rnc expected-results/test34.rnc
	$(SAXON) test34.odd ../odds/odd2json.xsl > test34.json
	perl -p -i -e 's/"date":"\d+-\d+\-\d+T\d+:\d+:\d+Z",//' test34.json
	diff test34.json expected-results/test34.json
	$(SAXON) test34.odd ../odds/odd2odd.xsl > test34.combined.odd
	$(SAXON) test34.combined.odd ../odds/odd2json.xsl > test34.combined.json
	perl -p -i -e 's/"date":"\d+-\d+\-\d+T\d+:\d+:\d+Z",//' test34.combined.json
	diff test34.combined.json expected-results/test34.combined.json
	$(BINDIR)/teitohtml --odd --summaryDoc test34.odd test34.odd.html
	xmllint --encode utf-8 --format test34.odd.html | perl cleanup.pl> test.temp ; mv test.temp test34.odd.html
	diff test34.odd.html expected-results/test34.odd.html
	$(BINDIR)/teitornc test35.odd test35.rnc
	perl -p -i -e 's/generated from ODD source .*//' test35.rnc
	diff test35.rnc expected-results/test35.rnc

test-scripts:
	for i in $(SCRIPTS); do $(BINDIR)/$$i maria.xml $$i.result && rm $$i.result; done
	$(BINDIR)/teitoodd test16.odd temp.odd
	for i in $(SCHEMASCRIPTS) ; do $(BINDIR)/$$i temp.odd $$i.result && rm $$i.result; done
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
	curl -s -F upload=@test.odd  -o test.rng http://oxgarage.oucs.ox.ac.uk:8080/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng
	curl -s -F upload=@test.odd  -o test.zip http://oxgarage.oucs.ox.ac.uk:8080/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/xsd%3Aapplication%3Axml-xsd/

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
	rm -f  test*.odd.rnc test*epub test*pdf test*rdf test*text test*.xml.docx test*.xml.odt test*.tex test*.fo *.html *.xhtml *~ dummy* test.html test3.html test4.html *aux *vrb *out *log *nav *ent *snm *toc *.end *.1 *.2 test.xsd test.zip test*.dtd test-indexes.xml test37.xml test38.xml test39.xml test40.xml
	rm -f test*.rnc test*.json test*.rnc test*.combined.odd test*listing* test*.tei test*.rng test*.html5 test*.processedodd *.isosch
	rm -f oddbyexample.* index*div*html
	rm -f testdrama.compiled.xml
	rm -f test5.odt test7.xml test18.xml test19.xml test-index.xml test7.zip test11.xml test9.docx test9.odt content.xml.odt.listing content.xml.odt test.xml.docx.core test7.docx
	rm -f A54031.xml dcr.result test-rtf2tei.xml test29.xml
	rm -f xml.result
	rm -rf charts/ embeddings/ media/ _rels/ \[Content_Types\].xml
	rm -rf temp-dir-for-ant Pictures OEBPS META-INF mimetype files
	rm -f test.xlsx.xml *.result.tex *.result.pdf _slidelogo.png
	rm -f content.xml
	rm -f cocoatest*.xml

oddtree:
	saxon /usr/share/xml/tei/odd/p5subset.xml odd-to-tree.xsl  > oddtree.xml
	teitohtml --profile=oxford oddtree.xml oddtree.html

