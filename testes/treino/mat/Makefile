octave.log: treino.m ../sim/incl ../data.txt
	octave $< > $@

../sim/incl:
	@mkdir ../sim/incl

../data.txt: ../test1_datagen.py
	$< > $@

data: ../test1_datagen.py
	$< > ../data.txt

clean:
	@rm -f octave.log octave-workspace *.eps *~ *.tex *.log *.aux *.pdf
	@rm -r -f ../sim/incl

.PHONY: clean
