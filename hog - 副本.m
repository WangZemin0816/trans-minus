function [ orient,weight] = hog( pic )
% ���ߣ�������1027329813@qq.com,2018.02.02
% ��ȡ����pic��Hog����
% ����picΪ��Ҫ��ȡhog�����Ķ�ά����
% ����ֵ�ֱ�Ϊ��
% orient:����ķ�������
% weight:����ķ���Ȩֵ
[v,h] = size(pic);
assert(ismatrix(pic),'hog�����������Ӧ��Ϊ��ά���飬��������')
assert( h > 2 || v > 2,'hog������������̫С������������')
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
% ����������(a,b),����Ƕ�phi��-pi��+pi
phi = zeros(size(a));
phase =  zeros(size(a));
phi(a==0) = pi/2;
phi(a~=0) = atan(abs(b(a~=0)./a(a~=0)));%��λ�Ƕ�
phase(a>0.*b>0) = phi(a>0.*b>0);
phase(a<0.*b>0) = pi-phi(a<0.*b>0);
phase(a<0.*b<0) = pi+phi(a<0.*b<0);
phase(a>0.*b<0) = 2*pi-phi(a>0.*b<0);
phase(phase>pi) = phase(phase>pi)-2*pi;
end



