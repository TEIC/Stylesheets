VERSION=`cat VERSION`
FLAG=
BINDIR=../bin
SAXONOPT=useFixedDate=true
SAXON=java -Djava.awt.headless=true -jar lib/saxon9he.jar
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
	teitoslides \
	teitotxt 

SCHEMASCRIPTS=teitornc \
	teitorelaxng \
	teitoxsd \
	teitodtd 

default: test-html test-to-docx test-from-docx

css:
	(cd ..; for i in css/*; do test -f `basename $$i` || ln -s $$i `basename $$i`;done)

test-sciencejournal:
	@echo BUILD: testing from-docx sciencejournal
	$(BINDIR)/docxtotei --profile=sciencejournal 95534.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > 95534.xml  && rm temp.xml
# do not validate for now
#	$(JING) test.rng 95534.xml
	diff 95534.xml expected-results/95534.xml
	$(BINDIR)/teitohtml --profile=sciencejournal 95534.xml test.html
	xmllint --encode utf-8 --format test.html | perl cleanup.pl > test.temp
	mv test.temp 95534.html

	$(BINDIR)/docxtotei --profile=sciencejournal 95122.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > 95122.xml  && rm temp.xml
# do not validate for now
#	$(JING) test.rng 95122.xml
	diff 95122.xml expected-results/95534.xml
	$(BINDIR)/teitohtml --profile=sciencejournal 95122.xml test.html
	xmllint --encode utf-8 --format test.html | perl cleanup.pl > test.temp
	mv test.temp 95122.html

test-html: css
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
	(mkdir files; cd files; saxon ../testnotes1.xml ../../html/html.xsl splitLevel=4 useFixedDate=true STDOUT=false cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/two.html > x ; mv x files/two.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes
	rm -rf files
	(mkdir files; cd files; saxon ../testnotes2.xml ../../html/html.xsl splitLevel=0 useFixedDate=true STDOUT=false cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes2
	rm -rf files
	(mkdir files; cd files; saxon ../testnotes2.xml ../../html/html.xsl splitLevel=4 useFixedDate=true STDOUT=false  cssFile=../../tei.css)
	xmllint --format files/index.html > x ; mv x files/index.html
	xmllint --format files/one.html > x ; mv x files/one.html
	xmllint --format files/two.html > x ; mv x files/two.html
	xmllint --format files/three.html > x ; mv x files/three.html
	diff -r  files expected-results/testnotes3
	$(SAXON) -o:test24.html test24.xml ../html/html.xsl $(SAXONOPT)
	diff test24.html expected-results/test24.html
	$(SAXON) test25.xml ../html/html.xsl $(SAXONOPT) | xmllint --format - > test25.html 
	diff test25.html expected-results/test25.html
	$(SAXON) test27.xml ../html/html.xsl $(SAXONOPT) cssFile=../tei.css cssSecondaryFile=../css/msdescription.css  | xmllint --format - > test27.html
	diff test27.html expected-results/test27.html
	rm -rf files
	$(SAXON) test28.xml ../html/html.xsl splitLevel=0  STDOUT=false $(SAXONOPT) 
	xmllint --format index.html > x ; mv x index.html
	diff index.html expected-results/test28.html
	$(SAXON) test31.xml ../html/html.xsl cssFile="" cssInlineFile=../tei.css $(SAXONOPT)  | xmllint --format - > test31.html
	diff test31.html expected-results/test31.html
	$(SAXON) test32.xml ../html/html.xsl cssFile="" cssInlineFile=../tei.css $(SAXONOPT)  | xmllint --format - > test32.html
	diff test32.html expected-results/test32.html


test-from-docx:
	@echo BUILD: testing from-docx
	$(BINDIR)/docxtotei test-indexes.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test-indexes.xml  && rm temp.xml
	$(JING) test.rng test-indexes.xml
	diff test-indexes.xml expected-results/test-indexes.xml
	$(BINDIR)/docxtotei test11.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl> test11.xml  && rm temp.xml
	$(JING) test.rng test11.xml
	diff test11.xml expected-results/test11.xml
	$(BINDIR)/docxtotei test19.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test19.xml  && rm temp.xml
	$(JING) test.rng test19.xml
	diff test19.xml expected-results/test19.xml
	$(BINDIR)/docxtotei test18.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test18.xml  && rm temp.xml
	$(JING) test.rng test18.xml
	diff test18.xml expected-results/test18.xml
	$(BINDIR)/docxtotei --profile=transcription test-rtf2tei.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test-rtf2tei.xml  && rm temp.xml
	diff test-rtf2tei.xml expected-results/test-rtf2tei.xml
	$(BINDIR)/docxtotei --profile=transcription test29.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test29.xml  && rm temp.xml
	diff test29.xml expected-results/test29.xml
	$(BINDIR)/docxtotei --profile=tei test37.docx temp.xml
	xmllint --format temp.xml | perl cleanup.pl > test37.xml  && rm temp.xml
	diff test37.xml expected-results/test37.xml

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


