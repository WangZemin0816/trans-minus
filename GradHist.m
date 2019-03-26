function [ gradHist ] = GradHist( grayImg,histNum)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[gradientWeight,gradientOrient] = Gradient(grayImg);
gradHist = zeros(histNum,1);
incRadian = pi/histNum;
for ii=1:histNum
    curRadianMin = -pi/2+incRadian*(ii-1);
    curRadianmax = -pi/2+incRadian*ii;
    boolGradMin = gradientOrient>curRadianMin;
    boolGradMax = gradientOrient<curRadianmax;
    boolGrad = boolGradMin&boolGradMax;
    gradHist(ii) = sum(sum(abs(gradientWeight(boolGrad))));
end
amax = max(gradHist);
amin = min(gradHist); 
gradHist = (gradHist-amin)/(amax-amin);
end

