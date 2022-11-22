clc;
close all;

RGB_data = imread('../pic/monkey.bmp');

R_data =    RGB_data(:,:,1);
G_data =    RGB_data(:,:,2);
B_data =    RGB_data(:,:,3);

% imshow(RGB_data);

[ROW,COL, DIM] = size(RGB_data);

Y_data = zeros(ROW,COL);
Cb_data = zeros(ROW,COL);
Cr_data = zeros(ROW,COL);

%原图像是倒着存的，将y分量倒一下
for r = 1:ROW
    for c = 1:COL
        R = uint16(R_data(r, c));
        G = uint16(G_data(r, c));
        B = uint16(B_data(r, c));
        
        Y_data(ROW + 1 - r,  c)    =   77 *R	+ 	150*G 	+ 	29 *B;
        Cb_data(r, c)   =   -43*R	- 	85 *G	+ 	128*B;
        Cr_data(r, c)   =   128*R	-	107*G  	-	21 *B;
        
        Y_data(ROW + 1 - r,  c)    =   bitshift(Y_data(ROW + 1 - r, c),-8);
        Cb_data(r, c)   =   bitshift(Cb_data(r, c),-8) + 128;
        Cr_data(r, c)   =   bitshift(Cr_data(r, c),-8) + 128;
    end
end







% Gray_data = RGB_data;
% Gray_data(:,:,1)=Y_data;
% Gray_data(:,:,2)=Y_data;
% Gray_data(:,:,3)=Y_data;
% 
% figure;
% imshow(Gray_data);

% %Median Filter
% imgn = imnoise(Gray_data,'salt & pepper',0.02);
% 
% figure;
% imshow(imgn);
% 
% Median_Img = Gray_data;
% for r = 2:ROW-1
%     for c = 2:COL-1
%         median3x3 =[imgn(r-1,c-1)    imgn(r-1,c) imgn(r-1,c+1)
%                     imgn(r,c-1)      imgn(r,c)      imgn(r,c+1)
%                     imgn(r+1,c-1)      imgn(r+1,c) imgn(r+1,c+1)];
%         sort1 = sort(median3x3, 2, 'descend');
%         sort2 = sort([sort1(1), sort1(4), sort1(7)], 'descend');
%         sort3 = sort([sort1(2), sort1(5), sort1(8)], 'descend');
%         sort4 = sort([sort1(3), sort1(6), sort1(9)], 'descend');
%         mid_num = sort([sort2(3), sort3(2), sort4(1)], 'descend');
%         Median_Img(r,c) = mid_num(2);
%     end
% end
% 
% figure;
% imshow(Median_Img);
% 
% %Sobel_Edge_Detect
% 
% Median_Img = double(Median_Img);
% Sobel_Threshold = 150;
% Sobel_Img = zeros(ROW,COL);
% for r = 2:ROW-1
%     for c = 2:COL-1
%         Sobel_x = Median_Img(r-1,c+1) + 2*Median_Img(r,c+1) + Median_Img(r+1,c+1) - Median_Img(r-1,c-1) - 2*Median_Img(r,c-1) - Median_Img(r+1,c-1);
%         Sobel_y = Median_Img(r-1,c-1) + 2*Median_Img(r-1,c) + Median_Img(r-1,c+1) - Median_Img(r+1,c-1) - 2*Median_Img(r+1,c) - Median_Img(r+1,c+1);
%         Sobel_Num = abs(Sobel_x) + abs(Sobel_y);
%         %Sobel_Num = sqrt(Sobel_x^2 + Sobel_y^2);
%         if(Sobel_Num > Sobel_Threshold)
%             Sobel_Img(r,c)=0;
%         else
%             Sobel_Img(r,c)=255;
%         end
%     end
% end
% 
% figure;
% imshow(Sobel_Img);