function [yarnnum,design,vs,relativephases] = phasesanalyse(phases,varargin)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 从平移相位变化分析一个组织结构包含多少根纱线，以及组织结构矩阵
% 调用方法：[yarnnum,design] = phasesanalyse(phases,T)
% yarnnum:每个循环组织包含的纱线数目
% design:组织意匠图矩阵
% phases:平移得到的相位差
% T:组织的周期
% max_yarnnum每个循环组织包含的纱线最大值
% vs为经向飞数
% 纱线数目不应该多于10
% 计算过程相位在-pi到+pi之间，误差会小很多
pnames = {'max_yarnnum'};
dflts =  {   8  };
[max_yarnnum] = internal.stats.parseArgs(pnames, dflts, varargin{:});%获取参数
[~,phase_num] = size(phases);%相位数目
assert(phase_num>5,'相角数目太少,图片包含的纬线数目不足');
max_varnum = min(max_yarnnum,phase_num-3);%一个周期包含的经线数目应该在最大经线和输入的数据数目-2
%%获取每个循环包含的纱线数目
diff = zeros(1,max_varnum);%分组相位差值
for jj=1:max_varnum
    diff(jj) = groupminus(phases,jj);
end
yarnnum = find(diff==min(diff));%差值最小的组别就是经线数目
%%获取每个循环内的经线出现的位置
ave_minus = aveminus(phases,yarnnum);%求取组中每个元素与第一个元素的平均差值
design = ones(yarnnum);
[~,sortidx] = sort(ave_minus);
for jj=1:yarnnum
    design(sortidx(jj),jj) = 0;
end
%%飞数计算
vs = sortidx(2)-sortidx(1);
if(abs(yarnnum-vs)<abs(vs))
    vs = vs-yarnnum;%计算绝对值较小的飞数
end
%%相对相位计算
relativephases = zeros(size(phases));
for ii = phase_num:-1:1
    cursubidx = yarnnum*floor((ii-1)/yarnnum)+1;
    relativephases(ii) = radiansub(phases(ii),phases(cursubidx));%每组相位第一个相位设置为0
end
end



function [diff] = aveminus(data,n)
% 分组计算元素与第一个元素的差值,用-pi到+pi之间的值误差会小很多
[~,num] = size(data);
diff = zeros(1,n);

for ii = num:-1:1
    cursubidx = n*floor((ii-1)/n)+1;
    data(ii) = radiansub(data(ii),data(cursubidx));%每组相位第一个相位设置为0
end
index = 1:num;
for ii=1:n
    if(ii==n)
        cur_idx = (mod(index,n)==0);
    else 
        cur_idx = (mod(index,n)==ii);
    end
    diff(ii) = mean(data(cur_idx));
end
diff(diff<0) = diff(diff<0)+2*pi;%实际需求相位在0-2pi之间
end

function [ave_diff] = groupminus(data,n)
%%分组，计算每组之间元素差值的平均值,用-pi到+pi之间的值误差会小很多
[x,y] = size(data);
assert(x==1,'参数错误');
assert(n<y&&n>0,'参数错误');
sum = 0;
count = 0;
for ii=n+1:y
    cursub = radiansub(data(ii),data(ii-n));
    sum = sum+abs(cursub);
    count = count+1;
end
ave_diff = sum/count;
end

function [subres] = radiansub(phasesA,phasesB)
% 角度相减算法,单位为弧度,结果在-pi到+pi之间
    subres = phasesA-phasesB;
    subres = mod(subres,2*pi);
    subres(subres>pi) = subres(subres>pi)-2*pi;
end









