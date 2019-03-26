function [ gradientWeight,gradientOrient] = Gradient( grayImg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [x,y] = size(grayImg);
    normGrayImg = double(grayImg)/double(max(max(grayImg)));
    xDiff = zeros(x,y);
    yDiff = zeros(x,y);
    xDiff(1:x-1,:) = diff(double(normGrayImg),1,1);
    yDiff(:,1:y-1) = diff(double(normGrayImg),1,2);
    gradientWeight = sqrt(xDiff.^2+yDiff.^2);
    gradientOrient = atan(yDiff./(xDiff+0.0001));
end

