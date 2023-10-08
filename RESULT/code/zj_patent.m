clc
clear all

%%%迭代次数水平图
fig1 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[83.25,80.75,80.75,80.5];
b=[88.05,86.73,85.93,85.2];
c=[25.58,35.09,44.78,54.26];
yyaxis left; % 激活左边的轴
plot(x,a,'-*k');
hold on
plot(x,b,'-xk');
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([79,89]); % 设置左y轴的界限
ylabel('完成时间','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,c,'-ok');
ylim([25,55]); % 设置右y轴的界限
ylabel('算法运行时间/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
title('迭代次数水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Min','Av','T','Location','SouthEast','FontSize',10,'FontWeight','normal');   %右下角标注
frame1 = getframe(fig1); % 获取frame
img1 = frame2im(frame1); % 将frame变换成imwrite函数可以识别的格式
imwrite(img1,'../结果图/zj_iter2.png'); % 保存到工作目录下，名字为"a.png"

%%%种群规模水平图
fig2 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[84.75,80.75,80,79.75];
b=[90.95,86.65,84.7,83.61];
c=[27.18,32.75,45.43,54.34];
yyaxis left; % 激活左边的轴
plot(x,a,'-*k');
hold on
plot(x,b,'-xk');
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([79,92]); % 设置左y轴的界限
ylabel('完成时间','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,c,'-ok');
ylim([26,56]); % 设置右y轴的界限
ylabel('算法运行时间/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
title('种群规模水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Min','Av','T','Location','SouthEast','FontSize',10,'FontWeight','normal');   %右下角标注
frame2 = getframe(fig2); % 获取frame
img2 = frame2im(frame2); % 将frame变换成imwrite函数可以识别的格式
imwrite(img2,'../结果图/zj_P2.png'); % 保存到工作目录下，名字为"a.png"

%%%交叉率水平图
fig3 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[83.5,80.5,80.5,80.75];
b=[88.05,86.27,85.09,86.5];
c=[38.1,40.54,45.17,38.87];
yyaxis left; % 激活左边的轴
plot(x,a,'-*k');
hold on
plot(x,b,'-xk');
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([79,92]); % 设置左y轴的界限
ylabel('完成时间','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,c,'-ok');
ylim([26,56]); % 设置右y轴的界限
ylabel('算法运行时间/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
title('交叉率水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Min','Av','T','Location','SouthEast','FontSize',10,'FontWeight','normal');   %右下角标注
frame3 = getframe(fig3); % 获取frame
img3 = frame2im(frame3); % 将frame变换成imwrite函数可以识别的格式
imwrite(img3,'../结果图/zj_Pc2.png'); % 保存到工作目录下，名字为"a.png"

%%%变异率水平图
fig4 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[80.5,78.75,80.75,85.25];
b=[84.57,84.41,86.38,90.55];
c=[37.2,45.77,34.97,41.77];
yyaxis left; % 激活左边的轴
plot(x,a,'-*k');
hold on
plot(x,b,'-xk');
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([78,91]); % 设置左y轴的界限
ylabel('完成时间','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,c,'-ok');
ylim([34,46]); % 设置右y轴的界限
ylabel('算法运行时间/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
title('变异率水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Min','Av','T','Location','SouthEast','FontSize',10,'FontWeight','normal');   %右下角标注
frame4 = getframe(fig4); % 获取frame
img4 = frame2im(frame4); % 将frame变换成imwrite函数可以识别的格式
imwrite(img4,'../结果图/zj_Pm2.png'); % 保存到工作目录下，名字为"a.png"

%%%精英保留率水平图
fig5 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[79.25,82,82.75,81.25];
b=[87.43,86.67,88.69,85.87];
c=[43.31,41.47,36.97,37.96];
yyaxis left; % 激活左边的轴
plot(x,a,'-*k');
hold on
plot(x,b,'-xk');
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([78,90]); % 设置左y轴的界限
ylabel('完成时间','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,c,'-ok');
ylim([36,45]); % 设置右y轴的界限
ylabel('算法运行时间/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
title('精英保留率水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Min','Av','T','Location','SouthEast','FontSize',10,'FontWeight','normal');   %右下角标注
frame5 = getframe(fig5); % 获取frame
img5 = frame2im(frame5); % 将frame变换成imwrite函数可以识别的格式
imwrite(img5,'../结果图/zj_Re2.png'); % 保存到工作目录下，名字为"a.png"
