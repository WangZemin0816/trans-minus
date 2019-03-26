function [phases] = transphases(pic,T,varargin)
% 作者：王泽民，1027329813@qq.com,2018.02.02
% 将图片水平或竖直方向一次移动一个周期，统计计算相位的变化规律
% 调用示例:[phases] = transphases(pic,T,'v')
% pic:待求取经密纬密的图片数组，应当为二维矩阵
% 参数:pic:操作的对象图片
%     T:移动的周期
%     direction:移动的方向,'v'或者'h'
[v,h] = size(pic);
assert(ismatrix(pic),'transminus函数输入参数应当为二维数组，参数错误！');
assert( h > 2 || v > 2,'transminus函数输入数组太小，不满足条件');
pnames = {'margin','direction'};
dflts =  {   0.1  ,   'v'   };
[margin,direction] = internal.stats.parseArgs(pnames, dflts, varargin{:});
assert( margin > 0 && margin < 1,'transminus函数参数margin应该在0~1之间');
assert( direction == 'v'||direction == 'h', '参数direction不合理');
assert( T>0&&T<min(v,h), '参数T不合理');

move_dist = v;
pre_move = strcat(direction,'_premove');
transdirect = 'h';%平移移动方向和预先移动方向相反
if(direction==h)
    move_dist = h;
    transdirect = 'v';
end
margindist = uint16(move_dist*margin);%平移裕量
steps = (uint16(move_dist-margindist)/T);
phases = zeros(1,steps);
for ii=0:steps-1
    [~,phase,~,~] = transminus(pic,pre_move,T*ii,'direction',transdirect);
    phases(ii+1) = phase;
end

end

