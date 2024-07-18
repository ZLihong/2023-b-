%%清空环境
clear;
clc;
close all;

%%初始化参数
x  = -800:200:800;
h = zeros(1,9);%海水高度
bx = zeros(1,9);%b点x坐标
by = zeros(1,9);%b点y坐标
cx = zeros(1,9);%c点x坐标
cy = zeros(1,9);%b点y坐标
cdl = zeros(1,9);%重叠率
w = zeros(1,9);%宽度

%%进行求解
for i  = 1:9
    h(i) = 70-x(i)*tan(1.5*pi/180);
    bx(i) =x(i)-(h(i)*cos(1.5*pi/180)*sin(60*pi/180))/cos(1.5*pi/180+60*pi/180);
    by(i) = -(h(i)*cos(1.5*pi/180)*cos(60*pi/180))/cos(1.5*pi/180+60*pi/180);
    cx(i) = x(i)+(h(i)*cos(1.5*pi/180)*sin(60*pi/180))/cos(1.5*pi/180-60*pi/180);
    cy(i) =-(h(i)*cos(1.5*pi/180)*cos(60*pi/180))/cos(1.5*pi/180-60*pi/180);
end

for j = 1:9
   w(j) = sqrt((bx(j)-cx(j))^2+(by(j)-cy(j))^2)*cos(1.5*pi/180);
end
for l = 2:9%判断三角形位置求解重叠率
    if cx(l-1)>bx(l)
        cdl(l) =sqrt((cx(l-1)-bx(l))^2+(cy(l-1)-by(l))^2)/w(l-1)*100;
    else
        cdl(l) =-sqrt((cx(l-1)-bx(l))^2+(cy(l-1)-by(l))^2)/w(l-1)*100;
    end
end
%%结果显示
disp('海水深度=');
disp(h);
disp('宽度=');
disp(w);
disp('重叠率=');
disp(cdl);