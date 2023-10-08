function [TS_set,FS_set,MS_set,L] = localSearch(numOfTasks,numOfSubTasks,PopulationTs,PopulationFs,PopulationMs,index_best,index_Population,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks)
%%%在关键路径上进行局部搜索:删除+转移

%%1.确定关键路径上的关键加工单元、关键子任务、关键工序集合
critical_TS = PopulationTs(index_best,:);
critical_FS = PopulationFs(index_best,:);
critical_MS = PopulationMs(index_best,:);%关键序列定位
critical_mcell = index_Population(1,1);%关键加工单元编号
critical_ST = index_Population(1,2);%关键子任务编号

%%2.找到当前关键路径上各个关键工序的可用加工单元列表
Optional_list = tableOfManuTime(critical_ST,:);
Optional_id  = find(Optional_list ~= 0);
list_index = find(Optional_id ~= critical_mcell);
L = length(list_index);
if L == 0
    TS_set = PopulationTs;
    FS_set = PopulationFs;
    MS_set = PopulationMs;
else
    TS_set = zeros(L,numOfSubTasks);
    FS_set = zeros(L,numOfSubTasks);
    MS_set = zeros(L,numOfSubTasks);
    for i = 1:L
        cell_ID = list_index(1,i);
        for j = 1:numOfTasks
            sum = vectorNumSubTasks(1,j);
            a = vectorSumOfSubTasks(1,j);
            b = cell_ID - a;
            if b <= sum&&b > 0
                factory = j;
                mcell = b;
            end
        end
        critical_FS(1,critical_ST) = factory;
        critical_MS(1,critical_ST) = mcell;
        TS_set(i,:) = critical_TS;
        FS_set(i,:) = critical_FS;
        MS_set(i,:) = critical_MS;
    end
end
end

