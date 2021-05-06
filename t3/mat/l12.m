close all 
clear all

I_S = 1e-9
V_T=25e-3

v = linspace(-1, 1, 100);
i = I_S*(exp(v/V_T/2) - 1);

plot(v, i)
title("Diode Current-Voltage Characteristic")
xlabel ("v[V]")
ylabel ("i[A]")
print ("iv.eps", "-depsc");



%%solve circuit with accurate model

function f = f(vD,vS,R)
Is = 1e-9;
VT=25e-3;
f = vD+R*Is * (exp(vD/VT/2)-1) - vS;
endfunction

function fd = fd(vD,R)
Is = 1e-9;
VT=25e-3;
fd = 1 + R*Is/2/VT * (exp(vD/VT/2)-1);
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


R=1000;
f=1000;
w=2*pi*f;
t=0:1e-6: 5e-3;
vS=2*cos(w*t);
vO = zeros(1,length(t));

for i=1:length(t)
  vD = solve_vD  (vS(i), R);
  vO(i) = vS(i)-vD;
endfor

figure
plot(t*1000, vO)
title("Output voltage v_o(t)")
xlabel ("t[ms]")
ylabel ("v_o[V]")
print ("vo.eps", "-depsc");


%solve circuit with ideal diode model
vO_i = zeros(1,length(t));

for i=1:length(t)
  if(vS(i) >=0)
    vO_i(i) = vS(i);
  else
    vO_i(i) = 0;
  endif 
endfor

figure
plot(t*1000, vO)
hold
plot(t*1000, vO_i)
title("Output voltage with ideal and accurate diode model")
legend("Accurate", "Ideal");
print ("vo_i.eps", "-depsc");

%solve circuit with ideal diode + vON model
vO_iv = zeros(1,length(t));
vON = 0.65;

for i=1:length(t)
  if(vS(i) - vON >=0)
    vO_iv(i) = vS(i) - vON;
  else
    vO_iv(i) = 0;
  endif 
endfor

figure
plot(t*1000, vO)
hold
plot(t*1000, vO_i)
plot(t*1000, vO_iv)
title("Output voltage with various diode models")
legend("Accurate", "Ideal", "Ideal+vON");
print ("vo_iv.eps", "-depsc");


%solve circuit with ideal diode + vON + RON model
vO_ivr = zeros(1,length(t));
vON = 0.6;
RON = 80;

for i=1:length(t)
  if(vS(i) - vON >=0)
    iD = (vS(i) - vON)/(RON+R);
    vO_ivr(i) = R*iD;
  else
    vO_ivr(i) = 0;
  endif 
endfor

figure
plot(t*1000, vO)
hold
plot(t*1000, vO_i)
plot(t*1000, vO_iv)
plot(t*1000, vO_ivr)
title("Output voltage with various diode models")
legend("Accurate", "Ideal", "Ideal+vON", "Ideal+vON+RON");
print ("vo_ivr.eps", "-depsc");


%incremental analysis
V_S = 2
figure
plot(t*1000, V_S+vS/10)
axis([0 5 0 3])
xlabel ("t[ms]")
ylabel ("v[V]")
title("DC and AC components")
print ("acdc.eps", "-depsc");
