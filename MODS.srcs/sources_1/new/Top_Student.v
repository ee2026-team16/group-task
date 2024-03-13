`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Mohamed
//  STUDENT B NAME: Joshua
//  STUDENT C NAME: Jun Yong
//  STUDENT D NAME: Sean
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input btnC, btnU, btnL, btnR, btnD,
    output [7:0] JC,
    inout PS2Clk, PS2Data
);
    //  clocks
    wire clk_25m, clk_12p5m, clk_6p25m, clk_1;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_12p5m (
        .basys_clock(clk),
        .my_m_value(3),
        .my_clk(clk_12p5m)
    );
    flexible_clock_module flexible_clock_module_6p25m (
        .basys_clock(clk),
        .my_m_value(7),
        .my_clk(clk_6p25m)
    );
    flexible_clock_module flexible_clock_module_1 (
        .basys_clock(clk),
        .my_m_value(49999999),
        .my_clk(clk_1)
    );
    
    // ---------- oled ----------
    // constants
    reg [15:0] white = 16'b11111_111111_11111;
    
    //  inputs
    reg reset = 0;
    reg [15:0] pixel_data;
    
    //  outputs
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    
    //  initialize
    Oled_Display(
        .clk(clk_6p25m), 
        .reset(reset), 
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(pixel_data),
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    // ---------- mouse ----------
    //  inputs
    reg rst = 0;
    reg [11:0] value = 12'b0;
    reg setx, sety, setmax_x, setmax_y = 0;
    
    //  outputs
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right;
    wire new_event;
        
    //  initialize
    MouseCtl(
        .clk(clk),
        .rst(rst),
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
    
//    assign led[15] = left;
//    assign led[14] = middle;
//    assign led[13] = right;
    
    // ---------- paint ----------
    //  inputs
    reg enable = 0; // disable = 0
    
    //  outputs
    wire [15:0] colour_chooser;
    
    //  initialize
    paint(
        .mouse_x(xpos),
        .mouse_y(ypos),
        .mouse_l(left),
        .reset(right),
        .pixel_index(pixel_index),
        .enable(enable),
        .clk_100M(clk),
        .clk_25M(clk_25m),
        .clk_12p5M(clk_12p5m),
        .clk_6p25M(clk_6p25m),
        .slow_clk(clk_1),
//        .seg(seg),
//        .led(led),
        .colour_chooser(colour_chooser)
    );
    
//    always @ (posedge clk_25m)
//    begin
//        pixel_data <= colour_chooser;
//    end

    // ---------- tasks ----------
    
    wire [15:0] task_a_pixel_data;
    taskA taskA(clk_25m, pixel_index, btnC, btnD, sw[0], task_a_pixel_data);
    wire [15:0] task_b_pixel_data;
    taskB taskB(clk, sw[0], sw[11], btnR, btnL, btnC, pixel_index, task_b_pixel_data);
    wire [15:0] task_c_pixel_data;                                                                        
    taskC taskC(btnD, clk, pixel_index, task_c_pixel_data);
    wire [15:0] task_d_pixel_data;
    taskD taskD(clk_6p25m, btnC, pixel_index, task_d_pixel_data);
    
    wire taskEActive = 0;
    taskE taskE(taskEActive, clk, seg, dp, an);
    
    // ---------- state machine ----------
    reg [31:0] state = 32'b0;
    reg [15:0] led_out = 16'b0;
    always @ (posedge clk)
    begin
        if (sw[12] == 1 &&
            sw[11] == 0 &&
            sw[10] == 0 &&
            sw[9] == 0 &&
            sw[8] == 0)
            begin
                state <= 32'h4A;
            end
        else if (sw[12] == 0 &&
                sw[11] == 1 &&
                sw[10] == 0 &&
                sw[9] == 0 &&
                sw[8] == 0)
            begin
                state <= 32'h4B;
            end
        else if (sw[12] == 0 &&
                sw[11] == 0 &&
                sw[10] == 1 &&
                sw[9] == 0 &&
                sw[8] == 0)
            begin
                state <= 32'h4C;
            end
        else if (sw[12] == 0 &&
                sw[11] == 0 &&
                sw[10] == 0 &&
                sw[9] == 1 &&
                sw[8] == 0)
            begin
                state <= 32'h4D;
            end
        else if (sw[12] == 0 &&
                sw[11] == 0 &&
                sw[10] == 0 &&
                sw[9] == 0 &&
                sw[8] == 1)
            begin
                state <= 32'h4E;
            end
        else
            begin
                state <= 32'h0;
            end
            
        case (state)
            32'h4A: 
                begin
                    pixel_data <= task_a_pixel_data;
                    led_out[0] <= 1;
                end
            32'h4B:
                begin
                    pixel_data <= task_b_pixel_data;
                    led_out[1] <= 1;
                end
            32'h4C:
                begin
                    pixel_data <= task_c_pixel_data;
                    led_out[2] <= 1;
                end
            32'h4D:
                begin
                    pixel_data <= task_d_pixel_data;
                    led_out[3] <= 1;
                end
            default: 
                begin
                    pixel_data <= white;
                    led_out <= 16'b0000_0000_0000_0000;
                end
        endcase
    end
    assign led = led_out;
    assign taskEActive = state == 32'h4E;
    
endmodule