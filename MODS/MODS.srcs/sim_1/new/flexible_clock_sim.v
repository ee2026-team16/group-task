`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:27:58
// Design Name: 
// Module Name: flexible_clock_sim
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


module flexible_clock_sim();
    reg sim_basys_clock;
    wire sim_output_clock;
    reg [31:0] sim_m_value;
    
    flexible_clock dut(sim_basys_clock, sim_m_value, sim_output_clock);
    initial
    begin
        sim_basys_clock = 0;
        sim_m_value = 7; 
    end
    
    always
    begin
        sim_basys_clock = ~sim_basys_clock; #10;
    end 
endmodule
