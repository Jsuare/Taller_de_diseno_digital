//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:02:21
// Design Name: 
// Module Name: Contador
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


module Contador #(
    parameter int N = 8
)(
    input  logic clk,
    input  logic rst,      // activo en bajo
    input  logic EN,
    output logic [N-1:0] Q //Bus de bits
);

    always_ff @(posedge clk) begin
        if (rst)
            Q <= '0;
        else if (EN)
            Q <= Q + 1;
    end


endmodule