%  GETMAPPING()函数返回LBP特征值求取时的映射。
%  MAPPING = GETMAPPING(SAMPLES,MAPPINGTYPE) 返回一个包括
%  LBP邻域映射的的结构体。MAPPINGTYPE可能的值有：
%       'u2'   LBP等价模式。
%       'ri'   LBP旋转不变模式。
%       'riu2' LBP旋转不变等价模式。
%  Example:
%       I=imread('rice.tif');
%       MAPPING=getmapping(16,'riu2');
%       LBPHIST=lbp(I,2,16,MAPPING,'hist');
%  得到图像ILBP旋转不变等价模式在半径为2，采样点为16的邻域内
%  直方图。
%
function mapping = GetMapping(samples,mappingtype)
% Version 0.2
% Authors: Marko Heikkil, Timo Ahonen and Xiaopeng Hong
matlab_ver = ver('MATLAB');
matlab_ver = str2double(matlab_ver.Version);
% 获取MATLAB版本信息
if matlab_ver < 8
    % 若使用MATLAB版本号低于8
    mapping = getmapping_ver7(samples,mappingtype);
else
    % 若使用MATLAB版本号高于等于8
    mapping = getmapping_ver8(samples,mappingtype);
end

end

function mapping = getmapping_ver7(samples,mappingtype)
% 显示版本信息
% disp('For Matlab version 7.x and lower');
% LBP值映射表，每种情况所对应的LBP模式值
table = 0:2^samples-1;
% LBP特征值种类数目
newMax  = 0;                           
index   = 0;
% 等价LBP模式
if strcmp(mappingtype,'u2')
    % 等价LBP模式的模式数为P（P+1）+3
    newMax = samples*(samples-1) + 3;
    % 每种情况所对应的LBP模式值
    for i = 0:2^samples-1
        % 向左旋转。
        j = bitset(bitshift(i,1,samples),1,bitget(i,samples)); %rotate left
        numt = sum(bitget(bitxor(i,j),1:samples));  %1->0和0->1跳变总次数
        if numt <= 2
            table(i+1) = index;
            index = index + 1;
        else
            table(i+1) = newMax - 1;
        end
    end
end
% 旋转不变LBP模式
if strcmp(mappingtype,'ri')
    tmpMap = zeros(2^samples,1) - 1;
    for i = 0:2^samples-1
        % rm为旋转最小值
        rm = i;
        r  = i;
        for j = 1:samples-1
            % 向左旋转移位
            r = bitset(bitshift(r,1,samples),1,bitget(r,samples)); 
            if r < rm
                rm = r;
            end
        end
        % 判断是否为新的最小值
        if tmpMap(rm+1) < 0
            tmpMap(rm+1) = newMax;
            newMax = newMax + 1;
        end
        table(i+1) = tmpMap(rm+1);
    end
end
%旋转不变等价LBP模式
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
