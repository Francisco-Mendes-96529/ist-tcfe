LODFIGS = $(patsubst %.ps,%.pdf,$(wildcard *.ps))

all: log-lab log-lab-zo

log-%: %.log
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
