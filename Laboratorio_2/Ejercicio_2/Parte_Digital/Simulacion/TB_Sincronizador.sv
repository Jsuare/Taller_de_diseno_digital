`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:32:06
// Design Name: 
// Module Name: TB_Sincronizador
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



module tb_Sincronizador;
    // Señales de entrada
    logic clk;
    logic asincronica_entrada;
    
    // Señales de salida
    logic sincronica_salida;
    
    // Instanciar el módulo bajo prueba
    Sincronizador dut (
        .clk(clk),
        .asincronica_entrada(asincronica_entrada),
        .sincronica_salida(sincronica_salida)
    );
    
    // Generación de reloj (10 MHz - periodo 100 ns)
    always #50 clk = ~clk;
    
    // Procedimiento de prueba
    initial begin
        // Inicializar señales
        clk = 0;
        asincronica_entrada = 0;
        
        // Header de la simulación
        $display("==================================================");
        $display("Testbench para Sincronizador (10 MHz)");
        $display("==================================================");
        $display("Tiempo(ns) | clk | Entrada | Salida | Comentario");
        $display("--------------------------------------------------");
        
        // Esperar inicialización
        #100;
        
        // Test 1: Cambio estable de 0 a 1
        asincronica_entrada = 1;
        #300;
        
        // Test 2: Cambio estable de 1 a 0
        asincronica_entrada = 0;
        #300;
        
        // Test 3: Cambios rápidos (simular rebotes)
        asincronica_entrada = 1;
        #20;
        asincronica_entrada = 0;
        #15;
        asincronica_entrada = 1;
        #25;
        asincronica_entrada = 0;
        #10;
        asincronica_entrada = 1;
        #300;
        
        // Test 4: Cambio durante flanco de reloj
        asincronica_entrada = 0;
        #70;
        asincronica_entrada = 1;
        #200;
        
        // Finalizar simulación
        #200;
        $display("==================================================");
        $display("Simulación completada");
        $display("==================================================");
        $finish;
    end
    
    // Monitoreo de resultados en cada flanco de reloj
    always @(posedge clk) begin
        $display("%9t |  %b  |    %b     |    %b     | Ciclo completado", 
                $time, clk, asincronica_entrada, sincronica_salida);
    end
    
    // Monitoreo de cambios en la entrada asíncrona
    always @(asincronica_entrada) begin
        $display("%9t |  %b  |    %b     |    %b     | Entrada cambió", 
                $time, clk, asincronica_entrada, sincronica_salida);
    end
    
endmodule
