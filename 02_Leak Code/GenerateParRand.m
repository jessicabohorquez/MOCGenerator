function [] = GenerateParRand(InputSysLeak,Total)
%Function that generates a file with transient pressure traces measured at the end of a pipe with
%one leak located at different points along the pipeline

LT=InputSysLeak(2);
MinTS=InputSysLeak(15);
TT=InputSysLeak(14);
NumLoc=InputSysLeak(16);
D=InputSysLeak(3);
DLeakMin=InputSysLeak(18);
DLeakMax=InputSysLeak(19);

[a]=WaveSpeed(InputSysLeak);
DeltaD=LT/NumLoc;

Times=Total/NumLoc;

FileUpV=cell(Times,1);
FileDownV=cell(Times,1);

Dt=TT/MinTS;
DiscL=Dt*a;

DiscL=round(DiscL*10)/10;

LAvail=LT-DiscL;

%parpool('local',2)
tic
for k=1:Times
    %k=4;
        
    DistV=zeros(NumLoc-2,1);
    
    Li=DiscL;

    for i=1:NumLoc-2
        RandDelta=DeltaD*rand();
        Dist=Li+RandDelta;
        Li=Li+DeltaD;
        DistV(i)=Dist;
    end

    FileDown=zeros(MinTS,NumLoc-2);
    FileUp=zeros(6,NumLoc-2);
    
    FileUp(2,:)=D;
    FileUp(4,:)=Dt;
    FileUp(5,:)=a;
    FileUp(6,:)=k;
   
    %Run the Leak function several times
    n=NumLoc-2;
    for i=1:n
        Dist=DistV(i)
        Dist=160;
        DLeak=randi([DLeakMin,DLeakMax]);
        DLeak=1;
                           
        [HeadV] = Leak(InputSysLeak,Dist,DLeak,Dt,a);
        
        FileUp(1,i)=Dist;
        FileUp(3,i)=DLeak;
        FileDown(:,i)=HeadV;
        
        plot(HeadV)
             
        %FileDownV{k,1}=FileDown;
        %FileUpV{k,1}=FileUp;   
    end

    File=[FileUp;FileDown];
    
    Str=strcat('results50_',num2str(k),'.csv');
    Filename=Str;

    csvwrite(Filename,File);

end
toc

end

