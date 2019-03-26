clc;clear;close;
%%��ȡͼƬ
tic
[filename, pathname] = uigetfile('Image/*.*', 'ѡȡ��ʶ���ͼƬ');
grayimg = rgb2gray(imread([pathname,filename]));
grayimg = gaussblur(grayimg);
[v,h] = size(grayimg);
%%��ȡͼƬ����ѭ�������ں���λ
[hT,hphase,hf,hd] = transminus(grayimg,'direction','h');
%%��ȡͼƬ����ѭ�������ں���λ(���������γ�ߵĿ��Ҳ�п�����һ����֯ѭ���Ŀ��)
[vT,vphase,vf,vd] = transminus(grayimg,'direction','v');
%%��ȡγ�߿�ȣ�����vT����vT������������
[weftwidth,vOffsetDist] = weftanalyse(grayimg,vT);
%%��ȡ��ֱ�����ƶ��õ���ˮƽ������λ���б�
hphases = transphases(grayimg,weftwidth,'direction','v');
%%������λ���б�,vsΪ�������S
[warp_num,design,vs,relativephases] = phasesanalyse(hphases);
%%ƽ�ƶ���б���ж�
tt = texturetype(warp_num,vs);
toc
%%��ʾ���
showtext = strcat('��֯���:',tt);
showtext = strcat(showtext,['\nѭ��ɴ����Ŀ:',num2str(warp_num)]);
showtext = strcat(showtext,['\n��֯ѭ������:',num2str(vs)]);
showtext = strcat(showtext,'\n');
fprintf(showtext);
imshow(textureimg(design));



