clear all
clc
close all
rng shuffle
start = cputime;
%参数设置
source = '../DataSet/mk/Mk01_DFJSP.mat';
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

%解码与适应度评价
[start_Time_pop0,end_Time_pop0,start_Time_trans1,end_Time_trans1] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfTransTime,tableOfManuTime);
[makespan_population0,makespan_best0,index0,index_Population0] = fitness(end_Time_pop0,numOfPopulation);

%初始化种群信息矩阵
PopulationTs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationFs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationMs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationTs_iter(:,:,1) = PopulationTs;
PopulationFs_iter(:,:,1) = PopulationFs;
PopulationMs_iter(:,:,1) = PopulationMs;

makespan_population_iter = zeros(numOfIterate,numOfPopulation);
makespan_population_iter(1,:) = makespan_population0;
makespan_best_iter = zeros(numOfIterate,1);
makespan_best_iter(1,1) = makespan_best0;

start_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
start_Time_trans = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_trans = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
free_Time_start_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
free_Time_end_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
index_Population_iter = zeros(1,2,numOfIterate);
index_best_iter = zeros(numOfIterate,1);

start_Time_iter(:,:,:,1) = start_Time_pop0;
end_Time_iter(:,:,:,1) = end_Time_pop0;
start_Time_trans(:,:,:,1) = start_Time_trans1;
end_Time_trans(:,:,:,1) = end_Time_trans1;
index_best_iter(1,:) = index0;
index_Population_iter(:,:,1) = index_Population0;

for iter = 1:numOfIterate-1
    %线性递减的交叉概率计算公式
    P_c = P_c0 * ((numOfIterate-iter)/numOfIterate);
    %全局搜索：交叉算子，变异算子
    [PopulationTs_new,PopulationFs_new,PopulationMs_new] = crossover(PopulationTs_iter(:,:,iter),PopulationFs_iter(:,:,iter),PopulationMs_iter(:,:,iter),P_c,numOfPopulation,numOfTasks,numOfSubTasks);
    [PopulationTs_new1,PopulationFs_new1,PopulationMs_new1] = mutation(PopulationTs_new,PopulationFs_new,PopulationMs_new,P_m,numOfTasks,numOfPopulation,mcellPerFactory,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfFactoryOptional);
    
    %解码
    [start_Time_pop,end_Time_pop,start_Time_trans0,end_Time_trans0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new1,PopulationFs_new1,PopulationMs_new1,tableOfTransTime,tableOfManuTime);
    %适应度评价
    [makespan_population,~,~,index_Population] = fitness(end_Time_pop,numOfPopulation);
    %选择
    [PopulationTs_new2,PopulationFs_new2,PopulationMs_new2] = tournamentSelect(numOfPopulation,numOfSubTasks,makespan_population,PopulationTs_new1,PopulationFs_new1,PopulationMs_new1);
    
    %%%解码
    [start_Time_pop_merge,end_Time_pop_merge,start_Time_trans_merge,end_Time_trans_merge] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new2,PopulationFs_new2,PopulationMs_new2,tableOfTransTime,tableOfManuTime);
    [makespan_population_merge,makespan_best_merge,index_best_merge,index_Population_merge] = fitness(end_Time_pop_merge,numOfPopulation);
    
    PopulationTs_merge1 = PopulationTs_new2;
    PopulationFs_merge1 = PopulationFs_new2;
    PopulationMs_merge1 = PopulationMs_new2;
    
    
    %%局部搜索
    [TS_set,FS_set,MS_set,L] = localSearch(numOfFactory,numOfTasks,numOfSubTasks,PopulationTs_merge1,PopulationFs_merge1,PopulationMs_merge1,index_best_merge,index_Population_merge,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks,end_Time_pop_merge(:,:,index_best_merge),vectormcellPerFactory,mcellPerFactory);
    for c = 1:L
        TS = TS_set(c,:);
        FS = FS_set(c,:);
        MS = MS_set(c,:);
        [start_Time_M0,end_Time_M0,start_Time_T0,end_Time_T0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,1,TS,FS,MS,tableOfTransTime,tableOfManuTime);
        [makespan_LC,~,~,index_LC] = fitness(end_Time_M0,1);
        if makespan_LC <= makespan_best_merge
            PopulationTs_merge1(index_best_merge,:) = TS;
            PopulationFs_merge1(index_best_merge,:) = FS;
            PopulationMs_merge1(index_best_merge,:) = MS;
            start_Time_pop_merge(:,:,index_best_merge) = start_Time_M0;
            end_Time_pop_merge(:,:,index_best_merge) = end_Time_M0;
            start_Time_trans_merge(:,:,index_best_merge) = start_Time_T0;
            end_Time_trans_merge(:,:,index_best_merge) = end_Time_T0;
            makespan_population_merge(index_best_merge,1) = makespan_LC;
            makespan_best_merge = makespan_LC;
            index_Population_merge = index_LC;
        end
    end

    %种群关键信息记录
    PopulationTs_iter(:,:,iter+1) = PopulationTs_merge1;
    PopulationFs_iter(:,:,iter+1) = PopulationFs_merge1;
    PopulationMs_iter(:,:,iter+1) = PopulationMs_merge1;
    makespan_population3 = makespan_population_merge.';
    makespan_population_iter(iter+1,:) = makespan_population3;
    makespan_best_iter(iter+1,1) = makespan_best_merge;
    start_Time_iter(:,:,:,iter+1) = start_Time_pop_merge;
    end_Time_iter(:,:,:,iter+1) = end_Time_pop_merge;
    start_Time_trans(:,:,:,iter+1) = start_Time_trans_merge;
    end_Time_trans(:,:,:,iter+1) = end_Time_trans_merge;
    index_best_iter(iter+1,1) = index_best_merge;
    index_Population_iter(:,:,iter+1) = index_Population_merge;
