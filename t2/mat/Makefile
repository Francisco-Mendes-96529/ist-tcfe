octave.log: t2.m ../sim/incl ../data.txt
	octave $< > $@

../sim/incl:
	@mkdir ../sim/incl

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex *.log *.aux *.pdf
	@rm -r ../sim/incl

.PHONY: clean
