`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 14:25:14
// Design Name: 
// Module Name: TOP_analogico
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


module TOP_analogico(
    input  logic clk_in1,          // Reloj externo de 100 MHz
    input  logic reset,            // Reset activo en alto
    input  logic boton_entrada,    // Señal limpia desde LM555
    output logic [7:0] leds        // Salida a LEDs
);

    // Señales internas
    logic clk_out1;
    logic locked;
    logic rst_sincronizado;
    logic senal_sincronizada;
    logic flanco_detectado;

    // ==================== Instancia del IP clk_wiz_0 ====================
    clk_wiz_0 instancia_clk_wiz (
        .clk_out1(clk_out1),     // Reloj generado
        .reset(reset),           // Reset del IP
        .locked(locked),         // Señal de bloqueo
        .clk_in1(clk_in1)        // Reloj de entrada
    );

    // ==================== Sincronizador de reset ====================
    Sincronizador sincronizador_reset (
        .clk(clk_out1),
        .asincronica_entrada(reset),
        .sincronica_salida(rst_sincronizado)
    );

    // ==================== Sincronizador de botón ====================
    Sincronizador sincronizador_boton (
        .clk(clk_out1),
        .asincronica_entrada(boton_entrada),
        .sincronica_salida(senal_sincronizada)
    );

    // ==================== Detector de flanco positivo ====================
    detector_flanco flanco (
        .clk(clk_out1),
        .rst(rst_sincronizado),
        .senal_entrada(senal_sincronizada),
        .flanco_positovo(flanco_detectado)
    );

    // ==================== Contador ====================
    Contador #(.N(8)) contador (
        .clk(clk_out1),
        .rst(rst_sincronizado),
        .EN(flanco_detectado),
        .Q(leds)
    );

endmodule
