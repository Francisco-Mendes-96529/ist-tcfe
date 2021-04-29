all: ngspice.log test-diodeV.log merit-20-5.log merit-x.log merit-22.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	ps2pdf dc-20-5.ps;
	ps2pdf dc-x.ps;
	ps2pdf dc-22.ps;

ngspice.log: t3.net
	ngspice -b $< -o $@

merit-%.log: merit-%.net
	ngspice -b $< -o $@

test-%.log: test-%.net
	ngspice -b $< -o $@

clean:
	@rm -f *.log *.tex *.pdf *.ps *~

.PHONY: all clean
