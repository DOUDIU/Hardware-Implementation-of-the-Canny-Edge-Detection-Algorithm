module canny_doubleThreshold#(
    parameter DATA_WIDTH = 2,
    parameter DATA_DEPTH = 640
)(
	input			                    clk                 ,
	input			                    rst_s               ,
    
	input			                    pre_frame_vsync     ,
	input			                    pre_frame_href      ,
	input			                    pre_frame_clken     ,
	input      [DATA_WIDTH - 1 : 0]     max_g               ,
    
	output		                        post_frame_vsync    ,
	output		                        post_frame_href     ,
	output		                        post_frame_clken    ,
	output      reg                     canny_out           
);

wire    [DATA_WIDTH - 1 : 0]   mag1_1;
wire    [DATA_WIDTH - 1 : 0]   mag1_2;
wire    [DATA_WIDTH - 1 : 0]   mag1_3;
wire    [DATA_WIDTH - 1 : 0]   mag2_1;
wire    [DATA_WIDTH - 1 : 0]   mag2_2;
wire    [DATA_WIDTH - 1 : 0]   mag2_3;
wire    [DATA_WIDTH - 1 : 0]   mag3_1;
wire    [DATA_WIDTH - 1 : 0]   mag3_2;
wire    [DATA_WIDTH - 1 : 0]   mag3_3;
    
wire        doubleThreshold_vsync   ;
wire        doubleThreshold_href    ;
wire        doubleThreshold_clken   ;    
wire        high_low                ;
wire        search                  ;


//双阈值，8连通域连接像素
matrix_generate_3x3 #(
	.DATA_WIDTH         (DATA_WIDTH             ),
	.DATA_DEPTH         (DATA_DEPTH             )
)u_matrix_generate_3x3(     
    .clk                (clk                    ), 
    .rst_n              (rst_s                  ),

    //处理前图像数据        
    .per_frame_vsync    (pre_frame_vsync        ),
    .per_frame_href     (pre_frame_href         ), 
    .per_frame_clken    (pre_frame_clken        ),
    .per_img_y          (max_g                  ),
    
    //处理后的图像数据
    .matrix_frame_vsync (doubleThreshold_vsync  ),
    .matrix_frame_href  (doubleThreshold_href   ),
    .matrix_frame_clken (doubleThreshold_clken  ),
    .matrix_p11         (mag1_1                 ),    
    .matrix_p12         (mag1_2                 ),    
    .matrix_p13         (mag1_3                 ),
    .matrix_p21         (mag2_1                 ),    
    .matrix_p22         (mag2_2                 ),    
    .matrix_p23         (mag2_3                 ),
    .matrix_p31         (mag3_1                 ),    
    .matrix_p32         (mag3_2                 ),    
    .matrix_p33         (mag3_3                 )
);

assign search = mag1_1[1] | mag1_2[1] | mag1_3[1] | mag2_1[1] | mag2_2[1] | mag2_3[1] 
| mag3_1[1] | mag3_2[1] | mag3_3[1];//搜寻目标像素周边是否包含梯度值大于高阈值的点，当然自身是高于的话，那么肯定为1  
assign high_low = mag2_2[1] | mag2_2[0];//排除小于低阈值的点

//对 hs vs de 进行适当的延迟，匹配时钟
reg         doubleThreshold_vsync_d1    ;
reg         doubleThreshold_href_d1     ;
reg         doubleThreshold_clken_d1    ;

always@(posedge clk or negedge rst_s) begin
    if (!rst_s) begin
        doubleThreshold_vsync_d1         <= 0 ;
        doubleThreshold_href_d1          <= 0 ;
        doubleThreshold_clken_d1         <= 0 ;
    end
    else begin
        doubleThreshold_vsync_d1         <= doubleThreshold_vsync   ;
        doubleThreshold_href_d1          <= doubleThreshold_href    ;
        doubleThreshold_clken_d1         <= doubleThreshold_clken   ;
    end
end

always @ (posedge clk or negedge rst_s) begin
    if(!rst_s)
        canny_out <= 1'b0;
    else if(high_low)
        canny_out <= (search) ? 1'b1 : 1'b0;
    else
        canny_out <= 1'b0;
end

assign post_frame_vsync = doubleThreshold_vsync_d1 ;
assign post_frame_href  = doubleThreshold_href_d1  ;
assign post_frame_clken = doubleThreshold_clken_d1 ;

    
endmodule
