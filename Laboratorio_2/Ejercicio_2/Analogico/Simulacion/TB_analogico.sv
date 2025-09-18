`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2025 14:27:33
// Design Name: 
// Module Name: TB_analogico
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


module TB_analogico();
    // Señales de prueba
    logic clk_in1;
    logic reset;
    logic boton_entrada;
    logic [7:0] leds;

    // Instancia del DUT (Device Under Test)
    TOP_analogico dut (
        .clk_in1(clk_in1),
        .reset(reset),
        .boton_entrada(boton_entrada),
        .leds(leds)
    );

    // ==================== Generación de reloj ====================
    initial clk_in1 = 0;
    always #5 clk_in1 = ~clk_in1; // 100 MHz → periodo de 10 ns

    // ==================== Estímulos ====================
    initial begin
        // Inicialización
        reset = 1;
        boton_entrada = 0;
        #20;

        // Liberar reset
        reset = 0;
        #50;

        // Simular pulsos del LM555 (pulso limpio de 10.56 ms ≈ 105600 ns)
        repeat (5) begin
            boton_entrada = 1;
            #105600; // Pulso alto
            boton_entrada = 0;
            #50000;  // Tiempo entre pulsos
        end

        // Esperar y finalizar
        #100000;
        $finish;
    end

endmodule
