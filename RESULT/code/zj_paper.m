clc
clear all
close all

%%%迭代次数水平图
fig1 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[53.48,50.83,50.35,49.33];
b=[22.75,39.90,50.94,60.85];
yyaxis left; % 激活左边的轴
plot(x,a,':ko','linewidth',1.5);
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([49,54]); % 设置左y轴的界限
ylabel('平均最大完成时间(Av)','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,b,':ks','linewidth',1.5);
ylim([22,62]); % 设置右y轴的界限
ylabel('CPU运行时间(T)/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
% title('迭代次数水平趋势图','FontSize',14,'FontName','黑体');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Av','T','Location','SouthEast','FontName','TimesNewRoman','FontSize',10,'FontWeight','normal');   %右下角标注
frame1 = getframe(fig1); % 获取frame
img1 = frame2im(frame1); % 将frame变换成imwrite函数可以识别的格式
imwrite(img1,'../结果图/zj_iter.png'); % 保存到工作目录下，名字为"a.png"


%%%种群规模水平图
fig2 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[52.98,50.58,49.78,50.65];
b=[26.24,43.04,47.95,57.21];
yyaxis left; % 激活左边的轴
plot(x,a,':ko','linewidth',1.5);
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([49,54]); % 设置右y轴的界限
ylabel('平均最大完成时间(Av)','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,b,':ks','linewidth',1.5);
ylim([25,58]); % 设置右y轴的界限
ylabel('CPU运行时间(T)/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
% title('种群规模水平趋势图');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Av','T','Location','SouthEast','FontName','TimesNewRoman','FontSize',10,'FontWeight','normal');   %右下角标注
frame2 = getframe(fig2); % 获取frame
img2 = frame2im(frame2); % 将frame变换成imwrite函数可以识别的格式
imwrite(img2,'../结果图/zj_P.png'); % 保存到工作目录下，名字为"a.png"


%%%交叉率水平图
fig3 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[51.38,50.98,50.88,50.75];
b=[26.24,43.97,42.00,42.38];
yyaxis left; % 激活左边的轴
plot(x,a,':ko','linewidth',1.5);
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([50,52]); % 设置右y轴的界限
ylabel('平均最大完成时间(Av)','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,b,':ks','linewidth',1.5);
ylim([25,45]); % 设置右y轴的界限
ylabel('CPU运行时间(T)/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
set(gca,'ycolor',[0 0 0])
% title('交叉率水平趋势图');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Av','T','Location','SouthEast','FontName','TimesNewRoman','FontSize',10,'FontWeight','normal');   %右下角标注
frame3 = getframe(fig3); % 获取frame
img3 = frame2im(frame3); % 将frame变换成imwrite函数可以识别的格式
imwrite(img3,'../结果图/zj_Pc.png'); % 保存到工作目录下，名字为"a.png"


%%%变异率水平图
fig4 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[52.18,49.83,49.50,52.48];
b=[49.23,41.95,40.09,43.17];
yyaxis left; % 激活左边的轴
plot(x,a,':ko','linewidth',1.5);
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([49,53]); % 设置右y轴的界限
ylabel('平均最大完成时间(Av)','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,b,':ks','linewidth',1.5);
ylim([40,50]); % 设置右y轴的界限
ylabel('CPU运行时间(T)/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
set(gca,'ycolor',[0 0 0])
% title('变异率水平趋势图');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Av','T','Location','SouthEast','FontName','TimesNewRoman','FontSize',10,'FontWeight','normal');   %右下角标注
frame4 = getframe(fig4); % 获取frame
img4 = frame2im(frame4); % 将frame变换成imwrite函数可以识别的格式
imwrite(img4,'../结果图/zj_Pm.png'); % 保存到工作目录下，名字为"a.png"


%%%精英保留率水平图
fig5 = figure('color','w');% 新建一个figure，并将图像句柄保存到fig
x = 1:1:4;
a=[50.28,49.93,50.85,52.93];
b=[44.83,42.78,40.59,46.24];
yyaxis left; % 激活左边的轴
plot(x,a,':ko','linewidth',1.5);
xlabel('水平等级','FontSize',14,'FontName','黑体');
xlim([0,5]); % 设置x轴的界限
ylim([49,53]); % 设置右y轴的界限
ylabel('平均最大完成时间(Av)','FontSize',14,'FontName','黑体'); % 给左y轴添加轴标签
set(gca,'ycolor',[0 0 0])
yyaxis right; % 激活右边的轴
plot(x,b,':ks','linewidth',1.5);
ylim([40,48]); % 设置右y轴的界限
ylabel('CPU运行时间(T)/s','FontSize',14,'FontName','黑体'); % 给右y轴添加轴标签
set(gca,'ycolor',[0 0 0])
% title('精英保留率水平趋势图');
set(gca,'XTick',[0:1:5],'xcolor',[0 0 0]) %x轴范围
set(gca,'ycolor',[0 0 0])
legend('Av','T','Location','SouthEast','FontName','TimesNewRoman','FontSize',10,'FontWeight','normal');   %右下角标注
frame5 = getframe(fig5); % 获取frame
img5 = frame2im(frame5); % 将frame变换成imwrite函数可以识别的格式
imwrite(img5,'../结果图/zj_Re.png'); % 保存到工作目录下，名字为"a.png"

