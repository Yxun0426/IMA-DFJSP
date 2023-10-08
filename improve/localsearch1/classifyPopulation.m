function [PopulationTs_elite,PopulationFs_elite,PopulationMs_elite,makespan_population_elite,PopulationTs_ordinary,PopulationFs_ordinary,PopulationMs_ordinary,makespan_population_ordinary] = classifyPopulation(numOfPopulation,PopulationTs_merge,PopulationFs_merge,PopulationMs_merge,makespan_population_merge,K)
%种群分级
%输入：进化后的种群
%输出：精英种群与普通种群

[makespan_population_sort,makespan_index] = sort(makespan_population_merge);
makespan_population_elite = makespan_population_sort(1,1:K);
makespan_population_ordinary = makespan_population_sort(1,K+1:numOfPopulation);

makespan_elite_index = makespan_index(1,1:K);
makespan_ordinary_index = makespan_index(1,K+1:numOfPopulation);

%大小为K的非劣解库
for i = 1:K
    ind1 = makespan_elite_index(1,i);
    PopulationTs_elite(i,:) = PopulationTs_merge(ind1,:);
    PopulationFs_elite(i,:) = PopulationFs_merge(ind1,:);
    PopulationMs_elite(i,:) = PopulationMs_merge(ind1,:);
end

%大小为numOfPopulation - K的普通解库
for i = 1:numOfPopulation - K
    ind2 = makespan_ordinary_index(1,i);
    PopulationTs_ordinary(i,:) = PopulationTs_merge(ind2,:);
    PopulationFs_ordinary(i,:) = PopulationFs_merge(ind2,:);
    PopulationMs_ordinary(i,:) = PopulationMs_merge(ind2,:);
end
end