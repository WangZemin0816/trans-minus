clc;clear;close;
%%��ȡͼƬ
grayimg = rgb2gray(imread('Image/1.bmp'));
grayimg = gaussblur(grayimg);
[v,h] = size(grayimg);
%��ȡͼƬ����ѭ�������ں���λ
[hT,hphase,f,d] = transminus(grayimg,'direction','h');
%��ȡͼƬ����ѭ�������ں���λ(���������γ�ߵĿ��Ҳ�п�����һ����֯ѭ���Ŀ��)
[vT,vphase] = transminus(grayimg,'direction','v');
%��ȡγ�߿�ȣ�����vT����vT������������
[nvT,cflevel] = weftanalyse(grayimg,vT);
%%