[fileName,pathName] = uigetfile('*.*','Ñ¡Ôñ´ý×ª»»µÄÍ¼Æ¬');
imgPath = strcat(pathName,fileName);
img = imread(imgPath);
img = rgb2gray(img);
[v,h] = size(img);
[orient,weight] = hog(img);
[vdist,hdist] = transminus(img);
accres = accumulate(orient>pi/4,'axis',2);
vcross = getvcross(accres,vdist);

figure(3)
[x,y] = size(img);
colormap('gray');
imagesc(img);
hold on;
%%%%%%%%%%%%%%%
for ii=0:uint16(v/vdist)
    line([0,y],[vcross+vdist*ii,vcross+vdist*ii],'color','c');
end

