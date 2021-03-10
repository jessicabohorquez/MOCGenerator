# Instruction to run 

This is a code in MATLAB

The main function is called GenerateParRand(InputSysLeak,Total). It takes a .mat file with a series of values representing the characteristics of the pipeline (See explanation below) and the Total number of traces desired (this total number should be a multiple of the number of leaks along the pipeline - InputSysLeak(16)).

If you want to get a subdataset of the complete dataset use Total=5000 (instead of 50 000 used in the paper). 

File InputSysLeak: This file is 19x1 matlab with different numerical values. If you desire to generate the dataset for the same case as the paper, you don't need to change anything. In case a different pipeline is desired:

``` matlab
InputSysLeak(1)= Initial pressure at reservoir (m)
InputSysLeak(2)= Pipe length (m)
InputSysLeak(3)= Diameter of pipeline (m)
InputSysLeak(4)= Thickness cement mortar lining (mm)
InputSysLeak(5)= Thickness steel (mm)
InputSysLeak(6)= Young Modulus of Cement Mortar Lining (GPa)
InputSysLeak(7)= Young Modulus of Steel (GPa)
InputSysLeak(8)= Water density (Kg/m3)
InputSysLeak(9)= Bulk modulus of elasticity (GPa)
InputSysLeak(10)= Pipeline Restrain parameter
InputSysLeak(11)= Kinematic viscosity (m2/s)
InputSysLeak(12)= Velocity in pipeline before valvo closure (m/s)
InputSysLeak(13)= Pipeline roughness (mm)
InputSysLeak(14)= Total simulation time (s)
InputSysLeak(15)= Desired Time Steps
InputSysLeak(16)= Number of Leak locations along the pipeline
InputSysLeak(17)= Valve discharge coefficient
InputSysLeak(18)= Min Leak Diameter (mm)
InputSysLeak(19)= Max Leak Diameter (mm)
```

After running GenerateParRand you should have the dataset before the time downsampling applied in the paper. If you wish to downsample this. Use function DownsampleComb(InputPath,Combinations,SampleSize) where:

InputPath= path where the results from GenerateParRand are
Combinations=Number of files generated from GenerateParRand
SampleSize = Desired length of final traces (1200 for the paper case)
