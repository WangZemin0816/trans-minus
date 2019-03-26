function [ orient,weight] = hog( pic )
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 求取数组pic的Hog特征
% 输入pic为需要求取hog特征的二维矩阵
% 返回值分别为：
% orient:矩阵的方向特征
% weight:矩阵的方向权值
[v,h] = size(pic);
assert(ismatrix(pic),'hog函数输入参数应当为二维数组，参数错误！')
assert( h > 2 || v > 2,'hog函数输入数组太小，不满足条件')
nor_pic = normalize(double(pic));
v_diff = zeros(v,h);
h_diff = zeros(v,h);
v_diff(2:v,:) = nor_pic(2:v,:)-nor_pic(1:v-1,:);
h_diff(:,2:h) = nor_pic(:,2:h)-nor_pic(:,1:h-1);
h_diff(h_diff==0) = 0.00001;
weight = normalize(sqrt(v_diff.^2+h_diff.^2));
orient = getphase(v_diff,h_diff);
end


function [phase] = getphase(a,b)
% 给定函数点(a,b),计算角度phi，-pi到+pi
phi = zeros(size(a));
phase =  zeros(size(a));
phi(a==0) = pi/2;
phi(a~=0) = atan(abs(b(a~=0)./a(a~=0)));%相位角度
phase(a>0.*b>0) = phi(a>0.*b>0);
phase(a<0.*b>0) = pi-phi(a<0.*b>0);
phase(a<0.*b<0) = pi+phi(a<0.*b<0);
phase(a>0.*b<0) = 2*pi-phi(a>0.*b<0);
phase(phase>pi) = phase(phase>pi)-2*pi;
end



