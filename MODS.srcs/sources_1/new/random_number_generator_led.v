`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 20:10:04
// Design Name: 
// Module Name: random_number_generator
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


module random_number_generator(input basys_clock, input [15:0] prev_number, output reg [15:0] new_number);

    always @ (posedge basys_clock)
    begin
        new_number[15:0] <= {(prev_number[5]^prev_number[3]^prev_number[2]^prev_number[0]),prev_number[12:1],prev_number[15:13]};     
    end
    
endmodule
