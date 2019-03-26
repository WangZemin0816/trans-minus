function [patternImg] = getPattern(rgbImage)
%GETPATTERN 此处显示有关此函数的摘要
%   此处显示详细说明
%%图片HOG特征求取
[m,n,~]=size(rgbImage);
grayimg = rgb2gray(rgbImage);
grayimg = gaussblur(grayimg);
hogFeature = hog(grayimg,8,8);

LBPmapping = GetMapping(16,'riu2');        %LBP参数设置
lbp = LBP(grayimg,4,16,LBPmapping,0);

patternImg = zeros(m,n,12);
patternImg(:,:,1:3)=double(rgbImage)./255*2;
patternImg(9:m,9:n,4:11)=double(hogFeature)./max(max(max(double(hogFeature))));
patternImg(5:m-4,5:n-4,12)=normalize(double(lbp))*4;


end

