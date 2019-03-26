function [T,phase,fourierpara,trans_val] = transminus( pic , varargin )
% ���ߣ�������1027329813@qq.com,2018.02.02
% ͨ��ƽ������ķ������������ӦͼƬ���������
% trans_val��ƽ������õ���ֵ
% ���÷���[ trans_val ] = transminus( pic , 'PARAM1',val1,'PARAM2',val2.... )
% pic:����ȡ����γ�ܵ�ͼƬ���飬Ӧ��Ϊ��ά����
% param :
%   'direction':ƽ������ķ���'v'����'h'
%   'margin':ƽ�������С��϶��Ĭ��Ϊ10%��ƽ�ƾ�������ᵼ���ص��������С����������Ӱ����
%   'step':ƽ�����ÿ��ƽ�Ƶľ���
%   'isflip':�Ƿ������
%   'v_premove':��ֱ�����λ�������
%   'h_premove':ˮƽ�����λ�������
%   'flipaxis':����������
%   'ishalf':�Ƿ�ֻ��ȡһ���ƶ����ݣ���Щͼ�ǶԳƵģ�
%��������
[v,h] = size(pic);
assert(ismatrix(pic),'transminus�����������Ӧ��Ϊ��ά���飬��������');
assert( h > 2 || v > 2,'transminus������������̫С������������');
pnames = {'direction','margin','step','isflip','v_premove','h_premove','flipaxis','ishalf'};
dflts =  {    'h'    ,  0.1   ,  1   ,    0   ,    0      ,    0      ,     2    ,    1   };
[direction,margin,step,isflip,v_premove,h_premove,flipaxis,ishalf] = internal.stats.parseArgs(pnames, dflts, varargin{:});
assert( margin > 0 && margin < 1,'transminus��������marginӦ����0~1֮��');
assert( step>0 && step<min(v,h),'transminus��������stepӦ�ô��������С��ͼƬ�ĳ���');
assert( v_premove>=0 && v_premove<v*(1-margin),'����������');
assert( h_premove>=0 && h_premove<h*(1-margin),'����������');
assert( flipaxis == 1||flipaxis == 2, '����������');
assert( direction == 'v'||direction == 'h', '����������');
pic = normalize(double(pic));%ͼƬ��һ������
%�������������ͼƬ
subtrahend = double(pic);%����������
minuend = double(pic);%��������
if(isflip) %�������
    subtrahend = fliplr(subtrahend);
end
minuend = minuend(v_premove+1:v,h_premove+1:h);
subtrahend = subtrahend(1:v-v_premove,1:h-h_premove);

if(direction=='v')
    minuend = minuend';
    subtrahend=subtrahend';
end
%����ƽ������
if(ishalf)
    trans_val = halftrans(minuend,subtrahend, margin,step);
else
    trans_val = trans(minuend,subtrahend, margin,step);
end
[T,phase,fourierpara] = fourier1fit(trans_val);
T = T*step;
end

function [ subvals ] = trans( minuend,subtrahend, margin,step)
% ��������ƽ������õ���ƽ��ֵ,����ֵΪ��ֵ����
[~,h] = size(minuend);
margindist = floor(h*margin);%ƽ��ԣ��
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
% ��������ƽ������õ���ƽ��ֵ,����ֵΪ��ֵ����
[~,h] = size(minuend);
margindist = floor(h*margin);%ƽ��ԣ��
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
% ���ߣ�������1027329813@qq.com,2018.02.02
% �����߽���һ�׸���Ҷ��ϣ����ض�Ӧ����ϲ���,TΪһ���ڳ��ȣ�phaseΪ��λ���
[~,x] = size(curves);
ft = fittype('fourier1');
opts = fitoptions( ft );
opts.Display = 'Off';
[fitresult, ~] = fit((1:x)', curves', ft, opts );
T = floor(round(2*pi/fitresult.w));%����
phase = getphase(fitresult.a1,fitresult.b1);
end
function [phase] = getphase(a,b)
% �������� b*sin(xw)+a*cos(xw)+c�е�a��b,������λ
% b=cos(phi),a = sin(phi)
if(b==0)
    phi = pi/2;
else
    phi = atan(abs(a/b));%��λ�Ƕ�
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




