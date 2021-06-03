printf("\n\n\nTEST A.\n\n\n");

clear all
close all

R1=1000
R2=10e3
R3=3000
k=6
VA=25

G1=1/R1
G2=1/R2
G3=1/R3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nI.\n\n");
IB=10e-3

printf("\n\na)\n\n");
C1A = -R1/(R1+R3)
C1B = R1*R3/(R1+R3)
C3A = 1/(R1+R3)
C3B = R1/(R1+R3)

V1A = C1A*VA
V1B = C1B*IB
V1 = V1A+V1B
I3A = C3A*VA
I3B = C3B*IB
I3 = I3A+I3B

%check with mesh analysis
AM = [R1+R3, -R3;
      0, 1];
BM = [VA; -IB];
IM = AM\BM;

V1check=R1*-IM(1) 
I3check=IM(1)-IM(2)

printf("\n\nb)\n\n");
I1=(VA-V1)/R1
if(I1>0)
  printf("\nVa is supplying energy\n");
else
  printf("\nVa is consuming energy\n");
endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nII.\n\n");

Veq = R3/(R1+R3)*VA
Req= R2+R3*R1/(R1+R3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\nIII.\n\n");
%I2=k*I3,   Ib=k(Ia-Ib), kIa -(k+1)Ib = 0

AM = [R1+R3, -R3;
      k, -(k+1)];
BM = [VA; 0];

R11=AM(1,1)
R12=AM(1,2)
A21=AM(2,1)
A22=AM(2,2)

IM = AM\BM;
V1 = R3*(IM(1)-IM(2))
V2 = (IM(1)-IM(2))*R3-IM(2)*R2

%check with nodal analysis
V1check = VA/R1/(1/R1+1/R3+k/R3)
V2check = R2*(-k/R3+1/R2)*V1check




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\  IV.\n\n");
printf("\n\na)\n\n");
VC0 = R3/(R3+R1)*10;
C = 20e-6;
WC = 1/2*C*VC0^2

printf("\n\nb)\n\n");
tau = Req*C
VCInf = 0; %C discharges
K1 = VCInf
K2 = VC0-VCInf

printf("\n\nc)\n\n");
%v3=R2*iC+vC
V31=0
V32=K2*(1-R2*C/tau)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\  V.\n\n");
printf("\n\na)\n\n");
R2=0
K0 = -R1/(R1+R3)
b = 1/(C*R1*R3/(R1+R3))
a = -K0*b

printf("\n\nb)\n\n");
w=2*pi*1000;
VA=40*exp(j*pi/6);
ZC=1/j/w/C

%determine V3 with nodal analysis
Vbeta = G1*VA/(G1+G2+1/ZC) ;
V3 = -Vbeta;

A3=abs(V3)
PHI3=angle(V3)/pi*180




printf("\n\nc)\n\n");
%complex power in C
PC = Vbeta*conj(Vbeta/ZC)/2
%reactive power in C
PCReact = imag(PC)

printf("\n\nd)\n\n");
%complex power for circuit
P = abs(VA*conj((VA-Vbeta)/R1))/2


