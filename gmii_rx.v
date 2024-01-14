//
// REPEATER
// EFINIX Trion Ti180 M484 Development Kit
// @shibatchii
// 2024/01/14
//
`timescale 1ns/1ps

module gmii_rx(
  ARSTN,

  RCLK,
  RXD,
  RXDV,
  RXER,

  FIFO_WDAT,
  FIFO_WEOD,
  FIFO_WEN,
  FIFO_AFULL,
  FIFO_WCNT
);

  input           ARSTN;

  input           RCLK;
  input   [7:0]   RXD;
  input           RXDV;
  input           RXER;

  output  [7:0]   FIFO_WDAT;
  output          FIFO_WEOD;
  output          FIFO_WEN;
  input           FIFO_AFULL;
  output  [10:0]  FIFO_WCNT;

  parameter ST_IDLE = 2'b00, // IDLE
            ST_PREA = 2'b01, // Preamble
            ST_BDY  = 2'b10, // Data
            ST_END  = 2'b11; // End

  reg     [1:0]   r_st;
  reg     [1:0]   w_st;
  reg     [7:0]   r_rxd;
  reg     [7:0]   r_rxdd;
  reg             r_rxdv;
  reg     [7:0]   r_fifo_wdat;
  reg             r_fifo_weod;
  reg             r_fifo_wen;
  wire            w_rxer_unused;
  reg     [10:0]  r_fifo_wcnt;

  assign  w_rxer_unused   = RXER;
  assign  FIFO_WDAT[7:0]  = r_fifo_wdat[7:0];
  assign  FIFO_WEOD       = r_fifo_weod;
  assign  FIFO_WEN        = r_fifo_wen;
  assign  FIFO_WCNT[10:0] = r_fifo_wcnt;

  // Input retiming
  always @( posedge RCLK or negedge ARSTN)begin
    if(ARSTN  == 1'b0) begin
      r_rxd[7:0]  <=  8'd0;
      r_rxdd[7:0] <=  8'd0;
      r_rxdv      <=  1'b0;
    end else begin
      r_rxd[7:0]  <=  RXD[7:0];
      r_rxdd[7:0] <=  r_rxd[7:0];
      r_rxdv      <=  RXDV;
    end
  end

  // State Machine
  always @( posedge RCLK or negedge ARSTN)begin
    if(ARSTN == 1'b0) begin
      r_st[1:0] <= ST_IDLE;
    end else begin
      r_st[1:0] <= w_st[1:0];
    end
  end

  // State Control
  always @(r_st or r_rxdv or FIFO_AFULL or r_rxdd )begin
    case(r_st[1:0])
      ST_IDLE:
        if((r_rxdv == 1'b1) && (FIFO_AFULL==1'b0))
          w_st[1:0] = ST_PREA;
        else
          w_st[1:0] = r_st[1:0];
      ST_PREA:
        if(r_rxdv == 1'b0)
          w_st[1:0] = ST_IDLE;
        else if(r_rxdd[7:0] == 8'b1101_0101)
          w_st[1:0] = ST_BDY;
        else
          w_st[1:0] = ST_PREA;
      ST_BDY:
        if(r_rxdv == 1'b0)
          w_st[1:0] = ST_END;
        else
          w_st[1:0] = ST_BDY;
      ST_END:
        w_st[1:0] = ST_IDLE;
      default:
        w_st[1:0] = ST_IDLE;
    endcase
  end

  // Packet Data
  always @(posedge RCLK or negedge ARSTN)begin
    if(ARSTN == 1'b0) begin
      r_fifo_wdat[7:0] <= 8'd0;
    end else begin
      r_fifo_wdat[7:0] <= r_rxdd[7:0];
    end
  end

  // End Flag
  always @(posedge RCLK or negedge ARSTN)begin
    if(ARSTN == 1'b0) begin
      r_fifo_weod <= 1'b0;
    end else begin
      case(r_st[1:0])
        ST_BDY:
          if(r_rxdv == 1'b0)
            r_fifo_weod <= 1'b1;
          else
            r_fifo_weod <= 1'b0;
        default:
          r_fifo_weod <= 1'b0;
      endcase
    end
  end

  // FIFO Write Enable
  always @(posedge RCLK or negedge ARSTN)begin
    if(ARSTN == 1'b0) begin
      r_fifo_wen <= 1'b0;
    end else begin
      case(r_st[1:0])
        ST_BDY:
          r_fifo_wen <= 1'b1;
        default:
          r_fifo_wen <= 1'b0;
      endcase
    end
  end

  // Packet Count
  always @(posedge RCLK or negedge ARSTN)begin
    if(ARSTN == 1'b0) begin
      r_fifo_wcnt[10:0] <= 11'd0;
    end else begin
      case(r_st[1:0])
        ST_BDY:
          r_fifo_wcnt[10:0] <= r_fifo_wcnt[10:0] + 11'd1;
        default:
          r_fifo_wcnt[10:0] <= 11'd0;
      endcase
    end
  end

endmodule
