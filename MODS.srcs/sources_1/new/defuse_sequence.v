`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mohamed Abubaker Mustafa Abdelaal Elsayed
//////////////////////////////////////////////////////////////////////////////////


module defuse_sequence(input basys_clock, clk_25MHz, btnC, btnU, btnL, btnR, btnD, sw1, input [12:0] pixel_index, output reg [15:0] oled_data);
    parameter BLACK = 16'b00000_000000_00000; // else case
    parameter RED = 16'b11111_000000_00000;
    parameter ORANGE = 16'b11111_011000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    parameter GREY = 16'b01000_010000_01000;
    wire clk_1000;
    
    reg [31:0] x, y;
    reg [31:0] state = 1;
    reg [31:0] defuse_state = 1;
    wire [31:0] prev_generated_state, generated_state;
    reg [31:0] count = 0, random_number = 0;
    
    random_number_generator unit(basys_clock, state, generated_state);
   
    reg circleC, circleU, circleL, circleR, circleD;
    
    always @ (posedge clk_25MHz)
    begin
        x = pixel_index / 96;
        y = pixel_index % 96;
        
        if (!sw1) begin
            count = 0;
            defuse_state = 1;
        end
                   
        count <= (count == 12500001) ? 0 : count + 1;
  
        circleC = (((x - 32) ** 2 + (y - 48) ** 2) < 64);
        circleL = (((x - 32) ** 2 + (y - 28) ** 2) < 64);
        circleR = (((x - 32) ** 2 + (y - 68) ** 2) < 64);
        circleU = (((x - 14) ** 2 + (y - 48) ** 2) < 64);
        circleD = (((x - 50) ** 2 + (y - 48) ** 2) < 64);
        
        
        state <= ((defuse_state == 1 && btnC) || (defuse_state == 2 && btnL) || (defuse_state == 3 && btnR) || (defuse_state == 4 && btnU) || (defuse_state == 5 && btnD)) ? (generated_state) : state;
        defuse_state <= state % 5 + 1;
        if (circleC) begin
            oled_data <= (defuse_state == 1) ? GREEN : GREY;
        end
        else if (circleL) begin
            oled_data <= (defuse_state == 2) ? GREEN : GREY;
        end
        else if (circleR) begin
            oled_data <= (defuse_state == 3) ? GREEN : GREY;
        end
        else if (circleU) begin
            oled_data <= (defuse_state == 4) ? GREEN : GREY;
        end
        else if (circleD) begin
            oled_data <= (defuse_state == 5) ? GREEN : GREY;
        end
        else begin
            oled_data <= BLACK;
        end
            
    end
endmodule
