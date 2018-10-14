##-----------------------------------------------------------------------------
##
## (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
##-----------------------------------------------------------------------------
##
## Project    : UltraScale+ FPGA PCI Express v4.0 Integrated Block
## File       : MA-X1.xdc
## Version    : 1.3
##-----------------------------------------------------------------------------
#
###############################################################################
# Vivado - PCIe GUI / User Configuration
###############################################################################
#
# Link Speed   - Gen3 - 8.0 Gb/s
# Link Width   - X16
# AXIST Width  - 512-bit
# AXIST Frequ  - 250 MHz = User Clock
# Core Clock   - 500 MHz
# Pipe Clock   - 125 MHz (Gen1) / 250 MHz (Gen2/Gen3/Gen4)
#
# Family       - virtexuplus
# Part         - xcvu9p
# Package      - flgb2104
# Speed grade  - 2L-e
# PCIe Block   - X1Y2
#
#
# PLL TYPE     - QPLL1
#
###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 10.000 -name sys_clk [get_ports sys_clk_p]
#
set_false_path -from [get_ports sys_rst_n]
set_property PULLUP true [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS12 [get_ports sys_rst_n]
#
#
#
#
#
#
# CLOCK_ROOT LOCKing to Reduce CLOCK SKEW
# Add/Edit  Clock Routing Option to improve clock path skew
#set_property USER_CLOCK_ROOT X5Y6 [get_nets -of_objects [get_pins pcie4_uscale_plus_0_i/inst//bufg_gt_sysclk/O]]
#
# BITFILE/BITSTREAM compress options
# Flash type constraints. These should be modified to match the target board.
#set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]



#set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
#set_property CONFIG_MODE BPI16 [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
#
#
#
#
# sys_clk vs TXOUTCLK
set_clock_groups -name async18 -asynchronous -group [get_clocks sys_clk] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -name async19 -asynchronous -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks sys_clk]
#
#
#
#
#
#
# ASYNC CLOCK GROUPINGS
# sys_clk vs user_clk
set_clock_groups -name async5 -asynchronous -group [get_clocks sys_clk] -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_clock_groups -name async6 -asynchronous -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -group [get_clocks sys_clk]
# sys_clk vs pclk
set_clock_groups -name async1 -asynchronous -group [get_clocks sys_clk] -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/O]]
set_clock_groups -name async2 -asynchronous -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/O]] -group [get_clocks sys_clk]
#
#
#
#
# Add/Edit Pblock slice constraints for 512b soft logic to improve timing
#create_pblock soft_512b; add_cells_to_pblock [get_pblocks soft_512b] [get_cells {pcie4_uscale_plus_0_i/inst/pcie_4_0_pipe_inst/pcie_4_0_init_ctrl_inst pcie4_uscale_plus_0_i/inst/pcie_4_0_pipe_inst/pcie4_0_512b_intfc_mod}]
# Keep This Logic Left/Right Side Of The PCIe Block (Whichever is near to the FPGA Boundary)
#resize_pblock [get_pblocks soft_512b] -add {SLICE_X157Y300:SLICE_X168Y370}
#set_property EXCLUDE_PLACEMENT 1 [get_pblocks soft_512b]
#
set_clock_groups -name async24 -asynchronous -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]] -group [get_clocks sys_clk]


#set_property IOSTANDARD LVDS [get_ports clk_300MHz_n]
#set_property PACKAGE_PIN AY37 [get_ports clk_300MHz_p]
#set_property PACKAGE_PIN AY38 [get_ports clk_300MHz_n]
#set_property IOSTANDARD LVDS [get_ports clk_300MHz_p]


