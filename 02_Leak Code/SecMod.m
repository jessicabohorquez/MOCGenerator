function [H] = SecMod(Cd,DLeak,alpha,S,M,HR)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Ho=HR;
Dh=0.0001;
Tol=1e-10;
Err=100;

H=Ho;


while Err > Tol
    fh=(Cd/4*pi*DLeak^2)*(2*9.81*H)^alpha+S*H-M;
    H1=H+Dh;
    fh1=(Cd/4*pi*DLeak^2)*(2*9.81*H1)^alpha+S*H1-M;
    
    HNew=H-(Dh*fh)/(fh1-fh);
    Err=abs(((HNew-H)/HNew)*100);
    H=HNew;
end

%H=round(H,3);

end

