# ---------------------------------------------------------
# type the "make" command to create report.pdf 
# ---------------------------------------------------------

#doc name
FILE=report

#list of LibreOffice Draw files
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))
LODFIGSMAT = $(patsubst ../mat/%.eps,../mat/%.pdf,$(wildcard ../mat/*.eps))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) $(LODFIGSMAT)
#	cp -f ../mat/*.eps .
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex


#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

#convert eps figures to pdf
../mat/%.pdf: ../mat/%.eps
	epstopdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.eps

.PHONY: all clean


