function [weftT,offsetDist] = weftanalyse(pic,vT)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ����ͼƬ��γ�߿�ȣ�����ֱ�ӵ���vT��Ҳ����vT����������,ʹ�������ۼӷ���֤
% ���÷���[weftT] = weftanalyse(pic,vT)
% �������
%   pic:����ȡγ�߿�ȵ�ͼƬ���飬Ӧ��Ϊ��ά����
%   vT:��ֱ������֯ѭ��������
% �������
%   weftT :γ�߿��
%   offsetDist:��һ��γ�ߵĿ��(��һ�����ܲ�����)
assert(ismatrix(pic),'�������picӦ��Ϊ��ά���飬��������');
accres = accumulate(pic,'axis',2);
[T,phase] = fourier1fit(accres');
Tnum = double(vT)/double(T);
weftT = round(((double(vT)/(round(Tnum)))+T)/2);
offsetDist = weftT*(1-phase/(2*pi));
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

