//============================================================================
//  Bally Astrocade Core Top for Analogue Pocket
//
//  Copyright (C) 2026 Eric Lewis
//  SPDX-License-Identifier: GPL-3.0-or-later
//
//  Based on Astrocade.sv (MiSTer) by Sorgelig
//  Hardware emulation by MiSTer community
//============================================================================

`default_nettype none

module core_top (

input   wire            clk_74a,
input   wire            clk_74b,

inout   wire    [7:0]   cart_tran_bank2,
output  wire            cart_tran_bank2_dir,
inout   wire    [7:0]   cart_tran_bank3,
output  wire            cart_tran_bank3_dir,
inout   wire    [7:0]   cart_tran_bank1,
output  wire            cart_tran_bank1_dir,
inout   wire    [7:4]   cart_tran_bank0,
output  wire            cart_tran_bank0_dir,
inout   wire            cart_tran_pin30,
output  wire            cart_tran_pin30_dir,
output  wire            cart_pin30_pwroff_reset,
inout   wire            cart_tran_pin31,
output  wire            cart_tran_pin31_dir,
input   wire            port_ir_rx,
output  wire            port_ir_tx,
output  wire            port_ir_rx_disable,
inout   wire            port_tran_si,
output  wire            port_tran_si_dir,
inout   wire            port_tran_so,
output  wire            port_tran_so_dir,
inout   wire            port_tran_sck,
output  wire            port_tran_sck_dir,
inout   wire            port_tran_sd,
output  wire            port_tran_sd_dir,
output  wire    [21:16] cram0_a,
inout   wire    [15:0]  cram0_dq,
input   wire            cram0_wait,
output  wire            cram0_clk,
output  wire            cram0_adv_n,
output  wire            cram0_cre,
output  wire            cram0_ce0_n,
output  wire            cram0_ce1_n,
output  wire            cram0_oe_n,
output  wire            cram0_we_n,
output  wire            cram0_ub_n,
output  wire            cram0_lb_n,
output  wire    [21:16] cram1_a,
inout   wire    [15:0]  cram1_dq,
input   wire            cram1_wait,
output  wire            cram1_clk,
output  wire            cram1_adv_n,
output  wire            cram1_cre,
output  wire            cram1_ce0_n,
output  wire            cram1_ce1_n,
output  wire            cram1_oe_n,
output  wire            cram1_we_n,
output  wire            cram1_ub_n,
output  wire            cram1_lb_n,
output  wire    [12:0]  dram_a,
output  wire    [1:0]   dram_ba,
inout   wire    [15:0]  dram_dq,
output  wire    [1:0]   dram_dqm,
output  wire            dram_clk,
output  wire            dram_cke,
output  wire            dram_ras_n,
output  wire            dram_cas_n,
output  wire            dram_we_n,
output  wire    [16:0]  sram_a,
inout   wire    [15:0]  sram_dq,
output  wire            sram_oe_n,
output  wire            sram_we_n,
output  wire            sram_ub_n,
output  wire            sram_lb_n,
input   wire            vblank,
output  wire            dbg_tx,
input   wire            dbg_rx,
output  wire            user1,
input   wire            user2,
inout   wire            aux_sda,
output  wire            aux_scl,
output  wire            vpll_feed,

// logical
output  wire    [23:0]  video_rgb,
output  wire            video_rgb_clock,
output  wire            video_rgb_clock_90,
output  wire            video_de,
output  wire            video_skip,
output  wire            video_vs,
output  wire            video_hs,
output  wire            audio_mclk,
input   wire            audio_adc,
output  wire            audio_dac,
output  wire            audio_lrck,
output  wire            bridge_endian_little,
input   wire    [31:0]  bridge_addr,
input   wire            bridge_rd,
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data,
input   wire    [31:0]  cont1_key,
input   wire    [31:0]  cont2_key,
input   wire    [31:0]  cont3_key,
input   wire    [31:0]  cont4_key,
input   wire    [31:0]  cont1_joy,
input   wire    [31:0]  cont2_joy,
input   wire    [31:0]  cont3_joy,
input   wire    [31:0]  cont4_joy,
input   wire    [15:0]  cont1_trig,
input   wire    [15:0]  cont2_trig,
input   wire    [15:0]  cont3_trig,
input   wire    [15:0]  cont4_trig
);

// ========================================================================
//  Tie-offs
// ========================================================================

assign port_ir_tx = 0;  assign port_ir_rx_disable = 1;  assign bridge_endian_little = 0;
assign cart_tran_bank3 = 8'hzz; assign cart_tran_bank3_dir = 0;
assign cart_tran_bank2 = 8'hzz; assign cart_tran_bank2_dir = 0;
assign cart_tran_bank1 = 8'hzz; assign cart_tran_bank1_dir = 0;
assign cart_tran_bank0 = 4'hf;  assign cart_tran_bank0_dir = 1;
assign cart_tran_pin30 = 0;     assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 0;
assign cart_tran_pin31 = 1'bz;  assign cart_tran_pin31_dir = 0;
assign port_tran_so = 1'bz;    assign port_tran_so_dir = 0;
assign port_tran_si = 1'bz;    assign port_tran_si_dir = 0;
assign port_tran_sck = 1'bz;   assign port_tran_sck_dir = 0;
assign port_tran_sd = 1'bz;    assign port_tran_sd_dir = 0;
assign cram0_a = 0; assign cram0_dq = {16{1'bZ}}; assign cram0_clk = 0;
assign cram0_adv_n=1; assign cram0_cre=0; assign cram0_ce0_n=1; assign cram0_ce1_n=1;
assign cram0_oe_n=1; assign cram0_we_n=1; assign cram0_ub_n=1; assign cram0_lb_n=1;
assign cram1_a = 0; assign cram1_dq = {16{1'bZ}}; assign cram1_clk = 0;
assign cram1_adv_n=1; assign cram1_cre=0; assign cram1_ce0_n=1; assign cram1_ce1_n=1;
assign cram1_oe_n=1; assign cram1_we_n=1; assign cram1_ub_n=1; assign cram1_lb_n=1;
// No SDRAM used
assign dram_a = 0; assign dram_ba = 0; assign dram_dq = {16{1'bZ}};
assign dram_dqm = 0; assign dram_clk = 0; assign dram_cke = 0;
assign dram_ras_n = 1; assign dram_cas_n = 1; assign dram_we_n = 1;
assign sram_a = 0; assign sram_dq = {16{1'bZ}};
assign sram_oe_n = 1; assign sram_we_n = 1; assign sram_ub_n = 1; assign sram_lb_n = 1;
assign dbg_tx = 1'bZ; assign user1 = 1'bZ; assign aux_scl = 1'bZ; assign vpll_feed = 1'bZ;

// ========================================================================
//  Bridge
// ========================================================================

wire [31:0] cmd_bridge_rd_data;
always @(*) begin
    casex (bridge_addr)
    32'hF8xxxxxx: bridge_rd_data <= cmd_bridge_rd_data;
    default:      bridge_rd_data <= 32'd0;
    endcase
end

wire reset_n;
wire pll_core_locked;
wire pll_core_locked_s;
synch_3 s01 (pll_core_locked, pll_core_locked_s, clk_74a);

wire status_boot_done  = pll_core_locked_s;
wire status_setup_done = pll_core_locked_s;
wire status_running    = reset_n;

wire        dataslot_requestread;
wire [15:0] dataslot_requestread_id;
wire        dataslot_requestread_ack = 1;
wire        dataslot_requestread_ok  = 1;
wire        dataslot_requestwrite;
wire [15:0] dataslot_requestwrite_id;
wire [31:0] dataslot_requestwrite_size;
wire        dataslot_requestwrite_ack = 1;
wire        dataslot_requestwrite_ok  = 1;
wire        dataslot_update;
wire [15:0] dataslot_update_id;
wire [31:0] dataslot_update_size;
wire        dataslot_allcomplete;
wire [31:0] rtc_epoch_seconds, rtc_date_bcd, rtc_time_bcd;
wire        rtc_valid;
wire savestate_supported = 0;
wire [31:0] savestate_addr = 0, savestate_size = 0, savestate_maxloadsize = 0;
wire savestate_start, savestate_load;
wire savestate_start_ack = 0, savestate_start_busy = 0, savestate_start_ok = 0, savestate_start_err = 0;
wire savestate_load_ack = 0, savestate_load_busy = 0, savestate_load_ok = 0, savestate_load_err = 0;
wire osnotify_inmenu;
reg  target_dataslot_read, target_dataslot_write, target_dataslot_getfile, target_dataslot_openfile;
wire target_dataslot_ack, target_dataslot_done;
wire [2:0] target_dataslot_err;
reg [15:0] target_dataslot_id;
reg [31:0] target_dataslot_slotoffset, target_dataslot_bridgeaddr, target_dataslot_length;
wire [31:0] target_buffer_param_struct, target_buffer_resp_struct;
wire [9:0] datatable_addr;
wire datatable_wren;
wire [31:0] datatable_data, datatable_q;

core_bridge_cmd icb (
    .clk(clk_74a), .reset_n(reset_n),
    .bridge_endian_little(bridge_endian_little),
    .bridge_addr(bridge_addr), .bridge_rd(bridge_rd), .bridge_rd_data(cmd_bridge_rd_data),
    .bridge_wr(bridge_wr), .bridge_wr_data(bridge_wr_data),
    .status_boot_done(status_boot_done), .status_setup_done(status_setup_done), .status_running(status_running),
    .dataslot_requestread(dataslot_requestread), .dataslot_requestread_id(dataslot_requestread_id),
    .dataslot_requestread_ack(dataslot_requestread_ack), .dataslot_requestread_ok(dataslot_requestread_ok),
    .dataslot_requestwrite(dataslot_requestwrite), .dataslot_requestwrite_id(dataslot_requestwrite_id),
    .dataslot_requestwrite_size(dataslot_requestwrite_size),
    .dataslot_requestwrite_ack(dataslot_requestwrite_ack), .dataslot_requestwrite_ok(dataslot_requestwrite_ok),
    .dataslot_update(dataslot_update), .dataslot_update_id(dataslot_update_id), .dataslot_update_size(dataslot_update_size),
    .dataslot_allcomplete(dataslot_allcomplete),
    .rtc_epoch_seconds(rtc_epoch_seconds), .rtc_date_bcd(rtc_date_bcd), .rtc_time_bcd(rtc_time_bcd), .rtc_valid(rtc_valid),
    .savestate_supported(savestate_supported), .savestate_addr(savestate_addr), .savestate_size(savestate_size), .savestate_maxloadsize(savestate_maxloadsize),
    .savestate_start(savestate_start), .savestate_start_ack(savestate_start_ack), .savestate_start_busy(savestate_start_busy), .savestate_start_ok(savestate_start_ok), .savestate_start_err(savestate_start_err),
    .savestate_load(savestate_load), .savestate_load_ack(savestate_load_ack), .savestate_load_busy(savestate_load_busy), .savestate_load_ok(savestate_load_ok), .savestate_load_err(savestate_load_err),
    .osnotify_inmenu(osnotify_inmenu),
    .target_dataslot_read(target_dataslot_read), .target_dataslot_write(target_dataslot_write),
    .target_dataslot_getfile(target_dataslot_getfile), .target_dataslot_openfile(target_dataslot_openfile),
    .target_dataslot_ack(target_dataslot_ack), .target_dataslot_done(target_dataslot_done), .target_dataslot_err(target_dataslot_err),
    .target_dataslot_id(target_dataslot_id), .target_dataslot_slotoffset(target_dataslot_slotoffset),
    .target_dataslot_bridgeaddr(target_dataslot_bridgeaddr), .target_dataslot_length(target_dataslot_length),
    .target_buffer_param_struct(target_buffer_param_struct), .target_buffer_resp_struct(target_buffer_resp_struct),
    .datatable_addr(datatable_addr), .datatable_wren(datatable_wren), .datatable_data(datatable_data), .datatable_q(datatable_q)
);

// ========================================================================
//  Clocks
// ========================================================================

wire clk_sys;     // 14.318 MHz
wire clk_vid;     // 7.159 MHz (pixel clock)
wire clk_vid_90;  // 7.159 MHz 90°

pll pll_inst (
    .refclk   (clk_74a),
    .rst      (1'b0),
    .outclk_0 (clk_sys),
    .outclk_1 (clk_vid),
    .outclk_2 (clk_vid_90),
    .locked   (pll_core_locked)
);

// CPU clock enable: clk_sys / 2 = ~7.16 MHz
reg [1:0] clk_cpu_ct;
always @(posedge clk_sys or posedge reset)
    if (reset) clk_cpu_ct <= 0;
    else       clk_cpu_ct <= clk_cpu_ct + 1'd1;

wire clk_cpu_en = clk_cpu_ct[0];

// ========================================================================
//  Reset
// ========================================================================

reg [19:0] reset_counter = 20'd300000;
wire reset = |reset_counter | ioctl_download;

always @(posedge clk_sys)
    if (reset_counter) reset_counter <= reset_counter - 1'd1;

// ========================================================================
//  Video — dedicated pixel clock, no skip
// ========================================================================

assign video_rgb_clock    = clk_vid;
assign video_rgb_clock_90 = clk_vid_90;
assign video_skip = 1'b0;

// Blanking (from Astrocade.sv)
reg [15:0] vsync_ct, hsync_ct;
reg        HSync_r, VSync_r;
wire       VBlank_w = (vsync_ct < 25) || (vsync_ct > 254);
wire       HBlank_w = (hsync_ct >= 214) || (hsync_ct < 34);

// Pixel counter and sync edge detect at pixel clock rate
always @(posedge clk_vid) begin
    hsync_ct <= hsync_ct + 1'd1;
    HSync_r <= hs;
    if (~HSync_r & hs) begin
        vsync_ct <= vsync_ct + 1'd1;
        hsync_ct <= 0;
        VSync_r <= vs;
        if (~VSync_r & vs) vsync_ct <= 0;
    end
end

assign video_rgb = (~HBlank_w & ~VBlank_w) ? {R, 4'd0, G, 4'd0, B, 4'd0} : 24'd0;
assign video_de  = ~HBlank_w & ~VBlank_w;
assign video_vs  = VSync_r;
assign video_hs  = HSync_r;

// ========================================================================
//  Audio — 8-bit mono → I2S
// ========================================================================

assign audio_mclk = audgen_mclk;
assign audio_dac  = audgen_dac;
assign audio_lrck = audgen_lrck;

reg  [21:0] audgen_accum;
reg         audgen_mclk;
parameter [20:0] CYCLE_48KHZ = 21'd122880 * 2;

always @(posedge clk_74a) begin
    audgen_accum <= audgen_accum + CYCLE_48KHZ;
    if (audgen_accum >= 21'd742500) begin
        audgen_mclk  <= ~audgen_mclk;
        audgen_accum <= audgen_accum - 21'd742500 + CYCLE_48KHZ;
    end
end

reg [1:0] aud_mclk_divider;
wire      audgen_sclk = aud_mclk_divider[1];
always @(posedge audgen_mclk) aud_mclk_divider <= aud_mclk_divider + 1'b1;

reg  [4:0]  audgen_lrck_cnt;
reg         audgen_lrck;
reg         audgen_dac;
reg  [15:0] audgen_shift;

// Expand 8-bit unsigned mono to 16-bit signed
reg [15:0] aud_sample;
always @(posedge clk_74a) begin
    // audio is 8-bit unsigned — convert to 16-bit signed
    aud_sample <= {~audio[7], audio[6:0], audio};
end

always @(negedge audgen_sclk) begin
    audgen_lrck_cnt <= audgen_lrck_cnt + 1'b1;
    if (audgen_lrck_cnt == 5'd31) audgen_lrck <= ~audgen_lrck;
    if (audgen_lrck_cnt == 5'd0)  audgen_shift <= aud_sample;
    audgen_dac   <= audgen_shift[15];
    audgen_shift <= {audgen_shift[14:0], 1'b0};
end

// ========================================================================
//  BALLY Astrocade Core
// ========================================================================

wire [7:0] audio;
wire [3:0] R, G, B;
wire       hs, vs;

wire [12:0] cart_addr;
wire  [7:0] cart_di, cart_do;
wire        cart_rd;

wire [12:0] bios_addr_core;
wire  [7:0] bios_do;
wire        bios_rd;

wire  [7:0] col_select;
wire  [7:0] row_data;
wire  [3:0] pot_select;

BALLY bally (
    .O_AUDIO       (audio),
    .O_VIDEO_R     (R),
    .O_VIDEO_G     (G),
    .O_VIDEO_B     (B),
    .O_CE_PIX      (),
    .O_HBLANK_V    (),
    .O_VBLANK_V    (),
    .O_HSYNC       (hs),
    .O_VSYNC       (vs),
    .O_COMP_SYNC_L (),
    .O_FPSYNC      (),
    .O_CAS_ADDR    (cart_addr),
    .O_CAS_DATA    (cart_di),
    .I_CAS_DATA    (cart_do),
    .O_CAS_CS_L    (cart_rd),
    .O_BIOS_ADDR   (bios_addr_core),
    .O_BIOS_CS_L   (bios_rd),
    .I_BIOS_DATA   (bios_do),
    .O_EXP_ADDR    (),
    .O_EXP_DATA    (8'hFF),
    .I_EXP_DATA    (),
    .I_EXP_OE_L    (1'b1),
    .O_EXP_M1_L    (),
    .O_EXP_MREQ_L  (),
    .O_EXP_IORQ_L  (),
    .O_EXP_WR_L    (),
    .O_EXP_RD_L    (),
    .O_SWITCH_COL  (col_select),
    .I_SWITCH_ROW  (row_data),
    .O_POT         (pot_select),
    .I_POT         (pot_data),
    .I_RESET_L     (~reset),
    .ENA           (clk_cpu_en),
    .CLK           (clk_sys)
);

// ========================================================================
//  Input
// ========================================================================

// Map Pocket controllers to Astrocade joystick format
// joya/b: [3:0]=R,L,D,U [4]=fire [5+]=keypad
wire [31:0] joya = {27'd0, cont1_key[4], cont1_key[3], cont1_key[2], cont1_key[1], cont1_key[0]};
wire [31:0] joyb = {27'd0, cont2_key[4], cont2_key[3], cont2_key[2], cont2_key[1], cont2_key[0]};
wire [31:0] joyc = {27'd0, cont3_key[4], cont3_key[3], cont3_key[2], cont3_key[1], cont3_key[0]};
wire [31:0] joyd = {27'd0, cont4_key[4], cont4_key[3], cont4_key[2], cont4_key[1], cont4_key[0]};

bally_input bally_input_inst (
    .clk_sys   (clk_sys),
    .joya      (joya),
    .joyb      (joyb),
    .joyc      (joyc),
    .joyd      (joyd),
    .ps2_key   (11'd0),
    .col_select(col_select),
    .row_data  (row_data)
);

// Paddles — use analog sticks
wire [7:0] pot_data =
    (pot_select[0] ? cont1_joy[7:0]  : 8'hFF) &
    (pot_select[1] ? cont2_joy[7:0]  : 8'hFF) &
    (pot_select[2] ? cont3_joy[7:0]  : 8'hFF) &
    (pot_select[3] ? cont4_joy[7:0]  : 8'hFF);

// ========================================================================
//  ROM / BIOS (dual-port RAM, loaded via ioctl)
// ========================================================================

// ROM loading via data_loader (agg23 utility)
// Slot 0 (BIOS) loads at 0x0xxxxxxx, Slot 1 (cart) at 0x1xxxxxxx
always @(posedge clk_74a) begin
    target_dataslot_read <= 0; target_dataslot_write <= 0;
    target_dataslot_getfile <= 0; target_dataslot_openfile <= 0;
end

// BIOS loader (address mask 0x0)
wire        bios_wr;
wire [27:0] bios_addr;
wire  [7:0] bios_data_dl;

data_loader #(.ADDRESS_MASK_UPPER_4(4'h0), .ADDRESS_SIZE(28)) bios_loader (
    .clk_74a(clk_74a), .clk_memory(clk_sys),
    .bridge_wr(bridge_wr), .bridge_endian_little(bridge_endian_little),
    .bridge_addr(bridge_addr), .bridge_wr_data(bridge_wr_data),
    .write_en(bios_wr), .write_addr(bios_addr), .write_data(bios_data_dl)
);

// Cart loader (address mask 0x1)
wire        cart_wr_dl;
wire [27:0] cart_addr_dl;
wire  [7:0] cart_data_dl;

data_loader #(.ADDRESS_MASK_UPPER_4(4'h1), .ADDRESS_SIZE(28)) cart_loader (
    .clk_74a(clk_74a), .clk_memory(clk_sys),
    .bridge_wr(bridge_wr), .bridge_endian_little(bridge_endian_little),
    .bridge_addr(bridge_addr), .bridge_wr_data(bridge_wr_data),
    .write_en(cart_wr_dl), .write_addr(cart_addr_dl), .write_data(cart_data_dl)
);

// Track download state
reg ioctl_download = 0;
always @(posedge clk_74a) begin
    if (dataslot_requestwrite) ioctl_download <= 1;
    if (dataslot_allcomplete)  ioctl_download <= 0;
end
reg dl_s0, dl_s1;
always @(posedge clk_sys) begin dl_s0 <= ioctl_download; dl_s1 <= dl_s0; end
wire downloading = dl_s1;

// Cartridge ROM (8KB) — loaded from slot 1 via cart_loader
dpram #(13) rom (
    .clock     (clk_sys),
    .address_a (downloading ? cart_addr_dl[12:0] : cart_addr),
    .data_a    (cart_data_dl),
    .wren_a    (cart_wr_dl),
    .q_a       (cart_do)
);

// BIOS ROM (8KB) — loaded from slot 0 via bios_loader
dpram #(13) bios (
    .clock     (clk_sys),
    .address_a (downloading ? bios_addr[12:0] : bios_addr_core),
    .data_a    (bios_data_dl),
    .wren_a    (bios_wr),
    .q_a       (bios_do)
);

endmodule
