module key_stable(
        input               clk_sys,
        input               reset_n,
        input               key_in,
        output              key_out
    );
    reg         [2:0]key_flag    =   3'b111;
    reg         key_in_past;
    reg         [18:0]count;
    assign  key_out = (key_flag <  3'd7)? key_out:key_in;
    
    always@(posedge clk_sys or negedge reset_n)
    if(!reset_n)
        count       <=  19'd1;
    else if(count < 19'd500)
        count   <=   count   +  1'b1;
    else
        count   <= 19'd1;
        
    always@(posedge clk_sys or negedge reset_n)
    if(!reset_n)
        key_in_past <=  key_in;
    else if(count < 19'd500)
        key_in_past   <=    key_in_past;
    else
        key_in_past   <=    key_in;     
    
    always@(posedge clk_sys or negedge reset_n)
        if(!reset_n)
            key_flag    <=  3'b000;
        else if(count == 19'd500)
            key_flag    <=  key_flag   +   1'b1;
        else if(key_in_past != key_in)
            key_flag    <=   3'b000;
        else
            key_flag    <=  key_flag;
            
endmodule
