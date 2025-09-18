
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 23:59:46
// Design Name: 
// Module Name: TOP_digital
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


module TOP_digital(
    input  logic clk_in1,
    input  logic reset, 
    input  logic boton_entrada,
    output logic [7:0] leds
);

    // Señales del Clock Wizard
    logic clk_out1;
    logic locked;
    
    // Señales del sistema
    logic rst_sincronizado;
    logic senal_sincronizada;  // ← Cambiado de sync_out a senal_sincronizada
    logic senal_sin_rebotes;
    logic en_contador;
    logic [7:0] contador_valor;

    // ==================== CLOCK WIZARD ====================
    clk_wiz_0 reloj_10mhz (
        .clk_out1(clk_out1),
        .reset(reset),
        .locked(locked),
        .clk_in1(clk_in1)
    );

    // ==================== SINCRONIZACIÓN DE RESET ====================
    always_ff @(posedge clk_out1) begin
        rst_sincronizado <= ~locked;
    end

    // ==================== SINCRONIZADOR DE ENTRADA ====================
    Sincronizador sincronizador_boton (
        .clk(clk_out1),
        .asincronica_entrada(boton_entrada),
        .sincronica_salida(senal_sincronizada) 
    );

    // ==================== MÓDULO ANTI-REBOTE ====================
    Rebote #(.N(4)) anti_rebote (
        .clk(clk_out1),
        .rst(rst_sincronizado),
        .ruido_entrada(senal_sincronizada),
        .senal_sin_ruido(senal_sin_rebotes)
    );
    //assign senal_sin_rebotes = senal_sincronizada;


    // ==================== DETECTOR DE FLANCO ====================
    detector_flanco detector (
        .clk(clk_out1),
        .rst(rst_sincronizado),
        .senal_entrada(senal_sin_rebotes),
        .flanco_positovo(en_contador)
    );

    // ==================== CONTADOR ====================
    Contador #(.N(8)) contador_pruebas (
        .clk(clk_out1),
        .rst(rst_sincronizado),
        .EN(en_contador),
        .Q(contador_valor)
    );

    // ==================== SALIDA A LEDs ====================
    assign leds = contador_valor;

endmodule