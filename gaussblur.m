function [blurimg] = gaussblur(img,varargin)
% ��˹ģ��������
pnames = {'sigma','window','boundary', };
dflts =  {   5   ,  [5,5] ,'replicate',};
[sigma,window,boundary] = internal.stats.parseArgs(pnames, dflts, varargin{:});
gausfilter = fspecial('gaussian',window, sigma);
blurimg = imfilter(img, gausfilter,boundary);
end

