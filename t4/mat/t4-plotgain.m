%gain stage

VT=25.9e-3
BFN=178.7
VAFN=69.7
RE1=200
RC1=700
RB1=85000
RB2=20000
VBEON=0.7
VCC=12
RS=100

RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1

gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 200
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
ro2 = VAFP/IC2
gpi2 = gm2/BFP
rpi2 = BFP/gm2
ge2 = 1/RE2



   %%%%%%%%%%%%%%%%%%;
Rin = 100
Cin = 0.5e-3
Cb = 9e-3
Co = 6e-3
RL = 8
Cbe1 = 1.61e-11
Cbc1 = 4.388e-12
Cbe2 = 1.4e-11
Cbc2 = 1.113e-11
 
f = logspace(0, 8, 81);
w = 2*pi*f;


vi0 = 1e-2


  %%%%%%% gain stage

  for i=1:length(f)
	  Zcin = 1./(j.*w(i).*Cin);
Zcb = 1./(j.*w(i).*Cb);
Zco = 1./(j.*w(i).*Co);
	  Zbe1 = 1./(j.*w(i).*Cbe1);
Zbc1 = 1./(j.*w(i).*Cbc1);
	  Zbe2 = 1./(j.*w(i).*Cbe2);
Zbc2 = 1./(j.*w(i).*Cbc2);


 

A = [-1./Rin.-1./Zcin, 1./Zcin, 0, 0;
	 1./Zcin, -1./Zcin.-1./RB1.-1./RB2.-1./rpi1.-1./Zbe1.-1./Zbc1, 1./rpi1.+1./Zbe1, 1./Zbc1;
	 0, 1./rpi1.+gm1.+1./Zbe1, -1./rpi1.-1./RE1.-1./Zcb.-gm1.-1./ro1.-1./Zbe1, 1./ro1;
	 0, -gm1.+1./Zbc1, gm1.+1./ro1, 1./RC1.-1./ro1.-1./Zbc1];
   
Y = [-vi0./Rin; 0; 0; 0]; %% vib, vi1, ve1, vo1

  V = A\Y;
vib(i) = V(1);
vo1(i) = V(4);

  %%%%%%%% output stage
  vi2 = V(4);

ve2 = (1./rpi2.+gm2.+1./Zbe2) ./ (1./rpi2 .+ 1./RE2 .+ 1./(Zco.+RL) .+ gm2 .+ 1./ro2 .+ 1./Zbe2) .* vi2;


vo2(i) = RL ./ (RL.+Zco) .* ve2;
  
endfor
  
  
%%%%%%%%%%%%%%%%% FIGURE

Av1 = 20*log10(abs(vo1 ./ vib));
Av2 = abs(vo2 ./ vo1);
Av = 20*log10(abs(vo2 ./ vib));

vdb_in2 = 20*log10(abs(vib/vi0));
vdb_out = 20*log10(abs(vo2/vi0));
Avv = vdb_out-vdb_in2;

MaxAv = max(Av)
  low = 0;
for i=1:length(Av)
	if (Av(i) >= MaxAv-3 && !low)
	  lowCOf = (f(i)+f(i-1))/2
	    low = 1;
	endif
	if (Av(i) <= MaxAv-3 && low)
	  highCOf = (f(i)+f(i-1))/2
	    low = 0;
	endif
endfor

bandwidth = highCOf - lowCOf
	
printf("\nAv2(100kHz) = %e", Av2(40));
printf("\nAv1(100kHz) = %e dB", Av1(40));
printf("\nAv(100kHz) = %e dB", Av(40));

hf = figure ();

plot(log10(f), vdb_out, '-', log10(f), vdb_in2, '-', log10(f), Av, '-')
hold

title("Output gain (f)")
xlabel ("log10(f) [Hz]")
legend("vdb(out)", "vdb(in2)", "Av_{db}")
print (hf,"gain.eps", "-depsc");
close(hf);


ff = fopen("tabNA.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff," & Value\\\\ \\midrule\n");
fprintf(ff,"$lowerCOf$ & %.5e \\\\\n", lowCOf);
fprintf(ff,"$upperCOf$ & %.5e \\\\\n", highCOf);
fprintf(ff,"$bandwidth$ & %.5e \\\\\n", bandwidth);
fprintf(ff,"$Gain_{total}\\ (dB)$ & %.5e \\\\ \\bottomrule\n", MaxAv);
fprintf(ff,"\\end{tabular}");
fclose(ff);
  
ff = fopen("tabNaugly.tex","w");
fprintf(ff," & %6f \\\\ \\hline\n", MaxAv);
fprintf(ff,"$lowerCOf$ & %6f \\\\ \\hline\n", lowCOf);
fprintf(ff,"$upperCOf$ & %6f \\\\ \\hline\n", highCOf);
fprintf(ff,"$bandwidth$ & %6f \\\\ \\hline\n", bandwidth);
fclose(ff);
