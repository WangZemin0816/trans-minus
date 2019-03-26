function [ HOGFeature ] = HOG( grayImg,cellSize,histNum )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[M,N] = size(grayImg);
% xNum = ceil(M/cellSize);
% yNum = ceil(N/cellSize);
HOGFeature = zeros(M-cellSize,N-cellSize,histNum);
% for ii=1:xNum
%     for jj=1:yNum
for ii=1:M-cellSize
    for jj=1:N-cellSize
%         xMax = ii*cellSize;
%         yMax = jj*cellSize;
        xMax = ii+cellSize;
        yMax = jj+cellSize;
        if(xMax>M)xMax=M;end
        if(yMax>N)yMax=N;end
        xRange = (xMax-cellSize+1):xMax;
        yRange = (yMax-cellSize+1):yMax;
        subImg = grayImg(xRange,yRange);
        HOGFeature(ii,jj,:)=GradHist(subImg,histNum);
    end
end
end

