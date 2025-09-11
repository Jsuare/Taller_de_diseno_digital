/////////////////////////////////////////////////////////////
// Módulo: reg_pipo
// Registro paralelo de N bits con: entrada de 
// habilitación de escritura (we) y valor 
// parametrizable en ancho (WIDTH)
/////////////////////////////////////////////////////////////
module reg_pipo #(
    parameter int WIDTH = 16)(   // ancho de 16 bits
    input  logic                 clk,   
    input  logic                 rst,  
    input  logic                 we,    // Write enable habilitación de nuevo valor
    input  logic [WIDTH-1:0]     d,     // dato de entrada
    output logic [WIDTH-1:0]     q);      // dato almacenado en salida

    always_ff @(posedge clk or posedge rst) begin //proceso secuencial del reloj
        if (rst)//registro a cero 
            q <= '0;
        else if (we)//carga nuevo valor a registro 
            q <= d;
    end
endmodule