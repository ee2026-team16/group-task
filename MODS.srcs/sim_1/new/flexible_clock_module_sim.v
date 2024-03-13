`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:27:06
// Design Name: 
// Module Name: flexible_clock_module_sim
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


module flexible_clock_module_sim();
    // input
    reg basys_clock;
    reg [31:0] my_m_value;
    
    // output
    wire my_clk;
    
    flexible_clock_module dut(basys_clock, my_m_value, my_clk);
    
    initial
    begin        
        my_m_value = 32'b111;
        basys_clock = 0;
    end
    
    always
    begin
        basys_clock = ~basys_clock;
        #5;
    end
endmodule
