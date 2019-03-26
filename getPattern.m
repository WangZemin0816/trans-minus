function [patternImg] = getPattern(rgbImage)
%GETPATTERN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%ͼƬHOG������ȡ
[m,n,~]=size(rgbImage);
grayimg = rgb2gray(rgbImage);
grayimg = gaussblur(grayimg);
hogFeature = hog(grayimg,8,8);

LBPmapping = GetMapping(16,'riu2');        %LBP��������
lbp = LBP(grayimg,4,16,LBPmapping,0);

patternImg = zeros(m,n,12);
patternImg(:,:,1:3)=double(rgbImage)./255*2;
patternImg(9:m,9:n,4:11)=double(hogFeature)./max(max(max(double(hogFeature))));
patternImg(5:m-4,5:n-4,12)=normalize(double(lbp))*4;


end

