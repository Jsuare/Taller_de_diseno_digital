`timescale 1ns/1ps
module top #(
//Contador de 2 segundos para hacer el cambio del valor
    parameter integer MAX_COUNT = 200_000_000 )(
    input  logic        clk_i,   // reloj a una 100 MHz
    input  logic        rst,     // reset
    input  logic        en,      // enable externo carga el valor
    output logic [6:0]  a_to_g,  // salida display
    output logic        dp,      // apagado 
    output logic [7:0]  an);      // selección de los 8 displays 

    assign dp = 1'b1; // Punto decimal
    logic [15:0] rnd;// Generador pseudoaleatorio
    lfsr16 lfsr_inst(
        .clk(clk_i), 
        .rst(rst), 
        .random(rnd));   // genera un número pseudoaleatorio de 16 bits

    logic tick;// Divisor de reloj
    clk_div #(.MAX_COUNT(MAX_COUNT)) div_inst(
        .clk(clk_i),
        .rst(rst),
        .tick(tick));   // pulso de reloj 2 segundos
    
    // Detección de flanco de subida en tick
    logic tick_d, we_pulse;//Cada 2 segundos es un flaco alto para dar la señal de cambio de WE
    always_ff @(posedge clk_i or posedge rst) begin
        if (rst) begin
            tick_d   <= 0;
            we_pulse <= 0;
        end else begin
            tick_d   <= tick;
            we_pulse <= (tick & ~tick_d);//generador del pulso 
        end
    end
    
    logic we;//Señal para activar la escritura del dispaly
    assign we = we_pulse & en;

    // Registro de 16 bits tipo PIPO (paralelo) valor aleatorio
    logic [15:0] q;
    reg_pipo #(.WIDTH(16)) REG16 ( //se parametriza en 16 bits 
        .clk(clk_i),
        .rst(rst),
        .we(we),   //nuevo valor
        .d(rnd),
        .q(q));  //Salida
 
    // Un contador rápido selecciona en qué display mostrar el dígito
    logic [19:0] refresh_counter;// Multiplexado de displays
    always_ff @(posedge clk_i or posedge rst) begin
        if (rst) 
            refresh_counter <= 0;
        else     
            refresh_counter <= refresh_counter + 1;
    end
    // Se usan 3 bits para seleccionar entre hasta 8 displays
    logic [2:0] sel = refresh_counter[19:17]; 
    logic [3:0] digit;

    always_comb begin//Secuencia para activar los display al ser solo valores de 16 bits se ocupa solo 4 display
        case(sel)
            2'b00: begin an = 8'b1110_1111; digit = q[3:0];   end 
            2'b01: begin an = 8'b1101_1111; digit = q[7:4];   end  
            2'b10: begin an = 8'b1011_1111; digit = q[11:8];  end   
            2'b11: begin an = 8'b0111_1111; digit = q[15:12]; end  
            default: begin an = 8'b1111_1111; digit = 4'h0;   end  
        endcase
    end
    hex7seg seg_decoder( //Decodificador de 7 segmentos
        .x(digit),
        .a_to_g(a_to_g));
endmodule
