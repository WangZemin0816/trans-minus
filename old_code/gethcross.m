function [hcross] = gethcross(feature,hdist,vcross)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ��ȡ��γ��֯��һ��������ˮƽ�����λ��
% ���÷�����[ vcross ] = getvcross(img,vdist)
% ����:feature ��ԭͼ��ֱ���򳤶���ͬ��һά����,����ˮƽ�������Ե��и�������
%     :vdist γ�߿��
[v,h] = size(feature);
assert(min(v,h)==1);
num = max(v,h);
index = uint16(1:num);
hcrosses = zeros(1,vdist);
for ii=1:vdist
    hcrosses(ii) = sum(feature(mod(index,vdist)==ii-1));
end
hcross = find(vcrosses==max(max(vcrosses)));
end
