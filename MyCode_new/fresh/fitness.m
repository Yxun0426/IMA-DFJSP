function [makespan_population,makespan_best,index_best,index_Population] = fitness(end_Time,numOfPopulation)
%种群评价
makespan_population = zeros(numOfPopulation,1);
makespan_best = 9999;
index_best = 1;%种群中个体编号
index_Population = zeros(1,2);%横坐标为加工单元编号，纵坐标为子任务编号
for i = 1:numOfPopulation
    end_Time_Population = end_Time(:,:,i);
    [max_val,max_index]= max(end_Time_Population(:));
    makespan_population(i,1) = max_val;
    [row,col] = ind2sub(size(end_Time_Population),max_index);
    index_Population_current(:,:) = [row,col];
    if makespan_population(i,1) <= makespan_best
        makespan_best = makespan_population(i,1);
        index_best = i;
        index_Population(:,:) = index_Population_current;
    else
        makespan_best = makespan_best;
        index_best = index_best;
        index_Population(:,:) = index_Population;
    end
end
end