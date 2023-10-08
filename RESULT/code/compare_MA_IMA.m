clc
clear all

fig = figure('Color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:100;
load('../data/base_Mk01.mat');
load('../data/improve_Mk01.mat');
plot(x,makespan_best_iter,'-kx',x,makespan_best_T_iter,'-ko');
title('在数据集DMk01上的优化过程迭代曲线','FontName','黑体','FontSize',14);
axis( [0,110,40,80])  %确定x轴与y轴框图大小
set(gca,'XTick',[0:10:110]) %x轴范围
set(gca,'YTick',[40:5:80]) %y轴范围
legend('模因算法','改进模因算法','Location','NorthEast','FontName','黑体','FontSize',10,'FontWeight','normal');   %右下角标注
xlabel('迭代次数', 'FontName','黑体','FontSize',14,'FontWeight','normal')  %x轴坐标描述
ylabel('加工完成时间', 'FontName','黑体','FontSize',14,'FontWeight','normal') %y轴坐标描述

frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
imwrite(img,'../结果图/GA_IMA.png'); % 保存到工作目录下，名字为"a.png"