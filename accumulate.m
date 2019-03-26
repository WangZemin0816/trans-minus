function [ accres ] = accumulate( mat , varargin )
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 对输入的矩阵进行某个方向的累加，从而得到一个一维数组
% 返回值accres为累加的结果
% 调用方法[ accres ] = accumulate( mat , 'PARAM1',val1,'PARAM2',val2.... )
% param :
%   'axis':累加的维度
%   'step':平移相减每次平移的距离
[v,h] = size(mat);
assert(ismatrix(mat),'accumulate函数输入参数应当为二维数组，参数错误！')
dfweight = ones(v,h);
pnames = { 'axis','weight'  };
dflts =  {   1  ,  dfweight };
[axis,weight] = internal.stats.parseArgs(pnames, dflts, varargin{:});
[vw,hw] = size(weight);
assert( h == hw || v == vw,'权值矩阵weight应当和累加对象维度相同！')
assert( axis == 1||axis==2,'累加维度axis应该为1或2')
weightmat = double(weight).*double(mat);
accres = sum(weightmat,axis);
end

