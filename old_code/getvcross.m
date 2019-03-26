function [ vcross ] = getvcross(feature,vdist)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 获取经纬组织第一个交错点的竖直方向的位置
% 调用方法：[ vcross ] = getvcross(img,vdist)
% 参数:feature 和原图竖直方向长度相同的一维矩阵,对于水平纹理明显的行该特征大
%     :vdist 纬线宽度
[v,h] = size(feature);
assert(min(v,h)==1);
num = max(v,h);
index = uint16(1:num);
vcrosses = zeros(1,vdist);
for ii=1:vdist
    vcrosses(ii) = sum(feature(mod(index,vdist)==ii-1));
end
vcross = find(vcrosses==max(max(vcrosses)));
vcross = vcross(1);
end

