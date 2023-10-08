clear all
clc
close all
rng shuffle
start = cputime;
%参数设置
source = '../DataSet/mk/Mk03_DFJSP.mat';
numOfIterate = 100;%迭代次数
numOfPopulation = 150;%种群规模
P_c0 = 0.8;%交叉概率,线性递减
P_m = 0.01;%变异概率

%数据集读取
% [numOfTasks,vectorNumSubTasks,numOfSubTasks,vectorSumOfSubTasks,numOfFactory,vectormcellPerFactory,mcellPerFactory,numOfTotalMcell,vectorSubTaskSequence,tableOfFactoryOptional,tableOfTransTime,tableOfMcellOptional,tableOfManuTime] = dataSetRead(source);
load(source);
%编码与生成初始化种群
PopulationTs = zeros(numOfPopulation,numOfSubTasks);
PopulationFs = zeros(numOfPopulation,numOfSubTasks);
PopulationMs = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    [PopulationTs(i,:),PopulationFs(i,:),PopulationMs(i,:)] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional);
end

%初始化种群信息矩阵
PopulationTs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationFs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationMs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationTs_iter(:,:,1) = PopulationTs;
PopulationFs_iter(:,:,1) = PopulationFs;
PopulationMs_iter(:,:,1) = PopulationMs;
makespan_population_iter = zeros(numOfIterate,numOfPopulation);
makespan_best_iter = zeros(numOfIterate,1);
start_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
start_Time_trans = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_trans = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
free_Time_start_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
free_Time_end_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
index_Population_iter = zeros(1,2,numOfIterate);
index_best_iter = zeros(numOfIterate,1);
for iter = 1:numOfIterate
    %线性递减的交叉概率计算公式
    P_c = P_c0 * ((numOfIterate-iter)/numOfIterate);
    %全局搜索：交叉算子，变异算子
    [PopulationTs_new,PopulationFs_new,PopulationMs_new] = crossover(PopulationTs_iter(:,:,iter),PopulationFs_iter(:,:,iter),PopulationMs_iter(:,:,iter),P_c,numOfPopulation,numOfTasks,numOfSubTasks);
    [PopulationTs_new1,PopulationFs_new1,PopulationMs_new1] = mutation(PopulationTs_new,PopulationFs_new,PopulationMs_new,P_m,numOfTasks,numOfPopulation,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    %解码
    [F_S,F_T,M_S,M_T,start_Time_pop,end_Time_pop,start_Time_trans0,end_Time_trans0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new1,PopulationFs_new1,PopulationMs_new1,tableOfTransTime,tableOfManuTime);
    %适应度评价
    [makespan_population,makespan_best,index,index_Population] = fitness(end_Time_trans0,numOfPopulation);
    %选择
    [PopulationTs_new2,PopulationFs_new2,PopulationMs_new2] = tournamentSelect(numOfPopulation,numOfSubTasks,makespan_population,PopulationTs_new1,PopulationFs_new1,PopulationMs_new1);
    
    %种群关键信息记录
    PopulationTs_iter(:,:,iter+1) = [PopulationTs_new2];
    PopulationFs_iter(:,:,iter+1) = [PopulationFs_new2];
    PopulationMs_iter(:,:,iter+1) = [PopulationMs_new2];
    makespan_population1 = makespan_population.';
    makespan_population_iter(iter,:) = makespan_population1;
    makespan_best_iter(iter,1) = makespan_best;
    start_Time_iter(:,:,:,iter) = start_Time_pop;
    end_Time_iter(:,:,:,iter) = end_Time_pop;
    start_Time_trans(:,:,:,iter) = start_Time_trans0;
    end_Time_trans(:,:,:,iter) = end_Time_trans0;
    index_Population_iter(:,:,iter) = index_Population;
    index_best_iter(iter,1) = index;
end
endtime = cputime - start;

%%最优个体甘特图
figure(1)
index = index_best_iter(numOfIterate,1);%最优个体索引
start_Time_best = start_Time_iter(:,:,index,numOfIterate);%最优个体的加工开始时间表
end_Time_best = end_Time_iter(:,:,index,numOfIterate);%最优个体的加工结束时间表
start_Time_best_t = start_Time_trans(:,:,index,numOfIterate);%最优个体的运输开始时间表
end_Time_best_t = end_Time_trans(:,:,index,numOfIterate);%最优个体的运输结束时间表
PopulationTs_best = PopulationTs(index,:);%最优个体的顺序序列
ganttGraph1(numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,start_Time_best_t,end_Time_best_t,PopulationTs_best,vectorSumOfSubTasks)%调用甘特图函数
% saveas(gcf,'./result/la01_DFJSP/调度图/最优调度图01.png');

%%最优值迭代曲线
figure(2)
x = 1:numOfIterate;
y = makespan_best_iter.';
makespan = plot(x,y,'r','LineWidth',1);
title('最优值迭代曲线')
xlabel('迭代次数')
ylabel('最优值')
% saveas(makespan,'./result/la01_DFJSP/迭代曲线/迭代曲线01.png');
% 
% save('./result/la01_DFJSP/最优值-迭代/makespan_best_iter01.mat','makespan_best_iter');
% save('./result/la01_DFJSP/全部值-迭代/makespan_population_iter01.mat','makespan_population_iter');
% save('./result/la01_DFJSP/最优值/makespan_best01.txt','makespan_best','acsii');
% save('./result/la01_DFJSP/运行时间/endtime01.txt','endtime','acsii');