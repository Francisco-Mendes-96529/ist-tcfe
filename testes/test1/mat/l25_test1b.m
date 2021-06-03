printf("\n\n\nTEST B.\n\n\n");

clear all
close all

R1=10e3
R2=2e3
R3=15e3
k=3
IA=1e-3

G1=1/R1
G2=1/R2
G3=1/R3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nI.\n\n");
VB=5

V3A = -R3*R1/(R1+R3)*IA
V3B = R3/(R1+R3)*VB
V3 = V3A+V3B
I1A = -R3/(R1+R3)*IA
I1B = -1/(R1+R3)*VB
I1 = I1A+I1B



%check with node analysis
AN = [G1+G3, -G3;
      0, 1];
BN = [IA; VB];
VN = AN\BN;

V3check=VN(2)-VN(1)
I1check=-VN(1)/R1


printf("\n\nb)\n\n");
VA=VN(1)
if(VA>0)
  printf("\nIa is supplying energy\n");
else
  printf("\nIa is consuming energy\n");
endif



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nII.\n\n");
Ieq = R1/(R1+R3)*IA
Req= 1/(1/R2+1/(R1+R3))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nIII.\n\n");
%VB=k*V3
AN = [G1+G3, -G3;
      0, 1];
BN = [IA; VB];
VN = AN\BN;


AN = [G1+G3, -G3;
      3, -2];
BN = [IA; 0];

G11=AN(1,1)
G12=AN(1,2)
A21=AN(2,1)
A22=AN(2,2)

VN = AN\BN;
Valpha=VN(1)
Vbeta=VN(2)

%check with mesh analysis

AM = [
      1, 0, 0;
      -R1, R1+R2+R3, -R2;
      0, -R2-k*R3, R2
     ];
BM = [IA; 0; 0];
IM = AM\BM;

ValphaCheck = R1*(IM(1)-IM(2))
VbetaCheck = R2*(IM(2)-IM(3))



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\IV.\n\n");

printf("\n\na)\n\n");
L = 0.2;
IL0 = R1/(R3+R1)*5e-3;
WL = 1/2*L*IL0^2

printf("\n\nb)\n\n");
tau = L/Req
ILInf = 0   %iA is null and L discharges
K1 = ILInf
K2 = IL0-ILInf

%c) i3 = iL+ vL/R2 
I31=0
I32=(1-L/tau/R2)*K2

KCL=-I32+K2-L*K2/tau/R2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\V.\n\n");
printf("\n\na)\n\n");
G2=0
K0 = -R3/(R1+R3)
b = (R1+R3)/L
a = -K0*b


printf("\n\nb)\n\n");
w=2*pi*1000;
IA=15e-3*exp(j*pi/3);
ZL=j*w*L;

I3 = R1/(R1+R3+ZL)*IA
A3 = abs(I3)
phi = angle(I3)/pi*180

printf("\n\nc)\n\n");
%complex power in L
PL = ZL*I3*conj(I3)/2
%reactive power in L
PLReact = imag(PL)

printf("\n\nd)\n\n");
%complex power for circuit
VA = I3*(R3+ZL)
P = VA*conj(IA)/2

%apparent power
Papp = abs(P)
