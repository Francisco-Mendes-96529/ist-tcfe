close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

%%solve circuit with accurate model

function f = f(vD,vS,R)
Is = 1e-14;
VT=25.9e-3;
f = 27*vD + R*Is * (exp(vD/VT)-1) - vS;
endfunction

function fd = fd(vD,R)
Is = 1e-14;
VT=25.9e-3;
fd = 27 + R*Is/VT * exp(vD/VT);
endfunction

function vD_root = solve_vD (vS, R)
  delta = 1e-6;
  x_next = 0.65;

  do 
    x=x_next;
    x_next = x  - f(x, vS, R)/fd(x, R);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction


function f = fc(vD,vC,R)
Is = 1e-14;
VT=25.9e-3;
f = 25*vD + R*Is * (exp(vD/VT)-1) - vC;
endfunction

function fd = fcd(vD,R)
Is = 1e-14;
VT=25.9e-3;
fd = 25 + R*Is/VT * exp(vD/VT);
endfunction

function vD_root = solve_vDc (vC,R,x)
  delta = 1e-6;
  x_next = x;

  do 
    x=x_next;
    x_next = x  - fc(x, vC, R)/fcd(x, R);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction


function [vcnext,vDnext,vPnext] = ftotal(vcn,vD,vP,vS,R,C)
  h = 0.2/1000;
vT = 25.9e-3;
Is = 1e-14;

vcnext = Is*(exp(vP/vT)-exp(vD/vT))/C*h+vcn;
vDnext = solve_vDc (vcnext,R,vD);
vPnext = (vS - 25*vDnext + R*Is*(exp(vDnext/vT)-1))/2;

endfunction


%envelope detector
A=13.115
R=100
C=1e-6
t=linspace(0, 0.6, 3000);
f=50;
T=1/f;
w=2*pi*f;
vS = A * sin(w*t);
vCr = zeros(1, length(t));
vC = zeros(1, length(t));
vO = zeros(1, length(t));
vT = 25.9e-3;
Is = 1e-14;

%% dvc/dt = 0, t = T/4
  vD = solve_vD  (A, R, 0.6)
vP = vD
vcn = 25*vD + R*Is*(exp(vD/vT)-1)

for i=25:length(t)
	[vcnext,vDnext,vPnext] = ftotal(vcn,vD,vP,abs(vS(i)),R,C);
vcn = vcnext;
vD = vDnext;
vP =vPnext;
vCr(i) = vcn;
vO(i) = vD*25;
endfor



hf = figure ();
tslice = t(1001:2000);

vCrslice = vCr(2001:end);
vOslice = vO(2001:end);

plot(tslice*1000, vCrslice,'-',tslice*1000, vOslice,'-')
%plot(t(25:end)*1000, vCr(25:end),'-',t(25:end)*1000, vO(25:end),'-')
hold

vO0 = vOslice-12;
plot(tslice*1000, vO0)


title("Output voltage (t)")
xlabel ("t[ms]")
legend("envelope","vO","(vO-12)")%"rectified",
print (hf,"vT3.eps", "-depsc");
close(hf);


printf("\n\nVALORES:\n");
maxVe = max(vCrslice);
minVe = min(vCrslice);
rippleVe = maxVe-minVe;
meanVe = mean(vCrslice);
maxVo = max(vOslice);
minVo = min(vOslice);
rippleVo = maxVo-minVo;
meanVo = mean(vOslice);
desvioPerc = abs(meanVo-12)/12*100;
ripplePerc = rippleVo/meanVo*100;
printf("rippleVe = %.6e\nmeanVe = %.6e\nrippleVo = %.6e\nmeanVo = %.6e\ndeviationPerc = %.6e\nripplePerc = %.6e\n", rippleVe,meanVe, rippleVo,meanVo, desvioPerc,ripplePerc);


ff = fopen("tabvout.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff," & Voltage (V)\\\\ \\midrule\n");
fprintf(ff,"$Ripple\\ (v_O)$ & %.5e \\\\\n", rippleVo);
fprintf(ff,"$Average\\ (v_O)$ & %.5e V\\\\\n", meanVo);
fprintf(ff,"$Deviation$ & %.5e \\%%\\\\\n", desvioPerc);
fprintf(ff,"$Ripple$ & %.5e \\%%\\\\ \\bottomrule\n", ripplePerc);
fprintf(ff,"\\end{tabular}");
fclose(ff);


%system("epstopdf phase.eps");
%disp("\nfigure saved");
