clear all
clc
rng shuffle

%参数设置
source = './dataSource/vdata/la21.fjs';

%基准实例数据读取
[numOfTasks, numOfTotalMcell, numOfSubTasks, vectorNumSubTasks, vectorSumOfSubTasks, vectorSubTaskSequence, tableOfManuTime, tableOfMcellOptional] = dataSetRead_FJSP(source);

%基准实例数据改造
%生成可选工厂矩阵,生成可选工厂对应的运输时间矩阵
%其中运输时间在[4,10]范围内随机生成 

%%%根据需求划分
numOfFactory = 2;
mcellPerFactory = [5,5];
vectormcellPerFactory = [0,5];
%%%
[tableOfFactoryOptional,tableOfTransTime] = transform(numOfSubTasks,numOfFactory,mcellPerFactory,vectormcellPerFactory,tableOfMcellOptional);
 save('./mydata/vdata/la21_DFJSP.mat');