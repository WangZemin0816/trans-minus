function [ warpwidth ,offsetDist] = warpanalyse( pic,hT,hphases,weftwidth,vOffsetDist,varargin)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ����֯���γ�߳���
% �������:
%   pic:����ȡγ�߿�ȵ�ͼƬ���飬Ӧ��Ϊ��ά����
%   hT:֯��ͼƬˮƽ���������
%   hphases:֯��ͼƬ��λ�����λ��
%   weftwidth:γ�߿��
%   vOffsetDist:��һ������γ�ߵĸ߶�
%   minWarp:γ����Сռ�������ڵı���
% �������
%   warpwidth :���߿��
%   offsetDist:��һ������γ���Ͼ��ߵ���ʼ��λ��


pnames = {'minWarp'};
dflts =  {   0.2   };
[minWarp] = internal.stats.parseArgs(pnames, dflts, varargin{:});

[~,h] = size(pic);
%%����γ����Ŀ
[~,weftnum ]= size(hphases);

%%ƽ��ÿ��γ��֮���ͼƬ
splitimg = uint8(zeros((weftnum-1)*weftwidth,h-hT));
%%��λ����λת��Ϊ����
hphases(hphases<=0)=hphases(hphases<=0)+2*pi;
phasesdist = uint16(hphases./(2*pi).*hT);
%%����ƽ��ÿ��γ��֮���ͼƬ
for vv = 1:weftnum-1
    vrange = uint16(vOffsetDist+(weftwidth*(vv-1))+1:vOffsetDist+(weftwidth*vv));
    hrange = uint16(phasesdist(vv)+1:h-(hT-phasesdist(vv)));
    splitimg(uint16((weftwidth*(vv-1)+1):(weftwidth*vv)),:) = pic(vrange,hrange);
end

%%���㾭γ��֯ÿһ��������������Ĳ�ֵ
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
%%��ȡ�ֲ����ֵ����ȡ���߿��
localmax = findlocmax(symDiff);
assert(length(localmax)>3);%�ֲ����ֵ��С��Ҫ3��
offsetDist = localmax(1);%��һ��γ�ߵ�ƫ��
localmaxDiff = diff(localmax);
diffIdx = 1:length(localmaxDiff);
width1 =  uint16(mean(localmaxDiff(mod(diffIdx,2)==1)));
width2 =  uint16(mean(localmaxDiff(mod(diffIdx,2)==0)));
warpwidth = width1;
if width1>width2
    warpwidth = width2;
    offsetDist=offsetDist+warpwidth;
end

%%���߿�ȼ���γ�߲���Ӧ�ú�һ�����ڽӽ�
assert(width1+width2-hT<0.1*hT);

%%����Ϊ���Բ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% %%ƽ��ÿ��γ��֮���ͼƬ
% splitimg = uint8(zeros((weftnum-1)*weftwidth,h-hT,3));
% %%��λ����λת��Ϊ����
% hphases(hphases<=0)=hphases(hphases<=0)+2*pi;
% phasesdist = uint16(hphases./(2*pi).*hT);
% %%����ƽ��ÿ��γ��֮���ͼƬ
% for vv = 1:weftnum-1
%     vrange = uint16(vOffsetDist+(weftwidth*(vv-1))+1:vOffsetDist+(weftwidth*vv));
%     hrange = uint16(phasesdist(vv)+1:h-(hT-phasesdist(vv)));
%     splitimg(uint16((weftwidth*(vv-1)+1):(weftwidth*vv)),1:(h-hT),:) = pic(vrange,hrange,:);
% end
end

function locmax = findlocmax(curves)
% �ֲ����ֵ����
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





