function [img] = textureimg(design,varargin)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 将设计图矩阵转化为黑白表格图

% 调用方法[ trans_val ] = textureimg( design , 'PARAM1',val1,'PARAM2',val2.... )
% design:设计图矩阵
% param :
%   'blocksize':每个方格的边长
%   'repeatv':竖直单元循环显示次数
%   'repeath':数值单元循环显示次数
%参数处理
pnames = {'blocksize','repeatv','repeath','border'};
dflts =  {    20     ,    2    ,    2    ,   1    };
[blocksize,repeatv,repeath,border] = internal.stats.parseArgs(pnames, dflts, varargin{:});
[m,n] = size(design);
assert(m==n&&m>1,'design维度不对');
img = repmat(design2block(design,blocksize,border),repeatv,repeath);
end

function [img] = design2block(design,blocksize,border)
assert(border*2<blocksize);
[m,n] = size(design);
img = double(zeros(blocksize*m,blocksize*m))+0.5; 
for vv = 1:m
    for hh= 1:n
        vindex = (vv-1)*blocksize+1+border:vv*blocksize+1-border;
        hindex = (hh-1)*blocksize+1+border:hh*blocksize+1-border;
        img(vindex,hindex) = design(vv,hh);
    end
end
end








