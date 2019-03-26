function [weftT,offsetDist] = weftanalyse(pic,vT)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 分析图片的纬线宽度，可能直接等于vT，也可能vT是其整数倍,使用亮度累加法验证
% 调用方法[weftT] = weftanalyse(pic,vT)
% 输入参数
%   pic:待求取纬线宽度的图片数组，应当为二维矩阵
%   vT:竖直方向组织循环的周期
% 输出参数
%   weftT :纬线宽度
%   offsetDist:第一条纬线的宽度(第一条可能不完整)
assert(ismatrix(pic),'输入参数pic应当为二维数组，参数错误！');
accres = accumulate(pic,'axis',2);
[T,phase] = fourier1fit(accres');
Tnum = double(vT)/double(T);
weftT = round(((double(vT)/(round(Tnum)))+T)/2);
offsetDist = weftT*(1-phase/(2*pi));
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

