%%清空环境
close all;
clc;
clear;
X = xlsread("X.xlsx","B2:CW126");
Y = xlsread("Y.xlsx","B2:CW126");          
Z = xlsread("Z.xlsx","B2:CW126");
xzb=0;
for i=1:125
  xzb = [xzb,ones(1,100)*i*0.2];
end
for i = 2:12501
x(i-1) = xzb(i);
end
m = 1;
for i = 1:125
    for j = 1:100
        y(m) = Y(i,j);
        z(m) = Z(i,j);
        m = m+1;
    end
end
data = zeros(1,12500);
x_a=sum(x)/length(data);
y_a=sum(y)/length(data);
z_a=sum(z)/length(data);
 
% 平方的均值
x_a=sum(x.*x)/length(data);
y_a=sum(y.*y)/length(data);
zz_a=sum(z.*z)/length(data);
 
xy_a=sum(x.*y)/length(data);
xz_a=sum(x.*z)/length(data);
yz_a=sum(y.*z)/length(data);
b=[xz_a;yz_a;z_a];
A = [x_a xy_a x_a;
    xy_a y_a y_a;
    x_a y_a 1];
 
XYZ=A^-1 *b;  % 方程求系数
a0=XYZ(1); % -A/C
a1=XYZ(2); % -B/C
a2=XYZ(3); % -D/C
V=[a0 a1  -1];% 平面法向量
nor=norm(V); % 向量的模
normalize_V=[a0/nor  a2/nor  -1/nor]; % 平面法向量归一化
scatter3(x,y,z,'filled')
hold on;
xfit=min(x):0.1:max(x);  % 坐标系的坐标
yfit=min(y):0.1:max(y);
[XF,YF]=meshgrid(xfit,yfit);% 生产XY点列 
 
ZF=a0*XF+a1*YF+a2;  %计算Z的值
 
% 显示
mesh(XF,YF,ZF)
arf = acos(-1/sqrt(V(1)^2+V(2)^2+V(3)^2));
D0=(52+2*1852*tan(1.5*pi/180))*(1-sqrt(3)*tan(1.5*pi/180));
m = D0*sin(60*pi/180)*cos(1.5*pi/180)/sin(28.5*pi/180);

%%求解船在第i条测线上航行时距海底的深度
% w0指船在左端第一条测线航行时波束覆盖宽度在坡面上的长度
% d指两相邻相邻测线之间的水平距离
% h0指船在左端第二条测线航行时距海底的深度
for i = 1:600  
w0 = sin(60*pi/180)*D0/sin(30*pi/180-arf)+sin(60*pi/180)*D0/sin(30*pi/180+arf);
% 利用重叠率为10%联立递推求解求解船在第i条测线上航行时距海底的深度
syms d h0
cdl =0.2;
f1 = D0 -d*tan(arf)-h0;
f2 = (-cdl*(D0*sin(60*pi/180)/sin(30*pi/180-arf)+...
    D0*sin(60*pi/180)/sin(30*pi/180+arf))+h0*sin(60*pi/180)/sin(30*pi/180-arf)...
    +h0*sin(60*pi/180)/sin(30*pi/180+arf))*sin(150*pi/180-arf)/sin(30*pi/180)-d;
[d,h0] = solve(f1,f2);
c(i) = double(d);
D0=h0;
end
a = 88;
%%求解满足覆盖整个海域的最小测线条数以及总测线的长度
l = m;
for i = 1:600
    l =l+c(i);
    if l>1852*2
        ind = i;
        break;
    end 
end
num=i;
length=2*1852*num;
disp('结果=');
disp(a);