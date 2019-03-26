function [ accres ] = accumulate( mat , varargin )
% ���ߣ�������1027329813@qq.com,2018.02.02
% ������ľ������ĳ��������ۼӣ��Ӷ��õ�һ��һά����
% ����ֵaccresΪ�ۼӵĽ��
% ���÷���[ accres ] = accumulate( mat , 'PARAM1',val1,'PARAM2',val2.... )
% param :
%   'axis':�ۼӵ�ά��
%   'step':ƽ�����ÿ��ƽ�Ƶľ���
[v,h] = size(mat);
assert(ismatrix(mat),'accumulate�����������Ӧ��Ϊ��ά���飬��������')
dfweight = ones(v,h);
pnames = { 'axis','weight'  };
dflts =  {   1  ,  dfweight };
[axis,weight] = internal.stats.parseArgs(pnames, dflts, varargin{:});
[vw,hw] = size(weight);
assert( h == hw || v == vw,'Ȩֵ����weightӦ�����ۼӶ���ά����ͬ��')
assert( axis == 1||axis==2,'�ۼ�ά��axisӦ��Ϊ1��2')
weightmat = double(weight).*double(mat);
accres = sum(weightmat,axis);
end

