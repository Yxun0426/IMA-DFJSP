clear all
clc
close all
rng shuffle
start = cputime;

%参数设置
source = '../DataSet/mk/Mk04_DFJSP.mat';
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
    [PopulationTs(i,:),PopulationFs(i,:),PopulationMs(i,:)] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional);
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
[F_S,F_T,M_S,M_T,start_Time_pop,end_Time_pop,start_Time_trans0,end_Time_trans0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfTransTime,tableOfManuTime);
[makespan_population,makespan_best,index,index_Population] = fitness(end_Time_trans0,numOfPopulation);
makespan_population_iter(1,:) = makespan_population;
makespan_best_iter(1,:) = makespan_best;
start_Time_iter(:,:,:,1) = start_Time_pop;
end_Time_iter(:,:,:,1) = end_Time_pop;
start_Time_trans(:,:,:,1) = start_Time_trans0;
end_Time_trans(:,:,:,1) = end_Time_trans0;
index_Population_iter(:,:,1) = index_Population;
index_best_iter(1,:) = index;


for iter = 1:numOfIterate
    %线性递减的交叉概率计算公式
    P_c = P_c0 * ((numOfIterate-iter)/numOfIterate);
    
    PopulationTs_merge0 = PopulationTs_iter(:,:,iter);
    PopulationFs_merge0 = PopulationFs_iter(:,:,iter);
    PopulationMs_merge0 = PopulationMs_iter(:,:,iter);
    makespan_population_merge0 = makespan_population_iter(iter,:);
    
    
    %种群分级
    [PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary] = classifyPopulation(numOfPopulation,PopulationTs_merge0,PopulationFs_merge0,PopulationMs_merge0,makespan_population_merge0,K);
    
    
    %精英群体进化
    [PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new] = eliteSelection(K,numOfSubTasks,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite);
    [PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1] = crossover(PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new,P_c,K/2,numOfTasks,numOfSubTasks);
    [PopulationTs_elite_new2,PopulationFs_elite_new2,PopulationMs_elite_new2] = mutation(PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1,P_m,numOfTasks,K/2,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
    %普通群体进化
    [PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new] = ordinarySelection(numOfPopulation,K,numOfSubTasks,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary);
    [PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1] = crossover(PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new,P_c,numOfPopulation-K,numOfTasks,numOfSubTasks);
    [PopulationTs_ordinary_new2,PopulationFs_ordinary_new2,PopulationMs_ordinary_new2] = mutation(PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1,P_m,numOfTasks,numOfPopulation-K,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
    %混合群体进化
    [PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid] = hybridSelection(numOfSubTasks,numOfPopulation,K,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary);
    [PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new] = crossover(PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid,P_c,K/2,numOfTasks,numOfSubTasks);
    [PopulationTs_hybrid_new1,PopulationFs_hybrid_new1,PopulationMs_hybrid_new1] = mutation(PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new,P_m,numOfTasks,K/2,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
    %%解码与评价
    PopulationTs_merge = [PopulationTs_elite_new2;PopulationTs_ordinary_new2;PopulationTs_hybrid_new1];
    PopulationFs_merge = [PopulationFs_elite_new2;PopulationFs_ordinary_new2;PopulationFs_hybrid_new1];
    PopulationMs_merge = [PopulationMs_elite_new2;PopulationMs_ordinary_new2;PopulationMs_hybrid_new1];
    [F_S,F_T,M_S,M_T,start_Time_pop_new,end_Time_pop_new,start_Time_trans1,end_Time_trans1] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_merge,PopulationFs_merge,PopulationMs_merge,tableOfTransTime,tableOfManuTime);
    [makespan_population_new,makespan_best_new,index_best,index_Population_new] = fitness(end_Time_trans1,numOfPopulation);
    
    %%种群选择
    %序列合并
    PopulationTs_merge1 = [PopulationTs_merge0;PopulationTs_elite_new2;PopulationTs_ordinary_new2;PopulationTs_hybrid_new1];
    PopulationFs_merge1 = [PopulationFs_merge0;PopulationFs_elite_new2;PopulationFs_ordinary_new2;PopulationFs_hybrid_new1];
    PopulationMs_merge1 = [PopulationMs_merge0;PopulationMs_elite_new2;PopulationMs_ordinary_new2;PopulationMs_hybrid_new1];
    %适应度值合并
    makespan = makespan_population_iter(iter,:).';
    makespan_population_new1 = [makespan;makespan_population_new];
    %加工时间合并
    end_Time_p = end_Time_iter(:,:,:,iter);
    start_Time_p = start_Time_iter(:,:,:,iter);
    start_Time_pop_new1 = cat(3,start_Time_p,start_Time_pop_new);
    end_Time_pop_new1 = cat(3,end_Time_p,end_Time_pop_new);
    %运输时间合并
    end_Time_t = end_Time_trans(:,:,:,iter);
    start_Time_t = start_Time_trans(:,:,:,iter);
    start_Time_tr = cat(3,start_Time_t,start_Time_trans1);
    end_Time_tr = cat(3,end_Time_t,end_Time_trans1);
    %锦标赛选择
    [PopulationTs_new2,PopulationFs_new2,PopulationMs_new2,index_p] = tournamentSelect(numOfPopulation,numOfSubTasks,makespan_population_new1,PopulationTs_merge1,PopulationFs_merge1,PopulationMs_merge1);
    
    
    %种群关键信息记录
    PopulationTs_iter(:,:,iter+1) = [PopulationTs_new2];
    PopulationFs_iter(:,:,iter+1) = [PopulationFs_new2];
    PopulationMs_iter(:,:,iter+1) = [PopulationMs_new2];
    makespan_population3 = makespan_population_new1(index_p).';
    makespan_population_iter(iter+1,:) = makespan_population3;
    makespan_best_iter(iter+1,1) = makespan_best_new;
    index_b = find(makespan_population3 == min(makespan_population3),1);
    start_Time_iter(:,:,:,iter+1) = start_Time_pop_new1(:,:,index_p);
    end_Time_iter(:,:,:,iter+1) = end_Time_pop_new1(:,:,index_p);
    start_Time_trans(:,:,:,iter+1) = start_Time_tr(:,:,index_p);
    end_Time_trans(:,:,:,iter+1) = end_Time_tr(:,:,index_p);
    index_Population_iter(:,:,iter+1) = index_Population_new;
    index_best_iter(iter+1,1) = index_b;
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
ganttGraph(numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,start_Time_best_t,end_Time_best_t,PopulationTs_best,vectorSumOfSubTasks)%调用甘特图函数
% saveas(gcf,'../result/la01_DFJSP/调度图/最优调度图01.png');

%%最优值迭代曲线
figure(2)
x = 1:numOfIterate+1;
y = makespan_best_iter.';
makespan = plot(x,y,'r','LineWidth',1);
title('最优值迭代曲线')
xlabel('迭代次数')
ylabel('最优值')
% saveas(makespan,'../result/la01_DFJSP/迭代曲线/迭代曲线01.png');

% save('../result/la01_DFJSP/最优值-迭代/makespan_best_iter01.mat','makespan_best_iter');
% save('../result/la01_DFJSP/全部值-迭代/makespan_population_iter01.mat','makespan_population_iter');
% save('../result/la01_DFJSP/最优值/makespan_best01.txt','makespan_best','-ascii');
% save('../result/la01_DFJSP/运行时间/endtime01.txt','endtime','-ascii');