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
fd = 27 + R*Is/VT * (exp(vD/VT)-1);
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
fd = 25 + R*Is/VT * (exp(vD/VT)-1);
endfunction

function vD_root = solve_vDc (vC, R)
  delta = 1e-6;
  x_next = 0.65;

  do 
    x=x_next;
    x_next = x  - fc(x, vC, R)/fcd(x, R);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction


function vc_f = vc_f(VC,R,C,length,t)
  delta = 1e-6;
  vc_next = VC;
Is = 1e-14;
VT = 25.9e-3;
h = 0.2/1000;
vc_f = zeros(1,length);
vo_f = zeros(1,length);
i_n = round(t/h);

vc_f(1+i_n) = vc_next;

for i=2+i_n:length
    vc=vc_next;
vD = solve_vDc (vc, R);
vcd = -Is/C * (exp(vD/VT)-1);
vc_next = vcd * h + vc;
vc_f(i) = vc_next;

endfor

endfunction


%envelope detector
A=13.115
R=100
C=1e-6
t=linspace(0, 0.4, 2000);
f=50;
T=1/f;
w=2*pi*f;
vS = A * sin(w*t);
vCr = zeros(1, length(t));
vC = zeros(1, length(t));
vT = 25.9e-3;
Is = 1e-14;


for i=1:length(t)
	vD = solve_vD  (abs(vS(i)), R);
  if (abs(vS(i)) > 2*vD)
    vCr(i) = abs(vS(i))-2*vD;
  else
    vCr(i) = 0;
  endif
endfor

hf = figure ();
tslice = t(1001:end);
vCrslice = vCr(1001:end);
plot(tslice*1000, vCrslice)
hold


tOFF = 10*T - T/4

vD = solve_vD(A, R)
VC0 = R*Is*(exp(vD/vT)-1) + 25*vD

  vCn = vc_f(VC0,R,C,length(t),tOFF);

i_n = tOFF*1000/0.2;
for i=i_n:length(t)
  if t(i) < tOFF
    vC(i) = vCr(i);
vD = solve_vDc(vC(i), R);
    vO(i) = 25*vD;
  elseif vCn(i) > vCr(i)
    vC(i) = vCn(i);
vD = solve_vDc(vC(i), R);
    vO(i) = 25*vD;
  else 
    tOFF += T/2;
    vCn = vc_f(VC0,R,C,length(t),tOFF);
    vC(i) = vCr(i);
vD = solve_vDc(vC(i), R);
    vO(i) = 25*vD;
  endif
endfor

 vCslice = vC(1001:end); 
%plot(tslice*1000, vCslice)
%hold
 vOslice = vO(1001:end); 
%plot(tslice*1000, vOslice)

plot(tslice*1000, vCslice,'-',tslice*1000, vOslice,'-');

title("Output voltage (t)")
xlabel ("t[ms]")
legend("rectified","envelope","vO")%"rectified",
print (hf,"vT3.eps", "-depsc");
close(hf);


printf("\n\nVALORES:\n");
maxVe = max(vCslice);
minVe = min(vCslice);
rippleVe = maxVe-minVe;
meanVe = mean(vCslice);
maxVo = max(vOslice);
minVo = min(vOslice);
rippleVo = maxVo-minVo;
meanVo = mean(vOslice);
desvioPerc = abs(meanVo-12)/12*100;
ripplePerc = rippleVo/meanVo*100;
printf("rippleVe = %.6e\nmeanVe = %.6e\nrippleVo = %.6e\nmeanVo = %.6e\n", rippleVe,meanVe, rippleVo,meanVo);


ff = fopen("tabvout.tex","w");
fprintf(ff,"\\begin{tabular}{cc}\n");
fprintf(ff,"\\toprule\n");
fprintf(ff," & Voltage (V)\\\\ \\midrule\n");
fprintf(ff,"$Ripple_{vO}$ & %.5e \\\\\n", rippleVo);
fprintf(ff,"$Average_{vO}$ & %.5e \\\\\n", meanVo);
fprintf(ff,"$Desvio\\ (\\%%)$ & %.5e \\\\\n", desvioPerc);
fprintf(ff,"$Ripple\\ (\\%%)$ & %.5e \\\\ \\bottomrule\n", ripplePerc);
fprintf(ff,"\\end{tabular}");
fclose(ff);



%system("epstopdf phase.eps");
%disp("\nfigure saved");
