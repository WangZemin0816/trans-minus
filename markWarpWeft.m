function [ markImg ] = markWarpWeft(img,warpwidth,hOffsetDist,weftwidth,vOffsetDist,hphases,hT,warp_num)
% 根据经线宽度和纬线宽度以及初始位置，标记组织的经线纬线
% 输入参数
%   img:彩色待标记图片
%   warpwidth:经线宽度
%   hOffsetDist:经线初始位置
%   weftwidth:纬线宽度
%   vOffsetDist:纬线初始位置
%   hphases:错位平移相减的得到的相位差
%   hT:水平方向组织循环的宽度
% 输出参数
%   markImg:二值化图片，1表示经线，0表示纬线
[v,h,c] = size(img);
assert(c==3);

%标记矩阵
markImg = zeros(v,h);
%%错位的相位转化为距离
hphases(hphases<0)=hphases(hphases<0)+2*pi;
phasesdist = int16(hphases./(2*pi).*hT);
%计算经组织区域，由于图像可能不完整，所以xy从-1开始，然后判断边界
for vv=(-1:int16(v/weftwidth))
    for hh=-1:int16(h/hT)
        if(vv<0)
            beginH = phasesdist(warp_num+vv+1)+hOffsetDist+hT* hh;%-1的phasesdist为每个周期最后的一个phasesdist
        elseif(vv>length(phasesdist)-1)
            beginH = phasesdist(mod(vv,warp_num)+1)+hOffsetDist+hT* hh;
        else
            beginH = phasesdist(vv+1)+hOffsetDist+hT* hh;
        end
        beginV = vOffsetDist+weftwidth*vv;
        endH = normal2range(beginH+int16(warpwidth),1,h);
        endV = normal2range(beginV+int16(weftwidth),1,v);
        beginH = normal2range(beginH,1,h);
        beginV = normal2range(beginV,1,v);
        markImg(beginV:endV,beginH:endH)=1;
    end
end

%%以下为调试程序代码
% figure(3)
% colormap('gray');
% imagesc(markImg);
% hold on;
% axis([-100 600 -100 700]) 
% 
% for vv=(-1:int16(v/weftwidth))
%     for hh=-1:(h/hT)
%         %计算经组织点左下角坐标
%         if(vv<0)
%             beginH = phasesdist(warp_num+vv+1)+hOffsetDist+hT* hh;
%         elseif(vv>length(phasesdist)-1)
%             beginH = phasesdist(mod(vv,warp_num)+1)+hOffsetDist+hT* hh;
%         else
%             beginH = phasesdist(vv+1)+hOffsetDist+hT* hh;
%         end
%         beginV = vOffsetDist+weftwidth*vv;
%         rectangle('position',[beginH,beginV,warpwidth,weftwidth]);                                                                                                                                                                                                                    
%         plot(beginH,beginV,'r*');
%     end
% end
end
function [nval] = normal2range(val,minVal,maxVal)
    if(val<minVal)
        nval = minVal;
    elseif(val>maxVal)
        nval = maxVal;
    else
        nval =val;
    end
end 

