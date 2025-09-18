///////////////////////////////////////////////////////////////////////////////////////////////////
//
// MiniUnidadCalculo.sv
//
// Este módulo sirve como módulo top de la Mini Unidad de Cálculo, el cual contiene todos
// los demás sub-módulos
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module MiniUnidadCalculo(
                        input  logic clk, rst, sw,
                        input  logic [3:0] boton,
                        output logic dp,
                        output logic [6:0] leds, a_to_g,
                        output logic [7:0] an
                        );

// ------------------------------------------------------------------------------------------------
//                                              Parámetros
// ------------------------------------------------------------------------------------------------

localparam N = 16;
localparam W = 5;
localparam L = 7;
localparam MAX_COUNT = 200_000_000;

// ------------------------------------------------------------------------------------------------
//                                          Señales internas
// ------------------------------------------------------------------------------------------------

logic Read_mode, Mux, WE;
logic [N-1:0] out, rs1, rs2, rs3, Op_result;
logic [L-1:0] random;
logic [W-1:0] addr_counter, addr_rs1, addr_rs2, addr_rs3;

// ------------------------------------------------------------------------------------------------
//                                               FSM
// ------------------------------------------------------------------------------------------------
FSMLab2 fsm(.clk(clk), .rst(rst), .sw(sw), .WE(WE),
            .Read_mode(Read_mode), .Mux(Mux), .leds(leds[6:4]));

// ------------------------------------------------------------------------------------------------
//                              Generador de pulso WE cada 2 segundos
// ------------------------------------------------------------------------------------------------
clk_div #(.MAX_COUNT(MAX_COUNT)) clk_div_inst(.clk(clk), .rst(rst), .WE(WE));

// ------------------------------------------------------------------------------------------------
//                                               LFSR
// ------------------------------------------------------------------------------------------------
lfsr7 lfsr(.clk(clk), .rst(rst), .random(random));

// ------------------------------------------------------------------------------------------------
//                                               Mux
// ------------------------------------------------------------------------------------------------
MuxLab2 #(.N(N)) mux(.Mux(Mux), .Data(random), .Op_result(Op_result), .out(out));

// ------------------------------------------------------------------------------------------------
//                                     Contador de direcciones
// ------------------------------------------------------------------------------------------------
ContadorLab2 cont_dir(.clk(clk), .rst(rst), .WE(WE), .Read_mode(Read_mode), .cont(addr_counter));

// Direcciones para casos especiales
always_comb begin

    addr_rs3 = addr_counter-1;

    if (addr_counter == 1) begin
        addr_rs1 = 30;
        addr_rs2 = 31;
    end

    else if (addr_counter == 2) begin
        addr_rs1 = 31;
        addr_rs2 = 1;
    end

    else begin
        addr_rs1 = addr_counter - 2;
        addr_rs2 = addr_counter - 1;
    end
end
// ------------------------------------------------------------------------------------------------
//                                  Banco de registros 32x16 bits
// ------------------------------------------------------------------------------------------------
register_file #(.N(N), .W(W)) bancoregistros(
                .clk(clk), .rst(rst), .we(WE), .Read_mode(Read_mode),
                .addr_rd(addr_counter), .data_in(out), .addr_rs1(addr_rs1), .addr_rs2(addr_rs2),
                .addr_rs3(addr_rs3), .rs1(rs1), .rs2(rs2), .rs3(rs3));

// ------------------------------------------------------------------------------------------------
//                                               ALU
// ------------------------------------------------------------------------------------------------
ALULab2 #(.N(N)) alu(.rs1(rs1), .rs2(rs2), .boton(boton),
                     .Op_result(Op_result), .leds(leds[3:0]));

// ------------------------------------------------------------------------------------------------
//                                         7 Segment Display
// ------------------------------------------------------------------------------------------------
logic [1:0] sel_digito;
logic [3:0] digito_actual;
logic [15:0] contador;

// Reloj rápido para multiplexado (ajusta frecuencia según tu reloj)
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        contador <= 0;
        sel_digito   <= 0;
    end else begin
        contador <= contador + 1;
        sel_digito   <= contador[15:14]; // Cambia cada ~1/4 del tiempo
    end
end

logic [3:0] rs2_0, rs2_1, rs2_2, rs2_3;
assign rs2_0 = rs2[3:0];
assign rs2_1 = rs2[7:4];
assign rs2_2 = rs2[11:8];
assign rs2_3 = rs2[15:12];

always_comb begin
    case(sel_digito)
        2'b00: begin an = 8'b11111110; digito_actual = rs2_0; end
        2'b01: begin an = 8'b11111101; digito_actual = rs2_1; end
        2'b10: begin an = 8'b11111011; digito_actual = rs2_2; end
        2'b11: begin an = 8'b11110111; digito_actual = rs2_3; end
        default: begin an = 8'b11111111; digito_actual = 4'h0; end
    endcase
end


hex7seg display(.x(digito_actual), .a_to_g(a_to_g));

assign dp = 1'b1; // Apagar punto decimal

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////