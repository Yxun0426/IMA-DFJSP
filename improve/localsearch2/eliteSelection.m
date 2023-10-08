function [PopulationTs_elite_new,PopulationFs_elite_new,PopulationMs_elite_new] = eliteSelection(K,numOfSubTasks,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite)
%精英群体选择：二元锦标赛
PopulationTs_elite_new = zeros(K/2,numOfSubTasks);
PopulationFs_elite_new = zeros(K/2,numOfSubTasks);
PopulationMs_elite_new = zeros(K/2,numOfSubTasks);
for i = 1:K/2
    num1 = randi(K);
    num2 = randi(K);
    fitness_1 = makespan_population_elite(num1);
    fitness_2 = makespan_population_elite(num2);
    if fitness_1 >= fitness_2
        PopulationTs_elite_new(i,:) = PopulationTs_elite(num2,:);
        PopulationFs_elite_new(i,:) = PopulationFs_elite(num2,:);
        PopulationMs_elite_new(i,:) = PopulationMs_elite(num2,:);
    else
        PopulationTs_elite_new(i,:) = PopulationTs_elite(num1,:);
        PopulationFs_elite_new(i,:) = PopulationFs_elite(num1,:);
        PopulationMs_elite_new(i,:) = PopulationMs_elite(num1,:);
    end
end
end

