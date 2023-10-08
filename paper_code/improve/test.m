clear all
clc
close all
rng shuffle

%参数设置
source = '../DataSet/mk/Mk01_DFJSP.mat';
numOfIterate = 150;%迭代次数
numOfPopulation = 100;%种群规模
P_c = 0.8;%交叉概率,线性递减
P_m = 0.2;%变异概率

%数据集读取
% [numOfTasks,vectorNumSubTasks,numOfSubTasks,vectorSumOfSubTasks,numOfFactory,vectormcellPerFactory,mcellPerFactory,numOfTotalMcell,vectorSubTaskSequence,tableOfFactoryOptional,tableOfTransTime,tableOfMcellOptional,tableOfManuTime] = dataSetRead(source);
load(source);
%编码与生成初始化种群
PopulationTs = zeros(numOfPopulation,numOfSubTasks);
PopulationFs = zeros(numOfPopulation,numOfSubTasks);
PopulationMs = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    [PopulationTs(i,:),PopulationFs(i,:),PopulationMs(i,:)] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional,vectormcellPerFactory);
end
%全局搜索算子
[PopulationTs_new,PopulationFs_new,PopulationMs_new] = crossover(PopulationTs,PopulationFs,PopulationMs,P_c,numOfPopulation,numOfTasks,numOfSubTasks);

%解码
[start_Time_pop,end_Time_pop] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new,PopulationFs_new,PopulationMs_new,tableOfManuTime);

%适应度评价
[makespan_population,makespan_best,index,index_Population] = fitness(end_Time_pop,numOfPopulation);

figure(1)
start_Time = start_Time_pop(:,:,index);
end_Time = end_Time_pop(:,:,index);
ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time,end_Time,PopulationTs_new,vectorSumOfSubTasks)%调用甘特图函数
