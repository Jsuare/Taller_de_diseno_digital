# Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
# syc_clk will be constrained by the MIG IP; commenting it avoids double clock definition and overridden clock definition warnings
create_clock -name sys_clk_pin -period 100.00 -waveform {0 50} [get_ports {clk}];


##Switches

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { sw }]; #IO_L24N_T3_RS0_15 Sch=sw[0]


## LEDs

set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }]; # Suma
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }]; # Resta
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { leds[2] }]; # AND
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { leds[3] }]; # OR
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { leds[4] }]; # Op_result
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { leds[5] }]; # B
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { leds[6] }]; # A


##7 segment display

set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[0] }];
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[1] }];
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[2] }];
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[3] }];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[4] }];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[5] }];
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { a_to_g[6] }];
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { dp }];

set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { an[2] }];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { an[3] }];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { an[4] }];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { an[5] }];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { an[6] }];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { an[7] }];


##Buttons

set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { rst }]; #rst
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { boton[0] }]; # Suma
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { boton[1] }]; # Resta
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { boton[2] }]; # AND
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { boton[3] }]; # OR
