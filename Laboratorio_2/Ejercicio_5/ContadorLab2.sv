///////////////////////////////////////////////////////////////////////////////////////////////////
//
// ContadorLab2.sv
//
// Este modulo sirve como un contador que suma 1 a su salida 'cont' cada vez que se activa su
// entrada 'WE' y resetea la salida 'cont' cuando se activa 'rst' o cuando 'cont' llega a 31.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module ContadorLab2 (
                    input logic clk, rst, WE, Read_mode,
                    output logic [4:0] cont
                    );

logic read_mode_d;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        read_mode_d <= 0;
        cont <= 1;
    end
    else begin
        read_mode_d <= Read_mode;
        if (Read_mode & ~read_mode_d) begin
            // Solo se ejecuta cuando read_mode sube de 0 a 1
            cont <= 1;
        end
        else if (WE) begin
            if (cont == 31)     // Si 'cont' llega a 31, se resetea a 1
                cont <= 1;
            else
                cont <= cont + 1;   // Se activa 'WE', 'cont' aumenta en 1
        end
    end
end


endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////