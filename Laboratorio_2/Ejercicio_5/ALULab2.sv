///////////////////////////////////////////////////////////////////////////////////////////////////
//
// ALULab2.sv
//
// Este módulo sirve como módulo top de la ALU, el cual contiene todos los demás sub-módulos
// para que la ALU funcione de forma adecuada
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module ALULab2 #(parameter N = 16)
                (
                input  logic [N-1:0] rs1, rs2,
                input  logic [3:0] boton,
                output logic [N-1:0] Op_result,
                output logic [3:0] leds
                );

    always_comb begin
        // LEDs reflejan la operación seleccionada
        leds[3:0] = boton[3:0];
        case (boton)
            4'b0001: Op_result = rs1 + rs2;       // Suma
            4'b0010: Op_result = rs1 - rs2;       // Resta
            4'b0100: Op_result = rs1 & rs2;       // AND
            4'b1000: Op_result = rs1 | rs2;       // OR
            default: Op_result = 0;                         // Ninguna operación
        endcase
    end

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////