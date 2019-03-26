%Hog_test,Hog函数的测试文件
rgb = imread('Image/2.jpg');
hsv = rgb2hsv(rgb);
% img = rgb2gray(rgb);
img = hsv(:,:,1);
[orient,weight] = hog(img);
figure(1)
subplot(2,2,1)
imshow(normalize(abs(orient)<pi/4))
subplot(2,2,2)
imshow(normalize(weight))
subplot(2,2,3)
imshow(normalize(weight.*abs(orient)))
subplot(2,2,4)
imshow(img)