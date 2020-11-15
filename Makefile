all: Spielerhandbuch.pdf Spells.pdf Hausregeln2020.pdf Hausregeln2021.pdf
	cd cover; make

gridmaps:
	cd gridmaps ; make all

Spielleiterbuch.pdf: Spielleiterbuch.md Makefile template.tex gridmaps
	pandoc -s -t latex --template template.tex \
	-f markdown+implicit_figures \
	--variable lang=de \
	--variable documentclass=memoir \
	--variable classoption="titlepage,twoside,a5paper,12pt" \
	--variable subparagraph \
	$< | sed -e "s/^Datum\:/$(shell date)/" \
	-e "s/\\\{/\{/" -e "s/\\\}/\}/" > tmp.$<.tex
	pdflatex --draftmode tmp.$<.tex
	makeindex tmp.$<.idx
	pdflatex --draftmode tmp.$<.tex
	makeindex tmp.$<.idx
	pdflatex tmp.$<.tex
	mv tmp.$<.pdf $@ &&\
	rm tmp.$<.*

%.pdf: %.md Makefile license.md template.tex 
	pandoc -s -t latex --template template.tex \
	-f markdown+implicit_figures \
	--variable lang=de \
	--variable documentclass=memoir \
	--variable classoption="titlepage,twoside,a5paper,12pt" \
	--variable subparagraph \
	$< license.md | sed -e "s/^Datum\:/$(shell date)/" \
	-e "s/\\\{/\{/" -e "s/\\\}/\}/" > tmp.$<.tex
	pdflatex --draftmode tmp.$<.tex
	makeindex tmp.$<.idx
	pdflatex --draftmode tmp.$<.tex
	makeindex tmp.$<.idx
	pdflatex tmp.$<.tex
	mv tmp.$<.pdf $@ &&\
	rm tmp.$<.*

Spells/Spells.md: Makefile
	cd Spells ; make Spells.md

Spells.md: Spells/Spells.md Makefile
	cp Spells/Spells.md Spells.md 

clean:
	rm -f tmp* Spells.md
	rm -f *.xmpi

realclean: clean
	cd gridmaps ; make realclean
	cd Spells; make realclean
	cd cover; make realclean
	rm -f *.pdf
	rm -f *.log *~ 
	rm -f *.xmpi

archive: realclean
	zip -rv  ../Hausregeln.zip . -x ".git/*" -x ".gitignore"
