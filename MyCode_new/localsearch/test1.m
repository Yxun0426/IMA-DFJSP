clear all
clc

source = '../DataSet/mk/Mk01_DFJSP.mat';
numOfIterate = 100;%迭代次数
numOfPopulation = 150;%种群规模
P_c0 = 0.8;%交叉概率,线性递减
P_m = 0.01;%变异概率
Re = 0.4;%精英保留率
K = Re * numOfPopulation;
load(source);

%编码与生成初始化种群
PopulationTs = zeros(numOfPopulation,numOfSubTasks);
PopulationFs = zeros(numOfPopulation,numOfSubTasks);
PopulationMs = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    [PopulationTs(i,:),PopulationFs(i,:),PopulationMs(i,:)] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional,vectormcellPerFactory);
end

%%%初始种群评价
[start_Time_pop,end_Time_pop,start_Time_T_pop,end_Time_T_pop] = decode2(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfTransTime,tableOfManuTime);
[makespan_population_T,makespan_best_T,index_best_T,index_Population_T] = fitness(end_Time_pop,numOfPopulation);

%%最优个体甘特图
figure(1)
ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best_T,start_Time_pop,end_Time_pop,start_Time_T_pop,end_Time_T_pop,PopulationTs,vectorSumOfSubTasks)%调用甘特图函数

