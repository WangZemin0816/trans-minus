rgb = imread('Image/2.jpg');
img = rgb2gray(rgb);
[orient,weight] = hog(img);
orient = abs(orient)>pi/4;

[vdist,hdist] = transminus(img);
accres = accumulate(orient.*weight,'axis',2);
[v,h] = size(img);
dist = uint8(vdist);
acc_vdist = zeros(1,dist);
for ii = 1:v
    mod_val = mod(ii,dist)+1;
    acc_vdist(mod_val)= acc_vdist(mod_val)+accres(ii);
end

figure(1)
plot(acc_vdist)

figure(3)
[x,y] = size(img);
colormap('gray');
imagesc(img);
hold on;


