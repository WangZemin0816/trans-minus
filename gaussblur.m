function [blurimg] = gaussblur(img,varargin)
% 高斯模糊化函数
pnames = {'sigma','window','boundary', };
dflts =  {   5   ,  [5,5] ,'replicate',};
[sigma,window,boundary] = internal.stats.parseArgs(pnames, dflts, varargin{:});
gausfilter = fspecial('gaussian',window, sigma);
blurimg = imfilter(img, gausfilter,boundary);
end

