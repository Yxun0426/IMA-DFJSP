%% 维数选择
% 人脸1.f
Dim = 10:10:100;
%% 数据选择
% 人脸1.f
RKSH = [53 68 74 77 77 78 78 78 78 78];
RKSHs = [73 81 84 84 85 86 88 88 88 88];
TCA = [63 73 74 78 77 78 78 78 79 79];
TCAs = [72 81 84 83 85 86 88 88 88 88];
IGLDA = [61 73 77 78 78 80 81 81 81 81];
IGLDAs = [72 81 84 83 85 86 88 88 88 88];
TIT = [58 68 72 76 76 75 74 75 75 75];
TITs = [62 71 76 78 79 79 81 82 83 82];
%% 画图
% 图1
% subplot(2,2,1)
plot(Dim,RKSH,'-*b',Dim,RKSHs,'-or'); %线性，颜色，标记
%title('RKHS-DA AND SLDARKHS-DA');
axis( [0,110,50,100])  %确定x轴与y轴框图大小
set(gca,'XTick',[0:10:110]) %x轴范围
set(gca,'YTick',[50:10:100]) %y轴范围
legend('RKHS-DA','SLDARKHS-DA','Location','SouthEast', 'FontName','Times New Roman','FontSize',8,'FontWeight','normal');   %右下角标注
xlabel('Dimensionality of Subspace', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal')  %x轴坐标描述
ylabel('Accuracy (%)', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal') %y轴坐标描述
% % 图2
% subplot(2,2,2)
% plot(Dim,TCA,'-*b',Dim,TCAs,'-or'); %线性，颜色，标记
% %title('TCA AND SLDA-TCA');
% axis( [0,110,50,100])  %确定x轴与y轴框图大小
% set(gca,'XTick',[0:10:110]) %x轴范围
% set(gca,'YTick',[50:10:100]) %y轴范围
% legend('TCA','SLDA-TCA','Location','SouthEast', 'FontName','Times New Roman','FontSize',8,'FontWeight','normal');   %右下角标注
% xlabel('Dimensionality of Subspace', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal')  %x轴坐标描述
% ylabel('Accuracy (%)', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal') %y轴坐标描述
% % 图3
% subplot(2,2,3)
% plot(Dim,IGLDA,'-*b',Dim,IGLDAs,'-or'); %线性，颜色，标记
% %title('IGLDA AND SLDA-IGLDA');
% axis( [0,110,50,100])  %确定x轴与y轴框图大小
% set(gca,'XTick',[0:10:110]) %x轴范围
% set(gca,'YTick',[50:10:100]) %y轴范围
% legend('IGLDA','SLDA-IGLDA','Location','SouthEast', 'FontName','Times New Roman','FontSize',8,'FontWeight','normal');   %右下角标注
% xlabel('Dimensionality of Subspace', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal')  %x轴坐标描述
% ylabel('Accuracy (%)', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal') %y轴坐标描述
% % 图4
% subplot(2,2,4)
% plot(Dim,TIT,'-*b',Dim,TITs,'-or'); %线性，颜色，标记
% %title('TIT AND SLDA-TIT');
% axis( [0,110,50,100])  %确定x轴与y轴框图大小
% set(gca,'XTick',[0:10:110]) %x轴范围
% set(gca,'YTick',[50:10:100]) %y轴范围
% legend('TIT','SLDA-TIT','Location','SouthEast', 'FontName','Times New Roman','FontSize',8,'FontWeight','normal');   %右下角标注
% xlabel('Dimensionality of Subspace', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal')  %x轴坐标描述
% ylabel('Accuracy (%)', 'FontName','Times New Roman','FontSize',11,'FontWeight','normal') %y轴坐标描述
