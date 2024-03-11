`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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


module taskD(input clk_6p25m, btnC, input [12:0] pixel_index, output reg [15:0] pixel_data);
    parameter WHITE = 16'b11111_111111_11111;
    parameter BLUE = 16'b00000_000000_11111;
    parameter BLACK = 16'b00000_000000_00000; // else case
   
    parameter [2:0] PIXEL_SIZE = 5;
    reg [7:0] start_x, end_x;
    reg [6:0] start_y, end_y;
     
    wire [7:0] x;
    wire [6:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    always @ (posedge clk_6p25m) begin
        start_x = btnC ? 46 : 1;
        end_x = start_x + PIXEL_SIZE - 1; // -1 to exclude last pixel
        start_y = btnC ? 57 : 1;
        end_y = start_y + PIXEL_SIZE - 1; // -1 to exclude last pixel
        
        if ((btnC) && (x >= start_x) && (x <= end_x) && (y >= start_y) && (y <= end_y)) begin
            pixel_data <= WHITE;
        end else if ((~btnC) && (x >= start_x) && (x <= end_x) && (y >= start_y) && (y <= end_y)) begin
            pixel_data <= BLUE;
        end else begin
            pixel_data <= BLACK;
        end
    end
    
endmodule
