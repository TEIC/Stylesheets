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

default: test-sciencejournal clean

css:
	(cd ..; for i in css/*; do test -f `basename $$i` || ln -s $$i `basename $$i`;done)

test-sciencejournal:
	@echo BUILD: testing from-docx sciencejournal


	for i in *.docx; do \
	$(BINDIR)/docxtotei --profile=sciencejournal $$i temp.xml;  \
	xmllint --format temp.xml | perl cleanup.pl > $$i.xml  && rm temp.xml; \
	diff $$i.xml expected-results/$$i.xml; \
	$(BINDIR)/teitohtml --profile=sciencejournal $$i.xml test.html; \
	xmllint --encode utf-8 --format test.html | perl cleanup.pl > test.temp; \
	mv test.temp $$i.html; \
	done \


clean:
	@echo CLEAN
	rm *.docx.xml
	rm *.docx.html
