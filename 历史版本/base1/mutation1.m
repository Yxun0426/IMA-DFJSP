function [PopulationTs_new1,PopulationFs_new1,PopulationMs_new1] = mutation1(PopulationTs_new,PopulationFs_new,PopulationMs_new,P_m,numOfTasks,numOfPopulation,mcellPerFactory,numOfSubTasks,vectorNumSubTasks,vectorSumOfSubTasks,vectormcellPerFactory,tableOfMcellOptional,tableOfTransTime,tableOfManuTime)
%变异操作

PopulationTs_new1 = zeros(numOfPopulation,numOfSubTasks);
PopulationFs_new1 = zeros(numOfPopulation,numOfSubTasks);
PopulationMs_new1 = zeros(numOfPopulation,numOfSubTasks);

%1.工厂选择序列和机器选择序列：贪婪变异算子(跨工厂)
for i = 1:numOfPopulation
    MS_new_ind = PopulationMs_new(i,:);
    FS_new_ind = PopulationFs_new(i,:);
    for j = 1:numOfTasks
        num = vectorNumSubTasks(1,j);
        count = vectorSumOfSubTasks(1,j);
        for m = 1:num
            F = FS_new_ind(1,count + m);
%             current_FT = tableOfTransTime(count + m,F);%当前运输时间
            M = MS_new_ind(1,count + m);
%             current_MT = tableOfManuTime(count + m,M);%当前制造时间
            P = rand(1);
            if P <= P_m
                [F_list,ind1] = find(tableOfTransTime(count + m,:) ~= 0);
                judge_F = length(F_list);
                r1 = randi(judge_F);
                F_id = ind1(1,r1);
%                 better_F = tableOfTransTime(count + m,F_id);
                
                %%%判断当前更佳的工厂是否有可加工单元
                num_M = mcellPerFactory(1,F_id);%当前更佳的工厂加工单元数量
                count_M = vectormcellPerFactory(1,F_id);%当前更佳的工厂起始ID
                list_M = tableOfMcellOptional(count + m,count_M + 1:count_M + num_M);%当前更佳的工厂可用制造单元列表
                [M_list,ind2] = find(list_M ~= 0);%寻找当前更佳的工厂中更佳的制造单元
                judge_M = length(M_list);
                r2 = randi(judge_M);
                M_id1 = ind2(1,r2);
%                 better_M = tableOfMcellOptional(count + m,count_M + M_id);
                
                FS_new_ind(1,count + m) = F_id;
                MS_new_ind(1,count + m) = M_id1;
            else
                FS_new_ind(1,count + m) = F;
                MS_new_ind(1,count + m) = M;
            end
        end
    end
    PopulationFs_new1(i,:) = FS_new_ind;
    PopulationMs_new1(i,:) = MS_new_ind;
end

%2.机器选择序列：贪婪变异算子(工厂内)
for i = 1:numOfPopulation
    MS_new_ind = PopulationMs_new1(i,:);
    FS_new_ind = PopulationFs_new1(i,:);
    for j = 1:numOfTasks
        num = vectorNumSubTasks(1,j);
        count = vectorSumOfSubTasks(1,j);
        for m = 1:num
            F = FS_new_ind(1,count + m);
            M = MS_new_ind(1,count + m);
%             current_MT = tableOfManuTime(count + m,M);%当前制造时间
            P = rand(1);
            if P <= P_m        
                num_M = mcellPerFactory(1,F);%当前工厂加工单元数量
                count_M = vectormcellPerFactory(1,F);%当前工厂起始ID
                list_M = tableOfMcellOptional(count + m,count_M + 1:count_M + num_M);%当前工厂可用制造单元列表
                [M_list,ind3] = find(list_M ~= 0);%寻找当前工厂中更佳的制造单元
                judge_M = length(M_list);
                r3 = randi(judge_M);
                M_id2 = ind3(1,r3);
%                 better_M = tableOfMcellOptional(count + m,count_M + ind3(1,r3));
                MS_new_ind(1,count + m) = M_id2;
            else
                MS_new_ind(1,count + m) = M;
            end
        end
    end
    PopulationMs_new1(i,:) = MS_new_ind;
end


%3.任务排序序列：邻域变异算子
for k = 1:numOfPopulation
    TS_new_ind = PopulationTs_new(k,:);
    TS_new_ind1 = PopulationTs_new(k,:);
    index0 = randperm(length(TS_new_ind),3);%随机选取序列上的三个位置，并返回索引
    index = sort(index0);%当前索引顺序
    index_list = perms(index);
    [row,~] = size(index_list);
    P1 = rand(1);
    P2 = randi(row);
    if P1 <= P_m
        index_current = index_list(P2,:);
        for m = 1:3
            TS_new_ind1(1,index(1,m)) = TS_new_ind(1,index_current(1,m));
        end
    else
        TS_new_ind = TS_new_ind1;
    end
    PopulationTs_new1(k,:) = TS_new_ind;
end
end