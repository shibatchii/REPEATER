//
// REPEATER
// EFINIX Trion Ti180 M484 Development Kit
// @shibatchii
// 2024/01/14
//
`timescale 1ns/1ps

module gmii_fifo(
  ARSTN,

  RCLK,
  FIFO_WDAT,
  FIFO_WEOD,
  FIFO_WEN,
  FIFO_AFULL,
  FIFO_WCNT,

  TCLK,
  FIFO_RDAT,
  FIFO_REN,
  FIFO_VALID,
  FIFO_RCNT
);

  input           ARSTN;

  input           RCLK;
  input   [7:0]   FIFO_WDAT;
  input           FIFO_WEOD;
  input           FIFO_WEN;
  output          FIFO_AFULL;
  input   [10:0]  FIFO_WCNT;

  input           TCLK;
  output  [7:0]   FIFO_RDAT;
  input           FIFO_REN;
  output          FIFO_VALID;
  output  [10:0]  FIFO_RCNT;

  wire          w_empty_o;
  wire          w_rd_valid_o;
  wire          w_fifo_reod;

  assign  FIFO_VALID = ~w_empty_o;

  gmii_fifo_dat u_gmii_fifo_dat(
    .almost_full_o  (                               ),
    .prog_full_o    ( FIFO_AFULL                    ),
    .full_o         (                               ),
    .overflow_o     (                               ),
    .wr_ack_o       (                               ),
    .empty_o        (                               ),
    .almost_empty_o (                               ),
    .prog_empty_o   (                               ),
    .underflow_o    (                               ),
    .rd_valid_o     (                               ),
    .rdata          ( {w_fifo_reod,FIFO_RDAT[7:0]}  ),
    .wr_clk_i       ( RCLK                          ),
    .rd_clk_i       ( TCLK                          ),
    .wr_en_i        ( FIFO_WEN                      ),
    .rd_en_i        ( FIFO_REN                      ),
    .wdata          ( {FIFO_WEOD,FIFO_WDAT[7:0]}    ),
    .wr_datacount_o (                               ),
    .rst_busy       (                               ),
    .rd_datacount_o (                               ),
    .a_rst_i        ( ~ARSTN                        )
  );

  gmii_fifo_val u_gmii_fifo_val(
    .almost_full_o  (                               ),
    .full_o         (                               ),
    .overflow_o     (                               ),
    .wr_ack_o       (                               ),
    .empty_o        ( w_empty_o                     ),
    .almost_empty_o (                               ),
    .underflow_o    (                               ),
    .rd_valid_o     ( w_rd_valid_o                  ),
    .rdata          ( FIFO_RCNT[10:0]               ),
    .wr_clk_i       ( RCLK                          ),
    .rd_clk_i       ( TCLK                          ),
    .wr_en_i        ( FIFO_WEOD & FIFO_WEN          ),
    .rd_en_i        ( w_fifo_reod & w_rd_valid_o    ),
    .wdata          ( FIFO_WCNT[10:0]               ),
    .wr_datacount_o (                               ),
    .rst_busy       (                               ),
    .rd_datacount_o (                               ),
    .a_rst_i        ( ~ARSTN                        )
  );

endmodule
