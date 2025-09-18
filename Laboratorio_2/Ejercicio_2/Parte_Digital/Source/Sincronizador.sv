//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:28:23
// Design Name: 
// Module Name: Sincronizador
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


module Sincronizador(

    input  logic clk,
    input  logic asincronica_entrada,
    output logic sincronica_salida
);

    logic s1 = 0;

    always_ff @(posedge clk) begin
        s1       <= asincronica_entrada;
        sincronica_salida <= s1;
    end

endmodule
