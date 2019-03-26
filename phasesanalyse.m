function [yarnnum,design,vs,relativephases] = phasesanalyse(phases,varargin)
% ���ߣ�������1027329813@qq.com,2018.02.02
% ��ƽ����λ�仯����һ����֯�ṹ�������ٸ�ɴ�ߣ��Լ���֯�ṹ����
% ���÷�����[yarnnum,design] = phasesanalyse(phases,T)
% yarnnum:ÿ��ѭ����֯������ɴ����Ŀ
% design:��֯�⽳ͼ����
% phases:ƽ�Ƶõ�����λ��
% T:��֯������
% max_yarnnumÿ��ѭ����֯������ɴ�����ֵ
% vsΪ�������
% ɴ����Ŀ��Ӧ�ö���10
% ���������λ��-pi��+pi֮�䣬����С�ܶ�
pnames = {'max_yarnnum'};
dflts =  {   8  };
[max_yarnnum] = internal.stats.parseArgs(pnames, dflts, varargin{:});%��ȡ����
[~,phase_num] = size(phases);%��λ��Ŀ
assert(phase_num>5,'�����Ŀ̫��,ͼƬ������γ����Ŀ����');
max_varnum = min(max_yarnnum,phase_num-3);%һ�����ڰ����ľ�����ĿӦ��������ߺ������������Ŀ-2
%%��ȡÿ��ѭ��������ɴ����Ŀ
diff = zeros(1,max_varnum);%������λ��ֵ
for jj=1:max_varnum
    diff(jj) = groupminus(phases,jj);
end
yarnnum = find(diff==min(diff));%��ֵ��С�������Ǿ�����Ŀ
%%��ȡÿ��ѭ���ڵľ��߳��ֵ�λ��
ave_minus = aveminus(phases,yarnnum);%��ȡ����ÿ��Ԫ�����һ��Ԫ�ص�ƽ����ֵ
design = ones(yarnnum);
[~,sortidx] = sort(ave_minus);
for jj=1:yarnnum
    design(sortidx(jj),jj) = 0;
end
%%��������
vs = sortidx(2)-sortidx(1);
if(abs(yarnnum-vs)<abs(vs))
    vs = vs-yarnnum;%�������ֵ��С�ķ���
end
%%�����λ����
relativephases = zeros(size(phases));
for ii = phase_num:-1:1
    cursubidx = yarnnum*floor((ii-1)/yarnnum)+1;
    relativephases(ii) = radiansub(phases(ii),phases(cursubidx));%ÿ����λ��һ����λ����Ϊ0
end
end



function [diff] = aveminus(data,n)
% �������Ԫ�����һ��Ԫ�صĲ�ֵ,��-pi��+pi֮���ֵ����С�ܶ�
[~,num] = size(data);
diff = zeros(1,n);

for ii = num:-1:1
    cursubidx = n*floor((ii-1)/n)+1;
    data(ii) = radiansub(data(ii),data(cursubidx));%ÿ����λ��һ����λ����Ϊ0
end
index = 1:num;
for ii=1:n
    if(ii==n)
        cur_idx = (mod(index,n)==0);
    else 
        cur_idx = (mod(index,n)==ii);
    end
    diff(ii) = mean(data(cur_idx));
end
diff(diff<0) = diff(diff<0)+2*pi;%ʵ��������λ��0-2pi֮��
end

function [ave_diff] = groupminus(data,n)
%%���飬����ÿ��֮��Ԫ�ز�ֵ��ƽ��ֵ,��-pi��+pi֮���ֵ����С�ܶ�
[x,y] = size(data);
assert(x==1,'��������');
assert(n<y&&n>0,'��������');
sum = 0;
count = 0;
for ii=n+1:y
    cursub = radiansub(data(ii),data(ii-n));
    sum = sum+abs(cursub);
    count = count+1;
end
ave_diff = sum/count;
end

function [subres] = radiansub(phasesA,phasesB)
% �Ƕ�����㷨,��λΪ����,�����-pi��+pi֮��
    subres = phasesA-phasesB;
    subres = mod(subres,2*pi);
    subres(subres>pi) = subres(subres>pi)-2*pi;
end









