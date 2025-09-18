///////////////////////////////////////////////////////////////////////////////////////////////////
//
// register_file.sv
//
// Este modulo sirve como el banco de registros de la Mini Unidad de Cálculo.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module register_file #(parameter int N = 16, parameter int W = 5)
	(
	input  logic		clk,
	input  logic		rst,
	input  logic    we, Read_mode,
	input  logic [W-1:0]    addr_rd,  // dirección de escritura
	input  logic [N-1:0]    data_in,  // dato a escribir
	input  logic [W-1:0]    addr_rs1, // dirección lectura puerto 1
	input  logic [W-1:0]    addr_rs2, // dirección lectura puerto 2
	input  logic [W-1:0]    addr_rs3, // dirección lectura puerto 3
	output logic [N-1:0]    rs1,      // dato leído puerto 1
	output logic [N-1:0]    rs2,      // dato leído puerto 2
	output logic [N-1:0]    rs3       // dato leído puerto 3
	);

localparam int DEPTH = 1 << W;
logic [N-1:0] mem [0:DEPTH-1];

always_ff @(posedge clk) begin
	if (rst) begin
		for (int i = 0; i < DEPTH; i++) mem[i] <= '0;
	end else if (!Read_mode && we && (addr_rd != '0)) begin
		mem[addr_rd] <= data_in;
	end
end

always_comb begin
	rs1 = (addr_rs1 == '0) ? '0 : mem[addr_rs1];
	rs2 = (addr_rs2 == '0) ? '0 : mem[addr_rs2];
	rs3 = (addr_rs3 == '0) ? '0 : mem[addr_rs3];
end

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////