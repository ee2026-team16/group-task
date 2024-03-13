`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2024 20:47:38
// Design Name: 
// Module Name: taskE
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


module taskE(
    input active,
    input clk,
    output reg [6:0] seg,
    output reg dp,      
    output reg [3:0] an
);
    wire clk_1000;
    flexible_clock_module flexible_clock_module_1000 (
        .basys_clock(clk),
        .my_m_value(49999),
        .my_clk(clk_1000)
    );
    
    reg [1:0] counter = 2'b00;
    always @ (posedge clk_1000)
        begin
            if (active == 0)
                begin
                    an <= 4'b1111;
                end
            else
                begin
                    counter <= (counter + 1) % 4;
                            
                    case (counter)
                        2'b00:
                            begin
                                an <= 4'b0111;
                                seg <= 7'b0010010;
                                dp <= 1;
                            end
                        2'b01:
                            begin
                                an <= 4'b1011;
                                seg <= 7'b0110000;
                                dp <= 0;
                            end
                        2'b10:
                            begin
                                an <= 4'b1101;
                                seg <= 7'b1111001;
                                dp <= 1;
                            end
                        2'b11:
                            begin
                                an <= 4'b1110;
                                seg <= 7'b0000010;
                                dp <= 1;
                            end
                    endcase
                end
        end
endmodule
