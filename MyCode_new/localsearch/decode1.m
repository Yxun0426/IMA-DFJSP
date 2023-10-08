function [start_Time_pop,end_Time_pop,start_Time_T_pop,end_Time_T_pop] = decode1(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfTransTime,tableOfManuTime)
%   解码函数：顺序解码与插入式解码
%   输入：
%   输出：工厂顺序矩阵F_S、运输时间顺序矩阵F_T、加工单元顺序矩阵M_S、加工时间顺序矩阵M_T、每个加工单元上的子任务集合、每个加工单元的完工时间以及种群中各个子任务所对应的工厂、运输时间、加工单元和加工时间。

%步骤1：对工厂选择序列进行解码，从左到右依次读取并转换成工厂顺序矩阵F_S和运输时间顺序矩阵F_T；对加工单元选择序列进行解码，从左到右依次读取并转换成加工单元顺序矩阵M_S和加工时间顺序矩阵M_T。
numOfSubTaskMax = max(max(vectorNumSubTasks));
F_S = zeros(numOfTasks,numOfSubTaskMax,numOfPopulation);
F_T = zeros(numOfTasks,numOfSubTaskMax,numOfPopulation);
M_S = zeros(numOfTasks,numOfSubTaskMax,numOfPopulation);
M_T = zeros(numOfTasks,numOfSubTaskMax,numOfPopulation);
for pop = 1:numOfPopulation
    FS = PopulationFs(pop,:);
    MS = PopulationMs(pop,:);
    factory = zeros(numOfTasks,numOfSubTaskMax);
    transTime = zeros(numOfTasks,numOfSubTaskMax);
    mcell = zeros(numOfTasks,numOfSubTaskMax);
    manuTime = zeros(numOfTasks,numOfSubTaskMax);
    
    %%%构建每个任务的每个子任务所对应的工厂选择矩阵、加工单元选择矩阵和加工时间矩阵
    for i = 1:numOfTasks
        numSubT = vectorNumSubTasks(1,i);%每个任务的子任务数
        sum = vectorSumOfSubTasks(i);
        for j = 1:numSubT
            factoryId = FS(1,sum+j);%记录子任务的加工工厂
            factory(i,j) = factoryId;
            mcellId = MS(1,sum+j);%记录子任务的加工单元
            mcell(i,j) = mcellId;
            manuTime(i,j) = tableOfManuTime(sum+j,vectormcellPerFactory(factoryId) + mcellId);
        end
    end
    F_S(:,:,pop) = factory;
    M_S(:,:,pop) = mcell;
    M_T(:,:,pop) = manuTime;
    
    %%%构建每个任务的每个子任务所对应的转移时间矩阵
    for k = 1:numOfTasks
        numSubT = vectorNumSubTasks(1,k);%每个任务的子任务数
%         sum = vectorSumOfSubTasks(k);
        for m = 1:numSubT-1
            current_F = factory(k,m);
            next_F = factory(k,m+1);
            transT = tableOfTransTime(current_F,next_F);
            if current_F ~= next_F
               transTime(k,m) = transT;
            end
        end
    end
    F_T(:,:,pop) = transTime;
end


%步骤2：根据前两步得到的信息，计算每个加工单元分配到的子任务集合,并进行插入式解码。
start_Time_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
end_Time_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
start_Time_T_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
end_Time_T_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
for pop = 1:numOfPopulation
    start_Time = zeros(numOfTotalMcell,numOfSubTasks);
    end_Time = zeros(numOfTotalMcell,numOfSubTasks);
    start_Time_T = zeros(numOfTotalMcell,numOfSubTasks);
    end_Time_T = zeros(numOfTotalMcell,numOfSubTasks);
    TS = PopulationTs(pop,:);
    factory = F_S(:,:,pop);
    transTime = F_T(:,:,pop);
    mcell = M_S(:,:,pop);
    manuTime = M_T(:,:,pop);%%当前加工顺序序列所对应的加工单元和加工时间。
    arr = zeros(1,numOfSubTasks);%辅助任务顺序序列
    for i = 1:numOfSubTasks
        
        taskId = TS(1,i);
        arr(1,i) = taskId;
        count = length(find(arr==taskId));%判断当前子任务是对应任务的第几个子任务
        subtaskId = vectorSumOfSubTasks(1,taskId)+count;%当前子任务的编号
        
        factoryChoose = factory(taskId,count);%当前子任务所对应的工厂
        mcellChoose = mcell(taskId,count);%当前子任务所对应的加工单元
        loc = vectormcellPerFactory(factoryChoose)+mcellChoose;%求子任务对应的加工单元编号
        factoryChoose_Time = transTime(taskId,count);%当前子任务加工前所对应的转移时间
        mcellChoose_Time = manuTime(taskId,count);%当前子任务所对应的加工时间
        
        mcell_choose_1 = end_Time(loc,:);
        mcell_choose = mcell_choose_1(mcell_choose_1 ~= 0);
        L = length(mcell_choose);
        if L ~=0
            mcell_max_end_time = max(mcell_choose);
%           [~,ind] = find(mcell == mcell_max_end_time);
        else
            mcell_max_end_time = 0;
        end%%计算当前加工单元的最大完工时间
        
        if count <= 1
            behind_subtask_end_time = 0;
