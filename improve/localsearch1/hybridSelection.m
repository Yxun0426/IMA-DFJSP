function [PopulationTs_hybrid,PopulationFs_hybrid,PopulationMs_hybrid] = hybridSelection(numOfSubTasks,numOfPopulation,K,PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary)
%混合群体选择：均匀选择
%混合群体大小为K
PopulationTs_hybrid = zeros(numOfPopulation-K,numOfSubTasks);
PopulationFs_hybrid = zeros(numOfPopulation-K,numOfSubTasks);
PopulationMs_hybrid = zeros(numOfPopulation-K,numOfSubTasks);
for i = 1:(numOfPopulation-K)/2
    num1 = randi(K);
    num2 = randi(K);
    num3 = randi(numOfPopulation - K);
    num4 = randi(numOfPopulation - K);
    fitness_1 = makespan_population_elite(num1);
    fitness_2 = makespan_population_elite(num2);
    fitness_3 = makespan_population_ordinary(num3);
    fitness_4 = makespan_population_ordinary(num4);
    
    if fitness_1 >= fitness_2
        PopulationTs_hybrid(i,:) = PopulationTs_elite(num2,:);
        PopulationFs_hybrid(i,:) = PopulationFs_elite(num2,:);
        PopulationMs_hybrid(i,:) = PopulationMs_elite(num2,:);
    else
        PopulationTs_hybrid(i,:) = PopulationTs_elite(num1,:);
        PopulationFs_hybrid(i,:) = PopulationFs_elite(num1,:);
        PopulationMs_hybrid(i,:) = PopulationMs_elite(num1,:);
    end
    
    if fitness_3 >= fitness_4
        PopulationTs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationTs_ordinary(num4,:);
        PopulationFs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationFs_ordinary(num4,:);
        PopulationMs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationMs_ordinary(num4,:);
    else
        PopulationTs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationTs_ordinary(num3,:);
        PopulationFs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationFs_ordinary(num3,:);
        PopulationMs_hybrid((numOfPopulation-K)/2 + i,:) = PopulationMs_ordinary(num3,:);
    end
end
end

