
rgb = imread('Image/2.jpg');
img = rgb2gray(rgb);
% trans_val = transminus(img);
% trans_val = transminus(img,'step',5);
% trans_val = transminus(img,'isflip',1);
% trans_val = transminus(img,'v_premove',23);
[hT,hphase] = transminus(grayimg,'direction','h');
[vT,vphase] = transminus(grayimg,'direction','v');
[T,phase,f,transdata] = transminus(img);
[x,y] = size(transdata);
a = max(x,y);
%% 
figure(1)
plot(transdata)
hold on
plot(1:a,f(1:a))