%             start_Time_T(loc,subtaskId) = 0;
%             end_Time_T(loc,subtaskId) = 0;
        else
            time = end_Time(:,subtaskId-1);
            behind_subtask_end_time = time(time~=0);
%             behind_subtask_end_time = behind_subtask_end_time0 + factoryChoose_Time;
%             start_Time_T(loc,subtaskId) = behind_subtask_end_time0;
%             end_Time_T(loc,subtaskId) = behind_subtask_end_time0 + factoryChoose_Time;
        end%%计算同一任务中上一个子任务的最大完工时间
        empty_judge = isempty(behind_subtask_end_time);
        if empty_judge == 1
            behind_subtask_end_time = 0;
        end
        
        %%%根据当前end和start时间表，确定当前单元的空闲时间段
        %%%%1.首先找到所有空闲时间段
        %%%%2.从前往后逐个判断能否插入
        end_time0 = end_Time(loc,:);
        start_time0 = start_Time(loc,:);
        index_end = find(end_time0 ~= 0);%index_end等于子任务编号
        L_end = length(index_end);
        free_loc = 0;%%%??
        if  L_end ~= 0
            endT = zeros(1,L_end);
            startT = zeros(1,L_end);
            for k = 1:L_end
                ind = index_end(1,k);
                endT(1,k) = end_time0(1,ind);
                startT(1,k) = start_time0(1,ind);
            end
            [endTT,index_sort] = sort(endT);
            [startTT,index_sort] = sort(startT);
            if  L_end ==1
                free_start = 0;
                free_end = 0;
            else
                arr0 = endTT(1,1:L_end-1);
                free_start = [0,arr0];
                free_end = startTT;
            end
            free_time = free_end - free_start;%%%空闲时间
            L_free = length(free_time);
            judge = zeros(1,L_free);
            for m = 1:L_free
                Ft = free_end(m);
                if Ft >= behind_subtask_end_time + factoryChoose_Time + mcellChoose_Time
                    judge(1,m) = 1;
                else
                    judge(1,m) = 0;
                end
            end
            free_loc = find(judge ~= 0,1);%%%%
        end
        
        %%%%开始解码
        if (count <= 1) && (L == 0)%无前置子任务，当前加工单元空闲
            start_Time(loc,subtaskId) = 0;
            end_Time(loc,subtaskId) = 0 + mcellChoose_Time;
        elseif (count <= 1) && (L ~= 0)%无前置子任务，当前加工单元繁忙
            A = isempty(free_loc);
            if A == 1
                start_Time(loc,subtaskId) = mcell_max_end_time;
                end_Time(loc,subtaskId) = mcell_max_end_time + mcellChoose_Time;
            else
                start_Time(loc,subtaskId) = free_start(1,free_loc);
                end_Time(loc,subtaskId) = free_start(1,free_loc) + mcellChoose_Time;
            end
        elseif (count > 1) && (L == 0)%有前置子任务，当前加工单元空闲
            start_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
            end_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time + mcellChoose_Time;
            start_Time_T(loc,subtaskId) = behind_subtask_end_time;
            end_Time_T(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
        elseif (count > 1) && (L ~= 0)%有前置子任务，当前加工单元繁忙
            A = isempty(free_loc);
            if A == 1
                if mcell_max_end_time >= behind_subtask_end_time
                    start_Time(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time;
                    end_Time(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time + mcellChoose_Time;
                    start_Time_T(loc,subtaskId) = mcell_max_end_time;
                    end_Time_T(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time;
                else
                    start_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                    end_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time + mcellChoose_Time;
                    start_Time_T(loc,subtaskId) = behind_subtask_end_time;
                    end_Time_T(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                end
            else
                free = find(free_time >= mcellChoose_Time&free_end -mcellChoose_Time >=behind_subtask_end_time,1);
                B = isempty(free);
                if B == 1
                    if mcell_max_end_time >= behind_subtask_end_time
                        start_Time(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time;
                        end_Time(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time + mcellChoose_Time;
                        start_Time_T(loc,subtaskId) = mcell_max_end_time;
                        end_Time_T(loc,subtaskId) = mcell_max_end_time + factoryChoose_Time;
                    else
                        start_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                        end_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time + mcellChoose_Time;
                        start_Time_T(loc,subtaskId) = behind_subtask_end_time;
                        end_Time_T(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                    end
                else
                    if free_start(1,free) <= behind_subtask_end_time
                        start_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                        end_Time(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time + mcellChoose_Time;
                        start_Time_T(loc,subtaskId) = behind_subtask_end_time;
                        end_Time_T(loc,subtaskId) = behind_subtask_end_time + factoryChoose_Time;
                    else
                        start_Time(loc,subtaskId) = free_start(1,free) + factoryChoose_Time;
                        end_Time(loc,subtaskId) = free_start(1,free) + factoryChoose_Time + mcellChoose_Time;
                        start_Time_T(loc,subtaskId) = free_start(1,free);
                        end_Time_T(loc,subtaskId) = free_start(1,free) + factoryChoose_Time;
                    end
                end
            end
        end
    end
    
    start_Time_pop(:,:,pop) = start_Time;
    end_Time_pop(:,:,pop) = end_Time;
    start_Time_T_pop(:,:,pop) = start_Time_T;
    end_Time_T_pop(:,:,pop) = end_Time_T;
end
end