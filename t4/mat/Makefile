#LODFIGS = $(patsubst %.eps,%.pdf,$(wildcard *.eps))

octave.log: t3.m #$(LODFIGS)
	octave $< > $@
	$(LODFIGS)

#convert eps figures to pdf
%.pdf: %.eps
	epstopdf $<

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex *.log *.aux *.pdf

.PHONY: clean
