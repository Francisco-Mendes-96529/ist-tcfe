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

function vD_root = solve_vD (x0,vS, R)
  delta = 1e-6;
  x_next = x0;

  do 
    x=x_next;
    x_next = x  - f(x, vS, R)/fd(x, R);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction



%envelope detector
A=13.115
R=100
C=1e-6
t=linspace(0, 0.2, 1000);
f=50;
T=1/f;
w=2*pi*f;
vS = A * sin(w*t);
vChr = zeros(1, length(t));
vC = zeros(1, length(t));
vT = 25.9e-3;
Is = 1e-14;

tOFF = -T/4+1e-5;

vD = solve_vD(0.65, A, R)
VC0 = R*Is*(exp(vD/vT)-1) + 25*vD
rD = vT/(Is*exp(vD/vT))
tau = C*(R+25*rD)
vCnexp = VC0 * exp(-(t-tOFF)/tau);

hf = figure ();
for i=1:length(t)
  if (abs(vS(i)) > 2*vD)
    vChr(i) = abs(vS(i))-2*vD;
  else
    vChr(i) = 0;
  endif
endfor
plot(t*1000, vChr)
hold

for i=1:length(t)
  if t(i) < tOFF
    vC(i) = vChr(i);
  elseif vCnexp(i) > vChr(i)
    vC(i) = vCnexp(i);
  else 
    tOFF += T/2;
    vCnexp = VC0 * exp(-(t-tOFF)/tau);
    vC(i) = vChr(i);
  endif
endfor

plot(t*1000, vC)
title("Output voltage v_e(t)")
xlabel ("t[ms]")
legend("rectified","envelope")
print (hf,"venvlopeT3.eps", "-depsc");
close(hf);






%system("epstopdf phase.eps");
%disp("\nfigure saved");
