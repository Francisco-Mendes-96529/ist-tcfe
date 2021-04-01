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

ff = fopen("../sim/incl/C.inc","w");
fprintf(ff, "C 6 8 %.11e\n", C);
fclose(ff);

printf("\n\n\nPasso 1:\n");
N = [1., 0, 0, 0, 0, 0, 0;
      1./R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0;
      0, Kb+1./R2, -1./R2, -Kb, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7;
      0, -Kb, 0, 1./R5+Kb, -1./R5, 0, 0;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7;
      0, 0, 0, 1., 0, Kd/R6, -1.];
x = [Vs; 0; 0; 0; 0; 0; 0];
 V=linsolve(N,x)

V6=V(5);
V8=V(7);

printf("\n\nPasso 2:\n");
Vx = V(5)-V(7) %% = V6 - V8

ff = fopen("../sim/incl/Vx.inc","w");
fprintf(ff, "Vx 6 8 %.11e\n", Vx);
fclose(ff);

N = [1., 0, 0, 0, 0, 0, 0, 0;
      1/R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0, 0;
      0, Kb+1./R2, -1./R2, -Kb, 0, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7, 1;
      0, -Kb, 0, 1./R5+Kb, -1./R5, 0, 0, -1;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7, 0;
      0, 0, 0, 1., 0, Kd/R6, -1., 0;
      0, 0, 0, 0, 1, 0, -1, 0];
x = [Vs; 0; 0; 0; 0; 0; 0; 0];
 V=linsolve(N,x)

   Ix = V(8)
Req = Vx/Ix

tau = Req*C

     #{ 
N = [-1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0, 0;
       Kb+1./R2, -1./R2, -Kb, 0, 0, 0, 0;
       1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7, 1;
       -Kb, 0, 1./R5+Kb, -1./R5, 0, 0, -1;
       0, 0, 0, 0, -1./R6-1./R7, 1./R7, 0;
       0, 0, 1., 0, Kd/R6, -1., 0;
       0, 0, 0, 1, 0, -1, 0];
x = [0; 0; 0; 0; 0; 0; Vx];
 V=linsolve(N,x)

   Ix = V(7)
   Req = Vx/Ix

tau = Req*C
   #}


   printf("\n\nPasso 3:\n");
#{
  printf("\nt=0\n");
%%vc0=Vx
%%v60=V6 = K12_6
%%v80=V8 = K12_8
%%K12=vc0
  
   printf("\nt->+oo\n");
%%vcI=0
%%viI=0
%%K1_i=viI=0
%%K1=vcI
%%K2=K12-K1
%% K2_i=K12_i
  
  #}
  
  %time axis: 0 to 20ms with 1us steps
t=0:1e-6:20e-3; %s


%%vc(t) = Vx*e;
v6n = V6 * power(e, (-t/tau));
%%v8(t) = V8(t=0)*e;

hf = figure ();
plot (t*1000, v6n, "g");

xlabel ("t[ms]");
ylabel ("v_6n(t) [V]");
print (hf, "v6natural.eps", "-depsc");




   printf("\n\nPasso 4:\n");

f=1000;
w=2*pi*f;
phi_vs = pi/2
vsp= power(e,-j*phi_vs)
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
v1p=V(1);
v2p=V(2);
v3p=V(3);
v5p=V(4);
v6p=V(5);
v7p=V(6);
v8p=V(7);

   
   %%%%%%%%%%%%%%%%%%%%% table;




   printf("\n\nPasso 5:\n");

  %time axis: -5 to 0ms with 1us steps
tn=-5e-3:1e-6:0; %s

v6neg = V6+0*tn;
vsneg = Vs+0*tn;

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

xlabel ("t[ms]");
ylabel ("v6(t), vs(t) [V]");
print (hf, "final.eps", "-depsc");
