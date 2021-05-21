%gain stage

VT=25.9e-3
BFN=178.7
VAFN=69.7
RE1=100
RC1=1000
RB1=80000
RB2=20000
VBEON=0.7
VCC=12
RS=100

RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1

gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2



   %%%%%%%%%%%%%%%%%%;
Rin = 100
Cin = 0.1e-3
Cb = 1e-3
Co = 1e-3

f = logspace(1, 8, 71);
w = 2*pi*f;

Zcin = i*w*Cin;
Zcb = i*w*Cb;
Zco = i*w*Co;

vin0 = 1e-2

  Rb = 1./( 1./(rpi1 .+ 1./(1./RE1.+1./Zcb)) .+ 1./RB1 .+ 1./RB2);
vi1 = Rb./(Rin.+Zcb.+Rb) .* vin0;

v1 = (gm1 .+ 1./rpi1 .+ RC1.*gm1./(ro1.-RC1)).*vi1./(1./RE1.+1./Zcb.+gm1.+1./ro1.+1./rpi1.+RC1.*(1./ro1.+gm1)./(ro1.-RC1))
