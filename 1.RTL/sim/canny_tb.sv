`timescale 1ns / 1ps
module canny_tb();

// `define Modelsim_Sim
`define Vivado_Sim

//--------------------------------------------------------------------------------
`ifdef Modelsim_Sim
localparam	PIC_INPUT_PATH  	= 	"..\\5.pic\\monkey.bmp"				;
localparam	PIC_OUTPUT_PATH 	= 	"..\\5.pic\\outcom.bmp"  			;
`endif
//--------------------------------------------------------------------------------
`ifdef Vivado_Sim
localparam	PIC_INPUT_PATH  	= 	"../../../../../5.pic/monkey.bmp"	;
localparam	PIC_OUTPUT_PATH 	= 	"../../../../../5.pic/outcom.bmp"	;
`endif

localparam	PIC_WIDTH  			=	640							;
localparam	PIC_HEIGHT 			=	480 						;

reg         cmos_clk   = 0;
reg         cmos_rst_n = 0;

wire        cmos_vsync              ;
wire        cmos_href               ;
wire        cmos_clken              ;
wire [23:0] cmos_data               ;

parameter cmos0_period = 6;

always#(cmos0_period/2) cmos_clk = ~cmos_clk;
initial #(20*cmos0_period) cmos_rst_n = 1;

//--------------------------------------------------
//Camera Simulation
sim_cmos #(
		.PIC_PATH		(PIC_INPUT_PATH			)
	,	.IMG_HDISP 		(PIC_WIDTH 				)
	,	.IMG_VDISP 		(PIC_HEIGHT				)
)u_sim_cmos0(
        .clk            (cmos_clk	    		)
    ,   .rst_n          (cmos_rst_n     		)
	,   .CMOS_VSYNC     (cmos_vsync     		)
	,   .CMOS_HREF      (cmos_href      		)
	,   .CMOS_CLKEN     (cmos_clken     		)
	,   .CMOS_DATA      (cmos_data      		)
	,   .X_POS          ()
	,   .Y_POS          ()
);

//--------------------------------------------------
//Image Processing

wire				post0_vsync			;
wire				post0_href 			;
wire				post0_clken			;
wire		[7:0]	post0_img_Y 		;
wire		[7:0]	post0_img_Cb		;
wire		[7:0]	post0_img_Cr		;

wire        		gauss_vsync		 	;
wire        		gauss_hsync		 	;
wire        		gauss_de   		 	;
wire        [7:0]	img_gauss     	 	;

wire        		canny_vsync  		;
wire        		canny_hsync  		;
wire        		canny_de     		;
wire        		img_canny    		;

//RGB888 to YCbCr444
VIP_RGB888_YCbCr444	u_VIP_RGB888_YCbCr444
(
	 	.clk				(cmos_clk	   		)
	,	.rst_n				(cmos_rst_n    		)

	,	.per_frame_vsync	(cmos_vsync     	)
	,	.per_frame_href		(cmos_href      	)
	,	.per_frame_clken	(cmos_clken     	)
	,	.per_img_red		(cmos_data[16+:8]	)
	,	.per_img_green		(cmos_data[ 8+:8]	)
	,	.per_img_blue		(cmos_data[ 0+:8]	)
	
	,	.post_frame_vsync	(post0_vsync		)
	,	.post_frame_href	(post0_href 		)
	,	.post_frame_clken	(post0_clken		)
	,	.post_img_Y			(post0_img_Y 		)
	,	.post_img_Cb		(post0_img_Cb		)
	,	.post_img_Cr		(post0_img_Cr		)
);

//Gaussian Filter
image_gaussian_filter u_image_gaussian_filter
(
	 	.clk                (cmos_clk	   		)
	,	.rst_n              (cmos_rst_n    		)

	,	.per_frame_vsync    (post0_vsync		)
	,	.per_frame_href     (post0_href 		)
	,	.per_frame_clken    (post0_clken		)
	,	.per_img_gray       (post0_img_Y 		)

	,	.post_frame_vsync   (gauss_vsync        )
	,	.post_frame_href    (gauss_hsync        )
	,	.post_frame_clken   (gauss_de           )
	,	.post_img_gray      (img_gauss          )
);

//Canny Edge Detection
canny_edge_detect_top u_canny_edge_detect_top(
     	.clk                (cmos_clk	   		)
    ,	.rst_n              (cmos_rst_n    		)

    ,	.per_frame_vsync    (gauss_vsync    	)
    ,	.per_frame_href     (gauss_hsync    	)
    ,	.per_frame_clken    (gauss_de       	)
    ,	.per_img_y          (img_gauss      	)

    ,	.post_frame_vsync   (canny_vsync    	)
    ,	.post_frame_href    (canny_hsync    	)
    ,	.post_frame_clken   (canny_de       	)
    ,	.post_img_bit       (img_canny      	)
);


//--------------------------------------------------
//Video saving 
video_to_pic #(
        .PIC_PATH       	(PIC_OUTPUT_PATH	)
    ,   .START_FRAME    	(1              	)
	,	.IMG_HDISP      	(PIC_WIDTH 			)
	,	.IMG_VDISP      	(PIC_HEIGHT			)
)u_video_to_pic0(
        .clk            	(cmos_clk	       	)
    ,   .rst_n          	(cmos_rst_n        	)
    ,   .video_vsync    	(canny_vsync    	)
    ,   .video_hsync    	(canny_hsync    	)
    ,   .video_de       	(canny_de       	)
    ,   .video_data     	({24{img_canny}} 	)
);







endmodule