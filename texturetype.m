function [type] = texturetype(R,S)
% �ж�֯��ƽ�ƶ���б��
%   �˴���ʾ��ϸ˵��
type = 'δ֪';
if(R==2&&abs(S)==1)
    type = 'ƽ��';
elseif(R>2&&abs(S)==1)
    type = 'б��';
elseif(R>=5&&abs(S)>1&&abs(S)<R-1&&gcd(R,abs(S))==1)
    type = '����';
end

