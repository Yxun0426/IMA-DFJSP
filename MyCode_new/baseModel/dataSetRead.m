function [numOfTasks,vectorNumSubTasks,numOfSubTasks,vectorSumOfSubTasks,numOfFactory,vectormcellPerFactory,mcellPerFactory,numOfTotalMcell,vectorSubTaskSequence,tableOfFactoryOptional,tableOfTransTime,tableOfMcellOptional,tableOfManuTime] = dataSetRead(source)
%   数据集读取函数
%   输入：数据集路径
%   输出：任务总数、每个任务具有的子任务数量向量、子任务总数、子任务累计向量、工厂总数、每个工厂具有的加工单元数量向量、子任务向量矩阵、可选工厂矩阵、可选工厂运输时间矩阵、tableOfMcellOptional、可选加工单元生产时间矩阵。
%   数据格式：
%   第一行和第二行代表基本数据，其中第一行的第一个数字为任务总数，第二个数字为工厂总数；第二行分别为各个工厂中加工单元总数，数据长度等于工厂数，数值代表加工单元个数。
%   第三行至最后一行为详细数据，每一行代表一个任务，总行数等于任务总数；其中每一行的第一个数字代表该任务包括的子任务总数，第二个数字代表
%   实例：
%   5	3
%   3	2	3
%   3  3 1 8 2 2 6 3 5 2 10 2 1 3 2 4 3 7 2 1 7 3 5  3 1 8 1 2 6 2 10 1 1 4 3 7 1 2 5  1 8 2 1 4 2 6 2 10 2 1 5 2 4 3 7 2 1 5 3 4
%   2  3 1 5 2 1 3 3 6 2 4 1 2 5 3 7 3 1 5 2 8 3 4  2 1 5 3 1 4 2 6 3 5 3 7 2 1 4 3 7
%   1  3 1 7 2 1 6 3 4 2 8 1 1 3 3 10 2 2 4 3 5
%   2  3 1 8 1 6 2 6 2 12 1 2 4 3 9 2 1 5 3 9  3 1 8 2 5 3 4 2 12 2 1 7 2 5 3 9 2 2 5 3 5
%   2  2 1 6 3 1 5 2 7 3 8 2 10 1 1 7  3 1 6 1 1 7 2 10 1 2 6 3 8 2 2 6 3 7
%
%   步骤：
%   1.打开文件，进行数据读取
%   2.基本数据获取：具体包括任务总数、工厂总数
%   3.详细数据获取：具体包括每个工厂的加工单元总数、所有工厂的加工单元总数、每个任务的子任务数、子任务序列、每个子任务的运输时间、每个子任务的加工时间
%   4.功能数据获取：具体包括子任务总数、可选加工工厂矩阵、可选加工单元矩阵


%1.打开文件
    dataSet=fopen(source,'r');
    data=fscanf(dataSet,'%f');

%2.基本数据
    numOfTasks = data(1);%任务总数
    numOfFactory = data(2);%工厂总数
    
%3.详细数据
    mcellPerFactory = zeros(1,numOfFactory);%每个工厂的加工单元总数
    index = 3;
    numOfTotalMcell=0;
    for i=1:numOfFactory
        mcellPerFactory(i) = data(index);
        numOfTotalMcell = numOfTotalMcell+mcellPerFactory(i);%所有工厂的加工单元总数
        index = index+1;
    end
    numT = 1;
    vectorSubTaskSequence = [];
    while(numT<=numOfTasks)
        vectorNumSubTasks(numT) = data(index);%每个任务的子任务数
        vectorIndexSubTasks(numT) = sum(vectorNumSubTasks(1:numT-1));%当前任务的子任务数累计
        subTasksequence = ones(1,vectorNumSubTasks(numT))*numT;
        vectorSubTaskSequence = [vectorSubTaskSequence,subTasksequence];%子任务序列
        for numSubTask = 1:vectorNumSubTasks(numT)
            index = index+1;
            numFactory = data(index);
            for numFac = 1:numFactory
                index = index+1;
                factoryId = data(index);
                vectorIndexFactory = sum(mcellPerFactory(1:factoryId-1));
                index = index+1;
                transTime = data(index);
                tableOfTransTime(numSubTask+vectorIndexSubTasks(numT),factoryId)=transTime;%每个子任务的运输时间
                index = index+1;
                numMcell = data(index);
                for numMC = 1:numMcell
                    index = index+1;
                    MCellId = data(index);
                    index = index+1;
                    manuTime = data(index);
                    tableOfManuTime(numSubTask+vectorIndexSubTasks(numT),vectorIndexFactory+MCellId)= manuTime;%每个子任务的加工时间
                end
            end
        end
        numT = numT+1;
        index = index+1;
    end

%4.功能数据
numOfSubTasks = length(vectorSubTaskSequence);%所有任务的子任务数的总和
for task = 1:numOfTasks
    vectorSumOfSubTasks(task) = sum(vectorNumSubTasks(1:task-1));%子任务累计向量
end
for f = 1:numOfFactory
    vectormcellPerFactory(f) = sum(mcellPerFactory(1:f-1));
end
tableOfFactoryOptional = [];%可选工厂矩阵
for fac = 1:length(tableOfTransTime)
    index_factory = tableOfTransTime(fac,:) ~= 0;
    tableOfFactoryOptional = [tableOfFactoryOptional;index_factory];
end
tableOfMcellOptional = [];%可选加工单元矩阵
for mcell = 1:length(tableOfManuTime)
    index_mcell = tableOfManuTime(mcell,:) ~= 0;
    tableOfMcellOptional = [tableOfMcellOptional;index_mcell];
end
end