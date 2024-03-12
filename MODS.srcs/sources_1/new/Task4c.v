`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2024 16:14:40
// Design Name: 
// Module Name: Task4c
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


module Taskc(
    input pb,
    input clk,
    input [12:0] pixel_index,
    output [15:0] oleddata
    );
    reg [15:0] data;
    wire [6:0] x;
    wire [5:0] y;
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;  
 
    reg [6:0] xindex1 = 45;
    reg [6:0] xindex2 = 50;
    reg [5:0] yindex1 = 0;
    reg [5:0] yindex2 = 5;
    reg [31:0] count = 0; //0.05s
    reg [31:0] count2 = 0; //pause for 0.5s
    reg [31:0] count3 = 0;// pause for 0.1s 
    
    reg pbcheck = 0; //check
    reg pbdone = 1; //1 for done, 0 for not done
    reg [2:0]turn = 0; //0 to ndown, 1 to right, 2 to pause, 3 to left, 4 to up, 5 to pause
    assign oleddata = data;
     //correct as until 4c.2
    always @ (posedge clk)
    begin

    if(pb == 1)
        begin
        if(pbdone == 1)
            begin 
            pbcheck = 1;
            pbdone = 0;
            turn = 0;
            xindex1 = 45;
            xindex2 = 50;
            yindex1 = 0;
            yindex2 = 5;
            end     
        end
     else
        begin
        if((x>=45) && (x<=50) && (y>=0) && (y<=5))
            begin
            data = 16'hF800;
            end
        else
            begin
            data = 16'h0000;
            end   
       end 
    if(pbcheck == 1)
        begin
        if (turn == 0)
            begin
            if((x>=45) && (x<=50) && (y>=0) && (y<=yindex2))
                begin
                data = 16'hF800;
                end
            else
                begin
                data = 16'h0000;
                end
            count = count + 1;
            count2 = 0;
            if (count == 4999999)
                begin
                yindex2 = yindex2+1;
                count = 0;
                end
            if(yindex2 >= 35)
                begin
                turn = 1;
                yindex2 = 35;
                end 
            end
        else if(turn == 1)
            begin
            count = 0;
            if((x>=45) && (x<=50) && (y>=0) && (y<=35))
                begin
                data = 16'hF800;
                end
            else if((x>=50) && (x<=xindex2) && (y>=30) && (y<=35))
                begin
                data = 16'hF800;
                end
            else
                begin
                data = 16'h0000;
                end                
            count2 = count2 + 1;
            if (count2 == 4999999)
                begin
                xindex2 = xindex2+1;
                count2 = 0;
                end 
            if(xindex2 >= 65)
                begin
                turn = 2;
                xindex2 = 65;
                end                              
            end
        else
            begin
            pbcheck = 0;
            pbdone = 1;
            end
        end
    end

/*   //correct as until 4c.2
    always @ (posedge clk)
    begin
    if(pb == 1)
        begin 
        pbcheck = 1;
        if(pbdone == 1)
            begin
            yindex2 = 5;
            pbdone = 0; //not done
            end
        end
    else
        begin
        if((x>=xindex1) && (x<=xindex2) && (y>=yindex1) && (y<=yindex2))
            begin
            data = 16'hF800;
            end
        else
            begin
            data = 16'h0000;
            end   
        end     
    if(pbcheck == 1)
        begin
        if (turn == 0)
            begin
            if((x>=xindex1) && (x<=xindex2) && (y>=yindex1) && (y<=yindex2))
                begin
                data = 16'hF800;
                end
            else
                begin
                data = 16'h0000;
                end
            count = count + 1;
            if (count == 4999999)
                begin
                yindex2 = yindex2+1;
                count = 0;
                end
            if(yindex2 >= 35)
                begin
                turn = 1;
                yindex2 = 35;
                end 
            end
        else if(turn == 1)
            begin
            pbdone = 1;
            pbcheck = 0;
            turn = 0;
            end
        end
    end */

endmodule
