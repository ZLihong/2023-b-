%%清空环境
clear;
close all;
clc;

%%初始化变量
sta = 0:45:315;
x = 0:0.3:2.1;
x = x.*1852;
a = 1.5;
ex = [1,0,0];
ey = [0,1,0];
ez = [0,0,1];
m = [1 0 0;0 1 0;0 0 1];
K = [0 0 1;0 0 0;-1 0 0];
R = m +sin(1.5*pi/180)*K+(1-cos(1.5*pi/180))*K^2;
v = [0 0 1 ]';
ep = R*v;%坡面法向量
R = m +sin((90-1.5)*pi/180)*K+(1-cos((90-1.5)*pi/180))*K^2;
etp = R*ep;
etc = zeros(3,8);%不同角度的轨迹向量
ezz = zeros(3,8);%不同角度的轨迹左探测线向量
ezy = zeros(3,8);%不同角度的轨迹右探测线向量
%%利用罗德里格斯公式对向量翻转进行求解
for i = 1:8
    K = [0 -1 0;1 0 0;0 0 0];
    R = m +sin(sta(i)*pi/180)*K+(1-cos(sta(i)*pi/180))*K^2;
    etc(:,i) =R*etp;
end
for i = 1:8
    K = [0 -etc(3,i) etc(2,i);etc(3,i) 0 -etc(1,i);-etc(2,i) etc(1,i) 0 ];
    R = m +sin(-60*pi/180)*K+(1-cos(-60*pi/180))*K^2;
    ezz(:,i) =R*v; 
end
for i = 1:8
    K = [0 -etc(3,i) etc(2,i);etc(3,i) 0 -etc(1,i);-etc(2,i) etc(1,i) 0 ];
    R = m +sin(60*pi/180)*K+(1-cos(60*pi/180))*K^2;
    ezy(:,i) =R*v; 
end
for i = 1:8%%判断坐标正负
    for j =1: 8
        if etc(1,j) >0&&etc(2,j)>0
            x0(j,i) = sqrt(x(i)^2/(1+(etc(2,j)/etc(1,j))^2));
            y0(j,i) = sqrt(x(i)^2/(1+(etc(1,j)/etc(2,j))^2));
        end
        if etc(1,j) >0&&etc(2,j)<0
            x0(j,i) = sqrt(x(i)^2/(1+(etc(2,j)/etc(1,j))^2));
            y0(j,i) = -sqrt(x(i)^2/(1+(etc(1,j)/etc(2,j))^2));
        end
        if etc(1,j) <0&&etc(2,j)>0
            x0(j,i) = -sqrt(x(i)^2/(1+(etc(2,j)/etc(1,j))^2));
            y0(j,i) = sqrt(x(i)^2/(1+(etc(1,j)/etc(2,j))^2));
        end
        if etc(1,j) <0&&etc(2,j)<0
            x0(j,i) = -sqrt(x(i)^2/(1+(etc(2,j)/etc(1,j))^2));
            y0(j,i) = -sqrt(x(i)^2/(1+(etc(1,j)/etc(2,j))^2));
        end
    end
end
for i =1:8%%进行距离求解
    for j = 1:8
        t =(-x0(j,i)*ep(1)-y0(j,i)*ep(2)-120*ep(3))/(ezz(1,j)*ep(1)+ezz(2,j)*ep(2)+ezz(3,j)*ep(3));
        x1(j,i) = x0(j,i)+ezz(1,j)*t;
        y1(j,i) = y0(j,i)+ezz(2,j)*t;
        z1(j,i) = ezz(3,j)*t;
        t1 =(-x0(j,i)*ep(1)-y0(j,i)*ep(2)-120*ep(3))/(ezy(1,j)*ep(1)+ezy(2,j)*ep(2)+ezy(3,j)*ep(3));
        x2(j,i) = x0(j,i)+ezy(1,j)*t1;
        y2(j,i) = y0(j,i)+ezy(2,j)*t1;
        z2(j,i) = ezy(3,j)*t1;
        d(j,i) = sqrt((x1(j,i)-x2(j,i))^2+(y1(j,i)-y2(j,i))^2);
    end
end
