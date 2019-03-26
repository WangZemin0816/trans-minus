clc;clear;close;
%%读取图片
tic
[filename, pathname] = uigetfile('Image/*.*', '选取待识别的图片');
grayimg = rgb2gray(imread([pathname,filename]));
grayimg = gaussblur(grayimg);
[v,h] = size(grayimg);
%%获取图片横向循环的周期和相位
[hT,hphase,hf,hd] = transminus(grayimg,'direction','h');
%%获取图片纵向循环的周期和相位(纵向可能是纬线的宽度也有可能是一个组织循环的宽度)
[vT,vphase,vf,vd] = transminus(grayimg,'direction','v');
%%获取纬线宽度（等于vT或者vT是其整数倍）
[weftwidth,vOffsetDist] = weftanalyse(grayimg,vT);
%%获取竖直方向移动得到的水平方向相位差列表
hphases = transphases(grayimg,weftwidth,'direction','v');
%%分析相位差列表,vs为经向飞数S
[warp_num,design,vs,relativephases] = phasesanalyse(hphases);
%%平纹锻纹斜纹判断
tt = texturetype(warp_num,vs);
toc
%%显示结果
showtext = strcat('组织类别:',tt);
showtext = strcat(showtext,['\n循环纱线数目:',num2str(warp_num)]);
showtext = strcat(showtext,['\n组织循环飞数:',num2str(vs)]);
showtext = strcat(showtext,'\n');
fprintf(showtext);
imshow(textureimg(design));



