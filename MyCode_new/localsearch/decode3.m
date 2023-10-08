function [start_Time_pop,end_Time_pop] = decode3(numOfTasks,numOfSubTasks,vectormcellPerFactory,numOfTotalMcell,vectorNumSubTasks,vectorSumOfSubTasks,numOfPopulation,PopulationTs,PopulationFs,PopulationMs,tableOfManuTime)
%   解码函数：顺序解码与插入式解码
%   输入：
%   输出：工厂顺序矩阵F_S、运输时间顺序矩阵F_T、加工单元顺序矩阵M_S、加工时间顺序矩阵M_T、每个加工单元上的子任务集合、每个加工单元的完工时间以及种群中各个子任务所对应的工厂、运输时间、加工单元和加工时间。

%步骤1：对工厂选择序列进行解码，从左到右依次读取并转换成工厂顺序矩阵F_S和运输时间顺序矩阵F_T；对加工单元选择序列进行解码，从左到右依次读取并转换成加工单元顺序矩阵M_S和加工时间顺序矩阵M_T。


%步骤2：根据前两步得到的信息，计算每个加工单元分配到的子任务集合,并进行插入式解码。
start_Time_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
end_Time_pop = zeros(numOfTotalMcell,numOfSubTasks,numOfPopulation);
numOfSubTaskMax = max(max(vectorNumSubTasks));
for pop = 1:numOfPopulation
    start_Time = zeros(numOfTotalMcell,numOfSubTasks);
    end_Time = zeros(numOfTotalMcell,numOfSubTasks);
    TS = PopulationTs(pop,:);
    FS = PopulationFs(pop,:);
    MS = PopulationMs(pop,:);
    factory = zeros(numOfTasks,numOfSubTaskMax);
    mcell = zeros(numOfTasks,numOfSubTaskMax);
    manuTime = zeros(numOfTasks,numOfSubTaskMax);%%当前加工顺序序列所对应的加工单元和加工时间。
    %%%构建每个任务的每个子任务所对应的工厂选择矩阵、加工单元选择矩阵和加工时间矩阵
    for i = 1:numOfTasks
        numSubT = vectorNumSubTasks(1,i);%每个任务的子任务数
        sum = vectorSumOfSubTasks(i);
        for j = 1:numSubT
            factoryId = FS(1,sum+j);%记录子任务的加工工厂
            factory(i,j) = factoryId;
            mcellId = MS(1,sum+j);%记录子任务的加工单元
            mcell(i,j) = mcellId;
            time = tableOfManuTime(sum+j,vectormcellPerFactory(factoryId) + mcellId);
            if time ~= 0
                manuTime(i,j) = time;
            else
                index = find(tableOfManuTime(sum+j,:) ~= 0,1);
                manuTime(i,j) = tableOfManuTime(sum+j,index);
                num_fac = length(vectormcellPerFactory);
                A = [vectormcellPerFactory,num_fac];
                for p = 1:num_fac
                    if index > A(1,p) && index <= A(1,p + 1)
                        fac = p;
                        cell = index - A(1,p);
                    end
                end
                FS(pop,sum+j) = fac;
                MS(pop,sum+j) = cell;
            end
        end
    end
    
    arr = zeros(1,numOfSubTasks);%辅助任务顺序序列
    for i = 1:numOfSubTasks
        taskId = TS(1,i);
        arr(1,i) = taskId;
        count = length(find(arr == taskId));%判断当前子任务是对应任务的第几个子任务
        subtaskId = vectorSumOfSubTasks(1,taskId)+count;%当前子任务的编号
        
        factoryChoose = factory(taskId,count);%当前子任务所对应的工厂
        mcellChoose = mcell(taskId,count);%当前子任务所对应的加工单元
        loc = vectormcellPerFactory(factoryChoose)+mcellChoose;%求子任务对应的加工单元编号
        mcellChoose_Time = manuTime(taskId,count);%当前子任务所对应的加工时间
        
        
        %%%计算当前加工单元的最大完工时间
        mcell_choose_1 = end_Time(loc,:);
        mcell_choose = mcell_choose_1(mcell_choose_1 ~= 0);
        L = length(mcell_choose);
        if L ~= 0
            mcell_max_end_time = max(mcell_choose);
%           [~,ind] = find(mcell == mcell_max_end_time);
        else
            mcell_max_end_time = 0;
        end
        
        
        %%计算前置子任务的最大完成时间（加工时间+转移时间）
        if count <= 1
            front_subtask_end_time = 0;
        else
            time = end_Time(:,subtaskId - 1);
            front_subtask_end_time = time(time ~= 0);
        end
