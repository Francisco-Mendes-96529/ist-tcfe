LODFIGS = $(patsubst %.ps,%.pdf,$(wildcard *.ps))

all: log-t4 log-t4-outimp

log-%: %.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)

pdf: $(LODFIGS)

.SECONDARY:

%.log: %.net
	ngspice -b $< -o $@

#convert eps figures to pdf
%.pdf: %.ps
	epstopdf $<

clean:
	@rm -f *.log *.tex *.pdf *.ps *~

.PHONY: all clean
