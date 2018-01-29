/*
Generic I2C slave module
======= === ===== ======

This module is a generic I2C slave module that acts a slave transmitter
and receiver that supports the I2C protocol defined as per the document:
 "I2C-bus specification and user manual (UM10204), Rev.6 4th April 2014"
*/

module i2c_slave()
(
	input		wire	sys_clk,

	output	wire	SCL,
	output	wire	SDA,

	input		wire	InputDataValid,
	input		reg		TxData,

	output	reg		OutputDataValid,
	output	reg		RxData
);

parameter FsmStateNumber = 8;
/* States: 
state_Idle
state_RxSlaveAddr
state_AckAddr
state_RxData
state_AckData
state_NackData
state_TxData
state_TxAckWait
*/

parameter state_Idle				= 8'b0000_0001,
					state_RxSlaveAddr	= 8'b0000_0010,
					state_AckAddr			= 8'b0000_0100,
					state_RxData			= 8'b0000_1000,
					state_AckData			= 8'b0001_0000,
					state_NackData		= 8'b0010_0000,
					state_TxData			= 8'b0100_0000,
					state_TxAckWait		= 8'b1000_0000;

reg [FsmStateNumber-1:0] CurrentState, NextState;

always @(*)