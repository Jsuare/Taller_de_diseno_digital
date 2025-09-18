/////////////////////////////////////////////////////////////////
// Módulo que convierte un número hexadecimal (4 bits) en
// el patrón correspondiente para un display de 7 segmentos.
////////////////////////////////////////////////////////////////
module hex7seg(
    input  logic [3:0] x,       // Entrada de 4 bits
    output logic [6:0] a_to_g   // Salida de 7 bits que controla los segmentos del display
);
    always_comb begin
        case(x)
            //Bloque para la activación de los segmentos del display
            //Cada seguncia dara una visualización del numero hexadecimal de 0 a F
            4'h0: a_to_g = 7'b1000000; 
            4'h1: a_to_g = 7'b1111001; 
            4'h2: a_to_g = 7'b0100100;
            4'h3: a_to_g = 7'b0110000;
            4'h4: a_to_g = 7'b0011001; 
            4'h5: a_to_g = 7'b0010010;
            4'h6: a_to_g = 7'b0000010;
            4'h7: a_to_g = 7'b1111000;
            4'h8: a_to_g = 7'b0000000; 
            4'h9: a_to_g = 7'b0010000; 
            4'hA: a_to_g = 7'b0001000; 
            4'hB: a_to_g = 7'b0000011; 
            4'hC: a_to_g = 7'b1000110; 
            4'hD: a_to_g = 7'b0100001; 
            4'hE: a_to_g = 7'b0000110;
            4'hF: a_to_g = 7'b0001110; 
            default: a_to_g = 7'b1111111;
        endcase
    end
endmodule