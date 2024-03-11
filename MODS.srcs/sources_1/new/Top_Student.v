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
    input btnC, // task D
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an,
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
    
    // ---------- state machine ----------
//    reg [31:0] state = 32'b0;
    
//    always @ (posedge clk)
//    begin
//        if (sw[4] == 0)
//            begin
//                state <= 31'h3A81;
//            end
//        else if (sw[4] == 1)
//            begin
//                state <= 31'h3A82;
//            end
            
//        case (state)
//            31'h3A81: oled_data <= task_3A81_oled_data;
//            31'h3A82: oled_data <= task_3A82_oled_data;
//            default: oled_data <= white;
//        endcase
//    end
    
    // ---------- oled ----------
    // constants
    reg [15:0] black = 16'b0;
    reg [15:0] white = 16'b11111_111111_11111;
    reg [15:0] green = 16'h07E0;
    reg [15:0] red = 16'b11111_000000_00000;
    
    //  inputs
    reg reset = 0;
    wire [15:0] pixel_data; // conflict w line 195
    
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
    
//    reg [31:0] x, y;
//    always @ (posedge clk_25m)
//    begin
//        x = pixel_index % 96;
//        y = pixel_index / 96;
        
//        if (x >= 0 && x <= 96 && y >= 0 && y <= 64)
//            begin
//                if (sw[4] == 0)
//                    begin
//                        pixel_data <= red;
//                    end
//                else if (sw[4] == 1)
//                    begin
//                        pixel_data <= green;
//                    end
//            end
//        else
//            begin
//                pixel_data <= white;
//            end
//    end
    
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
        .seg(seg),
        .colour_chooser(colour_chooser),
        .led(led)
    );
    
//    always @ (posedge clk_25m)
//    begin
//        pixel_data <= colour_chooser;
//    end
    
    // ---------- 4.D ----------
    // inputs
//    wire [15:0] pixel_data; // conflict w line 77
    taskD unit4(.clk_6p25m(clk_6p25m), .pixel_data(pixel_data), .pixel_index(pixel_index), .btnC(btnC)); 
    
    //  ---------- 4.B ----------
//    reg[2:0] sw0_counter = 3'b000;
    
//    always @ (posedge clk_1)
//    begin
//        if (sw[0] == 1)
//            begin
//                if (sw0_counter < 3'b100)
//                    begin
//                        sw0_counter <= sw0_counter + 1;
//                    end
//            end
//        else
//        begin
//            sw0_counter = 0;
//        end
//    end
    
//    reg [3:0] box_length = 6;
////    reg [3:0] box_separation = 11;
//    function is_box;
//        input [7:0] box_center_x;
//        input [7:0] box_center_y;
//        input [7:0] curr_x;
//        input [7:0] curr_y;
//        begin
//            if ((curr_y > box_center_y - box_length / 2) &&
//                (curr_y <= box_center_y + box_length / 2) &&
//                (curr_x > box_center_x - box_length / 2) &&
//                (curr_x <= box_center_x + box_length / 2))
//                is_box = 1;
//            else
//                is_box = 0;
//        end
//    endfunction
    
//    reg [3:0] border_thickness = 3;
//    reg [3:0] border_distance = 2;
//    function is_border;
//        input [7:0] border_center_x;
//        input [7:0] border_center_y;
//        input [7:0] curr_x;
//        input [7:0] curr_y;
//        reg [7:0] outer_min_x, outer_max_x, outer_min_y, outer_max_y;
//        reg [7:0] inner_min_x, inner_max_x, inner_min_y, inner_max_y;
//        begin
//            outer_min_x = border_center_x - box_length / 2 - border_distance - border_thickness;
//            outer_max_x = border_center_x + box_length / 2 + border_distance + border_thickness;
//            outer_min_y = border_center_y - box_length / 2 - border_distance - border_thickness;
//            outer_max_y = border_center_y + box_length / 2 + border_distance + border_thickness;
            
//            inner_min_x = border_center_x - box_length / 2 - border_distance;
//            inner_max_x = border_center_x + box_length / 2 + border_distance;
//            inner_min_y = border_center_y - box_length / 2 - border_distance;
//            inner_max_y = border_center_y + box_length / 2 + border_distance;
            
//            if (curr_y > outer_min_y && curr_y <= inner_min_y)
//                begin
//                    if (curr_x > outer_min_x && curr_x <= outer_max_x)
//                        is_border = 1;
//                    else
//                        is_border = 0;
//                end
//            else if (curr_y > inner_min_y && curr_y <= inner_max_y)
//                begin
//                    if (curr_x > outer_min_x && curr_x <= inner_min_x)
//                        is_border = 1;
//                    else if (curr_x > inner_max_x && curr_x <= outer_max_x)
//                        is_border = 1;
//                    else
//                        is_border = 0;
//                end
//            else if (curr_y > inner_max_y && curr_y <= outer_max_y)
//                begin
//                    if (curr_x > outer_min_x && curr_x <= outer_max_x)
//                        is_border = 1;
//                    else
//                        is_border = 0;
//                end
//            else
//                is_border = 0;
//        end
//    endfunction
    
//    reg [31:0] x, y;
//    reg [31:0] border_center_x, border_center_y;
//    always @ (posedge clk_25m)
//    begin
//        x = pixel_index % 96;
//        y = pixel_index / 96;
        
//        if (sw0_counter == 3'b100)
//            begin
//                border_center_x = 70;
//                border_center_y = 32;
                
//                if (is_border(border_center_x, border_center_y, x, y))
//                    begin
//                        pixel_data <= green;
//                    end
//                else if (is_box(14, 32, x, y) ||
//                        is_box(28, 32, x, y) ||
//                        is_box(42, 32, x, y) ||
//                        is_box(56, 32, x, y) ||
//                        is_box(70, 32, x, y))
//                    begin
//                        pixel_data <= white;
//                    end
//                else
//                    begin
//                        pixel_data <= black;
//                    end
//            end
//        else
//            begin
//                border_center_x = 48;
//                border_center_y = 32;
                
//                if (is_border(border_center_x, border_center_y, x, y))
//                    begin
//                        pixel_data <= green;
//                    end
//                else
//                    begin
//                        pixel_data <= black;
//                    end
//            end
//    end
    
endmodule