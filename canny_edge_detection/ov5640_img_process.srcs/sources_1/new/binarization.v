//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           binarization
// Last modified Date:  2020/05/04 9:19:08
// Last Version:        V1.0
// Descriptions:        图像的二值化处理
//                      
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/05/04 9:19:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module binarization(
    //module clock
    input               clk             ,   // 时钟信号
    input               rst_n           ,   // 复位信号（低有效）

    //图像处理前的数据接口
    input               ycbcr_vsync     ,   // vsync信号
    input               ycbcr_hsync     ,   // hsync信号
    input               ycbcr_de        ,   // data enable信号
    input   [7:0]       luminance       ,

    //图像处理后的数据接口
    output              post_vsync      ,   // vsync信号
    output              post_hsync      ,   // hsync信号
    output              post_de         ,   // data enable信号
    output   reg        monoc               // monochrome（1=白，0=黑）
);

//reg define
reg    ycbcr_vsync_d;
reg    ycbcr_hsync_d;
reg    ycbcr_de_d   ;

//*****************************************************
//**                    main code
//*****************************************************

assign  post_vsync = ycbcr_vsync_d  ;
assign  post_hsync = ycbcr_hsync_d  ;
assign  post_de    = ycbcr_de_d     ;

//二值化
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        monoc <= 1'b0;
    else if(luminance > 8'd64)  //阈值
        monoc <= 1'b1;
    else
        monoc <= 1'b0;
end

//延时1拍以同步时钟信号
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ycbcr_vsync_d <= 1'd0;
        ycbcr_hsync_d <= 1'd0;
        ycbcr_de_d    <= 1'd0;
    end
    else begin
        ycbcr_vsync_d <= ycbcr_vsync;
        ycbcr_hsync_d <= ycbcr_hsync;
        ycbcr_de_d    <= ycbcr_de   ;
    end
end

endmodule 