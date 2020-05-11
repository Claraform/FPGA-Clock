//`timescale 1ns / 1ps



module WallClock(
	//inputs - these will depend on your board's constraint files
    input CLK100MHZ,
    input buttonMin,
    input buttonHrs,
    input buttonReset,
	//outputs - these will depend on your board's constraint files
    output [3:0] SegmentDrivers,
    output reg [5:0] SecDispl,
    output [7:0] SevenSegment	
);

	//Define wires to carry button signals
    wire Reset;
	wire MButton;
	wire HButton;
	
	//Add delay for reset
	Delay_Reset delay1(CLK100MHZ, buttonReset, Reset);
	
	// Instantiate Debounce modules here
	Debounce dbMinutes(CLK100MHZ, buttonMin,MButton);
	Debounce dbHours(CLK100MHZ, buttonHrs,HButton);
	
	// registers for storing the time
	reg [29:0]Count=30'd0;
	reg [5:0]seconds=6'd0;
    reg [3:0]hours1=4'd0;
	reg [3:0]hours2=4'd0;
	reg [3:0]mins1=4'd0;
	reg [3:0]mins2=4'd0;
	
	parameter speed = 800000;
    
	//Initialize seven segment
	// You will need to change some signals depending on you constraints
	SS_Driver SS_Driver1(
		CLK100MHZ, Reset,
		hours2, hours1, mins2, mins1, // Use temporary test values before adding hours2, hours1, mins2, mins1
		SegmentDrivers, SevenSegment
	);
	
	//The main logic
	always @(posedge CLK100MHZ) begin
		// implement your logic here
		// Increment counter
		Count <= Count + 1'b1;
		// Check if counter has reached maximum
		if (Count == speed) begin
		  // Reset counter
		  Count <= 0;
		  // Increment seconds
		  seconds <= seconds + 1'b1;
	   end
	   // Check if minutes should be incremented
	   if (seconds == 60) begin
	       // Check if minutes about to overflow
	       if (minutes1 == 4'd9) begin
	           // Check for overflow
	           if (minutes2 == 4'd5) begin
	               minutes1 <= 0;
	               minutes2 <= 0;
	               // Do hours
	               if (hours1 == 4'd9) begin
	                   hours1 <= 0;
	                   hours2 <= hours2 + 1;
	               end
	               if (hours2 == 4'd2 && hours1 == 4'd3) begin
	                   hours1 <= 0;
	                   hours2 <= 0;
	               end
	               else begin
	                   hours1 <= hours1 + 1'b1;
	               end
	           end
	           else begin
	               // Increment minutes
	               minutes2 <= minutes2 + 1'b1;
	               minutes1 <= 0;
	           end
	       end
	       else begin
	       // Increment minutes
	       minutes1 <= minutes1 + 1'b1;
	       // Reset seconds
	       seconds <= 0;
	       end
		
		
		
		
		
		
		
	end
endmodule  
