
design = [1,0,0,0,0;
          0,0,1,0,0;
          0,0,0,0,1;
          0,1,0,0,0;
          0,0,0,1,0];
img = textureimg(design,'blocksize',30,'repeatv',2,'repeath',2);
imshow(~img)

% [y,x] = size(img);
% [xx,yy] = meshgrid(1:x,1:y);
% plot3(yy,xx,img)