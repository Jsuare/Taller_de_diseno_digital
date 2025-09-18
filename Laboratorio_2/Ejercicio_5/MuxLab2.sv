///////////////////////////////////////////////////////////////////////////////////////////////////
//
// MuxLab2.sv
//
// Este modulo sirve como multiplexor de 2 entradas de 16 bits.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module MuxLab2  #(parameter int N = 16)
                (
                input logic Mux,
                input logic [N-1:0] Op_result,
                input logic [6:0] Data,
                output logic [N-1:0] out
                );

always_comb begin
    
    case (Mux)
        1'b0: out = {9'b000000000, Data};
        1'b1: out = Op_result;
        default: out = {N{1'b0}};
    endcase
end

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////