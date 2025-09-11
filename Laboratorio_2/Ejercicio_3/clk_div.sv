///////////////////////////////////////////////////////////
// Módulo: clk_div
// Divide la frecuencia del reloj y genera un pulso alto 
// cada MAX_COUNT ciclos de reloj.
/////////////////////////////////////////////////////////////
module clk_div #(
    parameter int MAX_COUNT = 200_000_000)( // 2 s @100MHz (200 millones de ciclos)
    input  logic clk,   // reloj de entrada 
    input  logic rst,   // reset 
    output logic tick);   // pulso de 1 ciclo cada vez que se llega a MAX_COUNT

    localparam int NB = $clog2(MAX_COUNT);//bits para el contador
    logic [NB-1:0] cnt; //contador

    // Lógica secuencial: contador y pulso 
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt  <= 0;
            tick <= 0;
        end else if (cnt == MAX_COUNT-1) begin// Cuando se llega al valor máximo:
            cnt  <= 0;
            tick <= 1;
        end else begin
            cnt  <= cnt + 1;
            tick <= 0;
        end
    end
endmodule