clear;clc;
load data2;

[warpwidth,firstweftloc,firstwarploc] = warpanalyse(grayimg,weftwidth,hT,relativephases);

[bintex] = structanalyse(grayimg,weftwidth,warpwidth,firstweftloc,firstwarploc,hT,relativephases);