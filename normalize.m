
function [normalres] = normalize(mat)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ���������һ������,����Ӧ��Ϊһ������
% ����һ����ԭ������ͬ�Ĺ�һ������
% ���÷���[ normalres ] = normalize( mat)
assert(ismatrix(mat),'normalize�����������Ӧ��Ϊ��ά���飬��������')
[v,h] = size(mat);
mapval = mapminmax(reshape(mat,1,v*h),0,1);
normalres = reshape(mapval,v,h);
end