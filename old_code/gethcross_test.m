rgb = imread('Image/2.jpg');
img = rgb2gray(rgb);
[v,h] = size(img);
[orient,weight] = hog(img);
[vdist,hdist] = transminus(img);
accres = accumulate(orient<pi/4,'axis',1);
vcross = getvcross(accres,hdist);

figure(3)
[x,y] = size(img);
colormap('gray');
imagesc(img);
hold on;
%%%%%%%%%%%%%%%
for ii=0:uint16(h/hdist)
    line([vcross+hdist*ii,vcross+hdist*ii],[0,x],'color','c');
end
