function [phases] = transphases(pic,T,varargin)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ��ͼƬˮƽ����ֱ����һ���ƶ�һ�����ڣ�ͳ�Ƽ�����λ�ı仯����
% ����ʾ��:[phases] = transphases(pic,T,'v')
% pic:����ȡ����γ�ܵ�ͼƬ���飬Ӧ��Ϊ��ά����
% ����:pic:�����Ķ���ͼƬ
%     T:�ƶ�������
%     direction:�ƶ��ķ���,'v'����'h'
[v,h] = size(pic);
assert(ismatrix(pic),'transminus�����������Ӧ��Ϊ��ά���飬��������');
assert( h > 2 || v > 2,'transminus������������̫С������������');
pnames = {'margin','direction'};
dflts =  {   0.1  ,   'v'   };
[margin,direction] = internal.stats.parseArgs(pnames, dflts, varargin{:});
assert( margin > 0 && margin < 1,'transminus��������marginӦ����0~1֮��');
assert( direction == 'v'||direction == 'h', '����direction������');
assert( T>0&&T<min(v,h), '����T������');

move_dist = v;
pre_move = strcat(direction,'_premove');
transdirect = 'h';%ƽ���ƶ������Ԥ���ƶ������෴
if(direction==h)
    move_dist = h;
    transdirect = 'v';
end
margindist = uint16(move_dist*margin);%ƽ��ԣ��
steps = (uint16(move_dist-margindist)/T);
phases = zeros(1,steps);
for ii=0:steps-1
    [~,phase,~,~] = transminus(pic,pre_move,T*ii,'direction',transdirect);
    phases(ii+1) = phase;
end

end

