`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:40:33
// Design Name: 
// Module Name: TB_digital
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


module TB_TOP_digital();

    // Señales de prueba
    logic clk_in1;
    logic reset;
    logic boton_entrada;
    logic [7:0] leds;

    // Instancia del DUT
    TOP_digital dut (
        .clk_in1(clk_in1),
        .reset(reset),
        .boton_entrada(boton_entrada),
        .leds(leds)
    );

    // Generador de reloj de entrada (100 MHz)
    initial clk_in1 = 0;
    always #5 clk_in1 = ~clk_in1;

    // Simulación de reloj interno (10 MHz) - forzado
    initial begin
        force dut.clk_out1 = 0;
        forever #50 force dut.clk_out1 = ~dut.clk_out1;
    end

    // Forzar locked = 1 para desactivar reset interno

    // Tarea para aplicar reset global
    task aplicar_reset;
        begin
            reset = 1;
            #100;
            reset = 0;
            #1000; // Esperar estabilización
        end
    endtask

    // Tarea para simular pulsación con rebotes
    task pulsar_boton;
        input int rebotes;
        begin
            boton_entrada = 1;
            repeat (rebotes) #(20 + $urandom_range(10, 30)) boton_entrada = ~boton_entrada;
            boton_entrada = 1;
            #50000;
            boton_entrada = 0;
            #1000;
        end
    endtask

    // Tarea para verificar el valor del contador
    task verificar_contador;
        input [7:0] esperado;
        input string nombre_test;
        begin
            #500;
            if (leds !== esperado)
                $display("FALLA en %s: Contador = %0d, Esperado = %0d", nombre_test, leds, esperado);
            else
                $display("APROBADO %s: Contador = %0d", nombre_test, leds);
        end
    endtask

    // Secuencia de prueba principal
    initial begin
        boton_entrada = 0;
        reset = 0;

        $display("=== INICIO DE SIMULACION CON CLOCK Y LOCKED FORZADOS ===");

        aplicar_reset();
        verificar_contador(0, "Reset inicial");

        pulsar_boton(5);
        verificar_contador(1, "Pulso 1");

        pulsar_boton(7);
        verificar_contador(2, "Pulso 2");

        pulsar_boton(6);
        verificar_contador(3, "Pulso 3");

        $display("SIMULACION COMPLETADA");
        $finish;
    end

endmodule




