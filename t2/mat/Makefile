octave.log: t2.m ../sim/incl
	octave $< > $@

../sim/incl:
	@mkdir ../sim/incl

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex
	@rm -r ../sim/incl

.PHONY: clean
