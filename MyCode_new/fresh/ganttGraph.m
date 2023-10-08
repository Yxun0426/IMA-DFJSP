function ganttGraph(numOfFactory,mcellPerFactory,vectormcellPerFactory,numOfTasks,numOfSubTasks,numOfTotalMcell,makespan_best,start_Time_best,end_Time_best,vectorSumOfSubTasks)
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
%%%颜色图设计
color = zeros(numOfTasks,3);
for j = 1:numOfTasks
    c1 = rand(1);
    c2 = rand(1);
    c3 = rand(1);
    color(j,1) = c1;
    color(j,2) = c2;
    color(j,3) = c3;
end


for a = 1:numOfTotalMcell
    end_list = end_Time_best(a,:);
    subtask_list = find(end_list ~= 0);
    L = length(subtask_list);
    for b = 1:L
        current_id = subtask_list(1,b);
        B = [vectorSumOfSubTasks,numOfSubTasks];
        for c = 1:numOfTasks
            if current_id > B(1,c) && current_id <= B(1,c + 1)
                taskId = c;
                count_task = current_id - B(1,c);
            end
        end
        current_endtime = end_Time_best(a,current_id);
        current_starttime = start_Time_best(a,current_id);
        duration_time = current_endtime - current_starttime;

        rec1(1,1) = current_starttime;
        rec1(1,2) = a;
        rec1(1,3) = duration_time;
        rec1(1,4) = 0.5;
        txt1=sprintf('T(%d,%d)',taskId,count_task);%将工序号，加工时间连成字符串
        rectangle('Position',rec1,'LineWidth',0.5,'LineStyle','-','FaceColor',color(taskId,:));
        text(current_starttime,a+0.25,txt1,'FontSize',8,'FontWeight','Bold','FontName','Times New Roman');%字体的坐标和其它特性
    end
end
end