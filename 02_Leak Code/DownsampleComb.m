function [] = DownsampleComb(InputPath,Combinations,SampleSize)
%DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here

InputPath=strcat(InputPath);

TotalResults=cell(Combinations,1);


for i=1:Combinations
    Results=csvread(strcat(InputPath,'\results50_',num2str(i),'.csv'));
    
    ResultsUp=Results(1:6,:);
    ResultsDown=Results(7:end,:);
    TTi=size(ResultsDown,1);
    N=size(ResultsDown,1);
    Dt=ResultsUp(4,1);
   
    Time=(0:N-1)*Dt;


    DownSamplingRate=round(TTi/SampleSize);
    NewResultsDown=downsample(ResultsDown,DownSamplingRate);
    NewTime=(downsample(Time,DownSamplingRate))';
    ResultsUp(4,1)=NewTime(2);
    Results=[ResultsUp;NewResultsDown];
    
    TotalResults{i}=Results;
end

FileFinal=TotalResults{1};

for k=2:Combinations
    FileFinal=[FileFinal,TotalResults{k}];
end

Filename='results50_DownTo1200.csv';
csvwrite(Filename,FileFinal);


end

