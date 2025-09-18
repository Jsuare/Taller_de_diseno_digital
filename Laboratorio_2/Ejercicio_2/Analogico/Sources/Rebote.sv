/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:12:48
// Design Name: 
// Module Name: Rebote
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

module Rebote #(
    parameter int N = 20   // 2^20/10MHz ≈ 104.8576 ms (tiempo de debounce), se utiliza reducido para efector de simulación
)(
    input  logic clk,              // Reloj de 10 MHz
    input  logic rst,              // Reset activo en alto
    input  logic ruido_entrada,    // Señal con ruido/rebotes
    output logic senal_sin_ruido   // Señal limpia y estable
);

    logic [N-1:0] cont;           // Contador para tiempo de debounce
    logic stable_state;           // Estado estable actual de la señal

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset: inicializar todo
            cont <= '0;                   // Contador a cero
            stable_state <= 0;            // Estado estable a 0
            senal_sin_ruido <= 0;         // Salida a 0
        end else begin
            // Lógica principal de anti-rebote
            if (ruido_entrada == stable_state) begin
                // La entrada coincide con el estado estable: reiniciar contador
                cont <= '0;
            end else begin
                // La entrada es diferente: incrementar contador
                cont <= cont + 1;
                
                if (&cont) begin  // &cont es true cuando todos los bits son 1 (contador lleno)
                    // Contador llegó al máximo: cambio válido detectado
                    stable_state <= ruido_entrada;    // Actualizar estado estable
                    senal_sin_ruido <= ruido_entrada; // Actualizar salida
                    cont <= '0;                      // Reiniciar contador
                end
            end
        end
    end

endmodule
