function ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,start_Time_best_t,end_Time_best_t,PopulationTs_best,vectorSumOfSubTasks)
%绘制甘特图
axis([-10,makespan_best+20,0,numOfTotalMcell+1]);%x轴 y轴的范围
set(gca,'xtick',0:10:makespan_best) ;%x轴的增长幅度
set(gca,'ytick',0:1:numOfTotalMcell) ;%y轴的增长幅度
xlabel('完成时间','FontSize',14,'FontWeight','bold','FontName','黑体');
ylabel('加工单元','FontSize',14,'FontWeight','bold','FontName','黑体');%x轴 y轴的名称
title('当前最佳调度','FontSize',14,'FontWeight','bold','FontName','黑体');%图形的标题

rec_fac = zeros(1,4);
%%%画工厂
for f = 1:numOfFactory
    num = mcellPerFactory(1,f);
    start = vectormcellPerFactory(1,f);
    rec_fac(1,1) = -10;
    rec_fac(1,2) = start + 0.5;
    rec_fac(1,3) = 5;
    rec_fac(1,4) = num;
    rectangle('Position',rec_fac,'LineWidth',0.5,'LineStyle','-','FaceColor','w');
    txt_fac=sprintf('F%d',f);
    text(-7.5,start + 0.5 + num/2,txt_fac,'FontSize',10,'FontWeight','Bold','FontName','Times New Roman');
end

%%%画加工单元
rec_mcell = zeros(1,4);
count = 0;
for p = 1:numOfFactory
    num_mcell = mcellPerFactory(1,p);
    for m = 1:num_mcell
        count = count + 1;
        rec_mcell(1,1) = -5;
        rec_mcell(1,2) = count - 0.5;
        rec_mcell(1,3) = 5;
        rec_mcell(1,4) = 1;
        rectangle('Position',rec_mcell,'LineWidth',0.5,'LineStyle','-','FaceColor','w');
        txt_mcell=sprintf('M%d%d',p,m);
        text(-2.5,count,txt_mcell,'FontSize',10,'FontWeight','Bold','FontName','Times New Roman');
    end
end

% stt0 = start_Time_best_t(start_Time_best_t ~= 0);

stt = zeros(1,numOfSubTasks);
for k = 1:numOfSubTasks
    list = start_Time_best_t(:,k);
    L = length(list(list~=0));
    if L == 0
        stt(1,k) = 0;
    else
        stt(1,k) = list(list~=0);
    end
end
ent = zeros(1,numOfSubTasks);
for k = 1:numOfSubTasks
    list = end_Time_best_t(:,k);
    L = length(list(list~=0));
    if L == 0
        ent(1,k) = 0;
    else
        ent(1,k) = list(list~=0);
    end
end
% ent0 = end_Time_best_t(end_Time_best_t ~= 0);
% ent = ent0.';

et = end_Time_best(end_Time_best~=0);
endtime = et.';%每个子任务的结束时间
[cell,~] = find(end_Time_best~=0);
cell_list = cell.';%每个子任务的加工单元

starttime = zeros(1,numOfSubTasks);%每个子任务的开始时间
for k = 1:numOfSubTasks
    list = start_Time_best(:,k);
    L = length(list(list~=0));
    if L == 0
        starttime(1,k) = 0;
    else
        starttime(1,k) = list(list~=0);
    end
end

color = zeros(numOfTasks,3);%%颜色图设计
for j = 1:numOfTasks
    c1 = rand(1);
    c2 = rand(1);
    c3 = rand(1);
    color(j,1) = c1;
    color(j,2) = c2;
    color(j,3) = c3;
end

arr_taskId = zeros(1,numOfSubTasks);
order = zeros(1,numOfSubTasks);%加工顺序
for p = 1:numOfSubTasks
    taskId = PopulationTs_best(1,p);
    arr_taskId(1,p) = taskId;
    count_task = length(find(arr_taskId == taskId));
    subtaskId_order = vectorSumOfSubTasks(1,taskId)+count_task;%当前子任务的编号
    order(1,p) = subtaskId_order;
end


arr_task = zeros(1,numOfSubTasks);
rec1 = zeros(1,4);
rec2 = zeros(1,4);
for i = 1:numOfSubTasks
    taskId = PopulationTs_best(1,i);
    arr_task(1,i) = taskId;
    count_task = length(find(arr_task == taskId));
    current_id = order(1,i);
    
    current_starttime = starttime(1,current_id);
    current_endtime = endtime(1,current_id);
    duration_time = current_endtime - current_starttime;
    
    current_stt = stt(1,current_id);
    current_ent = ent(1,current_id);
    duration_t = current_ent - current_stt;
    
    current_cell = cell_list(1,current_id);
    rec1(1,1) = current_starttime;
    rec1(1,2) = current_cell;
    rec1(1,3) = duration_time;
    rec1(1,4) = 0.5;
    
    rec2(1,1) = current_stt;
    rec2(1,2) = current_cell-0.3;
    rec2(1,3) = duration_t;
    rec2(1,4) = 0.3;
    
    txt1=sprintf('T(%d,%d)',taskId,count_task);%将工序号，加工时间连成字符串
    txt2=sprintf('');
    rectangle('Position',rec1,'LineWidth',0.5,'LineStyle','-','FaceColor',color(taskId,:));
    if duration_t ~= 0
        rectangle('Position',rec2,'LineWidth',0.5,'LineStyle','-','FaceColor',color(taskId,:));
    end
    text(current_starttime,current_cell+0.25,txt1,'FontSize',8,'FontWeight','Bold','FontName','Times New Roman');%字体的坐标和其它特性
    text(current_stt,current_cell-0.25,txt2,'FontSize',6,'FontWeight','Bold','FontName','Times New Roman');
end
end