end
endtime = cputime - start;

%%最优个体甘特图
figure(1)
index = index_best_iter(numOfIterate,1);%最优个体索引
makespan_best = makespan_best_iter(numOfIterate,1);
start_Time_best = start_Time_iter(:,:,index,numOfIterate);%最优个体的加工开始时间表
end_Time_best = end_Time_iter(:,:,index,numOfIterate);%最优个体的加工结束时间表
start_Time_best_t = start_Time_trans(:,:,index,numOfIterate);%最优个体的运输开始时间表
end_Time_best_t = end_Time_trans(:,:,index,numOfIterate);%最优个体的运输结束时间表
PopulationTs_best = PopulationTs(index,:);%最优个体的顺序序列
ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,start_Time_best_t,end_Time_best_t,PopulationTs_best,vectorSumOfSubTasks)%调用甘特图函数
% saveas(gcf,'./result/la01_DFJSP/调度图/最优调度图01.png');

%%最优值迭代曲线
figure(2)
x = 1:numOfIterate;
y = makespan_best_iter.';
makespan = plot(x,y,'-ro','LineWidth',1);
grid on
grid minor
title('Makespan convergence curve','FontSize',16,'FontWeight','bold','FontName','Times New Roman')
xlabel('Number of iterations','FontSize',14,'FontWeight','bold','FontName','Times New Roman')
ylabel('Makespan','FontSize',14,'FontWeight','bold','FontName','Times New Roman')
% saveas(makespan,'./result/la01_DFJSP/迭代曲线/迭代曲线01.png');
% 
% save('./result/la01_DFJSP/最优值-迭代/makespan_best_iter01.mat','makespan_best_iter');
% save('./result/la01_DFJSP/全部值-迭代/makespan_population_iter01.mat','makespan_population_iter');
% save('./result/la01_DFJSP/最优值/makespan_best01.txt','makespan_best','acsii');
% save('./result/la01_DFJSP/运行时间/endtime01.txt','endtime','acsii');