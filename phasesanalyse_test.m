load data1;
%%分析相位差列表
plot(h_phases,'*');
[warp_num,design] = phasesanalyse(h_phases);