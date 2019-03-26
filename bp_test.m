% BP网络函数逼近实例
% 1.首先定义正弦函数，采样率为20Hz，频率为1Hz
k = 1; % 设定正弦信号频率
p = [0:0.05:4];
t = cos(k*pi*p) + 3*sin(pi*p);
plot(p, t, '-'), xlabel('时间'); ylabel('输入信号');
% 2.生成BP网络。用newff函数生成前向型BP网络，设定隐层中神经元数目为10
% 分别选择隐层的传递函数为 tansig，输出层的传递函数为 purelin，
% 学习算法为trainlm。
net = newff(minmax(p),[10,10,1],{'tansig','tansig','purelin'},'trainlm');
% 3.对生成的网络进行仿真并做图显示。
y1 = sim(net,p); plot(p, t, '-', p, y1, '--')
% 4.训练。对网络进行训练，设定训练误差目标为 1e-5，最大迭代次数为300，
% 学习速率为0.05。
net.trainParam.lr=0.05;
net.trainParam.epochs=1000;
net.trainParam.goal=1e-5;
[net,tr]=train(net,p,t);
%5.再次对生成的网络进行仿真并做图显示。
y2 = sim(net,p);
plot(p, t, '-', p, y2, '--')