clear all
clc
close all
rng shuffle
start = cputime;

% %参数设置
source = './dataSet_Transform/mydata/BR/Mk10_DFJSP.mat';
% source = './dataSet_Transform/mydata/vdata/la02_DFJSP.mat';
% source = '../DataSet/la/la01_DFJSP.mat';
numOfIterate = 150;%迭代次数
numOfPopulation = 150;%种群规模
P_c0 = 0.8;%交叉概率
P_m = 0.01;%变异概率

%数据集读取
load(source);
% [numOfTasks, numOfTotalMcell, numOfSubTasks, vectorNumSubTasks, vectorSumOfSubTasks, vectorSubTaskSequence, tableOfManuTime, tableOfMcellOptional] = dataSetRead_FJSP(source);

%编码与生成初始化种群
PopulationTs = zeros(numOfPopulation,numOfSubTasks);
PopulationFs = zeros(numOfPopulation,numOfSubTasks);
PopulationMs = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    [PopulationTs(i,:),PopulationFs(i,:),PopulationMs(i,:)] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional,vectormcellPerFactory);
end


%初始化种群信息矩阵
PopulationTs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationFs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);
PopulationMs_iter = zeros(numOfPopulation,numOfSubTasks,numOfIterate);

makespan_population_iter = zeros(numOfIterate,numOfPopulation);
makespan_best_iter = zeros(numOfIterate,1);

start_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);

index_Population_iter = zeros(1,2,numOfIterate);
index_best_iter = zeros(numOfIterate,1);

PopulationTs_iter(:,:,1) = PopulationTs;
PopulationFs_iter(:,:,1) = PopulationFs;
PopulationMs_iter(:,:,1) = PopulationMs;
%%%初始种群评价
[start_Time_pop,end_Time_pop] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfManuTime);
[makespan_population,makespan_best,index_best,index_Population] = fitness(end_Time_pop,numOfPopulation);

makespan_population_iter(1,:) = makespan_population;
makespan_best_iter(1,:) = makespan_best;
start_Time_iter(:,:,:,1) = start_Time_pop;
end_Time_iter(:,:,:,1) = end_Time_pop;
index_Population_iter(:,:,1) = index_Population;
index_best_iter(1,:) = index_best;

for iter = 1:numOfIterate-1
    %%%线性递减的交叉概率计算公式
    P_c = P_c0 * ((numOfIterate-iter)/numOfIterate);
    PopulationTs_merge = PopulationTs_iter(:,:,iter);
    PopulationFs_merge = PopulationFs_iter(:,:,iter);
    PopulationMs_merge = PopulationMs_iter(:,:,iter);
    makespan_population_merge = makespan_population_iter(iter,:);
    %选择
    [PopulationTs_new,PopulationFs_new,PopulationMs_new,~] = tournamentSelect(numOfPopulation,numOfPopulation,numOfSubTasks,makespan_population_merge,PopulationTs_merge,PopulationFs_merge,PopulationMs_merge);
    %交叉
    [PopulationTs_new1,PopulationFs_new1,PopulationMs_new1] = crossover(PopulationTs_new,PopulationFs_new,PopulationMs_new,P_c,numOfPopulation,numOfTasks,numOfSubTasks);
    %变异
    [PopulationTs_new2,PopulationFs_new2,PopulationMs_new2] = mutation(PopulationTs_new1,PopulationFs_new1,PopulationMs_new1,P_m,numOfTasks,numOfPopulation,mcellPerFactory,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfFactoryOptional);
    
    %解码
    [start_Time_pop_merge0,end_Time_pop_merge0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new2,PopulationFs_new2,PopulationMs_new2,tableOfManuTime);
    [makespan_population_merge0,makespan_best_merge,~,index_Population_merge] = fitness(end_Time_pop_merge0,numOfPopulation);
    
    [~,ind] = sort(makespan_population_merge0);
    PopulationTs_merge1 = PopulationTs_new2(ind(1:numOfPopulation),:);
    PopulationFs_merge1 = PopulationFs_new2(ind(1:numOfPopulation),:);
    PopulationMs_merge1 = PopulationMs_new2(ind(1:numOfPopulation),:);
    start_Time_pop_merge = start_Time_pop_merge0(:,:,ind(1:numOfPopulation));
    end_Time_pop_merge = end_Time_pop_merge0(:,:,ind(1:numOfPopulation));
    makespan_population_merge = makespan_population_merge0(ind(1:numOfPopulation),:);
    index_best_merge = 1;
    
    %%局部搜索
    [TS_set,FS_set,MS_set,L] = localSearch1(numOfFactory,numOfTasks,numOfSubTasks,PopulationTs_merge1,PopulationFs_merge1,PopulationMs_merge1,index_best_merge,index_Population_merge,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks,end_Time_pop_merge(:,:,index_best_merge),vectormcellPerFactory,mcellPerFactory);
    for c = 1:L
        TS = TS_set(c,:);
        FS = FS_set(c,:);
        MS = MS_set(c,:);
        [start_Time_M0,end_Time_M0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,1,TS,FS,MS,tableOfManuTime);
        [makespan_LC,~,~,index_LC] = fitness(end_Time_M0,1);
        if makespan_LC <= makespan_best_merge
            PopulationTs_merge1(index_best_merge,:) = TS;
            PopulationFs_merge1(index_best_merge,:) = FS;
            PopulationMs_merge1(index_best_merge,:) = MS;
            start_Time_pop_merge(:,:,index_best_merge) = start_Time_M0;
            end_Time_pop_merge(:,:,index_best_merge) = end_Time_M0;
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
    index_best_iter(iter+1,1) = index_best_merge;
    index_Population_iter(:,:,iter+1) = index_Population_merge;
end
endtime = cputime - start;

%%最优个体甘特图
figure(1)
makespan_best = makespan_best_iter(numOfIterate,1);
index = index_best_iter(numOfIterate,1);%最优个体索引
start_Time_best = start_Time_iter(:,:,index,numOfIterate);%最优个体的加工开始时间表
end_Time_best = end_Time_iter(:,:,index,numOfIterate);%最优个体的加工结束时间表
ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,vectorSumOfSubTasks)%调用甘特图函数
% saveas(gcf,'../result/la01_DFJSP/调度图/最优调度图01.png');

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
% saveas(makespan,'../result/la01_DFJSP/迭代曲线/迭代曲线01.png');

% save('../result/la01_DFJSP/最优值-迭代/makespan_best_iter01.mat','makespan_best_iter');
% save('../result/la01_DFJSP/全部值-迭代/makespan_population_iter01.mat','makespan_population_iter');
% save('../result/la01_DFJSP/最优值/makespan_best01.txt','makespan_best','-ascii');
% save('../result/la01_DFJSP/运行时间/endtime01.txt','endtime','-ascii');