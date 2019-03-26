
function [normalres] = normalize(mat)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 整个矩阵归一化处理,输入应当为一个矩阵
% 返回一个和原矩阵相同的归一化矩阵
% 调用方法[ normalres ] = normalize( mat)
assert(ismatrix(mat),'normalize函数输入参数应当为二维数组，参数错误！')
[v,h] = size(mat);
mapval = mapminmax(reshape(mat,1,v*h),0,1);
normalres = reshape(mapval,v,h);
end