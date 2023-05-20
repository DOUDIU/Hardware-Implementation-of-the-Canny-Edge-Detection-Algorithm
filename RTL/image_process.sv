`timescale 1ns / 1ns
module image_process();
 
integer iBmpFileId;                 //����BMPͼƬ

integer oBmpFileId_1;                 //���BMPͼƬ 1
integer oBmpFileId_2;                 //���BMPͼƬ 2
integer oBmpFileId_3;                 //���BMPͼƬ 3
integer oBmpFileId_4;                 //���BMPͼƬ 3

integer oTxtFileId;                 //����TXT�ı�
        
integer iIndex = 0;                 //���BMP��������
integer pixel_index = 0;            //��������������� 
        
integer iCode;      
        
integer iBmpWidth;                  //����BMP ���
integer iBmpHight;                  //����BMP �߶�
integer iBmpSize;                   //����BMP �ֽ�??
integer iDataStartIndex;            //����BMP ��������ƫ��??
    
reg [ 7:0] rBmpData [0:2000000];    //���ڼĴ�����BMPͼƬ??���ֽ���??����??54�ֽڵ��ļ�ͷ??

reg [ 7:0] Vip_BmpData_1 [0:2000000]; //���ڼĴ���???ͼ��???��֮�� ��BMPͼƬ ����  
reg [ 7:0] Vip_BmpData_2 [0:2000000]; //���ڼĴ���???ͼ��???��֮�� ��BMPͼƬ ���� 
reg [ 7:0] Vip_BmpData_3 [0:2000000]; //���ڼĴ���???ͼ��???��֮�� ��BMPͼƬ ���� 
reg [ 7:0] Vip_BmpData_4 [0:2000000]; //���ڼĴ���???ͼ��???��֮�� ��BMPͼƬ ���� 

reg [31:0] rBmpWord;                //���BMPͼƬʱ���ڼĴ���??����wordΪ��λ��??4byte??

reg [ 7:0] pixel_data;              //�����???��ʱ����������

reg clk;
reg rst_n;

//reg [ 7:0] vip_pixel_data [0:230400];   	//320x240x3
reg [ 7:0] vip_pixel_data_1 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data_2 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data_3 [0:921600];   	//640x480x3
reg [ 7:0] vip_pixel_data   [0:921600];     //640x480x3

integer i;
integer j;
wire [0:4] 	char_feature  [7:0] [7:0] ;		//�������

`ifdef Vivado_Sim
	//---------------------------------------------
	initial begin
		iBmpFileId	= 	$fopen("../../../../../pic/monkey.bmp","rb");

	//����??BMPͼƬ���ص������� 21_Su_A65NF7
		iCode = $fread(rBmpData,iBmpFileId);
	
		//����BMPͼƬ�ļ�ͷ�ĸ�ʽ����??�����ͼƬ�� ��� /�߶� /��������ƫ��?? /ͼƬ�ֽ�??
		iBmpWidth       = {rBmpData[21],rBmpData[20],rBmpData[19],rBmpData[18]};
		iBmpHight       = {rBmpData[25],rBmpData[24],rBmpData[23],rBmpData[22]};
		iBmpSize        = {rBmpData[ 5],rBmpData[ 4],rBmpData[ 3],rBmpData[ 2]};
		iDataStartIndex = {rBmpData[13],rBmpData[12],rBmpData[11],rBmpData[10]};
		
		//�ر�����BMPͼƬ
		$fclose(iBmpFileId);
			
		//�ӳ�14ms���ȴ�???һ??VIP�������
		#14000000    
		
		//����ͼ�����BMPͼƬ���ļ�ͷ��������??

	//---------------------------------------------		
		oBmpFileId_1 	= 	$fopen("../../../../../pic/gray.bmp","wb+");
		//���??һ??
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_1[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_1[iIndex] = vip_pixel_data_1[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??    
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			rBmpWord = Vip_BmpData_1[iIndex];
			$fwrite(oBmpFileId_1,"%c",rBmpWord);
		end
		$fclose(oBmpFileId_1);

	//---------------------------------------------		
		oBmpFileId_2 	= 	$fopen("../../../../../pic/gauss.bmp","wb+");
		//���??����
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_2[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_2[iIndex] = vip_pixel_data_2[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??  
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			rBmpWord = Vip_BmpData_2[iIndex];
			$fwrite(oBmpFileId_2,"%c",rBmpWord);
		end
		$fclose(oBmpFileId_2);

	//---------------------------------------------		
		oBmpFileId_3 	= 	$fopen("../../../../../pic/canny.bmp","wb+");
		//���??����
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_3[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_3[iIndex] = vip_pixel_data_3[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??  
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			rBmpWord = Vip_BmpData_3[iIndex];
			$fwrite(oBmpFileId_3,"%c",rBmpWord);
		end
		$fclose(oBmpFileId_3);

	end  
	//initial end
	//--------------------------------------------- 
`else
	//---------------------------------------------
	initial begin

		//������BMPͼƬ
		iBmpFileId      = $fopen("..\\pic\\monkey.bmp","rb");	

		//����??BMPͼƬ���ص������� 21_Su_A65NF7
		iCode = $fread(rBmpData,iBmpFileId);
	
		//����BMPͼƬ�ļ�ͷ�ĸ�ʽ����??�����ͼƬ�� ��� /�߶� /��������ƫ��?? /ͼƬ�ֽ�??
		iBmpWidth       = {rBmpData[21],rBmpData[20],rBmpData[19],rBmpData[18]};
		iBmpHight       = {rBmpData[25],rBmpData[24],rBmpData[23],rBmpData[22]};
		iBmpSize        = {rBmpData[ 5],rBmpData[ 4],rBmpData[ 3],rBmpData[ 2]};
		iDataStartIndex = {rBmpData[13],rBmpData[12],rBmpData[11],rBmpData[10]};
		
		//�ر�����BMPͼƬ
		$fclose(iBmpFileId);

	//---------------------------------------------		
			
		//�ӳ�14ms���ȴ�???һ??VIP�������
		#14000000    
		
		//����ͼ�����BMPͼƬ���ļ�ͷ��������??
		
	//---------------------------------------------	
		//�����BMPͼƬ
		oBmpFileId_1 = $fopen("..\\pic\\gray.bmp","wb+");	
		//���??һ??
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_1[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_1[iIndex] = vip_pixel_data_1[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??    
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
			rBmpWord = {Vip_BmpData_1[iIndex+3],Vip_BmpData_1[iIndex+2],Vip_BmpData_1[iIndex+1],Vip_BmpData_1[iIndex]};
			$fwrite(oBmpFileId_1,"%u",rBmpWord);
		end
		//�ر�����BMPͼƬ
		$fclose(oBmpFileId_1);

		oBmpFileId_2 = $fopen("..\\pic\\gauss.bmp","wb+");
		//���??����
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_2[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_2[iIndex] = vip_pixel_data_2[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??    
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
			rBmpWord = {Vip_BmpData_2[iIndex+3],Vip_BmpData_2[iIndex+2],Vip_BmpData_2[iIndex+1],Vip_BmpData_2[iIndex]};
			$fwrite(oBmpFileId_2,"%u",rBmpWord);
		end
		//�ر�����BMPͼƬ
		$fclose(oBmpFileId_2);

	//---------------------------------------------		
		oBmpFileId_3 = $fopen("..\\pic\\canny.bmp","wb+");
		//���??����
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 1) begin
			if(iIndex < 54)
				Vip_BmpData_3[iIndex] = rBmpData[iIndex];
			else
				Vip_BmpData_3[iIndex] = vip_pixel_data_3[iIndex-54];
		end
		//�������е���??д�����BMPͼƬ??    
		for (iIndex = 0; iIndex < iBmpSize; iIndex = iIndex + 4) begin
			rBmpWord = {Vip_BmpData_3[iIndex+3],Vip_BmpData_3[iIndex+2],Vip_BmpData_3[iIndex+1],Vip_BmpData_3[iIndex]};
			$fwrite(oBmpFileId_3,"%u",rBmpWord);
		end
		//�ر�����BMPͼƬ
		$fclose(oBmpFileId_3);
		
	//---------------------------------------------

	//initial end
	//--------------------------------------------- 
	end
`endif


//---------------------------------------------		
//��???��ʱ�Ӻ�???λ�ź�
initial begin
    clk     = 1;
    rst_n   = 0;
    #110
    rst_n   = 1;
end 

//����50MHzʱ��
always #10 clk = ~clk;
 
//---------------------------------------------		
//��ʱ�������£�������??�����������ݣ�������Modelsim??�鿴BMP??����?? 
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        pixel_data  <=  8'd0;
        pixel_index <=  0;
    end
    else begin
        pixel_data  <=  rBmpData[pixel_index];
        pixel_index <=  pixel_index+1;
    end
end
 
//---------------------------------------------
//��������ͷʱ?? 

wire		cmos_vsync ;
reg			cmos_href;
wire        cmos_clken;
reg	[23:0]	cmos_data;	
		 
reg         cmos_clken_r;

reg [31:0]  cmos_index;

parameter [10:0] IMG_HDISP = 11'd640;
parameter [10:0] IMG_VDISP = 11'd480;

localparam H_SYNC = 11'd10;		
localparam H_BACK = 11'd10;		
localparam H_DISP = IMG_HDISP;	
localparam H_FRONT = 11'd10;		
localparam H_TOTAL = H_SYNC + H_BACK + H_DISP + H_FRONT;	

localparam V_SYNC = 11'd10;		
localparam V_BACK = 11'd10;		
localparam V_DISP = IMG_VDISP;	
localparam V_FRONT = 11'd10;		
localparam V_TOTAL = V_SYNC + V_BACK + V_DISP + V_FRONT;

//---------------------------------------------
//ģ�� OV7725/OV5640 ����ģ�������ʱ��ʹ??
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_clken_r <= 0;
	else
        cmos_clken_r <= ~cmos_clken_r;
end

//---------------------------------------------
//ˮƽ����??
reg	[10:0]	hcnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		hcnt <= 11'd0;
	else if(cmos_clken_r) 
		hcnt <= (hcnt < H_TOTAL - 1'b1) ? hcnt + 1'b1 : 11'd0;
end

//---------------------------------------------
//��ֱ����??
reg	[10:0]	vcnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		vcnt <= 11'd0;		
	else if(cmos_clken_r) begin
		if(hcnt == H_TOTAL - 1'b1)
			vcnt <= (vcnt < V_TOTAL - 1'b1) ? vcnt + 1'b1 : 11'd0;
		else
			vcnt <= vcnt;
    end
end

//---------------------------------------------
//��ͬ??
reg	cmos_vsync_r;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_vsync_r <= 1'b0;			//H: Vaild, L: inVaild
	else begin
		if(vcnt <= V_SYNC - 1'b1)
			cmos_vsync_r <= 1'b0; 	//H: Vaild, L: inVaild
		else
			cmos_vsync_r <= 1'b1; 	//H: Vaild, L: inVaild
    end
end
assign	cmos_vsync	= cmos_vsync_r;

//---------------------------------------------
//����??
wire	frame_valid_ahead =  ( vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP
                            && hcnt >= H_SYNC + H_BACK  && hcnt < H_SYNC + H_BACK + H_DISP ) 
						? 1'b1 : 1'b0;
      
reg			cmos_href_r;      
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_href_r <= 0;
	else begin
		if(frame_valid_ahead)
			cmos_href_r <= 1;
		else
			cmos_href_r <= 0;
    end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cmos_href <= 0;
	else
        cmos_href <= cmos_href_r;
end

assign cmos_clken = cmos_href & cmos_clken_r;

//-------------------------------------
//����������??????��ʽ���������??
wire [10:0] x_pos;
wire [10:0] y_pos;

assign x_pos = frame_valid_ahead ? (hcnt - (H_SYNC + H_BACK )) : 0;
assign y_pos = frame_valid_ahead ? (vcnt - (V_SYNC + V_BACK )) : 0;

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
       cmos_index   <=  0;
       cmos_data    <=  24'd0;
   end
   else begin
       cmos_index   <=  y_pos * 1920  + x_pos*3 + 54;         //  3*(y*640 + x) + 54
       cmos_data    <=  {rBmpData[cmos_index], rBmpData[cmos_index+1] , rBmpData[cmos_index+2]};
   end
end
 
reg [10:0] x_pos_d	[0 : 10];
reg [10:0] y_pos_d	[0 : 10];

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 11; i = i + 1)begin
			x_pos_d[i]	<=	0;
			y_pos_d[i]	<=	0;
		end	
	end
	else begin
		x_pos_d[0]	<=	x_pos;
		y_pos_d[0]	<=	y_pos;
		for(i = 1; i < 11; i = i + 1)begin
			x_pos_d[i]	<=	x_pos_d[i-1];
			y_pos_d[i]	<=	y_pos_d[i-1];
		end	

	end
end


//-------------------------------------
//VIP�㷨������ɫת�Ҷ�

wire 		per_frame_vsync	=	cmos_vsync ;	
wire 		per_frame_href	=	cmos_href;	
wire 		per_frame_clken	=	cmos_clken;	
wire [7:0]	per_img_red		=	cmos_data[ 7: 0];	   	
wire [7:0]	per_img_green	=	cmos_data[15: 8];   	            
wire [7:0]	per_img_blue	=	cmos_data[23:16];   	            


wire 		post0_frame_vsync;   
wire 		post0_frame_href ;   
wire 		post0_frame_clken;    
wire [7:0]	post0_img_Y      ;   
wire [7:0]	post0_img_Cb     ;   
wire [7:0]	post0_img_Cr     ;   



VIP_RGB888_YCbCr444	u_VIP_RGB888_YCbCr444
(
	//global clock
	.clk				(clk),					
	.rst_n				(rst_n),				

	//Image data prepred to be processd
	.per_frame_vsync	(per_frame_vsync    ),		
	.per_frame_href		(per_frame_href     ),		
	.per_frame_clken	(per_frame_clken    ),		
	.per_img_red		(per_img_red        ),			
	.per_img_green		(per_img_green      ),		
	.per_img_blue		(per_img_blue       ),			
	
	//Image data has been processd
	.post_frame_vsync	(post0_frame_vsync	),	
	.post_frame_href	(post0_frame_href 	),		
	.post_frame_clken	(post0_frame_clken	),	
	.post_img_Y			(post0_img_Y 		),			
	.post_img_Cb		(post0_img_Cb		),			
	.post_img_Cr		(post0_img_Cr		)			
);

//gaussian�˲�
wire        		gauss_vsync		  ;
wire        		gauss_hsync		  ;
wire        		gauss_de   		  ;
wire        [7:0]	img_gauss     	  ;

image_gaussian_filter u_image_gaussian_filter
(
	.clk                (clk),
	.rst_n              (rst_n),
    
	.per_frame_vsync    (post0_frame_vsync	),
	.per_frame_href     (post0_frame_href 	),	
	.per_frame_clken    (post0_frame_clken	),
	.per_img_gray       (post0_img_Y 		),	
    
	.post_frame_vsync   (gauss_vsync        ),	
	.post_frame_href    (gauss_hsync        ),	
	.post_frame_clken   (gauss_de           ),		
	.post_img_gray      (img_gauss          )
);

//canny��Ե��??
wire        canny_vsync  ;
wire        canny_hsync  ;
wire        canny_de     ;
wire        img_canny    ;

canny_edge_detect_top u_canny_edge_detect_top(
        .clk                (clk),             
        .rst_n              (rst_n),  
                            
        .per_frame_vsync    (gauss_vsync    ), 
        .per_frame_href     (gauss_hsync    ),  
        .per_frame_clken    (gauss_de       ), 
        .per_img_y          (img_gauss      ),     
                          
        .post_frame_vsync   (canny_vsync    ), 
        .post_frame_href    (canny_hsync    ),  
        .post_frame_clken   (canny_de       ), 
        .post_img_bit       (img_canny      )
);



//-------------------------------------

wire        		PIC1_vip_out_frame_vsync    ;   
wire        		PIC1_vip_out_frame_href     ;   
wire        		PIC1_vip_out_frame_clken    ;    
wire        [7:0]	PIC1_vip_out_img_R          ;   
wire        [7:0]	PIC1_vip_out_img_G          ;   
wire        [7:0]	PIC1_vip_out_img_B          ;  

wire                PIC2_vip_out_frame_vsync    ;
wire                PIC2_vip_out_frame_href     ;
wire                PIC2_vip_out_frame_clken    ;
wire        [7:0]   PIC2_vip_out_img_R          ;
wire        [7:0]   PIC2_vip_out_img_G          ;
wire        [7:0]   PIC2_vip_out_img_B          ;

wire                PIC3_vip_out_frame_vsync    ;
wire                PIC3_vip_out_frame_href     ;
wire                PIC3_vip_out_frame_clken    ;
wire        [7:0]   PIC3_vip_out_img_R          ;
wire        [7:0]   PIC3_vip_out_img_G          ;
wire        [7:0]   PIC3_vip_out_img_B          ;

//??һ�������ͨ��ֵ����Ľ��
assign PIC1_vip_out_frame_vsync 	= 	post0_frame_vsync	;   
assign PIC1_vip_out_frame_href  	= 	post0_frame_href 	;   
assign PIC1_vip_out_frame_clken 	= 	post0_frame_clken	;  
assign PIC1_vip_out_img_R        	= 	post0_img_Y 		;   
assign PIC1_vip_out_img_G        	= 	post0_img_Y		    ;   
assign PIC1_vip_out_img_B        	= 	post0_img_Y		    ; 

assign PIC2_vip_out_frame_vsync		=	gauss_vsync         ; 
assign PIC2_vip_out_frame_href 		=	gauss_hsync         ; 
assign PIC2_vip_out_frame_clken		=	gauss_de            ; 
assign PIC2_vip_out_img_R     		=	img_gauss           ;  
assign PIC2_vip_out_img_G     		=	img_gauss           ;  
assign PIC2_vip_out_img_B     		=	img_gauss           ; 


assign PIC3_vip_out_frame_vsync 	=  	canny_vsync 		;   
assign PIC3_vip_out_frame_href  	=  	canny_hsync 		;   
assign PIC3_vip_out_frame_clken 	=  	canny_de    		; 
assign PIC3_vip_out_img_R 			=  	{8{img_canny}}		;
assign PIC3_vip_out_img_G 			=  	{8{img_canny}}		; 
assign PIC3_vip_out_img_B 			=  	{8{img_canny}}		; 

            


//�Ĵ�ͼ����֮���������??

//-------------------------------------
//??һ��ͼ
reg [31:0]  PIC1_vip_cnt;
reg         PIC1_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ??? 
reg         PIC1_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC1_vip_vsync_r   <=  1'b0;
   else 
        PIC1_vip_vsync_r   <=  PIC1_vip_out_frame_vsync;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC1_vip_out_en    <=  1'b1;
   else if(PIC1_vip_vsync_r & (!PIC1_vip_out_frame_vsync))  //??һ֡����֮��ʹ������
        PIC1_vip_out_en    <=  1'b0;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC1_vip_cnt <=  32'd0;
   end
   else if(PIC1_vip_out_en) begin
        if(PIC1_vip_out_frame_href & PIC1_vip_out_frame_clken) begin
            PIC1_vip_cnt <=  PIC1_vip_cnt + 3;
            vip_pixel_data_1[PIC1_vip_cnt+0] <= PIC1_vip_out_img_R;
            vip_pixel_data_1[PIC1_vip_cnt+1] <= PIC1_vip_out_img_G;
            vip_pixel_data_1[PIC1_vip_cnt+2] <= PIC1_vip_out_img_B;
        end
   end
end





//-------------------------------------
//??����??

reg [31:0]  PIC2_vip_cnt;
reg         PIC2_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ??? 
reg         PIC2_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC2_vip_vsync_r   <=  1'b0;
   else 
        PIC2_vip_vsync_r   <=  PIC2_vip_out_frame_vsync;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC2_vip_out_en    <=  1'b1;
	end
   else if(PIC2_vip_vsync_r & (!PIC2_vip_out_frame_vsync)) begin //??һ֡����֮��ʹ������
        PIC2_vip_out_en    <=  1'b0;
   end
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC2_vip_cnt 		<=  32'd0;
   end
   else if(PIC2_vip_out_en) begin
        if(PIC2_vip_out_frame_href & PIC2_vip_out_frame_clken) begin
            PIC2_vip_cnt <=  PIC2_vip_cnt + 3;
            vip_pixel_data_2[PIC2_vip_cnt+0] <= PIC2_vip_out_img_R;
            vip_pixel_data_2[PIC2_vip_cnt+1] <= PIC2_vip_out_img_G;
            vip_pixel_data_2[PIC2_vip_cnt+2] <= PIC2_vip_out_img_B;
        end
   end
end


//-------------------------------------
//??����??

reg [31:0]  PIC3_vip_cnt;
reg         PIC3_vip_vsync_r;    //�Ĵ�VIP����ĳ�ͬ??? 
reg         PIC3_vip_out_en;     //�Ĵ�VIP����ͼ���ʹ���źţ���ά��һ֡��ʱ��
always@(posedge clk or negedge rst_n)begin
   if(!rst_n) 
        PIC3_vip_vsync_r   <=  1'b0;
   else 
        PIC3_vip_vsync_r   <=  PIC3_vip_out_frame_vsync;
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC3_vip_out_en    	<=  1'b1;
   end
   else if(PIC3_vip_vsync_r & (!PIC3_vip_out_frame_vsync)) begin //??һ֡����֮��ʹ������
        PIC3_vip_out_en     <=  1'b0;
   end
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n) begin
        PIC3_vip_cnt <=  32'd0;
   end
   else if(PIC3_vip_out_en) begin
        if(PIC3_vip_out_frame_href & PIC3_vip_out_frame_clken) begin
            PIC3_vip_cnt <=  PIC3_vip_cnt + 3;
            vip_pixel_data_3[PIC3_vip_cnt+0] <= PIC3_vip_out_img_R;
            vip_pixel_data_3[PIC3_vip_cnt+1] <= PIC3_vip_out_img_G;
            vip_pixel_data_3[PIC3_vip_cnt+2] <= PIC3_vip_out_img_B;
        end
   end
end



endmodule 