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
    input sw,
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
 
    reg [6:0] xindex;
    reg [5:0] yindex;
    reg [31:0] count = 0; //0.05s , m = 4999999
    reg [31:0] count2 = 0; //pause for 0.5s, m = 49999999
    reg [31:0] count3 = 0;// pause for 0.1s, m = 9999999 
    
    reg init = 0;
    reg pbdone = 1; //1 for done, 0 for not done
    reg [2:0]turn = 0; //0 to down, 1 to right, 2 to pause, 3 to change colour, 4 to left, 5 to up, 6 to pause
    assign oleddata = data;
     //L can go in and back, but think of doing it again, have init = 0 or 1 inside data
    always @ (posedge clk)
    begin
    if(sw == 1)
    begin
    if(pbdone == 1)
        begin
        if(pb == 1)
            begin 
            pbdone = 0;
            turn = 0;
            yindex = 5;
            xindex = 50;
            end    
        else
            begin
            if(init == 0)
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
            else
                begin
                if((x>=45) && (x<=50) && (y>=0) && (y<=5))
                    begin
                    data = 16'hF800;
                    end               
                else if((x>=45) && (x<=50) && (y>=5) && (y<=35))
                    begin
                    data = 16'h07E0;
                    end
                else if((x>=50) && (x<=65) && (y>=30) && (y<=35))
                    begin
                    data = 16'h07E0;
                    end
                else
                    begin
                    data = 16'h0000;
                    end 
                end 
            end
        end  
    else
        begin
        if (turn == 0)
            begin
            if((x>=45) && (x<=50) && (y>=0) && (y<=yindex))
                begin
                data = 16'hF800;
                end
            else 
                begin
                if(init == 0)
                    begin
                    data = 16'h0000;
                    end
                else
                    begin
                    if((x>=45) && (x<=50) && (y>=yindex) && (y<=35))
                        begin
                        data = 16'h07E0;
                        end
                    else if((x>=50) && (x<=65) && (y>=30) && (y<=35))
                        begin
                        data = 16'h07E0;
                        end
                    else
                        begin
                        data = 16'h0000;
                        end 
                    end
                end
            count = count + 1;
            count2 = 0;
            count3 = 0;
            if (count == 4999999)
                begin
                yindex = yindex+1;
                count = 0;
                end
            if(yindex >= 35)
                begin
                turn = 1;
                yindex = 35;
                count = 0;
                end 
            end
        else if(turn == 1)
            begin
            if((x>=45) && (x<=50) && (y>=0) && (y<=35))
                begin
                data = 16'hF800;
                end
            else
            begin
                if(init == 0)
                begin
                    if((x>=50) && (x<=xindex) && (y>=30) && (y<=35))
                        begin
                        data = 16'hF800;
                        end
                    else
                        begin
                        data = 16'h0000;
                        end
                end
                else
                begin
                    if((x>=50) && (x<=xindex) && (y>=30) && (y<=35))
                        begin
                        data = 16'hF800;
                        end
                    else if((x>=xindex) && (x<=65) && (y>=30) && (y<=35))
                        begin
                        data = 16'h07E0;
                        end
                    else
                        begin
                        data = 16'h0000;
                        end
                end 
            end                               
            count = count + 1;
            if (count == 4999999)
                begin
                xindex = xindex+1;
                count = 0;
                end 
            if(xindex >= 65)
                begin
                turn = 2;
                xindex = 65;
                end                              
            end
        else if(turn == 2)
            begin
            if((x>=45) && (x<=50) && (y>=0) && (y<=35))
                begin
                data = 16'hF800;
                end
            else if((x>=50) && (x<=xindex) && (y>=30) && (y<=35))
                begin
                data = 16'hF800;
                end
            else
                begin
                data = 16'h0000;
                end 
            count = 0;
            count3 = 0;
            count2 = count2 + 1;
            if (count2 == 49999999)
                begin
                count2 = 0;
                turn = 3;
                end
            end
        else if(turn == 3) 
            begin
            if((x>=60) && (x<=65) && (y>=30) && (y<=35))
                begin
                data = 16'h07E0;
                end
            else if((x>=45) && (x<=50) && (y>=0) && (y<=35))
                begin
                data = 16'hF800;
                end
            else if((x>=50) && (x<=60) && (y>=30) && (y<=35))
                begin
                data = 16'hF800;
                end
            else
                begin
                data = 16'h0000;
                end 
            count2=count2+1;
            if (count2 == 49999999)
                begin
                count2 = 0;
                turn = 4;
                xindex = 60;
                end          
            end
        else if(turn == 4)
            begin
            count = 0;
            count2 = 0;
            if((x>=45) && (x<=50) && (y>=0) && (y<=30))
                begin
                data = 16'hF800;
                end
            else if((x>=45) && (x<=xindex) && (y>=30) && (y<=35))
                begin
                data = 16'hF800;
                end
            else if ((x>=xindex) && (x<=65) && (y>=30) && (y<=35))
                begin
                data = 16'h07E0;               
                end
            else
                begin
                data = 16'h0000;
                end
            count3 = count3 + 1;
            if (count3 == 9999999)
                begin
                xindex = xindex-1;
                count3 = 0;
                end 
            if(xindex <= 45)
                begin
                turn = 5;
                xindex = 45;
                yindex = 30;
                end                                         
            end
        else if(turn == 5)
            begin
            if((x>=45) && (x<=50) && (y>=0) && (y<=yindex))
                begin
                data = 16'hF800;
                end
            else if((x>=45) && (x<=50) && (y>=yindex) && (y<=35))
                begin
                data = 16'h07E0;
                end
            else if((x>=45) && (x<=65) && (y>=30) && (y<=35))
                begin
                data = 16'h07E0;
                end
            else
                begin
                data = 16'h0000;
                end
            count3 = count3 + 1;
            if (count3 == 9999999)
                begin
                yindex = yindex-1;
                count3 = 0;
                end
            if(yindex <= 0)
                begin
                yindex = 0;
                count3 = 0;
                turn = 6;
                end 
            end
        else 
           begin
           if((x>=45) && (x<=50) && (y>=0) && (y<=35))
               begin
               data = 16'h07E0;
               end
           else if((x>=50) && (x<=65) && (y>=30) && (y<=35))
               begin
               data = 16'h07E0;
               end
           else
               begin
               data = 16'h0000;
               end 
           count = 0;
           count3 = 0;
           count2 = count2 + 1;
           if (count2 == 49999999)
               begin
               count2 = 0;
               turn = 0;
               pbdone = 1;
               init = 1;
               end
        end                  
    end
    end
    else
        begin
        data = 16'h0000;
        init = 0;
        pbdone = 1;
        end
    end

