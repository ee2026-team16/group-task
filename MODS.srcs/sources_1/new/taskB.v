`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2024 08:55:56
// Design Name: 
// Module Name: basic_task_b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module taskB(
    input clk,
    input sw0,
    input btnR, btnL,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data
);
    reg [15:0] black = 16'b0;
    reg [15:0] white = 16'b11111_111111_11111;
    reg [15:0] green = 16'h07E0;
    
    wire clk_25m, clk_1000, clk_1;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_1000 (
        .basys_clock(clk),
        .my_m_value(49999),
        .my_clk(clk_1000)
    );
    flexible_clock_module flexible_clock_module_1 (
        .basys_clock(clk),
        .my_m_value(49999999),
        .my_clk(clk_1)
    );
    
    reg [3:0] box_length = 6;
//    reg [3:0] box_separation = 11;
    function is_box;
        input [7:0] box_center_x;
        input [7:0] box_center_y;
        input [7:0] curr_x;
        input [7:0] curr_y;
        begin
            if ((curr_y > box_center_y - box_length / 2) &&
                (curr_y <= box_center_y + box_length / 2) &&
                (curr_x > box_center_x - box_length / 2) &&
                (curr_x <= box_center_x + box_length / 2))
                is_box = 1;
            else
                is_box = 0;
        end
    endfunction
    
    reg [3:0] border_thickness = 3;
    reg [3:0] border_distance = 2;
    function is_border;
        input [7:0] border_center_x;
        input [7:0] border_center_y;
        input [7:0] curr_x;
        input [7:0] curr_y;
        reg [7:0] outer_min_x, outer_max_x, outer_min_y, outer_max_y;
        reg [7:0] inner_min_x, inner_max_x, inner_min_y, inner_max_y;
        begin
            outer_min_x = border_center_x - box_length / 2 - border_distance - border_thickness;
            outer_max_x = border_center_x + box_length / 2 + border_distance + border_thickness;
            outer_min_y = border_center_y - box_length / 2 - border_distance - border_thickness;
            outer_max_y = border_center_y + box_length / 2 + border_distance + border_thickness;
            
            inner_min_x = border_center_x - box_length / 2 - border_distance;
            inner_max_x = border_center_x + box_length / 2 + border_distance;
            inner_min_y = border_center_y - box_length / 2 - border_distance;
            inner_max_y = border_center_y + box_length / 2 + border_distance;
            
            if (curr_y > outer_min_y && curr_y <= inner_min_y)
                begin
                    if (curr_x > outer_min_x && curr_x <= outer_max_x)
                        is_border = 1;
                    else
                        is_border = 0;
                end
            else if (curr_y > inner_min_y && curr_y <= inner_max_y)
                begin
                    if (curr_x > outer_min_x && curr_x <= inner_min_x)
                        is_border = 1;
                    else if (curr_x > inner_max_x && curr_x <= outer_max_x)
                        is_border = 1;
                    else
                        is_border = 0;
                end
            else if (curr_y > inner_max_y && curr_y <= outer_max_y)
                begin
                    if (curr_x > outer_min_x && curr_x <= outer_max_x)
                        is_border = 1;
                    else
                        is_border = 0;
                end
            else
                is_border = 0;
        end
    endfunction
    
    reg[2:0] sw0_counter = 3'b000;
    always @ (posedge clk_1)
    begin
        if (sw0 == 1)
            begin
                if (sw0_counter < 3'b100)
                    begin
                        sw0_counter <= sw0_counter + 1;
                    end
            end
        else
        begin
            sw0_counter = 0;
        end
    end
    
    wire debounced_btnR;
    debounce(clk_1000, btnR, debounced_btnR);
    wire debounced_btnL;
    debounce(clk_1000, btnL, debounced_btnL);
    reg [3:0] border_state = 3'b101;
    always @ (posedge clk_1000)
    begin
        if (debounced_btnR == 1 && border_state < 5)
            border_state <= border_state + 1;
        else if (debounced_btnL == 1 && border_state > 1)
            border_state <= border_state - 1;
    end
    
    reg [31:0] x, y;
    reg [31:0] border_center_x, border_center_y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;
        
        if (sw0_counter == 3'b100)
            begin
                case (border_state)
                    1:
                        begin
                            border_center_x = 14;
                            border_center_y = 32;
                        end
                    2:
                        begin
                            border_center_x = 28;
                            border_center_y = 32;
                        end
                    3:
                        begin
                            border_center_x = 42;
                            border_center_y = 32;
                        end
                    4:
                        begin
                            border_center_x = 56;
                            border_center_y = 32;
                        end
                    5:
                        begin
                            border_center_x = 70;
                            border_center_y = 32;
                        end
                    default:
                        begin
                            border_center_x = 70;
                            border_center_y = 32;
                        end
                endcase
                
                if (is_border(border_center_x, border_center_y, x, y))
                    begin
                        pixel_data <= green;
                    end
                else if (is_box(14, 32, x, y) ||
                        is_box(28, 32, x, y) ||
                        is_box(42, 32, x, y) ||
                        is_box(56, 32, x, y) ||
                        is_box(70, 32, x, y))
                    begin
                        pixel_data <= white;
                    end
                else
                    begin
                        pixel_data <= black;
                    end
            end
        else
            begin
                border_center_x = 48;
                border_center_y = 32;
                
                if (is_border(border_center_x, border_center_y, x, y))
                    begin
                        pixel_data <= green;
                    end
                else
                    begin
                        pixel_data <= black;
                    end
            end
    end
endmodule