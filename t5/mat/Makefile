all: t5.log

.SECONDARY:

%.log: %.m
	octave $< > $@
	$(LODFIGS)

#convert eps figures to pdf
%.pdf: %.eps
	epstopdf $<

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex *.log *.aux *.pdf

.PHONY: clean
