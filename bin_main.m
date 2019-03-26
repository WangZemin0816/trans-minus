% clc;clear;close;
% % %%读取图片
% % [filename, pathname] = uigetfile('Image/*.*', '选取待识别的图片');
% % img = imread([pathname,filename]);
% % grayimg = rgb2gray(img);
% % grayimg = gaussblur(grayimg);
% % [v,h] = size(grayimg);
% % 
% % %%获取图片横向循环的周期和相位
% % [hT,hphase,~,~] = transminus(grayimg,'direction','h');
% % 
% % %%获取图片纵向循环的周期和相位(纵向可能是纬线的宽度也有可能是一个组织循环的宽度)
% % [vT,vphase,~,~] = transminus(grayimg,'direction','v');
% % 
% % %%获取纬线宽度（等于vT或者vT是其整数倍）
% % [weftwidth,vOffsetDist] = weftanalyse(grayimg,vT);
% % 
% % %%获取竖直方向移动得到的水平方向相位差列表
% % hphases = transphases(grayimg,weftwidth,'direction','v');
% 
load data1

%%分析相位差列表,vs为经向飞数S
[warp_num,design,vs,relativephases] = phasesanalyse(hphases);

%%获取纬线宽度（等于vT或者vT是其整数倍）
[warpwidth,hOffsetDist] = warpanalyse(grayimg,hT,relativephases,weftwidth,vOffsetDist);

%%标记方形黑白的经纬线
markImg = markWarpWeft(img,warpwidth,hOffsetDist,weftwidth,vOffsetDist,relativephases,hT,warp_num);



%%图片特征求取
pattern = getPattern(img);
[~,~,d] = size(pattern);

%%bp神经网络训练
inputn = (reshape(pattern,[v*h,d]))';
%inputn = [(double(reshape(img,[v*h,3]))./255)';imgHog'];
outputn = (reshape(markImg,[v*h,1]))';
net = newff(inputn,outputn,[150,150],{'tansig','tansig','tansig'},'trainlm');
net.trainParam.lr=0.01;
net.trainParam.epochs=15;
net.trainParam.goal=1e-5;
net=train(net,inputn,outputn); 
BPoutput=sim(net,inputn); 
binImg = double(reshape(BPoutput,[v,h]));
binImg2 = im2bw(binImg, graythresh(binImg));
% 
% binImg2 = double(binImg==0);
% se = strel('disk',1);
% I2 = imdilate(binImg2==0,se);
% figure(2);imshow(I2);
% I3 = imerode(I2,se);
% figure(1);imshow(I3)
%%以下为调试部分
aimg = img;
aimg(:,:,1) = aimg(:,:,1)-uint8(binImg*127);
aimg(:,:,2) = aimg(:,:,1)-uint8(binImg*127);
figure(1);imshow(aimg)
figure(2);imshow(binImg)
% 
% figure(3)
% [x,y] = size(img);
% colormap('gray');
% imagesc(img);
% hold on;
% %%%%%%%%%%%%%%%
% for ii=0:uint16(h/weftwidth)
%     line([0,y],[vOffsetDist+weftwidth*ii,vOffsetDist+weftwidth*ii],'color','c');
% end


% 

% binImg3 = 1-binImg>0.6;
% load pred;
% 
% warpNoise = removeSmall(binImg3);
% weftNoise = 1-removeSmall(1-warpNoise);
% 
% figure(1);imshow(weftNoise)
% figure(2);imshow(warpNoise)
% 
% B=[1 1 1;1 1 1;1 1 1];
% ImdImg =imdilate(weftNoise,B);
% se1=strel('square',3);%这里是创建一个半径为5的平坦型圆盘结构元素  
% RImg = imerode(ImdImg,se1);  
% figure(3);imshow(RImg)










