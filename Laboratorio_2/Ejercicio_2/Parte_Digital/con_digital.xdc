# ============================================================
# Proyecto: Contador con anti-rebote y sincronización
# Autor: Jean
# Fecha: 17 de septiembre de 2025
# Descripción: Archivo de constraints para Vivado
# ============================================================

## ==================== CONFIGURACIÓN GLOBAL ====================
## Configuración del banco 0 para evitar errores de voltaje
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## ==================== RELOJ DE ENTRADA ====================
## Reloj de 100 MHz conectado al pin E3
## NOTA: No se redefine el reloj aquí para evitar conflictos con clk_wiz_0
set_property PACKAGE_PIN E3 [get_ports clk_in1]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in1]

## ==================== RESET (ACTIVO ALTO) ====================
## Reset externo conectado al pin P17
set_property PACKAGE_PIN P17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## ==================== BOTÓN DE ENTRADA ====================
## Botón BTNO conectado al pin M18
set_property PACKAGE_PIN M18 [get_ports boton_entrada]
set_property IOSTANDARD LVCMOS33 [get_ports boton_entrada]

## ==================== SALIDA A LEDS ====================
## LEDs conectados a los pines V11 a V16 (8 bits)
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