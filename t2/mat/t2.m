close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic


%%  Leitura de dados

ff = fopen("../data.txt","r");
fskipl(ff,8);
str = fgetl(ff);
[values, component, igual, R1] = sscanf(str,"%s %s %s %lf", "C");
R1 *= 1e3;
printf("%s = %f",component, R1);

str = fgetl(ff);
[component, igual, R2] = sscanf(str,"%s %s %lf", "C");
R2 *= 1e3;
printf("\n%s = %f",component, R2);

str = fgetl(ff);
[component, igual, R3] = sscanf(str,"%s %s %lf", "C");
R3 *= 1e3;
printf("\n%s = %f",component, R3);

str = fgetl(ff);
[component, igual, R4] = sscanf(str,"%s %s %lf", "C");
R4 *= 1e3;
printf("\n%s = %f",component, R4);

str = fgetl(ff);
[component, igual, R5] = sscanf(str,"%s %s %lf", "C");
R5 *= 1e3;
printf("\n%s = %f",component, R5);

str = fgetl(ff);
[component, igual, R6] = sscanf(str,"%s %s %lf", "C");
R6 *= 1e3;
printf("\n%s = %f",component, R6);

str = fgetl(ff);
[component, igual, R7] = sscanf(str,"%s %s %lf", "C");
R7 *= 1e3;
printf("\n%s = %f",component, R7);

str = fgetl(ff);
[component, igual, Vs] = sscanf(str,"%s %s %lf", "C");
printf("\n%s = %f",component, Vs);

str = fgetl(ff);
[component, igual, C] = sscanf(str,"%s %s %lf", "C");
C *= 1e-6;
printf("\n%s = %f",component, C);

str = fgetl(ff);
[component, igual, Kb] = sscanf(str,"%s %s %lf", "C");
Kb *= 1e-3;
printf("\n%s = %f",component, Kb);

str = fgetl(ff);
[component, igual, Kd] = sscanf(str,"%s %s %lf", "C");
Kd *= 1e3;
printf("\n%s = %f",component, Kd);

fclose(ff);



%%  Tabela de dados

fmesh = fopen("tabconstants.tex","w");
fprintf(fmesh,"\\begin{tabular}{cc}\n");
fprintf(fmesh,"\\toprule\n");
fprintf(fmesh,"Components & \\\\ \\midrule\n");
fprintf(fmesh,"$R_1$ & %.5e $\\Omega$\\\\\n", R1);
fprintf(fmesh,"$R_2$ & %.5e $\\Omega$\\\\\n", R2);
fprintf(fmesh,"$R_3$ & %.5e $\\Omega$\\\\\n", R3);
fprintf(fmesh,"$R_4$ & %.5e $\\Omega$\\\\\n", R4);
fprintf(fmesh,"$R_5$ & %.5e $\\Omega$\\\\\n", R5);
fprintf(fmesh,"$R_6$ & %.5e $\\Omega$\\\\\n", R6);
fprintf(fmesh,"$R_7$ & %.5e $\\Omega$\\\\\n", R7);
fprintf(fmesh,"$V_s$ & %.5e V\\\\\n", Vs);
fprintf(fmesh,"$C$ & %.5e F\\\\\n", C);
fprintf(fmesh,"$K_b$ & %.5e S\\\\\n", Kb);
fprintf(fmesh,"$K_d$ & %.5e $\\Omega$\\\\ \\bottomrule\n", Kd);
fprintf(fmesh,"\\end{tabular}");
fclose(fmesh);


%% Dados para o ngspice

ff = fopen("../sim/incl/data.inc","w");
fprintf(ff, "R1 1 2 %.11e\n", R1);
fprintf(ff, "R2 2 3 %.11e\n", R2);
fprintf(ff, "R3 2 5 %.11e\n", R3);
fprintf(ff, "R4 0 5 %.11e\n", R4);
fprintf(ff, "R5 5 6 %.11e\n", R5);
fprintf(ff, "R6 0 7 %.11e\n", R6);
fprintf(ff, "VR6 7 7b %.11e\n", 0);
fprintf(ff, "R7 7b 8 %.11e\n", R7);
fprintf(ff, "GIb 6 3 (2,5) %.11e\n", Kb);
fprintf(ff, "HVd 5 8 VR6 %.11e\n", Kd);
fclose(ff);

