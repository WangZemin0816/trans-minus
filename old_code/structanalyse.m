function [ output_args ] = structanalyse(grayimg,weftwidth,warpwidth,firstweftloc,firstwarploc,hT,relativephases)
% 分析图片的结构图
[v,h] = size(grayimg);
[~,weftnum ]= size(relativephases);
newimg = grayimg;
phasesdist = uint16(relativephases./(2*pi).*hT);%相位转化为距离
for vv = 1:weftnum
    
    vrange = firstweftloc+(weftwidth*(vv-1))+1:firstweftloc+(weftwidth*vv);
    
    hrange = firstwarploc+phasesdist(vv)+1:firstwarploc+phasesdist(vv)+warpwidth;
    newimg(vrange,hrange) = 0;
end

end

