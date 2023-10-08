clc
clear all
close all

fig = figure('Color','w');
x = 1:1:150;
load('Mk09_IMA.mat');
load('Mk09_GLNSA.mat');
a = makespan_best_iter;
b = convergence_curve(1:150).';
plot(x,a,'-ko');
hold on
plot(x,b,'-kx');
title('在数据集DMk09上的优化过程迭代曲线','FontName','黑体','FontSize',14);
axis( [0,110,310,580])  %确定x轴与y轴框图大小
set(gca,'XTick',[0:10:110]) %x轴范围
set(gca,'YTick',[310:10:580]) %y轴范围
legend('IMA','GLNSA','Location','NorthEast', 'FontName','黑体','FontSize',10,'FontWeight','normal');   %右下角标注
xlabel('迭代次数', 'FontName','黑体','FontSize',14,'FontWeight','normal')  %x轴坐标描述
ylabel('加工完成时间', 'FontName','黑体','FontSize',14,'FontWeight','normal') %y轴坐标描述

frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
imwrite(img,'../结果图/MK09_compare.png'); % 保存到工作目录下，名字为"a.png"