//
// REPEATER
// EFINIX Trion Ti180 M484 Development Kit
// @shibatchii
// 2024/01/14
//
`timescale 1ns/1ps

module gmii_top(
  ARSTN,
  PHYRSTN,
  LED,

  PLL_RCLK_0,
  PLL_RCLK_1,

  TCLK_0_0,
  TCLK_1_0,
  TXD_0,
  TXEN_0,
  TXER_0,
  RCLK_0,
  RXD_0,
  RXDV_0,
  RXER_0,
  MDC_0,
  MDIOI_0,
  MDIOO_0,
  MDIOE_0,
  INTB_0,
  RSTN_0,

  TCLK_0_1,
  TCLK_1_1,
  TXD_1,
  TXEN_1,
  TXER_1,
  RCLK_1,
  RXD_1,
  RXDV_1,
  RXER_1,
  MDC_1,
  MDIOI_1,
  MDIOO_1,
  MDIOE_1,
  INTB_1,
  RSTN_1

);

  input           ARSTN;  // 非同期リセット
  input           PHYRSTN; // PHYリセット
  output  [3:2]   LED;    // LED

  input           PLL_RCLK_0; // 受信クロック 0
  input           PLL_RCLK_1; // 受信クロック 1

  output          TCLK_1_0; // 送信クロック 0
  output          TCLK_0_0; // 送信クロック 0
  output  [7:0]   TXD_0;  // 送信データ 0
  output          TXEN_0; // 送信可 0
  output          TXER_0; // 送信エラー 0
  input           RCLK_0; // 受信クロック 0
  input   [7:0]   RXD_0;  // 受信データ 0
  input           RXDV_0; // 受信有効 0
  input           RXER_0; // 受信エラー 0
  output          MDC_0;  // 管理クロック 0
  input           MDIOI_0;// 管理データ入力 0
  output          MDIOO_0;// 管理データ出力 0
  output          MDIOE_0;// 管理データ制御 0
  input           INTB_0; // 割り込み 0
  output          RSTN_0; // リセット 0

  output          TCLK_0_1; // 送信クロック 1
  output          TCLK_1_1; // 送信クロック 1
  output  [7:0]   TXD_1;  // 送信データ 1
  output          TXEN_1; // 送信可 1
  output          TXER_1; // 送信エラー 1
  input           RCLK_1; // 受信クロック 1
  input   [7:0]   RXD_1;  // 受信データ 1
  input           RXDV_1; // 受信有効 1
  input           RXER_1; // 受信エラー 1
  output          MDC_1;  // 管理クロック 1
  input           MDIOI_1;// 管理データ入力 1
  output          MDIOO_1;// 管理データ出力 1
  output          MDIOE_1;// 管理データ制御 1
  input           INTB_1; // 割り込み 1
  output          RSTN_1; // リセット 1

  wire            TCLK_0; // 送信クロック 0
  wire            TCLK_1; // 送信クロック 1

  wire    [7:0]   FIFO_WDAT_0;
  wire            FIFO_WEOD_0;
  wire            FIFO_WEN_0;
  wire            FIFO_AFULL_0;
  wire    [10:0]  FIFO_WCNT_0;
  wire    [7:0]   FIFO_RDAT_0;
  wire            FIFO_REN_0;
  wire            FIFO_VALID_0;
  wire    [10:0]  FIFO_RCNT_0;

  wire    [7:0]   FIFO_WDAT_1;
  wire            FIFO_WEOD_1;
  wire            FIFO_WEN_1;
  wire            FIFO_AFULL_1;
  wire    [10:0]  FIFO_WCNT_1;
  wire    [7:0]   FIFO_RDAT_1;
  wire            FIFO_REN_1;
  wire            FIFO_VALID_1;
  wire    [10:0]  FIFO_RCNT_1;

  reg     [27:0]  r_tclk_0;
  reg     [27:0]  r_tclk_1;

  assign  TCLK_0_0  = 1'b0;
  assign  TCLK_1_0  = 1'b1;
  assign  TCLK_0_1  = 1'b0;
  assign  TCLK_1_1  = 1'b1;

  assign  TCLK_0  = PLL_RCLK_0;
  assign  RSTN_0  = ~PHYRSTN;
  assign  MDC_0   = 1'b0;
  assign  MDIOO_0 = 1'b0;
  assign  MDIOE_0 = 1'b0;

  assign  TCLK_1  = PLL_RCLK_1;
  assign  RSTN_1  = ~PHYRSTN;
  assign  MDC_1   = 1'b0;
  assign  MDIOO_1 = 1'b0;
  assign  MDIOE_1 = 1'b0;

  assign  LED[2]  = r_tclk_0[27];
  assign  LED[3]  = r_tclk_1[27];

  always @(posedge TCLK_0 or negedge ARSTN )begin
    if(~ARSTN)
      r_tclk_0 <= 28'd0;
    else
      r_tclk_0 <= r_tclk_0 + 28'd1;
  end

  always @(posedge TCLK_1 or negedge ARSTN )begin
    if(~ARSTN)
      r_tclk_1 <= 28'd0;
    else
      r_tclk_1 <= r_tclk_1 + 28'd1;
  end

gmii_rx gmii_rx_0 (
  .ARSTN        (ARSTN                ),  // I
  .RCLK         (RCLK_0               ),  // I
  .RXD          (RXD_0        [7:0]   ),  // I
  .RXDV         (RXDV_0               ),  // I
  .RXER         (RXER_0               ),  // I
  .FIFO_AFULL   (FIFO_AFULL_0         ),  // I
  .FIFO_WDAT    (FIFO_WDAT_0  [7:0]   ),  // O
  .FIFO_WEOD    (FIFO_WEOD_0          ),  // O
  .FIFO_WEN     (FIFO_WEN_0           ),  // O
  .FIFO_WCNT    (FIFO_WCNT_0  [10:0]  )   // O
);

gmii_rx gmii_rx_1 (
  .ARSTN        (ARSTN                ),  // I
  .RCLK         (RCLK_1               ),  // I
  .RXD          (RXD_1        [7:0]   ),  // I
  .RXDV         (RXDV_1               ),  // I
  .RXER         (RXER_1               ),  // I
  .FIFO_AFULL   (FIFO_AFULL_1         ),  // I
  .FIFO_WDAT    (FIFO_WDAT_1  [7:0]   ),  // O
  .FIFO_WEOD    (FIFO_WEOD_1          ),  // O
  .FIFO_WEN     (FIFO_WEN_1           ),  // O
  .FIFO_WCNT    (FIFO_WCNT_1  [10:0]  )   // O
);

gmii_fifo gmii_fifo_01 (
  .ARSTN        (ARSTN                ),  // I
  .RCLK         (RCLK_0               ),  // I
  .FIFO_WDAT    (FIFO_WDAT_0    [7:0] ),  // I
  .FIFO_WEOD    (FIFO_WEOD_0          ),  // I
  .FIFO_WEN     (FIFO_WEN_0           ),  // I
  .FIFO_WCNT    (FIFO_WCNT_0    [10:0]),  // I
  .TCLK         (TCLK_1               ),  // I
  .FIFO_REN     (FIFO_REN_1           ),  // I
  .FIFO_AFULL   (FIFO_AFULL_1         ),  // O
  .FIFO_RDAT    (FIFO_RDAT_1    [7:0] ),  // O
  .FIFO_VALID   (FIFO_VALID_1         ),  // O
  .FIFO_RCNT    (FIFO_RCNT_1    [10:0])   // O
);

gmii_fifo gmii_fifo_10 (
  .ARSTN        (ARSTN                ),  // I
  .RCLK         (RCLK_1               ),  // I
  .FIFO_WDAT    (FIFO_WDAT_1    [7:0] ),  // I
  .FIFO_WEOD    (FIFO_WEOD_1          ),  // I
  .FIFO_WEN     (FIFO_WEN_1           ),  // I
  .FIFO_WCNT    (FIFO_WCNT_1    [10:0]),  // I
  .TCLK         (TCLK_0               ),  // I
  .FIFO_REN     (FIFO_REN_0           ),  // I
  .FIFO_AFULL   (FIFO_AFULL_0         ),  // O
  .FIFO_RDAT    (FIFO_RDAT_0    [7:0] ),  // O
  .FIFO_VALID   (FIFO_VALID_0         ),  // O
  .FIFO_RCNT    (FIFO_RCNT_0    [10:0])   // O
);

gmii_tx gmii_tx_0 (
  .ARSTN        (ARSTN                ),  // I
  .TCLK         (TCLK_0               ),  // I
  .FIFO_RDAT    (FIFO_RDAT_0    [7:0] ),  // I
  .FIFO_VALID   (FIFO_VALID_0         ),  // I
  .FIFO_RCNT    (FIFO_RCNT_0    [10:0]),  // I
  .TXD          (TXD_0          [7:0] ),  // O
  .TXEN         (TXEN_0               ),  // O
  .TXER         (TXER_0               ),  // O
  .FIFO_REN     (FIFO_REN_0           )   // O
);

gmii_tx gmii_tx_1 (
  .ARSTN        (ARSTN                ),  // I
  .TCLK         (TCLK_1               ),  // I
  .FIFO_RDAT    (FIFO_RDAT_1    [7:0] ),  // I
  .FIFO_VALID   (FIFO_VALID_1         ),  // I
  .FIFO_RCNT    (FIFO_RCNT_1    [10:0]),  // I
  .TXD          (TXD_1          [7:0] ),  // O
  .TXEN         (TXEN_1               ),  // O
  .TXER         (TXER_1               ),  // O
  .FIFO_REN     (FIFO_REN_1           )   // O
);

endmodule
