`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 15:39:12
// Design Name: 
// Module Name: animation_4E
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


module taskF(
    input clk,
    input btn,
    input [12:0] pixel_index,
    output [15:0] oled_data
    );
    reg [15:0] data;
    wire [6:0] x;
    wire [5:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96; 
    assign oled_data = data;
    reg [31:0] count = 0;  
    reg [2:0] colour = 0; //0 for green, 1 for red, 2 for blue, 3 for yellow, 4 for purple 
    reg [31:0] xindex = 16;
    reg btn_pressed = 0;

    always @ (posedge clk)
    begin
    if(btn == 1)
        begin
        btn_pressed = 1;
        end
    if(btn_pressed == 1)
        begin
            count = count + 1;
            if(count >= 12499999)
                begin
                    count = 0;
                    xindex <= (xindex == 80) ?16 : xindex + 8;
                    colour <= (xindex == 80) ? ((colour == 4) ? 0 : colour + 1) : colour;
                end
            if((x>=16)&&(x<xindex)&&(y>=26)&&(y<=37))
                begin
                    if(colour == 0)
                    begin
                    data = 16'h001F;
                    end
                    else if(colour == 1)
                    begin
                    data = 16'h07E0;
                    end
                    else if (colour == 2)
                    begin
                    data = 16'hF800;
                    end  
                    else if (colour == 3)
                    begin
                    data = 16'hFFE0;
                    end  
                    else 
                    begin
                    data = 16'hF87F;
                    end                                       
                end
            else
                begin
                    data = 16'h0000;
                end
        end
    else
        begin
        data = 16'h0000;
        xindex = 16;
        end
    end
      
endmodule
