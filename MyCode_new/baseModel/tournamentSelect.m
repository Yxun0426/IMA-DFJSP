function [PopulationTs_new,PopulationFs_new,PopulationMs_new] = tournamentSelect(numOfPopulation,numOfSubTasks,makespan_population,PopulationTs,PopulationFs,PopulationMs)
%基于二元锦标赛的选择策略：
%对种群中的个体执行二元锦标赛选择，从种群中随机选择2个个体(每个个体被选择的概率相同，且每次选择后复制并放回)
%根据每个个体的适应度值，选择其中适应度值最好的个体进入下一代种群。
PopulationTs_new = zeros(numOfPopulation,numOfSubTasks);
PopulationFs_new = zeros(numOfPopulation,numOfSubTasks);
PopulationMs_new = zeros(numOfPopulation,numOfSubTasks);
for i = 1:numOfPopulation
    num1 = randi(numOfPopulation);
    num2 = randi(numOfPopulation);
    fitness_1 = makespan_population(num1);
    fitness_2 = makespan_population(num2);
    if fitness_1 >= fitness_2
        PopulationTs_new(i,:) = PopulationTs(num2,:);
        PopulationFs_new(i,:) = PopulationFs(num2,:);
        PopulationMs_new(i,:) = PopulationMs(num2,:);
    else
        PopulationTs_new(i,:) = PopulationTs(num1,:);
        PopulationFs_new(i,:) = PopulationFs(num1,:);
        PopulationMs_new(i,:) = PopulationMs(num1,:);
    end
end
end