%         if isempty(front_subtask_end_time) == 1
%             front_subtask_end_time = 0;
%         end
        
        %%%根据当前end和start时间表，确定当前单元的空闲时间段
        %1.首先找到所有空闲时间段
        end_time0 = end_Time(loc,:);
        start_time0 = start_Time(loc,:);
        end_time1 = end_time0(end_time0 ~= 0);
        start_time1 = start_time0(end_time0 ~= 0);
        end_time2 = sort(end_time1);
        start_time2 = sort(start_time1);
        num_free0 = length(end_time2);
        if num_free0 ~= 0
            if num_free0 > 1
                free_start = end_time2(1:num_free0 - 1);%潜在空闲开始时间
                free_end = start_time2(2:num_free0);%潜在空闲结束时间
                free_value = free_end - free_start;%潜在空闲时间值
                [~,free_loc] = find(free_value ~= 0);%潜在非零空闲时间段的位置，元素值等于子任务编号
                num_free = length(free_loc);%潜在空闲时间段数量
            else
                num_free = 0;
            end
        else
            num_free = 0;
        end
        %2.从前往后逐个判断各个空闲时间段能否插入
        if num_free == 0
            judge = zeros(1,num_free);
        else
            judge = zeros(1,num_free);
            for j = 1:num_free
                current_free_start = free_start(1,free_loc(1,j));
                current_free_end = free_end(1,free_loc(1,j));
                if (count <= 1) && (current_free_start + mcellChoose_Time <= current_free_end)%无前置子任务可插入
                    judge(1,j) = 1;
                elseif(count <= 1) && (current_free_start + mcellChoose_Time > current_free_end)%无前置子任务不可插入
                    judge(1,j) = 0;
                elseif (count > 1) && (front_subtask_end_time <= current_free_start) && (current_free_start + mcellChoose_Time <= current_free_end)%有前置子任务且前置子任务结束时间小于空闲时间,可插入
                    judge(1,j) = 1;
                elseif (count > 1) && (front_subtask_end_time <= current_free_start) && (current_free_start + mcellChoose_Time > current_free_end)%有前置子任务且前置子任务结束时间小于空闲时间，不可插入
                    judge(1,j) = 0;
                elseif (count > 1) && (front_subtask_end_time > current_free_start) && (front_subtask_end_time + mcellChoose_Time <= current_free_end)%有前置子任务且前置子任务结束时间大于空闲时间，可插入
                    judge(1,j) = 1;
                elseif (count > 1) && (front_subtask_end_time > current_free_start) && (front_subtask_end_time + mcellChoose_Time > current_free_end)%有前置子任务且前置子任务结束时间大于空闲时间，不可插入
                    judge(1,j) = 0;
                end
            end
        end
        %%%开始解码
        insert = find(judge ~= 0,1);
        judge_insert = isempty(insert);
        if (count <= 1) && (L == 0)%无前置子任务，当前加工单元空闲
            start_Time(loc,subtaskId) = 0;
            end_Time(loc,subtaskId) = 0 + mcellChoose_Time;
        elseif (count <= 1) && (L ~= 0) && (num_free == 0)%无前置子任务，当前加工单元繁忙,无空闲可插入
            start_Time(loc,subtaskId) = mcell_max_end_time;
            end_Time(loc,subtaskId) = mcell_max_end_time + mcellChoose_Time;
        elseif (count <= 1) && (L ~= 0) && (num_free ~= 0) && (judge_insert == 0)%无前置子任务，当前加工单元繁忙,有空闲可插入，满足插入条件
            start_Time(loc,subtaskId) = free_start(free_loc(insert));
            end_Time(loc,subtaskId) = free_start(free_loc(insert)) + mcellChoose_Time;
        elseif (count <= 1) && (L ~= 0) && (num_free ~= 0) && (judge_insert == 1)%无前置子任务，当前加工单元繁忙,有空闲可插入,但不满足插入条件
            start_Time(loc,subtaskId) = mcell_max_end_time;
            end_Time(loc,subtaskId) = mcell_max_end_time + mcellChoose_Time;
            
            
            
        elseif (count > 1) && (L == 0)%有前置子任务，当前加工单元空闲
            start_Time(loc,subtaskId) = front_subtask_end_time;
            end_Time(loc,subtaskId) = front_subtask_end_time + mcellChoose_Time;
        elseif (count > 1) && (L ~= 0) && (num_free == 0) && (front_subtask_end_time > mcell_max_end_time)%有前置子任务，当前加工单元繁忙，且无空闲时间段，前置子任务结束时间大于机器空闲时间
            start_Time(loc,subtaskId) = front_subtask_end_time;
            end_Time(loc,subtaskId) = front_subtask_end_time + mcellChoose_Time;
        elseif (count > 1) && (L ~= 0) && (num_free == 0) && (front_subtask_end_time <= mcell_max_end_time)%有前置子任务，当前加工单元繁忙，且无空闲时间段，前置子任务结束时间小于机器空闲时间
            start_Time(loc,subtaskId) = mcell_max_end_time;
            end_Time(loc,subtaskId) = mcell_max_end_time + mcellChoose_Time;
        elseif (count > 1) && (L ~= 0) && (num_free ~= 0) && (judge_insert == 0) && (free_start(free_loc(insert)) >= front_subtask_end_time)%有前置子任务，当前加工单元繁忙，且有空闲时间段，满足插入条件,并且空闲开始时间大于前置子任务的完成时间
            start_Time(loc,subtaskId) = free_start(free_loc(insert));
            end_Time(loc,subtaskId) = free_start(free_loc(insert)) + mcellChoose_Time;
        elseif (count > 1) && (L ~= 0) && (num_free ~= 0) && (judge_insert == 0) && (free_start(free_loc(insert)) < front_subtask_end_time)%有前置子任务，当前加工单元繁忙，且有空闲时间段，满足插入条件,并且空闲开始时间小于前置子任务的完成时间
            start_Time(loc,subtaskId) = front_subtask_end_time;
            end_Time(loc,subtaskId) = front_subtask_end_time + mcellChoose_Time;
        elseif (count > 1) && (L ~= 0) && (num_free ~= 0) && (judge_insert == 1)%有前置子任务，当前加工单元繁忙，且有空闲时间段，但不满足插入条件
            start_Time(loc,subtaskId) = mcell_max_end_time;
            end_Time(loc,subtaskId) = mcell_max_end_time + mcellChoose_Time;
        end
    end
    start_Time_pop(:,:,pop) = start_Time;
    end_Time_pop(:,:,pop) = end_Time;
end
end