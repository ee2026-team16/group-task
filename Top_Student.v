`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input basys_clock, output [7:0] JC, output led13, led14, led15, inout PS2Clk, PS2Data);
    
    wire clk625MHz, clk_25MHz, clk_100MHz;
    reg [15:0] oled_data = 16'b00000_111111_00000;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index; 
    
    flexible_clock clock1(basys_clock, 7, clk625MHz);
    flexible_clock clock2(basys_clock, 1, clk_25MHz);
    
    Oled_Display(.clk(clk625MHz), 
    .reset(0), 
    .frame_begin(frame_begin), 
    .sending_pixels(sending_pixels),
    .sample_pixel(sample_pixel), 
    .pixel_index(pixel_index), 
    .pixel_data(oled_data), 
    .cs(JC[0]), 
    .sdin(JC[1]), 
    .sclk(JC[3]), 
    .d_cn(JC[4]), 
    .resn(JC[5]), 
    .vccen(JC[6]),
    .pmoden(JC[7]));
    
    reg [11:0] value;
    reg setx = 0, sety = 0, setmax_x = 0, setmax_y = 0;
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    assign led13 = right, led14 = middle, led15 = left;
    
    MouseCtl(.clk(basys_clock),
    .rst(0),
    .value(value),
    .setx(setx),
    .sety(sety),
    .setmax_x(setmax_x),
    .setmax_y(setmax_y),
    .xpos(xpos),
    .ypos(ypos),
    .zpos(zpos),
    .left(left),
    .middle(middle),
    .right(right),
    .new_event(new_event),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data)
    );
    
    reg [31:0] x, y;
    
    always @ (posedge clk_25MHz)
    begin
        x = pixel_index / 96;
        y = pixel_index % 96;
        if (x >= 30 && x <= 40 && y >= 10 && y <= 50) begin
            oled_data <= 16'b10101_000000_11001;
        end
        else begin
            oled_data <= 16'b11111_111111_11111;
        end
    end
    
endmodule