function [T,phase,fourierpara,trans_val] = transminus( pic , varargin )
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 通过平移相减的方法返回数组对应图片的相减曲线
% trans_val：平移相减得到的值
% 调用方法[ trans_val ] = transminus( pic , 'PARAM1',val1,'PARAM2',val2.... )
% pic:待求取经密纬密的图片数组，应当为二维矩阵
% param :
%   'direction':平移相减的方向'v'或者'h'
%   'margin':平移相减最小空隙，默认为10%，平移距离过长会导致重叠的区域过小，单个数据影响变大
%   'step':平移相减每次平移的距离
%   'isflip':是否镜像相减
%   'v_premove':竖直方向错位相减距离
%   'h_premove':水平方向错位相减距离
%   'flipaxis':镜像坐标轴
%   'ishalf':是否只获取一半移动数据（有些图是对称的）
%参数处理
[v,h] = size(pic);
assert(ismatrix(pic),'transminus函数输入参数应当为二维数组，参数错误！');
assert( h > 2 || v > 2,'transminus函数输入数组太小，不满足条件');
pnames = {'direction','margin','step','isflip','v_premove','h_premove','flipaxis','ishalf'};
dflts =  {    'h'    ,  0.1   ,  1   ,    0   ,    0      ,    0      ,     2    ,    1   };
[direction,margin,step,isflip,v_premove,h_premove,flipaxis,ishalf] = internal.stats.parseArgs(pnames, dflts, varargin{:});
assert( margin > 0 && margin < 1,'transminus函数参数margin应该在0~1之间');
assert( step>0 && step<min(v,h),'transminus函数参数step应该大于零而且小于图片的长宽');
assert( v_premove>=0 && v_premove<v*(1-margin),'参数不合理');
assert( h_premove>=0 && h_premove<h*(1-margin),'参数不合理');
assert( flipaxis == 1||flipaxis == 2, '参数不合理');
assert( direction == 'v'||direction == 'h', '参数不合理');
pic = normalize(double(pic));%图片归一化处理
%计算相减的两幅图片
subtrahend = double(pic);%被减数计算
minuend = double(pic);%减数计算
if(isflip) %镜像计算
    subtrahend = fliplr(subtrahend);
end
minuend = minuend(v_premove+1:v,h_premove+1:h);
subtrahend = subtrahend(1:v-v_premove,1:h-h_premove);

if(direction=='v')
    minuend = minuend';
    subtrahend=subtrahend';
end
%计算平移曲线
if(ishalf)
    trans_val = halftrans(minuend,subtrahend, margin,step);
else
    trans_val = trans(minuend,subtrahend, margin,step);
end
[T,phase,fourierpara] = fourier1fit(trans_val);
T = T*step;
end

function [ subvals ] = trans( minuend,subtrahend, margin,step)
% 计算数组平移相减得到的平均值,返回值为差值序列
[~,h] = size(minuend);
margindist = floor(h*margin);%平移裕量
steps = (floor(h-margindist)/step)*2+1;
subvals = zeros(1,steps+1);
for ii=0:steps
	curstep = step*ii;
    if(ii<floor(steps/2))
        cur_minuend = minuend(:,h-curstep-margindist+1:h);
        cur_subtrahend = subtrahend(:,1:curstep+margindist);
    elseif(ii>=floor(steps/2))
        curstep = step*(ii-floor(steps/2));
        cur_minuend = minuend(:,1:h-curstep);
        cur_subtrahend = subtrahend(:,curstep+1:h);
    end
    subvals(ii+1)=mean(mean(abs(cur_minuend-cur_subtrahend)));
end
end

function [ subvals ] = halftrans( minuend,subtrahend, margin,step)
% 计算数组平移相减得到的平均值,返回值为差值序列
[~,h] = size(minuend);
margindist = floor(h*margin);%平移裕量
steps = floor(h-margindist)/step;
subvals = zeros(1,steps+1);
for ii=0:steps
	curstep = step*ii;
    cur_minuend = minuend(:,1:h-curstep);
    cur_subtrahend = subtrahend(:,curstep+1:h);
    subvals(ii+1)=mean(mean(abs(cur_minuend-cur_subtrahend)));
end
end


function [T,phase,fitresult] = fourier1fit(curves)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 对曲线进行一阶傅里叶拟合，返回对应的拟合参数,T为一周期长度，phase为相位差长度
[~,x] = size(curves);
ft = fittype('fourier1');
opts = fitoptions( ft );
opts.Display = 'Off';
[fitresult, ~] = fit((1:x)', curves', ft, opts );
T = floor(round(2*pi/fitresult.w));%周期
phase = getphase(fitresult.a1,fitresult.b1);
end
function [phase] = getphase(a,b)
% 给定函数 b*sin(xw)+a*cos(xw)+c中的a和b,计算相位
% b=cos(phi),a = sin(phi)
if(b==0)
    phi = pi/2;
else
    phi = atan(abs(a/b));%相位角度
end
if(a>0&&b>0)
    phase = phi;
elseif(a>0&&b<0)
    phase = pi-phi;
elseif(a<0&&b<0)
    phase = phi+pi;
else
    phase = 2*pi-phi;
end
phase(phase>pi) = phase(phase>pi)-2*pi;
end




