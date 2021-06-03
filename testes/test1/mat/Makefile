all: l25_test1a.log

.SECONDARY:

%.log: %.m
	octave $< > log-$@
	$(LODFIGS)

#convert eps figures to pdf
%.pdf: %.eps
	epstopdf $<

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex *.log *.aux *.pdf

.PHONY: clean
