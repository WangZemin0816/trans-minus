function [type] = texturetype(R,S)
% ÅÐ¶ÏÖ¯ÎïÆ½ÎÆ¶ÐÎÆÐ±ÎÆ
%   ´Ë´¦ÏÔÊ¾ÏêÏ¸ËµÃ÷
type = 'Î´Öª';
if(R==2&&abs(S)==1)
    type = 'Æ½ÎÆ';
elseif(R>2&&abs(S)==1)
    type = 'Ð±ÎÆ';
elseif(R>=5&&abs(S)>1&&abs(S)<R-1&&gcd(R,abs(S))==1)
    type = '¶ÍÎÆ';
end

