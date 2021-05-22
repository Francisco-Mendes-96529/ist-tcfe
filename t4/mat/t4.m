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

RSB=RB*RS/(RB+RS)

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1_DB = 20*log10(abs(AV1))
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1)
AV1simple_DB = 20*log10(abs(AV1simple))

RE1=0
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1_DB = 20*log10(abs(AV1))
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1)
AV1simple_DB = 20*log10(abs(AV1simple))

RE1=200
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)))
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB) ) 
ZO1 = 1/(1/ZX+1/RC1)

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZO1 = 1/(1/ro1+1/RC1)

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
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)


%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)



   ;
q1_ib = IB1
q1_ie = IE1
q1_ic = IC1
vb1 = VBEON + VE1
vc1 = VO1
ve1 = VE1
vbe1 = vb1 - ve1
vce1 = vc1 - ve1
  
q2_ib = IC2/BFP
q2_ie = IE2
q2_ic = IC2
vb2 = VI2
vc2 = 0
ve2 = VO2
veb2 = ve2 - vb2
vec2 = ve2 - vc2
  ;

ff = fopen("tabop.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Name & Value (V or A)\\\\ \\midrule\n");
fprintf(ff,"@q1[ib] & %.5e \\\\\n", q1_ib);
fprintf(ff,"@q1[ie] & %.5e \\\\\n", q1_ie);
fprintf(ff,"@q1[ic] & %.5e \\\\\n", q1_ic);
fprintf(ff,"vb1 & %.5e \\\\\n", vb1);
fprintf(ff,"vc1 & %.5e \\\\\n", vc1);
fprintf(ff,"ve1 & %.5e \\\\\n", ve1);
fprintf(ff,"vbe1 & %.5e \\\\\n", vbe1);
fprintf(ff,"vce1 & %.5e \\\\\n", vce1);
fprintf(ff,"@q2[ib] & %.5e \\\\\n", q2_ib);
fprintf(ff,"@q2[ie] & %.5e \\\\\n", q2_ie);
fprintf(ff,"@q2[ic] & %.5e \\\\\n", q2_ic);
fprintf(ff,"vb2 & %.5e \\\\\n", vb2);
fprintf(ff,"vc2 & %.5e \\\\\n", vc2);
fprintf(ff,"ve2 & %.5e \\\\\n", ve2);
fprintf(ff,"veb2 & %.5e \\\\\n", veb2);
fprintf(ff,"vec2 & %.5e \\\\ \\bottomrule\n", vec2);
fprintf(ff,"\\end{tabular}");
fclose(ff);

ff = fopen("tabz.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Impedance & Value ($\\Omega$)\\\\ \\midrule\n");
fprintf(ff,"$Z_{I_1}$ & %.5e \\\\\n", ZI1);
fprintf(ff,"$Z_{O_1}$ & %.5e \\\\\n", ZO1);
fprintf(ff,"$Z_{I_2}$ & %.5e \\\\\n", ZI2);
fprintf(ff,"$Z_{O_2}$ & %.5e \\\\\n", ZO2);
fprintf(ff,"$Z_{I_{total}}$ & %.5e \\\\\n", ZI);
fprintf(ff,"$Z_{O_{total}}$ & %.5e \\\\ \\bottomrule\n", ZO);
fprintf(ff,"\\end{tabular}");
fclose(ff);
  
ff = fopen("tabtotal.tex","w");
fprintf(ff,"$Z_{I_1}$ & %6f \\\\ \\hline\n", ZI1);
fprintf(ff,"$Z_{O_1}$ & %6f \\\\ \\hline\n", ZO1);
fprintf(ff,"$Z_{I_2}$ & %6f \\\\ \\hline\n", ZI2);
fprintf(ff,"$Z_{O_2}$ & %6f \\\\ \\hline\n", ZO2);
fprintf(ff,"$Z_{I_{total}}$ & %6f \\\\ \\hline\n", ZI);
fprintf(ff,"$Z_{O_{total}}$ & %6f \\\\ \\hline\n", ZO);
fprintf(ff,"$Gain_1$ & %6f \\\\ \\hline\n", AV1);
fprintf(ff,"$Gain_2$ & %6f \\\\ \\hline\n", AV2);
fprintf(ff,"$Gain_{total}$ & %6f \\\\ \\hline\n", AV);
fprintf(ff,"$Gain_{total}\\ (dB)$ & %6f \\\\ \\hline\n", AV_DB);
fclose(ff);
