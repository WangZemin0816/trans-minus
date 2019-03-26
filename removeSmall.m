function [ nbinImg ] = removeSmall( binImg,varargin)
% �Ƴ�ͼƬ�е�СƬ��ͨ��
% �������
%   binImg:��ֵ��֮���ͼƬ,����ɫΪ��ɫ
%   'minThreshold':��ͨ�����С���,Ĭ��100
% �������
%   nbinImg:�Ƴ�С��ͨ��֮��Ķ�ֵ��ͼƬ

[v,h,c] = size(binImg);

% �ж�ͼƬ�Ƿ�Ϊ��ά����
assert(ismatrix(binImg),'����binImgӦ��Ϊһ���ڰ�ͼƬ');

% �ж�ͼƬ�Ƿ�Ϊ��ֵ��ͼƬ
assert(sum(sum(uint8(binImg==1|binImg==0)))==v*h,'����binImgӦ��Ϊһ����ֵ��ͼƬ');

% ��ȡ����
pnames = {'minThreshold '};
dflts =  {  100  };
[minThreshold] = internal.stats.parseArgs(pnames, dflts, varargin{:});

% ȥ����ͨ���С������,ͳһ����Ϊ��ɫ(0)
[sB,L] = bwboundaries(binImg,'noholes');
stats = regionprops(L,'BoundingBox','ConvexImage');
smallRegion = zeros(size(binImg));
for ii=1:length(sB)
    curRegion = double(stats(ii).ConvexImage);
    [n,~] = size(sB{ii});
	if(n<minThreshold)
        beginv = uint16(stats(ii).BoundingBox(2));%ɾ������ķ�Χ
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
        %ɾ����͹�����
        smallRegion((beginv:beginv+lenv-1),beginh:beginh+lenh-1) =(curRegion==1);
	end
end
nbinImg = binImg;
nbinImg(smallRegion==1) = 0;

end

