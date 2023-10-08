function [PopulationTs_ordinary_new,PopulationFs_ordinary_new,PopulationMs_ordinary_new] = ordinarySelection(numOfPopulation,K,numOfSubTasks,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary)
%普通群体选择：二元锦标赛
PopulationTs_ordinary_new = zeros(numOfPopulation - K,numOfSubTasks);
PopulationFs_ordinary_new = zeros(numOfPopulation - K,numOfSubTasks);
PopulationMs_ordinary_new = zeros(numOfPopulation - K,numOfSubTasks);
for i = 1:numOfPopulation - K
    num1 = randi(numOfPopulation - K);
    num2 = randi(numOfPopulation - K);
    fitness_1 = makespan_population_ordinary(num1);
    fitness_2 = makespan_population_ordinary(num2);
    if fitness_1 >= fitness_2
        PopulationTs_ordinary_new(i,:) = PopulationTs_ordinary(num2,:);
        PopulationFs_ordinary_new(i,:) = PopulationFs_ordinary(num2,:);
        PopulationMs_ordinary_new(i,:) = PopulationMs_ordinary(num2,:);
    else
        PopulationTs_ordinary_new(i,:) = PopulationTs_ordinary(num1,:);
        PopulationFs_ordinary_new(i,:) = PopulationFs_ordinary(num1,:);
        PopulationMs_ordinary_new(i,:) = PopulationMs_ordinary(num1,:);
    end
end
end

