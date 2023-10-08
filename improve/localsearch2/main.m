clear all
clc
close all
rng shuffle
start = cputime;

%参数设置
source = '../DataSet/mk/Mk07_DFJSP.mat';
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
makespan_population_T_iter = zeros(numOfIterate,numOfPopulation);
makespan_best_T_iter = zeros(numOfIterate,1);
start_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
end_Time_iter = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation,numOfIterate);
index_Population_T_iter = zeros(1,2,numOfIterate);
index_best_T_iter = zeros(numOfIterate,1);

PopulationTs_iter(:,:,1) = PopulationTs;
PopulationFs_iter(:,:,1) = PopulationFs;
PopulationMs_iter(:,:,1) = PopulationMs;
%%%初始种群评价
[F_S,F_T,M_S,M_T,start_Time_pop,end_Time_pop,start_Time_trans0,end_Time_trans0] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfTransTime,tableOfManuTime);
[makespan_population_T,makespan_best_T,index_best_T,index_Population_T] = fitness(end_Time_trans0,numOfPopulation);

makespan_population_T_iter(1,:) = makespan_population_T;
makespan_best_T_iter(1,:) = makespan_best_T;
% makespan_population_M_iter(1,:) = makespan_population_M;
% makespan_best_M_iter(1,:) = makespan_best_M;
start_Time_iter(:,:,:,1) = start_Time_pop;
end_Time_iter(:,:,:,1) = end_Time_pop;
start_Time_trans(:,:,:,1) = start_Time_trans0;
end_Time_trans(:,:,:,1) = end_Time_trans0;
index_Population_T_iter(:,:,1) = index_Population_T;
index_best_T_iter(1,:) = index_best_T;
% index_Population_M_iter(:,:,1) = index_Population_M;
% index_best_M_iter(1,:) = index_best_M;


