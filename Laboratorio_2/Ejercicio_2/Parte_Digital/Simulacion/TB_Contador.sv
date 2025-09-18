`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:06:34
// Design Name: 
// Module Name: TB_Contador
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


module TB_Contador();
// Parámetros
    parameter int N = 8;
    
    // Señales de entrada
    logic clk;
    logic rst;
    logic EN;
    
    // Señales de salida
    logic [N-1:0] Q;
    
    // Instanciar el módulo bajo prueba
    Contador #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .EN(EN),
        .Q(Q)
    );
    
    // Generación de reloj (10 MHz - periodo 100 ns)
    always #50 clk = ~clk;
    
    // Procedimiento de prueba
    initial begin
        // Inicializar señales
        clk = 0;
        rst = 0;  // Reset activo (bajo)
        EN = 0;
        
        // Header de la simulación
        $display("====================================================");
        $display("Testbench para Contador (%0d bits, 10 MHz)", N);
        $display("====================================================");
        $display("Tiempo(ns) | clk | rst | EN |   Q   | Comentario");
        $display("----------------------------------------------------");
        
        // Mantener reset por 2 ciclos
        #200;
        rst = 1;  // Liberar reset
        #100;
        
        // Test 1: Habilitación continua
        EN = 1;
        #1000;  // 10 ciclos de conteo
        
        // Test 2: Deshabilitar
        EN = 0;
        #500;   // 5 ciclos sin contar
        
        // Test 3: Habilitación intermitente
        EN = 1;
        #300;
        EN = 0;
        #200;
        EN = 1;
        #400;
        
        // Test 4: Reset durante operación
        rst = 0;  // Activar reset
        #200;
        rst = 1;  // Liberar reset
        #300;
        
        // Test 5: Overflow del contador
        EN = 1;
        #2000;  // 20 ciclos (para llegar a 255)
        
        // Finalizar simulación
        #200;
        $display("====================================================");
        $display("Simulación completada");
        $display("====================================================");
        $finish;
    end
    
    // Monitoreo de resultados en cada flanco de reloj
    always @(posedge clk) begin
        $display("%9t |  %b  |  %b  |  %b | %3d  | Flanco de reloj", 
                $time, clk, rst, EN, Q);
    end
    
    // Monitoreo de cambios en enable
    always @(EN) begin
        $display("%9t |  %b  |  %b  |  %b | %3d  | EN cambió", 
                $time, clk, rst, EN, Q);
    end
    
    // Monitoreo de reset
    always @(rst) begin
        $display("%9t |  %b  |  %b  |  %b | %3d  | Reset cambió", 
                $time, clk, rst, EN, Q);
    end
    
endmodule