ff = fopen("../sim/incl/Vs.inc","w");
fprintf(ff, "Vs 1 0 %.11e\n", Vs);
fclose(ff);
#{
ff = fopen("../sim/incl/VsPWL.inc","w");
fprintf(ff, "Vs 1 0 dc pwl(0 %.11e 0ms 0v 20ms 0v)", Vs);
fclose(ff);
ff = fopen("../sim/incl/VsACDC.inc","w");
fprintf(ff, "Vs 1 0 dc pwl(0 %.11e 0ms 0v 20ms 0v) ac 1 sin(0 1 1000)", Vs);
fclose(ff);
 #}
ff = fopen("../sim/incl/C.inc","w");
fprintf(ff, "C 6 8 %.11e", C);
fclose(ff);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\nPasso 1:\n");
N = [1., 0, 0, 0, 0, 0, 0;
      1./R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0;
      0, Kb+1./R2, -1./R2, -Kb, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7;
      0, -Kb, 0, 1./R5+Kb, -1./R5, 0, 0;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7;
      0, 0, 0, 1., 0, Kd/R6, -1.];
x = [Vs; 0; 0; 0; 0; 0; 0];  %%%%% v1 v2 v3 v5 v6 v7 v8
 V=linsolve(N,x)
   ;
for i=1:7
  if(abs(V(i))<1e-15)
    V(i)=0;
endif
endfor

V6=V(5);
V8=V(7);

I1 = (V(1)-V(2))/R1;
I2 = (V(2)-V(3))/R2;
I3 = (V(2)-V(4))/R3;
I4 = (-V(4))/R4;
I5 = (V(4)-V(5))/R5;
I6 = (-V(6))/R6;
I7 = (V(6)-V(7))/R7;
Is = -I1;
Ib = -I2;
Ivd = -I7;
IC = 0;
I = [I1, I2, I3, I4, I5, I6, I7];

%%%%%%%%%%%%%%%%%%%%% TABLE
ff=fopen("nodalAn-tneg.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Name & Value [A or V]\\\\ \\midrule\n");
fprintf(ff,"$I_c$ & %.5e \\\\\n",IC);
fprintf(ff,"$I_b$ & %.5e \\\\\n",Ib);
for i=1:7
    fprintf(ff,"$I_%d$ & %.5e \\\\\n", i,I(i));
endfor
for i=1:7
  if(i>=4)
    fprintf(ff,"$V_%d$ & %.5e \\\\\n", i+1,V(i));
  else
    fprintf(ff,"$V_%d$ & %.5e \\\\\n", i,V(i));
endif
endfor
fprintf(ff,"$I_{V_d}$ & %.5e \\\\\n", Ivd);
fprintf(ff,"$I_{V_s}$ & %.5e \\\\ \\bottomrule\n", Is);
fprintf(ff,"\\end{tabular}");
fclose(ff);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nPasso 2:\n");

Vx = V6-V8
ff = fopen("../sim/incl/Vx.inc","w");
fprintf(ff, "Vx 6 8 %.11e\n", Vx);
fclose(ff);
ff = fopen("../sim/incl/C-Vx.inc","w");
fprintf(ff, "C 6 8 %.11e IC=%.11eV", C, Vx);
fclose(ff);


   disp("\nvs = 0, and Vx");
N = [-1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0, 0;
       Kb+1./R2, -1./R2, -Kb, 0, 0, 0, 0;
       1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7, -1;
       -Kb, 0, 1./R5+Kb, -1./R5, 0, 0, 1;
       0, 0, 0, 0, -1./R6-1./R7, 1./R7, 0;
       0, 0, 1., 0, Kd/R6, -1., 0;
       0, 0, 0, 1, 0, -1, 0];
