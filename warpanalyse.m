function [ warpwidth ,offsetDist] = warpanalyse( pic,hT,hphases,weftwidth,vOffsetDist,varargin)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 分析织物的纬线长度
% 输入参数:
%   pic:待求取纬线宽度的图片数组，应当为二维矩阵
%   hT:织物图片水平方向的周期
%   hphases:织物图片错位相减相位差
%   weftwidth:纬线宽度
%   vOffsetDist:第一条完整纬线的高度
%   minWarp:纬线最小占整个周期的比例
% 输出参数
%   warpwidth :经线宽度
%   offsetDist:第一条完整纬线上经线的起始点位置


pnames = {'minWarp'};
dflts =  {   0.2   };
[minWarp] = internal.stats.parseArgs(pnames, dflts, varargin{:});

[~,h] = size(pic);
%%计算纬线数目
[~,weftnum ]= size(hphases);

%%平移每条纬线之后的图片
splitimg = uint8(zeros((weftnum-1)*weftwidth,h-hT));
%%错位的相位转化为距离
hphases(hphases<=0)=hphases(hphases<=0)+2*pi;
phasesdist = uint16(hphases./(2*pi).*hT);
%%计算平移每条纬线之后的图片
for vv = 1:weftnum-1
    vrange = uint16(vOffsetDist+(weftwidth*(vv-1))+1:vOffsetDist+(weftwidth*vv));
    hrange = uint16(phasesdist(vv)+1:h-(hT-phasesdist(vv)));
    splitimg(uint16((weftwidth*(vv-1)+1):(weftwidth*vv)),:) = pic(vrange,hrange);
end

%%计算经纬组织每一列像素左右区域的差值
splitimg = gaussblur(splitimg);
[~,sh] = size(splitimg);
symWidth = uint16(minWarp*hT);
symDiff = zeros(1,sh);
for ii=symWidth+1:sh-symWidth
    subVal = double(splitimg(:,(ii-symWidth):ii))-double(splitimg(:,ii:(ii+symWidth)));
	symDiff(ii)=mean(mean(abs(subVal)));
end
for ii=1:symWidth
    symDiff(ii)=symDiff(symWidth+1);
    symDiff(sh-ii+1)=symDiff(sh-symWidth);
end 
%%求取局部最大值并获取经线宽度
localmax = findlocmax(symDiff);
assert(length(localmax)>3);%局部最大值最小需要3个
offsetDist = localmax(1);%第一个纬线的偏移
localmaxDiff = diff(localmax);
diffIdx = 1:length(localmaxDiff);
width1 =  uint16(mean(localmaxDiff(mod(diffIdx,2)==1)));
width2 =  uint16(mean(localmaxDiff(mod(diffIdx,2)==0)));
warpwidth = width1;
if width1>width2
    warpwidth = width2;
    offsetDist=offsetDist+warpwidth;
end

%%经线宽度加上纬线部分应该和一个周期接近
assert(width1+width2-hT<0.1*hT);

%%以下为调试部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3)
% colormap('gray');
% imagesc(splitimg);
% hold on;
% % plot(symDiff.*20-330)
% [y,x] = size(splitimg);
% line([offsetDist,offsetDist],[0,y],'color','r');
% for ii=0:uint16((h-hT)/hT)
%     line([offsetDist+warpwidth+hT*ii,offsetDist+hT*ii+warpwidth],[0,y],'color','r');
%     line([offsetDist+hT*(ii+1),offsetDist+hT*(ii+1)],[0,y],'color','r');
% end

% %%平移每条纬线之后的图片
% splitimg = uint8(zeros((weftnum-1)*weftwidth,h-hT,3));
% %%错位的相位转化为距离
% hphases(hphases<=0)=hphases(hphases<=0)+2*pi;
% phasesdist = uint16(hphases./(2*pi).*hT);
% %%计算平移每条纬线之后的图片
% for vv = 1:weftnum-1
%     vrange = uint16(vOffsetDist+(weftwidth*(vv-1))+1:vOffsetDist+(weftwidth*vv));
%     hrange = uint16(phasesdist(vv)+1:h-(hT-phasesdist(vv)));
%     splitimg(uint16((weftwidth*(vv-1)+1):(weftwidth*vv)),1:(h-hT),:) = pic(vrange,hrange,:);
% end
end

function locmax = findlocmax(curves)
% 局部最大值查找
[m,n] = size(curves);
assert(m==1&&n>2);
dcurves = diff(curves,1,2);
locmax = zeros(size(curves));
for ii=2:n-1
    if(dcurves(ii-1)>0&&dcurves(ii)<=0)
        locmax(ii)=1;
    end
end
locmax = find(locmax==1);
end





