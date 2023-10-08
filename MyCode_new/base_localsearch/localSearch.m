function [critical_TS1,critical_FS1,critical_MS1,L] = localSearch(numOfFactory,numOfTasks,numOfSubTasks,PopulationTs,PopulationFs,PopulationMs,index_best,index_Population,tableOfManuTime,vectorNumSubTasks,vectorSumOfSubTasks,end_Time,vectormcellPerFactory,mcellPerFactory)
%%%在关键工厂、关键单元和关键工序上进行局部搜索

%%1.确定关键路径上的关键工厂、关键加工单元、关键子任务
critical_TS = PopulationTs(index_best,:);
critical_FS = PopulationFs(index_best,:);
critical_MS = PopulationMs(index_best,:);%关键序列定位

critical_mcell = index_Population(1,1);%关键单元编号
critical_ST = index_Population(1,2);%关键子任务编号
Task = find(vectorSumOfSubTasks >= critical_ST,1)-1;%关键任务编号
if isempty(Task) == 1
    Task = numOfTasks;
end
STask_num = vectorNumSubTasks(1,Task);%子任务数量
Task_Start = vectorSumOfSubTasks(1,Task);
STask_list = zeros(1,STask_num);%关键子任务集合
for j = 1:STask_num
    STask_list(1,j) = Task_Start + j;
end



%%%2.关键任务局部搜索
critical_task_FS = critical_FS;
critical_task_MS = critical_MS;
critical_subtask_TS = zeros(STask_num,numOfSubTasks);
critical_subtask_FS = zeros(STask_num,numOfSubTasks);
critical_subtask_MS = zeros(STask_num,numOfSubTasks);
for k = 1:STask_num
    ST = STask_list(1,k);
    CM = critical_MS(1,ST);
    CF = critical_FS(1,ST);
    CMID = vectormcellPerFactory(1,CF) + CM;
    current_mcellTime = tableOfManuTime(ST,CMID);%当前单元制造时间%%%%%%%%存在BUG
    
    if current_mcellTime == 0
        Optional_list0 = tableOfManuTime(ST,:);
        ind = find(Optional_list0 ~= 0);
        Optional_list = Optional_list0(ind);
        [~,index_op] = sort(Optional_list);
        best_mcell_index = ind(index_op(1));
        best_factory = find(vectormcellPerFactory >= best_mcell_index,1)-1;
        if isempty(best_factory) == 1
            best_factory = numOfFactory;
        end
        best_mcell = best_mcell_index - vectormcellPerFactory(1,best_factory);
        critical_task_FS(1,ST) = best_factory;
        critical_task_MS(1,ST) = best_mcell;
        critical_subtask_FS(k,:) = critical_task_FS;
        critical_subtask_TS(k,:) = critical_TS;
        critical_subtask_MS(k,:) = critical_task_MS;
    else
        Optional_list0 = tableOfManuTime(ST,:);
        ind = find(Optional_list0 ~= 0);
        Optional_list = Optional_list0(ind);
        loc = find(Optional_list <= current_mcellTime,1);
        best_mcell_index = ind(loc);
        best_factory = find(vectormcellPerFactory >= best_mcell_index,1)-1;
        if isempty(best_factory) == 1
            best_factory = numOfFactory;
        end
        best_mcell = best_mcell_index - vectormcellPerFactory(1,best_factory);
        critical_task_FS(1,ST) = best_factory;
        critical_task_MS(1,ST) = best_mcell;
        critical_subtask_FS(k,:) = critical_task_FS;
        critical_subtask_TS(k,:) = critical_TS;
        critical_subtask_MS(k,:) = critical_task_MS;
    end
end

%%3.关键单元和关键工厂局部搜索
critical_mcell_MS1 = critical_MS;
subtask_list0 = end_Time(critical_mcell,:);
subtask_list = find(subtask_list0 ~= 0);
subtask_num = length(subtask_list);
critical_cell_TS = zeros(subtask_num,numOfSubTasks);
critical_cell_FS = zeros(subtask_num,numOfSubTasks);
critical_cell_MS = zeros(subtask_num,numOfSubTasks);
for m = 1:subtask_num
    current_ST = subtask_list(1,m);
    CM1 = critical_MS(1,current_ST);
    CF1 = critical_FS(1,current_ST);
    mcell_num = mcellPerFactory(1,CF1);
    mcell_start = vectormcellPerFactory(1,CF1);
    QJ = [mcell_start + 1:mcell_start + CM1 - 1,mcell_start + CM1 + 1:mcell_start + mcell_num];
    mcell_list0 = tableOfManuTime(critical_ST,QJ);%其他可选加工单元集合
    index_mcell = find(mcell_list0 ~= 0);
    if isempty(index_mcell) == 1
        best_mcell1 = CM1;
        critical_mcell_MS1(1,current_ST) = best_mcell1;
        critical_cell_FS(m,:) = critical_FS;
        critical_cell_TS(m,:) = critical_TS;
        critical_cell_MS(m,:) = critical_mcell_MS1;
    else
        mcell_list = mcell_list0(index_mcell);
        QJ1 = QJ(index_mcell);
        [~,loc] = sort(mcell_list);
        mcell = QJ1(loc(1));
        best_mcell1 = mcell - vectormcellPerFactory(1,CF1);
        critical_mcell_MS1(1,current_ST) = best_mcell1;
        critical_cell_FS(m,:) = critical_FS;
        critical_cell_TS(m,:) = critical_TS;
        critical_cell_MS(m,:) = critical_mcell_MS1;
    end
end


critical_TS1 = [critical_subtask_TS;critical_cell_TS];
critical_FS1 = [critical_subtask_FS;critical_cell_FS];
critical_MS1 = [critical_subtask_MS;critical_cell_MS];
L = STask_num + subtask_num;
end