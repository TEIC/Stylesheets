  for i in `find . -name "*.xml" | xargs grep common2 | sed 's/:.*//'`; do perl -p -i -e 's/common2/common/' $i; done
  for i in `find . -name "*.xml" | xargs grep xhtml2 | sed 's/:.*//'`; do perl -p -i -e 's/xhtml2/html/' $i; done
  for i in `find . -name "*.xml" | xargs grep latex2 | sed 's/:.*//'`; do perl -p -i -e 's/latex2/latex/' $i; done
