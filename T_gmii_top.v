//
// REPEATER
// EFINIX Trion Ti180 M484 Development Kit
// @shibatchii
// 2024/01/14
//
`timescale 1ns/1ps

module T_gmii_top;

// Dump Wave
initial begin
  $dumpvars();
end //

  reg         ARSTN;  // 非同期リセット
  reg         PHYRSTN;// 非同期リセット
  reg   [7:0] RXD_0;  // 受信データ 0
  reg         RXDV_0; // 受信有効 0
  reg         RXER_0; // 受信エラー 0
  reg         INTB_0; // 割り込み 0
  reg   [7:0] RXD_1;  // 受信データ 1
  reg         RXDV_1; // 受信有効 1
  reg         RXER_1; // 受信エラー 1
  reg         INTB_1; // 割り込み 1
  reg         MDIOI_0;// 管理データ入力 0
  reg         MDIOI_1;// 管理データ入力 1

  wire  [3:2] LED;    // LED
  wire        TCLK_0; // 送信クロック 0
  wire  [7:0] TXD_0;  // 送信データ 0
  wire        TXEN_0; // 送信可 0
  wire        TXER_0; // 送信エラー 0
  wire        MDC_0;  // 管理クロック 0
  wire        RSTN_0; // リセット 0
  wire        TCLK_1; // 送信クロック 1
  wire  [7:0] TXD_1;  // 送信データ 1
  wire        TXEN_1; // 送信可 1
  wire        TXER_1; // 送信エラー 1
  wire        MDC_1;  // 管理クロック 1
  wire        RSTN_1; // リセット 1
  wire        MDIOO_0;// 管理データ出力 0
  wire        MDIOO_1;// 管理データ出力 1
  wire        MDIOE_0;// 管理データ制御 0
  wire        MDIOE_1;// 管理データ制御 1

  reg       RTL_CLOCK;

gmii_top gmii_top (
  .ARSTN  (ARSTN        ),  // I      非同期リセット
  .PHYRSTN(PHYRSTN      ),  // I      PHYリセット
  .RCLK_0 (RTL_CLOCK    ),  // I      受信クロック 0
  .PLL_RCLK_0 (RTL_CLOCK),  // I      PLL受信クロック 0
  .PLL_RCLK_1 (RTL_CLOCK),  // I      PLL受信クロック 1
  .RXD_0  (RXD_0  [7:0] ),  // I [7:0]受信データ 0
  .RXDV_0 (RXDV_0       ),  // I      受信有効 0
  .RXER_0 (RXER_0       ),  // I      受信エラー 0
  .INTB_0 (INTB_0       ),  // I      割り込み 0
  .RCLK_1 (RTL_CLOCK    ),  // I      受信クロック 1
  .RXD_1  (RXD_1  [7:0] ),  // I [7:0] 受信データ 1
  .RXDV_1 (RXDV_1       ),  // I      受信有効 1
  .RXER_1 (RXER_1       ),  // I      受信エラー 1
  .INTB_1 (INTB_1       ),  // I      割り込み 1
  .MDIOI_0(MDIOI_0      ),  // I      管理データ入力 0
  .MDIOI_1(MDIOI_1      ),  // I      管理データ入力 1
  .LED    (LED    [3:2] ),  // O [3:2]LED
  .TCLK_0 (TCLK_0       ),  // O      送信クロック 0
  .TXD_0  (TXD_0  [7:0] ),  // O [7:0] 送信データ 0
  .TXEN_0 (TXEN_0       ),  // O      送信可 0
  .TXER_0 (TXER_0       ),  // O      送信エラー 0
  .MDC_0  (MDC_0        ),  // O      管理クロック 0
  .RSTN_0 (RSTN_0       ),  // O      リセット 0
  .TCLK_1 (TCLK_1       ),  // O      送信クロック 1
  .TXD_1  (TXD_1  [7:0] ),  // O [7:0]送信データ 1
  .TXEN_1 (TXEN_1       ),  // O      送信可 1
  .TXER_1 (TXER_1       ),  // O      送信エラー 1
  .MDC_1  (MDC_1        ),  // O      管理クロック 1
  .RSTN_1 (RSTN_1       ),  // O      リセット 1
  .MDIOO_0(MDIOO_0      ),  // O      管理データ出力 0
  .MDIOO_1(MDIOO_1      ),  // O      管理データ出力 1
  .MDIOE_0(MDIOE_0      ),  // O      管理データ制御 0
  .MDIOE_1(MDIOE_1      ),  // O      管理データ制御 1
);

// Please replace your RTL clock
initial begin
  forever begin
    RTL_CLOCK = 1'b0;
    #50;
    RTL_CLOCK = 1'b1;
    #50;
  end //
end //

// Do not replace this clock for input timing
reg clock;
initial begin
  #1;
  forever begin
    clock = 1'b0;
    #50;
    clock = 1'b1;
    #50;
  end //
end //

  assign  MDIO_0_io = MDIO_0;
  assign  MDIO_1_io = MDIO_1;

initial begin
  ARSTN       = 1'b0;
  PHYRSTN     = 1'b0;
  RXD_0 [7:0] = 8'h0;
  RXDV_0      = 1'b0;
  RXER_0      = 1'b0;
  INTB_0      = 1'b0;
  RXD_1 [7:0] = 8'h0;
  RXDV_1      = 1'b0;
  RXER_1      = 1'b0;
  INTB_1      = 1'b0;
  MDIOI_0     = 1'b0;
  MDIOI_1     = 1'b0;

  repeat(1)@(posedge(clock));
  ARSTN       = 1'b1;
  PHYRSTN     = 1'b1;
  repeat(1)@(posedge(clock));

  RXD_0 = 8'h55;
  RXDV_0 = 1'b1;
  repeat(7)@(posedge(clock));
  RXD_0 = 8'hD5;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h12;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h34;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h56;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h78;
  repeat(1)@(posedge(clock));
  RXDV_0        = 1'b0;
  RXD_0 = 8'h00;

  repeat(5)@(posedge(clock));

  RXD_0 = 8'h55;
  RXDV_0 = 1'b1;
  repeat(7)@(posedge(clock));
  RXD_0 = 8'hD5;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h9A;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'hBC;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'hDE;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'hF0;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h11;
  repeat(1)@(posedge(clock));
  RXD_0 = 8'h22;
  repeat(1)@(posedge(clock));
  RXDV_0        = 1'b0;
  RXD_0 = 8'h00;

  repeat(50)@(posedge(clock));
  $finish;

end //

endmodule
