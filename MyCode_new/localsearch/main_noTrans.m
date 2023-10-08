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
Re = 0.4;%精英保留率
K = Re * numOfPopulation;

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
[start_Time_pop,end_Time_pop] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfManuTime);
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
    PopulationTs_merge0 = PopulationTs_iter(:,:,iter);
    PopulationFs_merge0 = PopulationFs_iter(:,:,iter);
    PopulationMs_merge0 = PopulationMs_iter(:,:,iter);
    makespan_population_merge0 = makespan_population_iter(iter,:);
    
    
    %%%种群分级
    [PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite0,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary0] = classifyPopulation(numOfPopulation,PopulationTs_merge0,PopulationFs_merge0,PopulationMs_merge0,makespan_population_merge0,K);
    
    
    %%%精英群体进化
    [PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new] = eliteSelection(K,numOfSubTasks,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite0);
    [PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1] = crossover(PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new,P_c,K,numOfTasks,numOfSubTasks);
    [PopulationTs_elite_new2,PopulationFs_elite_new2,PopulationMs_elite_new2] = mutation(PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1,P_m,numOfTasks,K,mcellPerFactory,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfFactoryOptional);
    %解码与评价
    [start_Time_pop_elite,end_Time_pop_elite] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,K,PopulationTs_elite_new2,PopulationFs_elite_new2,PopulationMs_elite_new2,tableOfManuTime);
    [makespan_population_elite,makespan_best_elite,index_best_elite,index_Population_elite] = fitness(end_Time_pop_elite,K);
    [makespan_population_elite1,index_elite1] = sort(makespan_population_elite);
    makespan_population_elite2 = makespan_population_elite1(1:K/2,:);
    PopulationTs_elite_new3 = PopulationTs_elite_new2(index_elite1(1:K/2),:);
    PopulationFs_elite_new3 = PopulationFs_elite_new2(index_elite1(1:K/2),:);
    PopulationMs_elite_new3 = PopulationMs_elite_new2(index_elite1(1:K/2),:);
    
    
    %%%普通群体进化
    [PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new] = ordinarySelection(numOfPopulation,K,numOfSubTasks,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary0);
    [PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1] = crossover(PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new,P_c,K,numOfTasks,numOfSubTasks);
    [PopulationTs_ordinary_new2,PopulationFs_ordinary_new2,PopulationMs_ordinary_new2] = mutation(PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1,P_m,numOfTasks,K,mcellPerFactory,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfFactoryOptional);
    %解码与评价
    [start_Time_pop_ordinary,end_Time_pop_ordinary] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,K,PopulationTs_ordinary_new2,PopulationFs_ordinary_new2,PopulationMs_ordinary_new2,tableOfManuTime);
    [makespan_population_ordinary,makespan_best_ordinary,index_best_ordinary,index_Population_ordinary] = fitness(end_Time_pop_ordinary,K);
    [makespan_population_ordinary1,index_ordinary1] = sort(makespan_population_ordinary);
    makespan_population_ordinary2 = makespan_population_ordinary1(1:K/2,:);
    PopulationTs_ordinary_new3 = PopulationTs_ordinary_new2(index_elite1(1:K/2),:);
    PopulationFs_ordinary_new3 = PopulationFs_ordinary_new2(index_elite1(1:K/2),:);
    PopulationMs_ordinary_new3 = PopulationMs_ordinary_new2(index_elite1(1:K/2),:);
    
    
    %%%混合群体进化
    [PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid] = hybridSelection(numOfSubTasks,numOfPopulation,K,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite0,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary0);
    [PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new] = crossover(PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid,P_c,numOfPopulation-K,numOfTasks,numOfSubTasks);
    [PopulationTs_hybrid_new1,PopulationFs_hybrid_new1,PopulationMs_hybrid_new1] = mutation(PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new,P_m,numOfTasks,numOfPopulation-K,mcellPerFactory,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfFactoryOptional);
    %解码与评价
    [start_Time_pop_hybrid,end_Time_pop_hybrid] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation-K,PopulationTs_hybrid_new1,PopulationFs_hybrid_new1,PopulationMs_hybrid_new1,tableOfManuTime);
    [makespan_population_hybrid,makespan_best_hybrid,index_best_hybrid,index_Population_hybrid] = fitness(end_Time_pop_hybrid,numOfPopulation-K);
    
    
    %序列合并
    PopulationTs_merge1 = [PopulationTs_elite_new3;PopulationTs_ordinary_new3;PopulationTs_hybrid_new1];
    PopulationFs_merge1 = [PopulationFs_elite_new3;PopulationFs_ordinary_new3;PopulationFs_hybrid_new1];
    PopulationMs_merge1 = [PopulationMs_elite_new3;PopulationMs_ordinary_new3;PopulationMs_hybrid_new1];
    %%%解码
    [start_Time_pop_merge,end_Time_pop_merge] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_merge1,PopulationFs_merge1,PopulationMs_merge1,tableOfManuTime);
    [makespan_population_merge,makespan_best_merge,index_best_merge,index_Population_merge] = fitness(end_Time_pop_merge,numOfPopulation);
    
    
    %%局部搜索
    [TS_set,FS_set,MS_set,L] = localSearch(numOfFactory,numOfTasks,numOfSubTasks,PopulationTs_merge1,PopulationFs_merge1,PopulationMs_merge1,index_best_merge,index_Population_merge,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks,end_Time_pop_merge(:,:,index_best_merge),vectormcellPerFactory,mcellPerFactory);
    for c = 1:L
        TS = TS_set(c,:);
        FS = FS_set(c,:);
        MS = MS_set(c,:);
        [start_Time_M0,end_Time_M0] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,1,TS,FS,MS,tableOfManuTime);
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
PopulationTs_best = PopulationTs(index,:);%最优个体的顺序序列
ganttGraph1(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,vectorSumOfSubTasks)%调用甘特图函数
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