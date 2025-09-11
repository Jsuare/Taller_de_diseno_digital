/////////////////////////////////////////////////////////
// Módulo: lfsr16
// Genera números pseudoaleatorios de 16 bits usando
// un registro de retroalimentación lineal (LFSR).
//////////////////////////////////////////////////////////
module lfsr16 (
    input  logic       clk,       // reloj
    input  logic       rst,       // reset
    output logic [15:0] random);    // salida pseudoaleatoria
    
    logic [15:0] r;//registro interno de 16 bits
    logic feedback;//señal xor de realimentacion
    assign random = r;//salida registro

    always_ff @(posedge clk or posedge rst) begin//actualiza cada flaco del reloj
        if (rst) begin//en caso de bug
            r <= 16'h1;
        end else begin//retroalimentacion por etapas de polinomio 
            feedback = r[15] ^ r[13] ^ r[12] ^ r[10];
            r <= {r[14:0], feedback};//desplazar y generar a partir de la realimentacion
        end
    end
endmodule