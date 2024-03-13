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
    input clk,
    input sw8,
    input [15:13] sw,
    output reg [6:0] seg,
    output reg dp,      
    output reg [3:0] an,
    input [6:0] paint_seg
);
    reg [6:0] number0 = 7'b1000000;
    reg [6:0] number1 = 7'b1111001;
    reg [6:0] number2 = 7'b0100100;
    reg [6:0] number3 = 7'b0110000;
    reg [6:0] number4 = 7'b0011001;
    reg [6:0] number5 = 7'b0010010;
    reg [6:0] number6 = 7'b1111101;
    reg [6:0] number7 = 7'b1111000;
    reg [6:0] number8 = 7'b1111111;
    reg [6:0] number9 = 7'b1100111;
    
    wire clk_1000;
    flexible_clock_module flexible_clock_module_1000 (
        .basys_clock(clk),
        .my_m_value(49999),
        .my_clk(clk_1000)
    );
    
    reg [1:0] counter = 2'b00;
    always @ (posedge clk_1000)
        begin
            if (sw8 == 0)
                begin
                    an <= 4'b1111;
                    seg <= 7'b1111111;
                    dp <= 1;
                end
            else if (sw[15] == 1)
                begin
                    an <= 4'b1101;
                    seg <= paint_seg;
                    dp <= 1;
                end
            else if (sw[14] == 1)
                begin
                    an <= 4'b1110;
                    seg <= paint_seg;
                    dp <= 1;
                end
            else if (sw[13] == 1)
                begin
                    counter <= (counter + 1) % 2;
                                                    
                    case (counter)
                        2'b00:
                            begin
                                an <= 4'b0111;
                                seg <= number5;
                                dp <= 1;
                            end
                        2'b01:
                            begin
                                an <= 4'b1011;
                                seg <= number3;
                                dp <= 0;
                            end
                    endcase
                end
            else
                begin
                    counter <= (counter + 1) % 4;
                                    
                    case (counter)
                        2'b00:
                            begin
                                an <= 4'b0111;
                                seg <= number5;
                                dp <= 1;
                            end
                        2'b01:
                            begin
                                an <= 4'b1011;
                                seg <= number3;
                                dp <= 0;
                            end
                        2'b10:
                            begin
                                an <= 4'b1101;
                                seg <= number1;
                                dp <= 1;
                            end
                        2'b11:
                            begin
                                an <= 4'b1110;
                                seg <= number0;
                                dp <= 1;
                            end
                    endcase
                end
        end
endmodule
