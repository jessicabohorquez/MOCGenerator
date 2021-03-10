function [HeadV] = Leak(InputSys,Dist,DLeak,Dt,a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

HR=InputSys(1);
LT=InputSys(2);
D=InputSys(3);
nuu=InputSys(11);
vo1=InputSys(12);
ks=InputSys(13);
TT=InputSys(14);
Cd=InputSys(18);

g=9.81;
Alpha=0.5;

%Locate the leak
L1=Dist;
L2=LT-Dist;

%Determine Dx and Reaches in each pipe

Dx1=Dt*a;
N1=L1/Dx1;
N1=floor(N1);
Dx1=L1/N1;

Dx2=Dt*a;
N2=L2/Dx2;
N2=floor(N2);
Dx2=L2/N2;

%Determine Time Steps
TS=TT/Dt;
TS=round(TS,0);

%Calculation of Steady State
Area = (pi * (D) ^ 2) / 4;
Q1 = vo1 * Area;

Re=(vo1*D)/nuu;
ks=ks/1000;
f=0.01;
Err=100;
Tol=0.001;

while Err>Tol
    ff=-2*log10(ks/(3.7*D)+(2.51/(Re*(f)^0.5)));
    fn=(1/ff)^2;
    Err=(abs(f-fn)/fn)*100;
    f=fn;
end

hf1 = (f * L1 * (vo1) ^ 2) / (D * 2 * g);
H1=HR-hf1;
DLeak=DLeak/1000;
QLeak=(Cd/4*pi*DLeak^2)*(2*g*H1)^Alpha;
Q2=Q1-QLeak;
vo2=Q2/Area;

%Calculation of Transient Parameters
B1 = a / (g * Area);
R1 = f * Dx1 / (2 * g * D * (Area) ^ 2);
B2 = a / (g * Area);
R2 = f * Dx2 / (2 * g * D * (Area) ^ 2);

%Creation of Matrix for Results
Head1=zeros(N1+1, 1);
Flow1=zeros(N1+1, 1);
Head2=zeros(N2+1, 1);
Flow2=zeros(N2+1, 1);
FlowLeak=zeros(TS,1);

Head1p=zeros(N1+1, 1);
Flow1p=zeros(N1+1, 1);
Head2p=zeros(N2+1, 1);
Flow2p=zeros(N2+1, 1);

HeadV=zeros(TS,1);

%Asign Initial Q and H
%Pipe 1
for i = 1 : N1+1
    hf1 = (f * Dx1 * (i-1) * (vo1) ^ 2) / (D * 2 * g);
    Head1(i, 1) = HR - hf1;
    Head1p(i, 1) = HR - hf1;
end

for i = 1 : N1+1
    Flow1(i, 1) = Q1;
    Flow1p(i, 1) = Q1;
end

%Pipe 2

for i = 1 : N2+1
    hf2 = (f * Dx2 * (i-1) * (vo2) ^ 2) / (D * 2 * g);
    Head2(i, 1) = HR - hf1-hf2;
    Head2p(i, 1) = HR - hf1-hf2;
end

for i = 1 : N2+1
    Flow2(i, 1) = Q2;
    Flow2p(i, 1) = Q2;
end

FlowLeak(1,1)=QLeak;


% Initial Transient Conditions for Valve Closure at the end
Cp = Head2(N2 , 1) + B2 * Flow2(N2 , 1);
Bp = B2 + R2 * abs(Flow2(N2 , 1));

Flow2(N2+1, 1) = 0;

Head2(N2+1, 1) = Cp - Bp * Flow2(N2+1, 1);
HeadV(1)=Head2(N2+1, 1);

% Transient Results for the rest of Dt
% This will go in time
for t = 2:TS
    
    if t==6694
        d=9;
    end
    
    %Pipe 1
    for i=1:N1
        if i == 1
            Cm = Head1p(i+1 , 1 ) - B1 * Flow1p(i + 1,1);
            Bm = B1 + R1 * abs(Flow1p(i + 1,1));
            Head1(i, 1) = HR;
            Flow1(i, 1) = (HR - Cm) / Bm;
        else
            Cp = Head1p(i - 1, 1) + B1 * Flow1p(i - 1, 1);
            Bp = B1 + R1 * abs(Flow1p(i - 1, 1));
            Cm = Head1p(i + 1, 1) - B1 * Flow1p(i + 1, 1);
            Bm = B1 + R1 * abs(Flow1p(i + 1, 1));
            
            Head1(i, 1) = (Cp * Bm + Cm * Bp) / (Bp + Bm);
            Flow1(i, 1) = (Cp - Cm) / (Bp + Bm);
        end
    end

    %At Junction
    Cp1 = Head1p(N1, 1) + B1 * Flow1p(N1, 1);
    Bp1 = B1 + R1 * abs(Flow1p(N1, 1));
    
    Cm2 = Head2p(2 , 1 ) - B2 * Flow2p(2, 1);
    Bm2 = B2 + R2 * abs(Flow2p(2, 1));
    
    %FlowLeak(1,t)=-Bp1*Cv+((Bp1*Cv)^2+(2*Cv*Cp1))^0.5;
    %H=(FlowLeak(1,t)/Beta)^2;
    
    S=(1/Bm2)+(1/Bp1);
    M=(Cm2/Bm2)+(Cp1/Bp1);
    
    H=SecMod(Cd,DLeak,Alpha,S,M,HR);
        
    Head1(N1+1,1)=H;
    Head2(1,1)=H;
        
    Flow1(N1+1,1)=Cp1/Bp1-H/Bp1;
    Flow2(1,1)=H/Bm2-Cm2/Bm2;
    FlowLeak(t,1)=Flow1(N1+1,1)-Flow2(1,1);
    
    %Pipe 2
    for i=2:N2+1
        if i == N2+1
            Cp = Head2p(i - 1, 1) + B2 * Flow2p(i - 1, 1);
            Bp = B2 + R2 * abs(Flow2p(i - 1, 1));
            
            Flow2(i, 1) = 0;
            Head2(i, 1) = Cp - Bp * Flow2(i, 1);
            
        else
            Cp = Head2p(i - 1,1) + B2 * Flow2p(i - 1, 1);
            Bp = B2 + R2 * abs(Flow2p(i - 1,1));
            Cm = Head2p(i + 1,1) - B2 * Flow2p(i + 1,1);
            Bm = B2 + R2 * abs(Flow2p(i + 1,1));
            
            Head2(i, 1) = (Cp * Bm + Cm * Bp) / (Bp + Bm);
            Flow2(i, 1) = (Cp - Cm) / (Bp + Bm);
        end
    end
    Head1p=Head1;
    Flow1p= Flow1;
    Head2p=Head2;
    Flow2p=Flow2;
    
    HeadV(t)=Head2(N2+1, 1);
    
    if HeadV(t)<0
        d=0;
    end
    
    t
end

Time=zeros(TS,1);

for i=1:TS
    Time(i)=Dt*(i-1);
end

% fh = figure(1); 
% set(fh, 'color', 'white');
% Single=plot(Time,HeadV);
% set(Single, 'LineStyle', '-', 'LineWidth', 0.5, 'Color', 'Black');
% xlabel('Time (s)', 'FontSize', 14 );
% ylabel('Head (m)', 'FontSize', 14, 'Rotation', 90 );
end

