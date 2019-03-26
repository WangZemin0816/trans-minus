function [ nbinImg ] = removeSmall( binImg,varargin)
% 移除图片中的小片连通域
% 输入参数
%   binImg:二值化之后的图片,背景色为黑色
%   'minThreshold':连通域的最小面积,默认100
% 输出参数
%   nbinImg:移除小连通域之后的二值化图片

[v,h,c] = size(binImg);

% 判断图片是否为二维矩阵
assert(ismatrix(binImg),'参数binImg应当为一副黑白图片');

% 判断图片是否为二值化图片
assert(sum(sum(uint8(binImg==1|binImg==0)))==v*h,'参数binImg应当为一副二值化图片');

% 获取参数
pnames = {'minThreshold '};
dflts =  {  100  };
[minThreshold] = internal.stats.parseArgs(pnames, dflts, varargin{:});

% 去除连通域过小的区域,统一设置为黑色(0)
[sB,L] = bwboundaries(binImg,'noholes');
stats = regionprops(L,'BoundingBox','ConvexImage');
smallRegion = zeros(size(binImg));
for ii=1:length(sB)
    curRegion = double(stats(ii).ConvexImage);
    [n,~] = size(sB{ii});
	if(n<minThreshold)
        beginv = uint16(stats(ii).BoundingBox(2));%删除区域的范围
        beginh = uint16(stats(ii).BoundingBox(1));
        
        [lenv,lenh] = size(curRegion);    
        if(beginv<1)
            beginv=1;
        end
        if(beginh<1)
            beginh=1;
        end
        if(beginh+lenh-1>h)
            beginh = h-lenh+1;
        end
        if(beginv+lenv-1>v)
            beginv = v-lenv+1;
        end
        %删除该凸多边形
        smallRegion((beginv:beginv+lenv-1),beginh:beginh+lenh-1) =(curRegion==1);
	end
end
nbinImg = binImg;
nbinImg(smallRegion==1) = 0;

end