set_false_path -from [get_clocks -of_objects [get_pins clk_wiz/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_false_path -from [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins clk_wiz/inst/mmcme4_adv_inst/CLKOUT0]]



#create_pblock pblock_0
#add_cells_to_pblock [get_pblocks pblock_0] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[0].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[1].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[2].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[3].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[4].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[5].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[6].core}]]
#resize_pblock [get_pblocks pblock_0] -add {CLOCKREGION_X0Y0:CLOCKREGION_X5Y4}
#create_pblock pblock_1
#add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[10].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[11].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[12].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[13].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[7].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[8].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[9].core}]]
#resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X0Y5:CLOCKREGION_X5Y9}
#create_pblock pblock_2
#add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[14].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[15].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[16].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[17].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[18].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[19].core} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[20].core}]]
#resize_pblock [get_pblocks pblock_2] -add {CLOCKREGION_X0Y10:CLOCKREGION_X5Y14}

#set_property MARK_DEBUG true [get_nets pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/lic_valid]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[9]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[9]}]
#set_property MARK_DEBUG true [get_nets pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/user_temp_alarm_out]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[0]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[10]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[11]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[12]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[13]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[14]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[15]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[16]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[17]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[18]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[19]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[1]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[20]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[21]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[22]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[23]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[24]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[25]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[26]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[27]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[28]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[29]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[2]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[30]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[31]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[32]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[33]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[34]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[35]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[36]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[37]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[38]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[39]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[3]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[40]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[41]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[42]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[43]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[44]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[45]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[46]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[47]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[48]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[49]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[4]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[50]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[51]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[52]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[53]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[54]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[55]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[56]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[57]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[58]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[59]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[5]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[60]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[61]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[62]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[63]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[64]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[65]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[66]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[67]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[68]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[69]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[6]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[70]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[71]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[72]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[73]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[74]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[75]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[76]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[77]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[78]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[79]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[7]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[80]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[81]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[82]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[83]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[84]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[85]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[86]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[87]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[88]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[89]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[8]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[90]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[91]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[92]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[93]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[94]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[95]}]
#set_property MARK_DEBUG true [get_nets {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[9]}]
#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/CLK_USERCLK]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 32 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch3_reg[31]}]]
#create_debug_core u_ila_1 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
#set_property port_width 1 [get_debug_ports u_ila_1/clk]
#connect_debug_port u_ila_1/clk [get_nets [list clk_wiz/inst/clk_out2]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
#set_property port_width 96 [get_debug_ports u_ila_1/probe0]
#connect_debug_port u_ila_1/probe0 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[31]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[32]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[33]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[34]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[35]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[36]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[37]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[38]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[39]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[40]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[41]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[42]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[43]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[44]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[45]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[46]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[47]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[48]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[49]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[50]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[51]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[52]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[53]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[54]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[55]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[56]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[57]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[58]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[59]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[60]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[61]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[62]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[63]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[64]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[65]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[66]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[67]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[68]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[69]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[70]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[71]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[72]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[73]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[74]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[75]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[76]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[77]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[78]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[79]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[80]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[81]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[82]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[83]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[84]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[85]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[86]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[87]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[88]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[89]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[90]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[91]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[92]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[93]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[94]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/dna0/DNA_value_reg[94]_0[95]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 32 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch2_reg[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 32 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch0_reg[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 32 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/scratch1_reg[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 32 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data10[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 32 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data8[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 32 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[0]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[1]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[2]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[3]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[4]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[5]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[6]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[7]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[8]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[9]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[10]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[11]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[12]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[13]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[14]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[15]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[16]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[17]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[18]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[19]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[20]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[21]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[22]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[23]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[24]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[25]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[26]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[27]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[28]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[29]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[30]} {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/data9[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 1 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/lic_valid]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 1 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list pcie4_uscale_plus_0_i/inst/store_ltssm]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 1 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[0]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
#set_property port_width 1 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
#set_property port_width 1 [get_debug_ports u_ila_0/probe11]
#connect_debug_port u_ila_0/probe11 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[2]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
#set_property port_width 1 [get_debug_ports u_ila_0/probe12]
#connect_debug_port u_ila_0/probe12 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[3]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
#set_property port_width 1 [get_debug_ports u_ila_0/probe13]
#connect_debug_port u_ila_0/probe13 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[4]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
#set_property port_width 1 [get_debug_ports u_ila_0/probe14]
#connect_debug_port u_ila_0/probe14 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
#set_property port_width 1 [get_debug_ports u_ila_0/probe15]
#connect_debug_port u_ila_0/probe15 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[6]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
#set_property port_width 1 [get_debug_ports u_ila_0/probe16]
#connect_debug_port u_ila_0/probe16 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
#set_property port_width 1 [get_debug_ports u_ila_0/probe17]
#connect_debug_port u_ila_0/probe17 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[8]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
#set_property port_width 1 [get_debug_ports u_ila_0/probe18]
#connect_debug_port u_ila_0/probe18 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[9]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
#set_property port_width 1 [get_debug_ports u_ila_0/probe19]
#connect_debug_port u_ila_0/probe19 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[10]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
#set_property port_width 1 [get_debug_ports u_ila_0/probe20]
#connect_debug_port u_ila_0/probe20 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[11]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
#set_property port_width 1 [get_debug_ports u_ila_0/probe21]
#connect_debug_port u_ila_0/probe21 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[12]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
#set_property port_width 1 [get_debug_ports u_ila_0/probe22]
#connect_debug_port u_ila_0/probe22 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[13]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
#set_property port_width 1 [get_debug_ports u_ila_0/probe23]
#connect_debug_port u_ila_0/probe23 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[14]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
#set_property port_width 1 [get_debug_ports u_ila_0/probe24]
#connect_debug_port u_ila_0/probe24 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[15]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
#set_property port_width 1 [get_debug_ports u_ila_0/probe25]
#connect_debug_port u_ila_0/probe25 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[16]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
#set_property port_width 1 [get_debug_ports u_ila_0/probe26]
#connect_debug_port u_ila_0/probe26 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[17]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
#set_property port_width 1 [get_debug_ports u_ila_0/probe27]
#connect_debug_port u_ila_0/probe27 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[18]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
#set_property port_width 1 [get_debug_ports u_ila_0/probe28]
#connect_debug_port u_ila_0/probe28 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[19]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
#set_property port_width 1 [get_debug_ports u_ila_0/probe29]
#connect_debug_port u_ila_0/probe29 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[20]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
#set_property port_width 1 [get_debug_ports u_ila_0/probe30]
#connect_debug_port u_ila_0/probe30 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[21]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
#set_property port_width 1 [get_debug_ports u_ila_0/probe31]
#connect_debug_port u_ila_0/probe31 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[22]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
#set_property port_width 1 [get_debug_ports u_ila_0/probe32]
#connect_debug_port u_ila_0/probe32 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[23]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
#set_property port_width 1 [get_debug_ports u_ila_0/probe33]
#connect_debug_port u_ila_0/probe33 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[24]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
#set_property port_width 1 [get_debug_ports u_ila_0/probe34]
#connect_debug_port u_ila_0/probe34 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[25]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
#set_property port_width 1 [get_debug_ports u_ila_0/probe35]
#connect_debug_port u_ila_0/probe35 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[26]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
#set_property port_width 1 [get_debug_ports u_ila_0/probe36]
#connect_debug_port u_ila_0/probe36 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[27]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
#set_property port_width 1 [get_debug_ports u_ila_0/probe37]
#connect_debug_port u_ila_0/probe37 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[28]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
#set_property port_width 1 [get_debug_ports u_ila_0/probe38]
#connect_debug_port u_ila_0/probe38 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[29]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
#set_property port_width 1 [get_debug_ports u_ila_0/probe39]
#connect_debug_port u_ila_0/probe39 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[30]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
#set_property port_width 1 [get_debug_ports u_ila_0/probe40]
#connect_debug_port u_ila_0/probe40 [get_nets [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/text_out_reg_reg_n_0_[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
#set_property port_width 1 [get_debug_ports u_ila_0/probe41]
#connect_debug_port u_ila_0/probe41 [get_nets [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/user_temp_alarm_out]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets slowclock]


set_false_path -from [get_clocks -of_objects [get_pins clk_wiz/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]


#create_pblock pblock_jh_core1
#add_cells_to_pblock [get_pblocks pblock_jh_core1] [get_cells -quiet [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/core0/jh_core1]]
#resize_pblock [get_pblocks pblock_jh_core1] -add {SLICE_X142Y0:SLICE_X168Y299}
#resize_pblock [get_pblocks pblock_jh_core1] -add {DSP48E2_X17Y0:DSP48E2_X18Y119}
#resize_pblock [get_pblocks pblock_jh_core1] -add {LAGUNA_X20Y0:LAGUNA_X23Y239}
#resize_pblock [get_pblocks pblock_jh_core1] -add {RAMB18_X10Y0:RAMB18_X11Y119}
#resize_pblock [get_pblocks pblock_jh_core1] -add {RAMB36_X10Y0:RAMB36_X11Y59}
#create_pblock pblock_jh_core2
#add_cells_to_pblock [get_pblocks pblock_jh_core2] [get_cells -quiet [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/core0/jh_core2]]
#resize_pblock [get_pblocks pblock_jh_core2] -add {SLICE_X117Y0:SLICE_X141Y299}
#resize_pblock [get_pblocks pblock_jh_core2] -add {DSP48E2_X14Y0:DSP48E2_X15Y119}
#resize_pblock [get_pblocks pblock_jh_core2] -add {LAGUNA_X16Y0:LAGUNA_X19Y239}
#resize_pblock [get_pblocks pblock_jh_core2] -add {RAMB18_X9Y0:RAMB18_X9Y119}
#resize_pblock [get_pblocks pblock_jh_core2] -add {RAMB36_X9Y0:RAMB36_X9Y59}
#resize_pblock [get_pblocks pblock_jh_core2] -add {URAM288_X3Y0:URAM288_X3Y79}
#create_pblock pblock_keccak_inst
#add_cells_to_pblock [get_pblocks pblock_keccak_inst] [get_cells -quiet [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/core0/keccak_inst]]
#resize_pblock [get_pblocks pblock_keccak_inst] -add {SLICE_X93Y0:SLICE_X116Y299}
#resize_pblock [get_pblocks pblock_keccak_inst] -add {DSP48E2_X12Y0:DSP48E2_X13Y119}
#resize_pblock [get_pblocks pblock_keccak_inst] -add {LAGUNA_X14Y0:LAGUNA_X15Y239}
#resize_pblock [get_pblocks pblock_keccak_inst] -add {RAMB18_X7Y0:RAMB18_X8Y119}
#resize_pblock [get_pblocks pblock_keccak_inst] -add {RAMB36_X7Y0:RAMB36_X8Y59}
#resize_pblock [get_pblocks pblock_keccak_inst] -add {URAM288_X2Y0:URAM288_X2Y79}
#create_pblock pblock_echo_core
#add_cells_to_pblock [get_pblocks pblock_echo_core] [get_cells -quiet [list pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/core0/echo_core]]
#resize_pblock [get_pblocks pblock_echo_core] -add {SLICE_X0Y0:SLICE_X92Y299}
#resize_pblock [get_pblocks pblock_echo_core] -add {DSP48E2_X0Y0:DSP48E2_X10Y119}
#resize_pblock [get_pblocks pblock_echo_core] -add {LAGUNA_X0Y0:LAGUNA_X13Y239}
#resize_pblock [get_pblocks pblock_echo_core] -add {RAMB18_X0Y0:RAMB18_X6Y119}
#resize_pblock [get_pblocks pblock_echo_core] -add {RAMB36_X0Y0:RAMB36_X6Y59}
#resize_pblock [get_pblocks pblock_echo_core] -add {URAM288_X0Y0:URAM288_X1Y79}
#create_pblock pblock_jh_core1_1
#add_cells_to_pblock [get_pblocks pblock_jh_core1_1] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[1].core/jh_core1}]]
#resize_pblock [get_pblocks pblock_jh_core1_1] -add {SLICE_X142Y300:SLICE_X168Y599}
#resize_pblock [get_pblocks pblock_jh_core1_1] -add {DSP48E2_X17Y120:DSP48E2_X18Y239}
#resize_pblock [get_pblocks pblock_jh_core1_1] -add {LAGUNA_X20Y240:LAGUNA_X23Y479}
#resize_pblock [get_pblocks pblock_jh_core1_1] -add {RAMB18_X10Y120:RAMB18_X11Y239}
#resize_pblock [get_pblocks pblock_jh_core1_1] -add {RAMB36_X10Y60:RAMB36_X11Y119}
#create_pblock pblock_jh_core2_1
#add_cells_to_pblock [get_pblocks pblock_jh_core2_1] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[1].core/jh_core2}]]
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {SLICE_X117Y300:SLICE_X141Y599}
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {DSP48E2_X14Y120:DSP48E2_X16Y239}
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {LAGUNA_X16Y240:LAGUNA_X19Y479}
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {RAMB18_X9Y120:RAMB18_X9Y239}
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {RAMB36_X9Y60:RAMB36_X9Y119}
#resize_pblock [get_pblocks pblock_jh_core2_1] -add {URAM288_X3Y80:URAM288_X3Y159}
#create_pblock pblock_keccak_inst_1
#add_cells_to_pblock [get_pblocks pblock_keccak_inst_1] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[1].core/keccak_inst}]]
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {SLICE_X93Y300:SLICE_X116Y599}
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {DSP48E2_X12Y120:DSP48E2_X13Y239}
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {LAGUNA_X14Y240:LAGUNA_X15Y479}
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {RAMB18_X7Y120:RAMB18_X8Y239}
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {RAMB36_X7Y60:RAMB36_X8Y119}
#resize_pblock [get_pblocks pblock_keccak_inst_1] -add {URAM288_X2Y80:URAM288_X2Y159}
#create_pblock pblock_echo_core_1
#add_cells_to_pblock [get_pblocks pblock_echo_core_1] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[1].core/echo_core}]]
#resize_pblock [get_pblocks pblock_echo_core_1] -add {SLICE_X0Y300:SLICE_X92Y599}
#resize_pblock [get_pblocks pblock_echo_core_1] -add {DSP48E2_X0Y120:DSP48E2_X10Y239}
#resize_pblock [get_pblocks pblock_echo_core_1] -add {LAGUNA_X0Y240:LAGUNA_X13Y479}
#resize_pblock [get_pblocks pblock_echo_core_1] -add {RAMB18_X0Y120:RAMB18_X6Y239}
#resize_pblock [get_pblocks pblock_echo_core_1] -add {RAMB36_X0Y60:RAMB36_X6Y119}
#resize_pblock [get_pblocks pblock_echo_core_1] -add {URAM288_X0Y80:URAM288_X1Y159}
#create_pblock pblock_jh_core1_2
#add_cells_to_pblock [get_pblocks pblock_jh_core1_2] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[2].core/jh_core1}]]
#resize_pblock [get_pblocks pblock_jh_core1_2] -add {SLICE_X142Y600:SLICE_X168Y899}
#resize_pblock [get_pblocks pblock_jh_core1_2] -add {DSP48E2_X17Y240:DSP48E2_X18Y359}
#resize_pblock [get_pblocks pblock_jh_core1_2] -add {LAGUNA_X20Y480:LAGUNA_X23Y719}
#resize_pblock [get_pblocks pblock_jh_core1_2] -add {RAMB18_X10Y240:RAMB18_X11Y359}
#resize_pblock [get_pblocks pblock_jh_core1_2] -add {RAMB36_X10Y120:RAMB36_X11Y179}
#create_pblock pblock_jh_core2_2
#add_cells_to_pblock [get_pblocks pblock_jh_core2_2] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[2].core/jh_core2}]]
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {SLICE_X117Y600:SLICE_X141Y899}
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {DSP48E2_X14Y240:DSP48E2_X16Y359}
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {LAGUNA_X16Y480:LAGUNA_X19Y719}
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {RAMB18_X9Y240:RAMB18_X9Y359}
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {RAMB36_X9Y120:RAMB36_X9Y179}
#resize_pblock [get_pblocks pblock_jh_core2_2] -add {URAM288_X3Y160:URAM288_X3Y239}
#create_pblock pblock_keccak_inst_2
#add_cells_to_pblock [get_pblocks pblock_keccak_inst_2] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[2].core/keccak_inst}]]
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {SLICE_X93Y600:SLICE_X116Y899}
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {DSP48E2_X12Y240:DSP48E2_X13Y359}
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {LAGUNA_X14Y480:LAGUNA_X15Y719}
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {RAMB18_X7Y240:RAMB18_X8Y359}
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {RAMB36_X7Y120:RAMB36_X8Y179}
#resize_pblock [get_pblocks pblock_keccak_inst_2] -add {URAM288_X2Y160:URAM288_X2Y239}
#create_pblock pblock_echo_core_2
#add_cells_to_pblock [get_pblocks pblock_echo_core_2] [get_cells -quiet [list {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/shell_loop[2].core/echo_core}]]
#resize_pblock [get_pblocks pblock_echo_core_2] -add {SLICE_X0Y600:SLICE_X92Y899}
#resize_pblock [get_pblocks pblock_echo_core_2] -add {DSP48E2_X0Y240:DSP48E2_X10Y359}
#resize_pblock [get_pblocks pblock_echo_core_2] -add {LAGUNA_X0Y480:LAGUNA_X13Y719}
#resize_pblock [get_pblocks pblock_echo_core_2] -add {RAMB18_X0Y240:RAMB18_X6Y359}
#resize_pblock [get_pblocks pblock_echo_core_2] -add {RAMB36_X0Y120:RAMB36_X6Y179}
#resize_pblock [get_pblocks pblock_echo_core_2] -add {URAM288_X0Y160:URAM288_X1Y239}



#MA-X1
set_property PACKAGE_PIN AK11 [get_ports sys_clk_p]

set_property PACKAGE_PIN AR26 [get_ports sys_rst_n]
set_property PACKAGE_PIN AY23 [get_ports clk_100MHz_p]

set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports clk_100MHz_p]

set_property PACKAGE_PIN BD23 [get_ports fan_pwm0]
set_property PACKAGE_PIN BE23 [get_ports fan_pwm1]
set_property IOSTANDARD LVCMOS18 [get_ports fan_pwm0]
set_property IOSTANDARD LVCMOS18 [get_ports fan_pwm1]
