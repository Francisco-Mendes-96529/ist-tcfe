close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

Z = vpa('0.');
U = vpa('1.');

syms R1
syms R2
syms R3
syms R4
syms R5
syms R6
syms R7
syms Va
syms Id
syms Kb
syms Kc

syms IA
syms IB
syms IC
syms ID

syms V1
syms V2
syms V3
syms V4
syms V5
syms V6
syms V7

printf("\n\nMesh method matrixes:\n");

M = [R3+R1+R4, -R3, -R4, Z;
       Kb*R3, U-Kb*R3, Z, Z;
       -R4, Z, -Kc+R4+R6+R7, Z;
       Z, Z, Z, U]

  I = [IA; IB; IC; ID]
  
  y = [-Va; Z; Z; Id]

  %%I = solve(A , y)


printf("\n\nMesh method matrixes:\n");

N = [U, Z, Z, Z, Z, Z, Z;
      U/R1, -U/R1-U/R2-U/R3, U/R2, U/R3, Z, Z, Z;
      Z, Kb+U/R3, -U/R3, -Kb, Z, Z, Z;
      Z, U/R3, Z, -U/R3-U/R4-U/R5, U/R5, U/R7, -U/R7;
      Z, -Kb, Z, U/R5+Kb, -U/R5, Z, Z;
      Z, Z, Z, Z, Z, -U/R6-U/R7, U/R7;
      Z, Z, Z, U, Z, Kc/R6, -U]

  V = [V1; V2; V3; V4;V5;V6;V7]
  
  x = [Va; Z; Z; Id; -Id; Z; Z]

  %%I = solve(A , y)


  
printf("\n\n\n\nCALCULO:\n");

%%EXAMPLE NUMERIC COMPUTATIONS
R1 = 1.00933568836e3;
R2 = 2.0029710407e3;
R3 = 3.10902902068e3; 
R4 = 4.13001338156e3;
R5 = 3.10840903174e3;
R6 = 2.07407526395e3;
R7 = 1.04985237166e3;
Va = 5.09749812451;
Id = 1.04885339412e-3;
Kb = 7.12347298707e-3;
Kc = 8.31335357268e3;

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
fprintf(fmesh,"$V_a$ & %.5e V\\\\\n", Va);
fprintf(fmesh,"$I_d$ & %.5e A\\\\\n", Id);
fprintf(fmesh,"$K_b$ & %.5e S\\\\\n", Kb);
fprintf(fmesh,"$K_c$ & %.5e $\\Omega$\\\\ \\bottomrule\n", Kc);
fprintf(fmesh,"\\end{tabular}");
fclose(fmesh);



printf("\n*************\n* Mesh:\n*************\n");
A = [R3+R1+R4, -R3, -R4, 0;
       Kb*R3, 1-Kb*R3, 0, 0;
       -R4, 0, -Kc+R4+R6+R7, 0;
       0, 0, 0, 1];
y = [-Va; 0; 0; Id];

I=linsolve(A,y)

  I1=-I(1)
  I2=-I(2)
  I3=-I(1)+I(2)
  I4=I(1)-I(3)
  I5=I(2)-I(4)
  I6=I(3)
  I7=I6

  printf("\n");

  V1=R1*I1
  V2=R2*I2
  V3=R3*I3
  V4=R4*I4
  V5=R5*I5
  V6=R6*I6
  V7=R7*I7

    ;
fmesh = fopen("tabmesh.tex","w");
fprintf(fmesh,"\\begin{tabular}{cc}\n");
fprintf(fmesh,"\\toprule\n");
fprintf(fmesh,"Mesh & (A) \\\\ \\midrule\n");
fprintf(fmesh,"$I_A$ & %.5e \\\\\n", I(1));
fprintf(fmesh,"$I_B$ & %.5e \\\\\n", I(2));
fprintf(fmesh,"$I_C$ & %.5e \\\\\n", I(3));
fprintf(fmesh,"$I_D$ & %.5e \\\\ \\bottomrule\n", I(4));
fprintf(fmesh,"\\end{tabular}\n");
fclose(fmesh);

  
printf("\n*************\n* Node:\n*************\n");
R1 = 1.00933568836e3;
R2 = 2.0029710407e3;
R3 = 3.10902902068e3; 
R4 = 4.13001338156e3;
R5 = 3.10840903174e3;
R6 = 2.07407526395e3;
R7 = 1.04985237166e3;
Va = 5.09749812451;
Id = 1.04885339412e-3;
Kb = 7.12347298707e-3;
Kc = 8.31335357268e3;

N = [1., 0, 0, 0, 0, 0, 0;
      1./R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0;
      0, Kb+1./R2, -1./R2, -Kb, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7;
      0, -Kb, 0, 1./R5+Kb, -1./R5, 0, 0;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7;
      0, 0, 0, 1., 0, Kc/R6, -1.];
x = [Va; 0; 0; Id; -Id; 0; 0];
 V=linsolve(N,x)

;
fmesh = fopen("tabnode.tex","w");
fprintf(fmesh,"\\begin{tabular}{cc}\n");
fprintf(fmesh," \\toprule\n");
fprintf(fmesh,"Node & (V) \\\\ \\midrule\n");
fprintf(fmesh,"$V_1$ & %.5e \\\\\n", V(1));
fprintf(fmesh,"$V_2$ & %.5e \\\\\n", V(2));
fprintf(fmesh,"$V_3$ & %.5e \\\\\n", V(3));
fprintf(fmesh,"$V_4$ & %.5e \\\\\n", V(4));
fprintf(fmesh,"$V_5$ & %.5e \\\\\n", V(5));
fprintf(fmesh,"$V_6$ & %.5e \\\\\n", V(6));
fprintf(fmesh,"$V_7$ & %.5e \\\\ \\bottomrule\n", V(7));
fprintf(fmesh,"\\end{tabular}\n");
fclose(fmesh);


   V1 = V(1)-V(2)
   V2 = V(2)-V(3)
   V3 = V(2)-V(4)
   V4 = -V(4)
   V5 = V(4)-V(5)
   V6 = -V(6)
   V7 = V(6)-V(7)

   printf("\n");

   I1 = V1/R1
   I2 = V2/R2
   I3 = V3/R3
   I4 = V4/R4
   I5 = V5/R5
   I6 = V6/R6
   I7 = V7/R7

     ;
fmesh = fopen("tabIeV.tex","w");
fprintf(fmesh,"\\begin{tabular}{ccc}\n");
fprintf(fmesh," \\toprule\n");
fprintf(fmesh,"Resistor & Voltage drop (V) & Current (A) \\\\ \\midrule\n");
fprintf(fmesh,"$R_1$ & %.5e & %.5e \\\\\n", V1, I1);
fprintf(fmesh,"$R_2$ & %.5e & %.5e \\\\\n", V2, I2);
fprintf(fmesh,"$R_3$ & %.5e & %.5e \\\\\n", V3, I3);
fprintf(fmesh,"$R_4$ & %.5e & %.5e \\\\\n", V4, I4);
fprintf(fmesh,"$R_5$ & %.5e & %.5e \\\\\n", V5, I5);
fprintf(fmesh,"$R_6$ & %.5e & %.5e \\\\\n", V6, I6);
fprintf(fmesh,"$R_7$ & %.5e & %.5e \\\\ \\bottomrule\n", V7, I7);
fprintf(fmesh,"\\end{tabular}\n");
fclose(fmesh);
