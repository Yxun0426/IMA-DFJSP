function [tableOfFactoryOptional,tableOfTransTime] = transform(numOfSubTasks,numOfFactory,mcellPerFactory,vectormcellPerFactory,tableOfMcellOptional)
%基准数据补充

%%%生成可选工厂矩阵
tableOfFactoryOptional = zeros(numOfSubTasks,numOfFactory);
for i = 1:numOfSubTasks
    list = tableOfMcellOptional(i,:);
    for j= 1:numOfFactory
        num = mcellPerFactory(1,j);
        start = vectormcellPerFactory(1,j);
        arr_list = list(1,start+1:start+num);
        arr = find(arr_list ~= 0);
        L = length(arr);
        if L ~= 0
            tableOfFactoryOptional(i,j) = 1;
        else
            tableOfFactoryOptional(i,j) = 0;
        end
    end
end

%%%生成转移时间矩阵
tableOfTransTime0 = zeros(numOfFactory,numOfFactory);
for m = 1:numOfFactory
    for n = 1:numOfFactory
        rand = randi([30,80]);
        if m == n
            tableOfTransTime0(m,n) = 0;
        else
            tableOfTransTime0(m,n) = rand;
        end
    end
end
tableOfTransTime = tableOfTransTime0 + tableOfTransTime0.';
end

