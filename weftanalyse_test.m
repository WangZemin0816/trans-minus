clc;clear;close;
%%读取图片
grayimg = rgb2gray(imread('Image/1.bmp'));
grayimg = gaussblur(grayimg);
[v,h] = size(grayimg);
%获取图片横向循环的周期和相位
[hT,hphase,f,d] = transminus(grayimg,'direction','h');
%获取图片纵向循环的周期和相位(纵向可能是纬线的宽度也有可能是一个组织循环的宽度)
[vT,vphase] = transminus(grayimg,'direction','v');
%获取纬线宽度（等于vT或者vT是其整数倍）
[nvT,cflevel] = weftanalyse(grayimg,vT);
%%