for iter = 1:numOfIterate
    %线性递减的交叉概率计算公式
    P_c = P_c0 * ((numOfIterate-iter)/numOfIterate);
    
    PopulationTs_merge0 = PopulationTs_iter(:,:,iter);
    PopulationFs_merge0 = PopulationFs_iter(:,:,iter);
    PopulationMs_merge0 = PopulationMs_iter(:,:,iter);
    makespan_population_merge0 = makespan_population_T_iter(iter,:);
    
    
    %种群分级
    [PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary] = classifyPopulation(numOfPopulation,PopulationTs_merge0,PopulationFs_merge0,PopulationMs_merge0,makespan_population_merge0,K);
    
    
    %精英群体进化
    [PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new] = eliteSelection(K,numOfSubTasks,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite);
    [PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1] = crossover(PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new,P_c,K/2,numOfTasks,numOfSubTasks);
    [PopulationTs_elite_new2,PopulationFs_elite_new2,PopulationMs_elite_new2] = mutation(PopulationTs_elite_new1,PopulationFs_elite_new1,PopulationMs_elite_new1,P_m,numOfTasks,K/2,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
    %普通群体进化
    [PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new] = ordinarySelection(numOfPopulation,K,numOfSubTasks,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary);
    [PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1] = crossover(PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new,P_c,K/2,numOfTasks,numOfSubTasks);
    [PopulationTs_ordinary_new2,PopulationFs_ordinary_new2,PopulationMs_ordinary_new2] = mutation(PopulationTs_ordinary_new1,PopulationFs_ordinary_new1,PopulationMs_ordinary_new1,P_m,numOfTasks,K/2,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
    %混合群体进化
    [PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid] = hybridSelection(numOfSubTasks,numOfPopulation,K,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary);
    [PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new] = crossover(PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid,P_c,numOfPopulation-K,numOfTasks,numOfSubTasks);
    [PopulationTs_hybrid_new1,PopulationFs_hybrid_new1,PopulationMs_hybrid_new1] = mutation(PopulationTs_hybrid_new,PopulationFs_hybrid_new,PopulationMs_hybrid_new,P_m,numOfTasks,numOfPopulation-K,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime);
    
    
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
    makespan = makespan_population_T_iter(iter,:).';
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
    
    %%%解码
    [~,~,~,~,start_Time_pop_merge,end_Time_pop_merge,start_Time_trans_merge,end_Time_trans_merge] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs_new2,PopulationFs_new2,PopulationMs_new2,tableOfTransTime,tableOfManuTime);
    [makespan_population_merge,makespan_best_merge,index_best_merge,index_Population_merge] = fitness(end_Time_trans_merge,numOfPopulation);
    
    
    %%局部搜索
    [TS_set,FS_set,MS_set,L] = localSearch(numOfTasks,numOfSubTasks,PopulationTs_new2,PopulationFs_new2,PopulationMs_new2,index_best_merge,index_Population_merge,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks);
    MK = zeros(1,L);
    start_Time_M = zeros(numOfTotalMcell,numOfSubTasks,L);
    end_Time_M = zeros(numOfTotalMcell,numOfSubTasks,L);
    start_Time_T = zeros(numOfTotalMcell,numOfSubTasks,L);
    end_Time_T = zeros(numOfTotalMcell,numOfSubTasks,L);
    index = zeros(1,2,L);
    for c = 1:L
        TS = TS_set(c,:);
        FS = FS_set(c,:);
        MS = MS_set(c,:);
        [~,~,~,~,start_Time_M,end_Time_M,start_Time_T,end_Time_T] = decode(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,1,TS,FS,MS,tableOfTransTime,tableOfManuTime);
        [makespan_LC,~,~,index_LC] = fitness(end_Time_T,1);
        MK(1,c) = makespan_LC;
        start_Time_M(:,:,c) = start_Time_M;
        end_Time_M(:,:,c) = end_Time_M;
        start_Time_T(:,:,c) = start_Time_T;
        end_Time_T(:,:,c) = end_Time_T;
        index(:,:,c) = index_LC;
    end
    J = find(MK < makespan_best_merge,1);
    LJ = length(J);
    if LJ == 0
        PopulationTs_update = PopulationTs_new2;
        PopulationFs_update = PopulationFs_new2;
        PopulationMs_update = PopulationMs_new2;
        makespan_population_update = makespan_population_merge;
        makespan_best_merge_update = makespan_best_merge;
        start_Time_update = start_Time_pop_merge;
        end_Time_update = end_Time_pop_merge;
        start_Time_trans_update = start_Time_trans_merge;
        end_Time_trans_update = end_Time_trans_merge;
        index_best_T_update = index_best_merge;
        index_Population_T_update = index_Population_merge;
    else
        PopulationTs_new2(index_best_merge,:) = TS_set(J,:);
        PopulationFs_new2(index_best_merge,:) = FS_set(J,:);
        PopulationMs_new2(index_best_merge,:) = MS_set(J,:);
        PopulationTs_update = PopulationTs_new2;
        PopulationFs_update = PopulationFs_new2;
        PopulationMs_update = PopulationMs_new2;
        makespan_population_merge(index_best_merge,1) = MK(1,J);
        makespan_population_update = makespan_population_merge;
        makespan_best_merge_update = MK(1,J);
        start_Time_pop_merge(:,:,index_best_merge) = start_Time_M(:,:,J);
        start_Time_update = start_Time_pop_merge;
        end_Time_pop_merge(:,:,index_best_merge) = end_Time_M(:,:,J);
        end_Time_update = end_Time_pop_merge;
        start_Time_trans_merge(:,:,index_best_merge) = start_Time_T(:,:,J);
        start_Time_trans_update = start_Time_trans_merge;
        end_Time_trans_merge(:,:,index_best_merge) = end_Time_T(:,:,J);
        end_Time_trans_update = end_Time_trans_merge;
        index_best_T_update = index_best_merge;
        index_Population_T_update = index(:,:,J);
    end
    
    %种群关键信息记录
    PopulationTs_iter(:,:,iter+1) = [PopulationTs_update];
    PopulationFs_iter(:,:,iter+1) = [PopulationFs_update];
    PopulationMs_iter(:,:,iter+1) = [PopulationMs_update];
    makespan_population3 = makespan_population_update.';
    makespan_population_T_iter(iter+1,:) = makespan_population3;
    makespan_best_T_iter(iter+1,1) = makespan_best_merge_update;
    start_Time_iter(:,:,:,iter+1) = start_Time_update;
    end_Time_iter(:,:,:,iter+1) = end_Time_update;
    start_Time_trans(:,:,:,iter+1) = start_Time_trans_update;
    end_Time_trans(:,:,:,iter+1) = end_Time_trans_update;
    index_best_T_iter(iter+1,1) = index_best_T_update;
    index_Population_T_iter(:,:,iter+1) = index_Population_T_update;
%     index_best_M_iter(iter+1,1) = index_best_M_update;
%     index_Population_M_iter(:,:,iter+1) = index_Population_M_update;
end
endtime = cputime - start;

%%最优个体甘特图
figure(1)
makespan_best = makespan_best_T_iter(numOfIterate,1);
index = index_best_T_iter(numOfIterate,1);%最优个体索引
start_Time_best = start_Time_iter(:,:,index,numOfIterate);%最优个体的加工开始时间表
end_Time_best = end_Time_iter(:,:,index,numOfIterate);%最优个体的加工结束时间表
start_Time_best_t = start_Time_trans(:,:,index,numOfIterate);%最优个体的运输开始时间表
end_Time_best_t = end_Time_trans(:,:,index,numOfIterate);%最优个体的运输结束时间表
PopulationTs_best = PopulationTs(index,:);%最优个体的顺序序列
ganttGraph(numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,start_Time_best_t,end_Time_best_t,PopulationTs_best,vectorSumOfSubTasks)%调用甘特图函数
%ganttGraph2(numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,PopulationTs_best,vectorSumOfSubTasks)
% saveas(gcf,'../result/la01_DFJSP/调度图/最优调度图01.png');

%%最优值迭代曲线
figure(2)
x = 1:numOfIterate+1;
y = makespan_best_T_iter.';
makespan = plot(x,y,'r','LineWidth',1);
title('最优值迭代曲线')
xlabel('迭代次数')
ylabel('最优值')
% saveas(makespan,'../result/la01_DFJSP/迭代曲线/迭代曲线01.png');

% save('../result/la01_DFJSP/最优值-迭代/makespan_best_iter01.mat','makespan_best_iter');
% save('../result/la01_DFJSP/全部值-迭代/makespan_population_iter01.mat','makespan_population_iter');
% save('../result/la01_DFJSP/最优值/makespan_best01.txt','makespan_best','-ascii');
% save('../result/la01_DFJSP/运行时间/endtime01.txt','endtime','-ascii');