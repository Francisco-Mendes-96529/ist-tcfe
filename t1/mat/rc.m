close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

Z = vpa(0.0);
U = vpa(1.0);

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
  R1 = 1.00933568836;
R2 = 2.0029710407;
R3 = 3.10902902068; 
R4 = 4.13001338156;
R5 = 3.10840903174;
R6 = 2.07407526395;
R7 = 1.04985237166;
Va = 5.09749812451;
Id = 1.04885339412;
Kb = 7.12347298707 ;
Kc = 8.31335357268 ;

printf("\n\nMesh:\n");
A = [R3+R1+R4, -R3, -R4, 0;
       Kb*R3, 1-Kb*R3, 0, 0;
       -R4, 0, -Kc+R4+R6+R7, 0;
       0, 0, 0, 1];
y = [-Va; 0; 0; Id];

I=linsolve(A,y)

  V1=R1*(-I(1))
  V2=R2*(-I(2))
  V3=R3*(-I(1)+I(2))
  V4=R4*(I(1)-I(3))
  V5=R5*(I(2)-I(4))
  V6=R6*I(3)
  V7=R7*I(3)

  
printf("\n\nNode:\n");
 R1 = 1.00933568836;
R2 = 2.0029710407;
R3 = 3.10902902068; 
R4 = 4.13001338156;
R5 = 3.10840903174;
R6 = 2.07407526395;
R7 = 1.04985237166;
Va = 5.09749812451;
Id = 1.04885339412;
Kb = 7.12347298707 ;
Kc = 8.31335357268 ;

N = [1., 0, 0, 0, 0, 0, 0;
      1./R1, -1./R1-1./R2-1./R3, 1./R2, 1./R3, 0, 0, 0;
      0, Kb+1./R3, -1./R3, -Kb, 0, 0, 0;
      0, 1./R3, 0, -1./R3-1./R4-1./R5, 1./R5, 1./R7, -1./R7;
      0, -Kb, 0, 1./R5+Kb, -1./R5, 0, 0;
      0, 0, 0, 0, 0, -1./R6-1./R7, 1./R7;
      0, 0, 0, 1., 0, Kc/R6, -1.];
x = [Va; 0; 0; Id; -Id; 0; 0];
 V=linsolve(N,x)

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

