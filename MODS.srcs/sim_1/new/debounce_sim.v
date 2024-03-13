`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 22:21:04
// Design Name: 
// Module Name: debounce_sim
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


module debounce_sim();
    // input
    reg basys_clock;
    reg btn_in;
    
    // output
    wire btn_out;
    
    debounce dut(basys_clock, btn_in, btn_out);
        
    initial
    begin
        btn_in = 0;
        basys_clock = 0;
    end
    
    always
    begin
        basys_clock = ~basys_clock; #5; btn_in = 1;
    end
endmodule