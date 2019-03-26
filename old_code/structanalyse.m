function [ output_args ] = structanalyse(grayimg,weftwidth,warpwidth,firstweftloc,firstwarploc,hT,relativephases)
% ����ͼƬ�Ľṹͼ
[v,h] = size(grayimg);
[~,weftnum ]= size(relativephases);
newimg = grayimg;
phasesdist = uint16(relativephases./(2*pi).*hT);%��λת��Ϊ����
for vv = 1:weftnum
    
    vrange = firstweftloc+(weftwidth*(vv-1))+1:firstweftloc+(weftwidth*vv);
    
    hrange = firstwarploc+phasesdist(vv)+1:firstwarploc+phasesdist(vv)+warpwidth;
    newimg(vrange,hrange) = 0;
end

end

