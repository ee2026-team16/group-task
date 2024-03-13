`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:11:58
// Design Name: 
// Module Name: flexible_clock_module
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


module flexible_clock_module(input basys_clock, input [31:0] my_m_value, output reg my_clk = 0);
    reg [31:0] count = 0;
    
    always @ (posedge basys_clock)
    begin
        count <= (count == my_m_value) ? 0 : count + 1;
        my_clk <= (count == 0) ? ~my_clk: my_clk;
    end
endmodule
