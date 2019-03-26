% clc;clear;close;
% % %%��ȡͼƬ
% % [filename, pathname] = uigetfile('Image/*.*', 'ѡȡ��ʶ���ͼƬ');
% % img = imread([pathname,filename]);
% % grayimg = rgb2gray(img);
% % grayimg = gaussblur(grayimg);
% % [v,h] = size(grayimg);
% % 
% % %%��ȡͼƬ����ѭ�������ں���λ
% % [hT,hphase,~,~] = transminus(grayimg,'direction','h');
% % 
% % %%��ȡͼƬ����ѭ�������ں���λ(���������γ�ߵĿ��Ҳ�п�����һ����֯ѭ���Ŀ��)
% % [vT,vphase,~,~] = transminus(grayimg,'direction','v');
% % 
% % %%��ȡγ�߿�ȣ�����vT����vT������������
% % [weftwidth,vOffsetDist] = weftanalyse(grayimg,vT);
% % 
% % %%��ȡ��ֱ�����ƶ��õ���ˮƽ������λ���б�
% % hphases = transphases(grayimg,weftwidth,'direction','v');
% 
load data1

%%������λ���б�,vsΪ�������S
[warp_num,design,vs,relativephases] = phasesanalyse(hphases);

%%��ȡγ�߿�ȣ�����vT����vT������������
[warpwidth,hOffsetDist] = warpanalyse(grayimg,hT,relativephases,weftwidth,vOffsetDist);

%%��Ƿ��κڰ׵ľ�γ��
markImg = markWarpWeft(img,warpwidth,hOffsetDist,weftwidth,vOffsetDist,relativephases,hT,warp_num);



%%ͼƬ������ȡ
pattern = getPattern(img);
[~,~,d] = size(pattern);

%%bp������ѵ��
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
%%����Ϊ���Բ���
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
% se1=strel('square',3);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��  
% RImg = imerode(ImdImg,se1);  
% figure(3);imshow(RImg)










