/////////////////////////////////////////////////////////
// Módulo: lfsr7
// Genera números pseudoaleatorios de 16 bits usando
// un registro de retroalimentación lineal (LFSR).
//////////////////////////////////////////////////////////
module lfsr7(
            input  logic       clk,     // reloj
            input  logic       rst,     // reset
            output logic [6:0] random  // salida pseudoaleatoria
            );  
    
    logic [6:0] r;     //registro interno de 7 bits
    logic feedback;     //señal xor de realimentacion
    assign random = r;  //salida registro

    always_ff @(posedge clk or posedge rst) begin   //actualiza cada flanco del reloj
        if (rst) begin  //en caso de bug
            r <= 7'h1;
        end
        else begin      //retroalimentacion por etapas de polinomio 
            feedback = r[6] ^ r[5];
            r <= {r[5:0], feedback};   //desplazar y generar a partir de la realimentacion
        end
    end
endmodule