function [TS,FS,MS] = randomInit(numOfSubTasks,vectorSubTaskSequence,numOfFactory,tableOfFactoryOptional,mcellPerFactory,tableOfMcellOptional)
%   种群初始化方法：随机初始化策略
%   输入：任务数量、子任务数量、工厂数量、每个工厂的制造单元数量矩阵、子任务向量矩阵、可选工厂矩阵、可选加工单元矩阵。
%   输出：任务排序序列、工厂选择序列、制造单元选择序列。
%   步骤：
%   1.随机生成子任务排序序列；
%   2.根据子任务排序序列，在每个子任务的可选加工工厂集合中随机选择一个加工工厂；
%   3.为每个任务的子任务选择加工单元，要结合每个子任务在每个工厂所对应的可选加工单元集合确定。


%1.随机生成子任务排序序列；
%思路：利用randperm函数生成随机整数，且随机整数的数量和取值范围均为子任务总数-->以生成的随机整数为索引，从子任务向量矩阵中取值
indices=randperm(numOfSubTasks);
TS=vectorSubTaskSequence(indices);

%2.根据子任务排序序列，在每个子任务的可选加工工厂集合中随机选择一个加工工厂；
%思路：定义一个工厂列表和工厂序列空矩阵-->从可选工厂表（由数据读取时形成）中读取可选工厂集合
%-->转换成真正对应的工厂编号-->根据可选工厂集合长度随机生成一个随机数-->根据随机数确定索引，选择编号相对应的工厂-->循环填值
list_Factory = 1:numOfFactory;
FS = zeros(1,numOfSubTasks);
for i=1:numOfSubTasks
    factories=tableOfFactoryOptional(i,:);
    factoryOptional=list_Factory(logical(factories));
    numFactoryOptional=length(factoryOptional);
    indexFactory=randi([1 numFactoryOptional]);
    factory=factoryOptional(indexFactory);
    FS(i)=factory;
end

%3.为每个任务的子任务选择加工单元，要结合每个子任务在每个工厂所对应的可选加工单元集合确定。
%思路：读取FS序列中对应的工厂号-->找到该工厂对应的可用加工单元集合-->根据可用加工单元集合长度随机生成一个随机数
%-->根据随机数确定索引，选择编号相对应的加工单元-->循环填值
MS = zeros(1,numOfSubTasks);
for i=1:numOfSubTasks
    factoryID=FS(i);
    numMcells=mcellPerFactory(factoryID);%mcellPerFactory由数据集读取时生成,表示每个工厂具有的加工单元数量。
    num=0;
    for j=1:factoryID-1
        num=num+mcellPerFactory(j);
    end
    list_Mcell=1:numMcells;
    mcells=tableOfMcellOptional(i,num+1:num+numMcells);
    mcellsOptional = list_Mcell(logical(mcells));
    numMcellsOptional=length(mcellsOptional);
    indexMcell=randi([1 numMcellsOptional]);
    mcell=mcellsOptional(indexMcell);
    MS(i)=mcell;
end
end