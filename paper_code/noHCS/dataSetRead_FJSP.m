function [numOfTasks_FJSP, numOfMcell, numOfSubTasks_fjsp, vectorNumSubTasks_FJSP, vectorIndexOfSubTasks, vectorSubTasks_FJSP, tableOfMcellTime, tableOfMcellOptional] = dataSetRead_FJSP(source_FJSP)
%基准实例读取
archivo=fopen(source_FJSP,'r');
datos=fscanf(archivo,'%f');
numOfTasks_FJSP=datos(1);
numOfMcell=datos(2);
vectorSubTasks_FJSP=[];
indice=4;
nt=1;
while(nt<=numOfTasks_FJSP)
    vectorNumSubTasks_FJSP(nt)=datos(indice);
    vectorIndexOfSubTasks(nt)=sum(vectorNumSubTasks_FJSP(1:nt-1));
    operacionesTrabajo=ones(1,vectorNumSubTasks_FJSP(nt))*nt;
    vectorSubTasks_FJSP=[vectorSubTasks_FJSP operacionesTrabajo];
    for numOper=1:vectorNumSubTasks_FJSP(nt)
        indice=indice+1;
        numMaq=datos(indice);
        for i=1:numMaq
            indice=indice+1;
            maquina=datos(indice);
            indice=indice+1;
            tiempo=datos(indice);
            tableOfMcellTime(vectorIndexOfSubTasks(nt)+numOper,maquina)=tiempo;
        end
    end
    indice=indice+1;
    nt=nt+1;
end

%子任务数
numOfSubTasks_fjsp=length(vectorSubTasks_FJSP);

%子任务可用加工单元表
tableOfMcellOptional=[];
for oper=1:length(tableOfMcellTime)
    indices_factibles = tableOfMcellTime(oper,:) ~= 0;
    tableOfMcellOptional=[tableOfMcellOptional; indices_factibles];
end
end

