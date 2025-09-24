set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## ================================
## CLOCK PRINCIPAL (100 MHz)
## ================================
set_property PACKAGE_PIN E3 [get_ports clk_in1]        ;# Pin del reloj 100 MHz de la FPGA
set_property IOSTANDARD LVCMOS33 [get_ports clk_in1]


## ================================
## RESET (activo alto)
## ================================
set_property PACKAGE_PIN P17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## ================================
## BOTÓN EXTERNO (entrada limpia por hardware)
## ================================
set_property PACKAGE_PIN C17 [get_ports boton_entrada]
set_property IOSTANDARD LVCMOS33 [get_ports boton_entrada]
set_property PULLDOWN true [get_ports boton_entrada]   ;# asegura que está en 0 si queda flotante

## ================================
## LEDS (usamos 8 LEDs)
## ================================
set_property PACKAGE_PIN V11 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]

set_property PACKAGE_PIN V12 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]

set_property PACKAGE_PIN V14 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]

set_property PACKAGE_PIN V15 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]

set_property PACKAGE_PIN T16 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]

set_property PACKAGE_PIN U14 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]

set_property PACKAGE_PIN T15 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]

set_property PACKAGE_PIN V16 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]

