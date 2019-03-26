%  GETMAPPING()��������LBP����ֵ��ȡʱ��ӳ�䡣
%  MAPPING = GETMAPPING(SAMPLES,MAPPINGTYPE) ����һ������
%  LBP����ӳ��ĵĽṹ�塣MAPPINGTYPE���ܵ�ֵ�У�
%       'u2'   LBP�ȼ�ģʽ��
%       'ri'   LBP��ת����ģʽ��
%       'riu2' LBP��ת����ȼ�ģʽ��
%  Example:
%       I=imread('rice.tif');
%       MAPPING=getmapping(16,'riu2');
%       LBPHIST=lbp(I,2,16,MAPPING,'hist');
%  �õ�ͼ��ILBP��ת����ȼ�ģʽ�ڰ뾶Ϊ2��������Ϊ16��������
%  ֱ��ͼ��
%
function mapping = GetMapping(samples,mappingtype)
% Version 0.2
% Authors: Marko Heikkil, Timo Ahonen and Xiaopeng Hong
matlab_ver = ver('MATLAB');
matlab_ver = str2double(matlab_ver.Version);
% ��ȡMATLAB�汾��Ϣ
if matlab_ver < 8
    % ��ʹ��MATLAB�汾�ŵ���8
    mapping = getmapping_ver7(samples,mappingtype);
else
    % ��ʹ��MATLAB�汾�Ÿ��ڵ���8
    mapping = getmapping_ver8(samples,mappingtype);
end

end

function mapping = getmapping_ver7(samples,mappingtype)
% ��ʾ�汾��Ϣ
% disp('For Matlab version 7.x and lower');
% LBPֵӳ���ÿ���������Ӧ��LBPģʽֵ
table = 0:2^samples-1;
% LBP����ֵ������Ŀ
newMax  = 0;                           
index   = 0;
% �ȼ�LBPģʽ
if strcmp(mappingtype,'u2')
    % �ȼ�LBPģʽ��ģʽ��ΪP��P+1��+3
    newMax = samples*(samples-1) + 3;
    % ÿ���������Ӧ��LBPģʽֵ
    for i = 0:2^samples-1
        % ������ת��
        j = bitset(bitshift(i,1,samples),1,bitget(i,samples)); %rotate left
        numt = sum(bitget(bitxor(i,j),1:samples));  %1->0��0->1�����ܴ���
        if numt <= 2
            table(i+1) = index;
            index = index + 1;
        else
            table(i+1) = newMax - 1;
        end
    end
end
% ��ת����LBPģʽ
if strcmp(mappingtype,'ri')
    tmpMap = zeros(2^samples,1) - 1;
    for i = 0:2^samples-1
        % rmΪ��ת��Сֵ
        rm = i;
        r  = i;
        for j = 1:samples-1
            % ������ת��λ
            r = bitset(bitshift(r,1,samples),1,bitget(r,samples)); 
            if r < rm
                rm = r;
            end
        end
        % �ж��Ƿ�Ϊ�µ���Сֵ
        if tmpMap(rm+1) < 0
            tmpMap(rm+1) = newMax;
            newMax = newMax + 1;
        end
        table(i+1) = tmpMap(rm+1);
    end
end
%��ת����ȼ�LBPģʽ
if strcmp(mappingtype,'riu2') %Uniform & Rotation invariant
    newMax = samples + 2;
    for i = 0:2^samples - 1
        j = bitset(bitshift(i,1,samples),1,bitget(i,samples)); %rotate left
        numt = sum(bitget(bitxor(i,j),1:samples));
        if numt <= 2
            table(i+1) = sum(bitget(i,1:samples));
        else
            table(i+1) = samples+1;
        end
    end
end

mapping.table=table;
mapping.samples=samples;
mapping.num=newMax;
end



function mapping = getmapping_ver8(samples,mappingtype)

% disp('For Matlab version 8.0 and higher');

table = 0:2^samples-1;
newMax  = 0; %number of patterns in the resulting LBP code
index   = 0;

if strcmp(mappingtype,'u2') %Uniform 2
    newMax = samples*(samples-1) + 3;
    for i = 0:2^samples-1

        i_bin = dec2bin(i,samples);
        j_bin = circshift(i_bin',-1)';              %circularly rotate left
        numt = sum(i_bin~=j_bin);                   %number of 1->0 and
                                                    %0->1 transitions
                                                    %in binary string
                                                    %x is equal to the
                                                    %number of 1-bits in
                                                    %XOR(x,Rotate left(x))

        if numt <= 2
            table(i+1) = index;
            index = index + 1;
        else
            table(i+1) = newMax - 1;
        end
    end
end

if strcmp(mappingtype,'ri') %Rotation invariant
    tmpMap = zeros(2^samples,1) - 1;
    for i = 0:2^samples-1
        rm = i;
    
        r_bin = dec2bin(i,samples);

        for j = 1:samples-1

            r = bin2dec(circshift(r_bin',-1*j)'); %rotate left    
            if r < rm
                rm = r;
            end
        end
        if tmpMap(rm+1) < 0
            tmpMap(rm+1) = newMax;
            newMax = newMax + 1;
        end
        table(i+1) = tmpMap(rm+1);
    end
end

if strcmp(mappingtype,'riu2') %Uniform & Rotation invariant
    newMax = samples + 2;
    for i = 0:2^samples - 1
        
        i_bin =  dec2bin(i,samples);
        j_bin = circshift(i_bin',-1)';
        numt = sum(i_bin~=j_bin);
  
        if numt <= 2
            table(i+1) = sum(bitget(i,1:samples));
        else
            table(i+1) = samples+1;
        end
    end
end

mapping.table=table;
mapping.samples=samples;
mapping.num=newMax;
end
