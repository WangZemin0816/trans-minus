rgb = imread('Image/2.jpg');
img = rgb2gray(rgb);
figure(1)
imshow(img);
figure(2)
imshow(gaussblur(img))