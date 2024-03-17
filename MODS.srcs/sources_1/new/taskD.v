`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sean
// 
// Create Date: 11.03.2024 21:49:03
// Design Name: 
// Module Name: taskD
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


module taskD(input clk, clk_6p25m, sw0, sw9, btnC, btnR, btnL, btnU, input [12:0] pixel_index, output reg [15:0] pixel_data);
    // inputs
    wire [7:0] x;
    wire [6:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    wire clk_45, clk_30, clk_15, slow_clk; // m = (clk / (2*fd)) - 1
    flexible_clock_module (.basys_clock(clk), .my_m_value(1_111_110), .my_clk(clk_45));
    flexible_clock_module (.basys_clock(clk), .my_m_value(1_666_666), .my_clk(clk_30));
    flexible_clock_module (.basys_clock(clk), .my_m_value(3_333_332), .my_clk(clk_15));
    
    parameter WHITE = 16'b11111_111111_11111;
    parameter BLUE = 16'b00000_000000_11111;
    parameter BLACK = 16'b00000_000000_00000; // else case
    
    // x and y coordinates: [7:0] for x, [6:0] for y
    parameter [2:0] PIXEL_SIZE = 5;
    parameter [7:0] RIGHT_LIMIT = 95 - PIXEL_SIZE;
    parameter [7:0] LEFT_LIMIT = 0;
    parameter [6:0] UP_LIMIT = 0;
    parameter [7:0] BOTTOM_CENTRE_X = 46; // (max_x_pixel / 2) - 1 ie (95 / 2) - 1 = 47 - 1 = 46
    parameter [6:0] BOTTOM_CENTRE_Y = 57; // max_y_pixel - PIXEL_SIZE - 1 ie 63 - 5 - 1 = 57
    
    // initialization
    reg [7:0] start_x = LEFT_LIMIT;
    reg [7:0] end_x;
    reg [6:0] start_y = 0;
    reg [6:0] end_y;
    reg [7:0] extra_x = 0;
    reg [6:0] extra_y = 0;
    
    // initialize flags
    reg is_initial = 1;
    reg was_btnC_pressed = 0;
    reg was_btnR_pressed = 0;
    reg was_btnL_pressed = 0;
    reg was_btnU_pressed = 0;
    
    reg has_reached_R_limit = 0;
    reg has_reached_L_limit = 0;
    reg has_reached_U_limit = 0;
    
    // how fast extra_x / extra_y changes
    assign slow_clk = sw0 ? (was_btnU_pressed ? clk_15 : clk_30) : clk_45;
    
    always @ (posedge slow_clk) begin
        if (was_btnC_pressed) begin
            extra_x <= 0;
            extra_y <= 0;
        end else if (was_btnR_pressed) begin
            extra_x <= has_reached_R_limit ? extra_x : extra_x + 1;
        end else if (was_btnL_pressed) begin
            extra_x <= has_reached_L_limit ? extra_x : extra_x - 1;
        end else if (was_btnU_pressed) begin
            extra_y <= has_reached_U_limit ? extra_y : extra_y - 1;
        end
    end
    
    // display on oled (main loop)
    always @ (posedge clk_6p25m) begin
        if (sw9 == 0) begin
            // initialization when sw9 switch OFF 
            start_x = LEFT_LIMIT;
            start_y = 0;
            
            // initialize flags
            is_initial = 1;
            was_btnC_pressed = 0;
            was_btnR_pressed = 0;
            was_btnL_pressed = 0;
            was_btnU_pressed = 0;
        
            has_reached_R_limit = 0;
            has_reached_L_limit = 0;
            has_reached_U_limit = 0;
        end
        
        end_x <= start_x + PIXEL_SIZE - 1; // -1 to exclude last pixel
        end_y <= start_y + PIXEL_SIZE - 1; // -1 to exclude last pixel
          
        if (is_initial && (x >= start_x) && (x <= end_x) && (y >= start_y) && (y <= end_y)) begin
                   pixel_data <= BLUE; // initialization
        end else if (~is_initial && (was_btnC_pressed || was_btnR_pressed || was_btnL_pressed || was_btnU_pressed) && 
                (x >= start_x + extra_x) && (x <= end_x + extra_x) &&  
                (y >= start_y + extra_y) && (y <= end_y + extra_y)) begin // {btnC must be pressed for is_initial == 0}
            pixel_data <= WHITE;
        end else begin
            pixel_data <= BLACK; // background
        end
        
        // action for each btn
        if (btnC) begin
            is_initial <= 0;
            was_btnC_pressed <= 1;
            was_btnR_pressed <= 0;
            was_btnL_pressed <= 0;
            was_btnU_pressed <= 0;
            start_x <= BOTTOM_CENTRE_X; // 46; // (95 / 2) - 1 = 47 - 1
            start_y <= BOTTOM_CENTRE_Y; // 57; // 63 - PIXEL_SIZE
        end
        if (btnR) begin
            was_btnC_pressed <= 0;
            was_btnR_pressed <= 1;
            was_btnL_pressed <= 0;
            was_btnU_pressed <= 0;
        end
        if (btnL) begin
            was_btnC_pressed <= 0;
            was_btnR_pressed <= 0;
            was_btnL_pressed <= 1;
            was_btnU_pressed <= 0;
        end
        if (btnU) begin
            was_btnC_pressed <= 0;
            was_btnR_pressed <= 0;
            was_btnL_pressed <= 0; 
            was_btnU_pressed <= 1;
        end
        // reset flag
        has_reached_R_limit <= ((start_x + extra_x) == RIGHT_LIMIT);
        has_reached_L_limit <= ((start_x + extra_x) == LEFT_LIMIT);
        has_reached_U_limit <= ((start_y + extra_y) == UP_LIMIT);
    end

endmodule
