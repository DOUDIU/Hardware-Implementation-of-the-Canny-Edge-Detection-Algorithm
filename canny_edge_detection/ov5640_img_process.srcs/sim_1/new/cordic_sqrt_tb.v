`timescale 1ns / 1ps
module cordic_sqrt_tb();

reg clk;
reg rst_n;

wire    [10 : 0]    out;

initial begin
    clk     =   0;
    rst_n   =   0;
    #2
    rst_n   =   1;
end

always#1 begin
    clk = !clk;
end




cordic_sqrt u_cordic_sqrt(
    .clk            (clk),
    .rst_n          (rst_n),
    .sqrt_in_0      (21'd40),
    .sqrt_in_1      (21'd40),

    .sqrt_out       (out)
);



endmodule
