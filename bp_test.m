% BP���纯���ƽ�ʵ��
% 1.���ȶ������Һ�����������Ϊ20Hz��Ƶ��Ϊ1Hz
k = 1; % �趨�����ź�Ƶ��
p = [0:0.05:4];
t = cos(k*pi*p) + 3*sin(pi*p);
plot(p, t, '-'), xlabel('ʱ��'); ylabel('�����ź�');
% 2.����BP���硣��newff��������ǰ����BP���磬�趨��������Ԫ��ĿΪ10
% �ֱ�ѡ������Ĵ��ݺ���Ϊ tansig�������Ĵ��ݺ���Ϊ purelin��
% ѧϰ�㷨Ϊtrainlm��
net = newff(minmax(p),[10,10,1],{'tansig','tansig','purelin'},'trainlm');
% 3.�����ɵ�������з��沢��ͼ��ʾ��
y1 = sim(net,p); plot(p, t, '-', p, y1, '--')
% 4.ѵ�������������ѵ�����趨ѵ�����Ŀ��Ϊ 1e-5������������Ϊ300��
% ѧϰ����Ϊ0.05��
net.trainParam.lr=0.05;
net.trainParam.epochs=1000;
net.trainParam.goal=1e-5;
[net,tr]=train(net,p,t);
%5.�ٴζ����ɵ�������з��沢��ͼ��ʾ��
y2 = sim(net,p);
plot(p, t, '-', p, y2, '--')