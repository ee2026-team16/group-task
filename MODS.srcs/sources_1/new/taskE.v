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
    input btnC,
    input [6:0] paint_seg,
    output reg success
);
    reg [6:0] number1 = 7'b1111001;
    reg [6:0] number3 = 7'b0110000;
    reg [6:0] number5 = 7'b0010010;
    reg [6:0] number6 = 7'b0000010;
    
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
                    
                    success <= 0;
                end
            else if (sw[15] == 1) // AN1 shows paint_seg
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
                                seg <= paint_seg;
                                dp <= 1;
                            end
                        2'b11:
                            begin
                                an <= 4'b1110;
                                seg <= number6;
                                dp <= 1;
                            end
                    endcase
                    
                    success <= success ? 1 : (btnC && paint_seg == number1);
                end
            else if (sw[14] == 1) // AN0 shows paint_seg
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
                                seg <= paint_seg;
                                dp <= 1;
                            end
                    endcase
                    
                    success <= success ? 1 : (btnC && paint_seg == number6);
                end
            else if (sw[13] == 1) // AN[1:0] OFF
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
                                an <= 4'b1111;
                                seg <= number1;
                                dp <= 1;
                            end
                        2'b11:
                            begin
                                an <= 4'b1111;
                                seg <= number6;
                                dp <= 1;
                            end
                    endcase
                end
            else // all SW[15:13] are OFF
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
                                seg <= number6;
                                dp <= 1;
                            end
                    endcase
                    
                    success <= success ? 1 : btnC;
                end
        end
endmodule
