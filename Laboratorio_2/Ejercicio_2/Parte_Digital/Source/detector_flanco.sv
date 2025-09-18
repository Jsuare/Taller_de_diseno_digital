//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:49:11
// Design Name: 
// Module Name: detector_flanco
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


module detector_flanco(
    input  logic clk,
    input  logic rst,
    input  logic senal_entrada,
    output logic flanco_positovo 
);

    logic prev = 0; //condicional para almacenar la señal previa

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev        <= 0;
            flanco_positovo  <= 0;
        end else begin
            flanco_positovo  <= (senal_entrada & ~prev);
            prev        <= senal_entrada;
        end
    end

endmodule