function [ markImg ] = markWarpWeft(img,warpwidth,hOffsetDist,weftwidth,vOffsetDist,hphases,hT,warp_num)
% ���ݾ��߿�Ⱥ�γ�߿���Լ���ʼλ�ã������֯�ľ���γ��
% �������
%   img:��ɫ�����ͼƬ
%   warpwidth:���߿��
%   hOffsetDist:���߳�ʼλ��
%   weftwidth:γ�߿��
%   vOffsetDist:γ�߳�ʼλ��
%   hphases:��λƽ������ĵõ�����λ��
%   hT:ˮƽ������֯ѭ���Ŀ��
% �������
%   markImg:��ֵ��ͼƬ��1��ʾ���ߣ�0��ʾγ��
[v,h,c] = size(img);
assert(c==3);

%��Ǿ���
markImg = zeros(v,h);
%%��λ����λת��Ϊ����
hphases(hphases<0)=hphases(hphases<0)+2*pi;
phasesdist = int16(hphases./(2*pi).*hT);
%���㾭��֯��������ͼ����ܲ�����������xy��-1��ʼ��Ȼ���жϱ߽�
for vv=(-1:int16(v/weftwidth))
    for hh=-1:int16(h/hT)
        if(vv<0)
            beginH = phasesdist(warp_num+vv+1)+hOffsetDist+hT* hh;%-1��phasesdistΪÿ����������һ��phasesdist
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

%%����Ϊ���Գ������
% figure(3)
% colormap('gray');
% imagesc(markImg);
% hold on;
% axis([-100 600 -100 700]) 
% 
% for vv=(-1:int16(v/weftwidth))
%     for hh=-1:(h/hT)
%         %���㾭��֯�����½�����
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

