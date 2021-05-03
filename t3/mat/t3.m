close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

%envelope detector
A=13.115
R=100
C=1e-6
t=linspace(0, 0.2, 1000);
f=50;
T=1/f;
w=2*pi*f;
vS = A * sin(w*t);
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));
rc = R * C * 10^4.5;
k = w * R * C * 10^1.5;
vD = 0.48;

  tOFF = 1/w * (acos(vD*27 / (A*sqrt(k*k+1))) + atan(1/k));
tOFF -= T/2;

vOnexp = (A*abs(sin(w*tOFF))-vD*2) * exp(-(t-tOFF)/rc);

hf = figure ();
for i=1:length(t)
  if (abs(vS(i)) > 2*vD)
    vOhr(i) = abs(vS(i))-2*vD;
  else
    vOhr(i) = 0;
  endif
endfor
plot(t*1000, vOhr)
hold

for i=1:length(t)
  if t(i) < tOFF
    vO(i) = vOhr(i);
  elseif vOnexp(i) > vOhr(i)
    vO(i) = vOnexp(i);
  else 
    tOFF += T/2;
    vOnexp = (A*abs(sin(w*tOFF)) - 2*vD) * exp(-(t-tOFF)/rc);
    vO(i) = vOhr(i);
  endif
endfor

plot(t*1000, vO)
title("Output voltage v_e(t)")
xlabel ("t[ms]")
legend("rectified","envelope")
print (hf,"venvlopeT3.eps", "-depsc");
close(hf);






%system("epstopdf phase.eps");
%disp("\nfigure saved");
