module canny_nonLocalMaxValue#(
    parameter DATA_WIDTH = 16,
    parameter DATA_DEPTH = 640
)(
	input			                    clk,
	input			                    rst_s,

	input			                    grandient_vs,
	input			                    grandient_hs,
	input			                    grandient_de,
	input       [DATA_WIDTH - 1 : 0]    gra_path,
	
	output		                        post_frame_vsync,
	output		                        post_frame_href ,
	output		                        post_frame_clken,
	output  reg [1 : 0]	                max_g
);

// 9x9���󣬷Ǽ���ֵ������
wire [DATA_WIDTH - 1 : 0]   max1_1                  ;
wire [DATA_WIDTH - 1 : 0]   max1_2                  ;
wire [DATA_WIDTH - 1 : 0]   max1_3                  ;
wire [DATA_WIDTH - 1 : 0]   max2_1                  ;
wire [DATA_WIDTH - 1 : 0]   max2_2                  ;
wire [DATA_WIDTH - 1 : 0]   max2_3                  ;
wire [DATA_WIDTH - 1 : 0]   max3_1                  ;
wire [DATA_WIDTH - 1 : 0]   max3_2                  ;
wire [DATA_WIDTH - 1 : 0]   max3_3                  ;

wire [3 : 0]                path_se                 ;

wire                        nonLocalMaxValue_vsync  ;
wire                        nonLocalMaxValue_href   ;
wire                        nonLocalMaxValue_clken  ;

matrix_generate_3x3 #(
	.DATA_WIDTH         (DATA_WIDTH             ),
	.DATA_DEPTH         (DATA_DEPTH             )
)u_matrix_generate_3x3(
    .clk                (clk                    ), 
    .rst_n              (rst_s                  ),
    
    //����ǰͼ������
    .per_frame_vsync    (grandient_vs           ),
    .per_frame_href     (grandient_hs           ), 
    .per_frame_clken    (grandient_de           ),
    .per_img_y          (gra_path               ),
    
    //������ͼ������
    .matrix_frame_vsync (nonLocalMaxValue_vsync ),
    .matrix_frame_href  (nonLocalMaxValue_href  ),
    .matrix_frame_clken (nonLocalMaxValue_clken ),
    .matrix_p11         (max1_1                 ),    
    .matrix_p12         (max1_2                 ),    
    .matrix_p13         (max1_3                 ),
    .matrix_p21         (max2_1                 ),    
    .matrix_p22         (max2_2                 ),    
    .matrix_p23         (max2_3                 ),
    .matrix_p31         (max3_1                 ),    
    .matrix_p32         (max3_2                 ),    
    .matrix_p33         (max3_3                 )
);

//�ڼ���һ�����ص��ݶȺͷ���󣬿�ʼ�Ǽ���ֵ����
//���зǼ���ֵ����
assign path_se = max2_2[13:10];//����Ŀ�����ص��ݶȷ�����з���
//һ����ˮ
always @ (posedge clk or negedge rst_s)
begin
	if(!rst_s)
	   max_g <= 2'd0;
	else
        case (path_se)
            4'b0001:   
                max_g <=((max2_2[9:0]> max2_1[9:0])&(max2_2[9:0]> max2_3[9:0]))?{max2_2[15:14]} :   2'd0;
            4'b0010:        
                max_g <=((max2_2[9:0]> max1_3[9:0])&(max2_2[9:0]> max3_1[9:0]))?{max2_2[15:14]} :   2'd0;
            4'b0100: 	        
                max_g <=((max2_2[9:0]> max1_2[9:0])&(max2_2[9:0]> max3_2[9:0]))?{max2_2[15:14]} :   2'd0;
            4'b1000:			        
                max_g <=((max2_2[9:0]> max1_1[9:0])&(max2_2[9:0]> max3_3[9:0]))?{max2_2[15:14]} :   2'd0;
            default:
                max_g <= 2'd0;
        endcase
end

//�� hs vs de �����ʵ����ӳ٣�ƥ��ʱ��
reg     nonLocalMaxValue_vsync_d1   ;
reg     nonLocalMaxValue_href_d1    ;
reg     nonLocalMaxValue_clken_d1   ;

always@(posedge clk or negedge rst_s)
begin
    if (!rst_s)begin
        nonLocalMaxValue_vsync_d1       <=  0 ;
        nonLocalMaxValue_href_d1        <=  0 ;
        nonLocalMaxValue_clken_d1       <=  0 ;
    end
    else begin
        nonLocalMaxValue_vsync_d1       <=  nonLocalMaxValue_vsync  ;
        nonLocalMaxValue_href_d1        <=  nonLocalMaxValue_href   ;
        nonLocalMaxValue_clken_d1       <=  nonLocalMaxValue_clken  ;
    end
end

assign post_frame_vsync =   nonLocalMaxValue_vsync_d1 ;
assign post_frame_href  =   nonLocalMaxValue_href_d1  ;
assign post_frame_clken =   nonLocalMaxValue_clken_d1 ;

endmodule
