`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Mohamed Abubaker Mustafa Abdelaal Elsayed

module taskA(input basys_clock, clk_25MHz, input [12:0] pixel_index, input btnC, btnD, sw0, output reg [15:0] oled_data);
    parameter BLACK = 16'b00000_000000_00000; // else case
    parameter RED = 16'b11111_000000_00000;
    parameter ORANGE = 16'b11111_011000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    
    wire clk_1000;
    flexible_clock_module flexible_clock_1000 (basys_clock, 49999, clk_1000);
    
    reg [31:0] x, y;
    reg btnC_pressed = 0, btnD_pressed = 0, btnD_previous = 0;
    reg [1:0] center = 0;
    reg [31:0] count = 0, half_sec_count = 0, btnD_count = 0;
    
    wire debounced_btnD;
    debounce(clk_1000, btnD, debounced_btnD);
    
    always @ (posedge clk_25MHz)
    begin
        x = pixel_index / 96;
        y = pixel_index % 96;
        
        if (!sw0) begin
            btnC_pressed = 0;
            btnD_pressed = 0;
            half_sec_count = 0;
            btnD_count = 0;
            count = 0;
            center = 0;
        end
        if (btnC) begin
            btnC_pressed = 1;
        end 
        
        half_sec_count <= (count == 12500000) ? ((half_sec_count == 11) ? 0 : half_sec_count + 1) : half_sec_count;
        
        count <= (count == 12500001) ? 0 : ((btnC_pressed) ? count + 1: count);
        //line_count <= (count == 0) ? ((line_count == 6142) ? 0 : line_count + 1) : line_count;
       
        btnD_count = (btnD_count == 6250000) ? 0 : ((btnD_pressed) ? btnD_count + 1 : 0); 
        center <= (btnD_count == 0 && btnD_pressed) ? ((center == 3 || center == 0) ? 1 : center + 1) : center;
        
       
        if ((x == 2 || x == 61 || y == 2 || y == 93) && !(x < 2 || x > 61 || y < 2 || y > 93)) begin
            oled_data <= RED;
        end
        else if (btnC_pressed && ((x >= 5 && x <= 7) || (y >= 5 && y <= 7) || (x <= 58 && x >= 56) || (y <= 90 && y >= 88)) && !(x < 5 || x > 58 || y < 5 || y > 90)) begin
            oled_data <= ORANGE;
        end
        else if (half_sec_count >= 4 && (x == 10 || x == 53 || y == 10 || y == 85) && !(x < 10 || x > 53 || y < 10 || y > 85)) begin
            oled_data <= GREEN; 
        end
        else if (half_sec_count >= 7 && ((x >= 13 && x <= 14) || (y >= 13 && y <= 14) || (x <= 50 && x >= 49) || (y <= 82 && y >= 81)) && !(x < 13 || x > 50 || y < 13 || y > 82)) begin
            oled_data <= GREEN;
        end
        else if (center == 1 && x >= 27 && x <= 36 && y >= 43 && y <= 52) begin
            oled_data <= RED;
        end
        else if (center == 2 && ((x - 32) ** 2 + (y - 48) ** 2) < 144) begin
            oled_data <= ORANGE;
        end
        else if (center == 3 && x >= 26 && x <= 37 && (y <= (48 + x - 26)) && (y >= (48 - x + 26))) begin
            oled_data <= GREEN;
        end 
        else begin
            oled_data <= BLACK;
        end
        
        if (!debounced_btnD && btnD_previous && btnC_pressed) begin
            btnD_pressed <= 1;
            center <= 0;
        end
        
        btnD_previous <= debounced_btnD;
    end
endmodule