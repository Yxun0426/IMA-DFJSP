function [PopulationTs_new,PopulationFs_new,PopulationMs_new] = crossover(PopulationTs,PopulationFs,PopulationMs,P_c,numOfPopulation,numOfTasks,numOfSubTasks)
%

%1.工厂选择序列和加工单元选择序列：UX交叉
PopulationFs_new = zeros(numOfPopulation,numOfSubTasks);
PopulationMs_new = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    FS_ind = PopulationFs(i,:);
    MS_ind = PopulationMs(i,:);
    K1 = randi(numOfPopulation);
    FSparent_1 = FS_ind;
    FSparent_2 = PopulationFs(K1,:);
    MSparent_1 = MS_ind;
    MSparent_2 = PopulationMs(K1,:);%得到两个父代个体
    P = rand(1);
    if P <= P_c
        K2 = randi(numOfSubTasks);
        random_list = randperm(numOfSubTasks);
        UX_list = random_list(1,1:K2);
        L_UX_list = length(UX_list);
        for k = 1:L_UX_list
            FS_value(1,k) = FSparent_2(1,UX_list(k));
            FSparent_1(1,UX_list(k)) = FS_value(1,k);
            MS_value(1,k) = MSparent_2(1,UX_list(k));
            MSparent_1(1,UX_list(k)) = MS_value(1,k);
        end
        PopulationFs_new(i,:) = FSparent_1;
        PopulationMs_new(i,:) = MSparent_1;
    else
        PopulationFs_new(i,:) = FS_ind;
        PopulationMs_new(i,:) = MS_ind;
    end
end


%2.POX交叉
PopulationTs_POX = PopulationTs(:,:);
PopulationTs_new = zeros(numOfPopulation,numOfSubTasks);
for n = 1:numOfPopulation
    TS_ind = PopulationTs_POX(n,:);
    TS_K1 = randi(numOfPopulation);
    TSparent_1 = TS_ind;
    TSparent_2 = PopulationTs_POX(TS_K1,:);%得到两个父代个体
    P = rand(1);
    if P <= P_c
        TS_list = randperm(numOfTasks);
        TS_K1 = randi(numOfTasks);
        POX_list1 = TS_list(1,1:TS_K1);
        POX_list2 = TS_list(1,TS_K1 + 1:numOfTasks);
        judge1 = zeros(1,numOfSubTasks);
        judge2 = zeros(1,numOfSubTasks);
        for m = 1:numOfSubTasks
            T1 = TSparent_1(1,m);
            T2 = TSparent_2(1,m);
            A0 = find(POX_list1 == T1);
            B0 = find(POX_list2 == T2);
            A = length(A0);
            B = length(B0);
            if A == 0
                judge1(1,m) = 0;
            else
                judge1(1,m) = 1;
            end
            if B == 0
                judge2(1,m) = 0;
            else
                judge2(1,m) = 1;
            end
        end
        index1 = find(judge1 ~= 0);
        index2 = find(judge2 ~= 0);
        index3 = find(judge1 == 0);
        L1 = length(index1);
        L2 = length(index2);
        child_TS = zeros(1,numOfSubTasks);
        for o = 1:numOfSubTasks
            for q = 1:L1
                TS_value1 = TSparent_1(1,index1(1,q));
                child_TS(1,index1(1,q)) = TS_value1;
            end
            for p = 1:L2
                TS_value2 = TSparent_2(1,index2(1,p));
                child_TS(1,index3(1,p)) = TS_value2;
            end
        end
        PopulationTs_new(n,:) = child_TS;
    else
        PopulationTs_new(n,:) = TS_ind;
    end
end
% %TEST
% count_TS = zeros(25,10);
% for zyx = 1:25
%     TS = PopulationTs_new(zyx,:);
%     for cc = 1:10
%          count_TS(zyx,cc) = length(find(TS == cc));
%     end
% end
end