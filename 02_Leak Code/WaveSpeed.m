function [a] = WaveSpeed(Input)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

D=Input(3);
EspCM=Input(4);
EspS=Input(5);
ECM=Input(6);
E=Input(7);
Rho=Input(8);
K=Input(9);
C1=Input(10);



g=9.81;

EspCM=EspCM/1000;
EspS=EspS/1000;

ECM=ECM*10^9;
E=E*10^9;
K=K*10^9;

EspEq1=EspCM*ECM/E;

Esp1=EspS+EspEq1;

a = ((K / Rho) / (1 + ((K / E) * (D / Esp1) * C1))) ^ 0.5;


end