x = [0; 0; 0; 0; 0; 0; Vx];
V=linsolve(N,x) %% V2, V3, V5, V6, V7, V8, Ix
  ;
for i=1:7
  if(abs(V(i))<1e-15)
    V(i)=0;
endif
endfor

V60 = V(4)
V80 = V(6)

Ix = V(7)
Req = Vx/Ix
tau = Req*C

%%%%%%%%%%%%%%%%%%%%% TABLE
ff=fopen("nodalAn-t0.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff,"Node & Voltage (V)\\\\ \\midrule\n");
fprintf(ff,"$V_%d$ & %.5f \\\\\n", 1,0);
for i=1:5
  if(i>=3)
    fprintf(ff,"$V_%d$ & %.5f \\\\\n", i+2,V(i));
  else
    fprintf(ff,"$V_%d$ & %.5f \\\\\n", i+1,V(i));
endif
endfor
fprintf(ff,"$V_%d$ & %.5f \\\\ \\bottomrule\n", 8,V(6));
fprintf(ff,"\\toprule\n");
fprintf(ff," & Value \\\\ \\midrule\n");
fprintf(ff,"$V_x$ & %.5e V \\\\\n", Vx);
fprintf(ff,"$I_x$ & %.5e A \\\\\n", Ix);
fprintf(ff,"$R_{eq}$ & %.5e $\\Omega$ \\\\\n", Req);
fprintf(ff,"$\\tau$ & %.5e $s^{-1}$ \\\\ \\bottomrule\n", tau);
fprintf(ff,"\\end{tabular}");
fclose(ff);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nPasso 3:\n");

#{
  printf("\nt=0\n");
%% vc0=Vx
%% v60=V60 = K12_6
%% v80=V80 = K12_8
%% K12=vc0
  
   printf("\nt->+oo\n");
%% vcI=0
%% viI=0
%% K1_i=viI=0
    
%% K1=vcI
%% K2=K12-K1
%% K2_i=K12_i
  
  #}
  
  %time axis: 0 to 20ms with 1us steps
t=0:1e-6:20e-3; %s


%%vc(t) = Vx*e;
v6n = V60 * power(e, (-t/tau));
%%v8(t) = V8(t=0)*e;

hf = figure ();
plot (t*1000, v6n, "r");

xlabel ("t[ms]");
ylabel ("v_{6n}(t) [V]");
print (hf, "v6natural.eps", "-depsc");
system("epstopdf v6natural.eps");
close(hf);
disp("figure saved");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   printf("\n\nPasso 4:\n");

f=1000;
w=2*pi*f;
phi_vs = pi/2
vsp= 1*power(e,-j*phi_vs)
Zc=1/(j*w*C)

N = [1., 0, 0, 0, 0, 0, 0;
      1./R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0;
      0, Kb+1./R2, -1./R2, -Kb, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5+1/Zc, 1./R7, -1./R7-1/Zc;
      0, -Kb, 0, 1./R5+Kb, -1./R5-1/Zc, 0, 1/Zc;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7;
      0, 0, 0, 1., 0, Kd/R6, -1.];
x = [vsp; 0; 0; 0; 0; 0; 0];
 V=linsolve(N,x)
   ;

for i=1:7
	if(abs(real(V(i)))<1e-15)
	  V(i)=0+j*imag(V(i));
endif
endfor

v1p=V(1);
v2p=V(2);
v3p=V(3);
v5p=V(4);
v6p=V(5);
v7p=V(6);
v8p=V(7);

   
%%%%%%%%%%%%%%%%%%%%% table;
fmesh = fopen("tabPhasors.tex","w");
fprintf(fmesh,"\\begin{tabular}{cc}\n");
fprintf(fmesh,"\\toprule\n");
fprintf(fmesh,"Phasor & Value \\\\ \\midrule\n");
fprintf(fmesh,"$\\tilde{V}_1$ & %.5f %+.5f j \\\\\n", real(v1p), imag(v1p));
fprintf(fmesh,"$\\tilde{V}_2$ & %.5f %+.5f j \\\\\n", real(v2p), imag(v2p));
fprintf(fmesh,"$\\tilde{V}_3$ & %.5f %+.5f j \\\\\n", real(v3p), imag(v3p));
fprintf(fmesh,"$\\tilde{V}_5$ & %.5f %+.5f j \\\\\n", real(v5p), imag(v5p));
fprintf(fmesh,"$\\tilde{V}_6$ & %.5f %+.5f j \\\\\n", real(v6p), imag(v6p));
fprintf(fmesh,"$\\tilde{V}_7$ & %.5f %+.5f j \\\\\n", real(v7p), imag(v7p));
fprintf(fmesh,"$\\tilde{V}_8$ & %.5f %+.5f j \\\\ \\bottomrule\n", real(v8p), imag(v8p));
fprintf(fmesh,"\\end{tabular}");
fclose(fmesh);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nPasso 5:\n");

%%%%%%%%%%% t<0
  %time axis: -5 to -1e-6ms with 1us steps
tn=-5e-3:1e-3:0; %s

v6neg = V6+0*tn;
vsneg = Vs+0*tn;

%%%%%%%%%%% t>=0
Gain = abs(v6p)
  Phase = angle(v6p)

  v6f = Gain*cos(w*t+Phase);

v6 = v6n + v6f;
vs = cos(w*t - phi_vs);

v6final = [v6neg,v6];
vsfinal = [vsneg,vs];
tfinal = [tn,t];


hf = figure ();
plot (tfinal*1000, v6final, "g");
hold on;
plot (tfinal*1000, vsfinal, "b");

legend("v6","vs");
xlabel ("t[ms]");
ylabel ("v_6(t), v_s(t) [V]");
print (hf, "final.eps", "-depsc");
system("epstopdf final.eps");
close(hf);
disp("\nfigure saved");




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nPasso 6:\n");
f =-1:0.1:6; %Hz
w = 2*pi*power(10,f);

vsp= 1*power(e,-j*phi_vs);
Zc=1. ./ (j .* w .* C);

N = [Kb+1./R2, -1./R2, -Kb, 0;
     1./R3-Kb,  0, Kb-1./R3-1./R4, -1./R6;
     Kb-1./R1-1./R3, 0, 1./R3-Kb, 0;
     0, 0, 1., Kd/R6-R7/R6-1.];
b = [0; 0; -vsp/R1; 0];

V=linsolve(N,b); % v2, v3, v5, v7
 
v8 = R7*(1./R7+1./R6)*V(4) + 0*Zc;
v6 = ((1./R5+Kb)*V(3)-Kb*V(1)+ (v8 ./ Zc)) ./ (1./R5 + 1. ./ Zc);
vc = v6 - v8;
vs = power(e,j*pi/2) + 0*w;


hf = figure ();
plot (f, 20*log10(abs(vc)), "m");
hold on;
plot (f, 20*log10(abs(v6)), "b");
hold on;
plot (f, 20*log10(abs(vs)), "r");

legend("vc","v6","vs");
xlabel ("log_{10}(f) [Hz]");
ylabel ("v^~_c(f), v^~_6(f), v^~_s(f) [dB]");
print (hf, "dB.eps", "-depsc");
system("epstopdf dB.eps");
close(hf);
disp("\nfigure saved");

av6 = 180/pi*(angle(v6));
for  i=1:length(av6)
	if(av6(i)<=-90) 
		av6(i) += 180;
	elseif (av6(i)>=90) 
		av6(i) -= 180;
endif
endfor

hf = figure ();
plot (f, 180/pi*(angle(vc) + pi), "m");
hold on;
plot (f, av6, "b");
hold on;
plot (f, 180/pi*angle(vs), "r");

legend("vc","v6","vs");
xlabel ("log_{10}(f) [Hz]");
ylabel ("Phase v_c(f), v_6(f), v_s(f) [degrees]");
print (hf, "phase.eps", "-depsc");
system("epstopdf phase.eps");
close(hf);
disp("\nfigure saved");
