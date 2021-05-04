close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic


%%  Leitura de dados

function [str,val] = getnum(str)
  igual = false;
sstr="";
sval="";
for i=1:length(str)
	if (str(i)=='=')
	  igual=true;
elseif(igual)
sval = [sval,str(i)];
 else
   sstr = [sstr,str(i)];
  endif
endfor
  str=sstr;
  [val]=sscanf(sval,"%lf","C");
endfunction

ff = fopen("../data.txt","r");
fskipl(ff,10);
val = [0];
varname = [" "];
while(1)
  str = fgetl(ff);
if(str==-1)
  break;
endif
[name,n] = getnum(str);
val = [val, n];
printf("%s=%12.11f\n",name,n);
endwhile
fclose(ff);

R4 = val(2);
phi= val(3);
R1 = val(4);
R2 = val(5);
R3 = val(6);
fx = val(7);
X  = val(8);
k  = val(9);
VC = val(10);
AI = val(11);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\n////////////\nEXERCICIO 1:\n");
A = [-1./R1-1./R2-1./R3, 1./R2, 1./R3;
       1./R2-k/R3, -1./R2, k/R3;
       1./R3+k/R3, 0, -1./R3-k/R3-1./R4];
y = [-AI/R1; 0; 0];  %%%%% v1 v2 v3
 V=linsolve(A,y)
   ;

IR1=(AI-V(1))/R1
  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\n////////////\nEXERCICIO 2:\n");
printf("\n2.1:\n");

tau = 1/(2*pi*fx)

printf("\n2.2:\n");
Zb=i*X
  VIp=AI*exp(i*phi);
A = [-1./R1-1./R2-1./R3, 1./R2, 1./R3, 0;
       1./R2-k/R3, -1./R2-1/Zb, k/R3, 1/Zb;
       1./R3+k/R3, 0, -1./R3-k/R3-1./R4, 0;
	0, 0, 0, 1];
  y = [-VIp/R1; 0; 0; 0];  %%%%% v1 v2 v3 v4
 V=linsolve(A,y)
   ;
Vop=V(2)-V(4)
  Vo=abs(Vop)
  vophi=angle(Vop)
  ;
  
printf("\n2.4:\n");
IR1p=(VIp-V(1))/R1;
IR1=abs(IR1p)
  IR1phi=angle(IR1p)
  ;


printf("\n2.6:\n");
vo4ms=Vo*cos(0.004/tau+vophi)
  ;


printf("\n2.7:\n");
A = [-1./R1-1./R2-1./R3, 1./R2, 1./R3, 0;
       1./R2-k/R3, -1./R2-1/Zb, k/R3, 1/Zb;
       1./R3+k/R3, 0, -1./R3-k/R3-1./R4, 0;
	0, 0, 0, 1];
  y = [-AI/R1; 0; 0; VC];  %%%%% v1 v2 v3 v4
 V=linsolve(A,y)
   ;
vo0=real(V(2)-V(4))
  ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf("\n\n\n////////////\nEXERCICIO 4:\n");
Zeq=Zb*VIp/Vop;
  theta=angle(Zeq)
  Ii=-IR1;
  PF=cos(theta)
  Pm=AI*Ii/2*PF
    Prea=AI*Ii/2*sin(theta)
