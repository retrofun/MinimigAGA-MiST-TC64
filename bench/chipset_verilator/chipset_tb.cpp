#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <list>
#include "Vchipset_tb.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


static Vchipset_tb *tb;
static VerilatedVcdC *trace;
static double timestamp = 0;

double sc_time_stamp() {
	return timestamp;
}

void tick(int c) {
	tb->clk_28 = c;
	tb->eval();
	trace->dump(timestamp);
	timestamp += 4.38;
}

void ticks(int c) {
	while(c--) {
		tick(1);
		tick(0);
	}
}

void tick7(int c) {
	do {
		ticks(1);
	} while (c ? tb->clk7_en==0 : tb->clk7n_en==0);
}

int spi_byte(int d) {
	int i;
	int result=0;
	for(i=0;i<8;++i) {
		result=(result>>1) | (tb->spi_miso << 7);
		tb->spi_clk=1;		
		ticks(1);
		tb->spi_clk=0;
		tb->spi_mosi=d&1;
		d>>=1;
		ticks(1);
	}
	return(result);
}

#define CMD_RESET 0x08

void spi_release_cpu() {
	tb->spi_cs&=0x5; /* bit 1 for OSD */
	ticks(1);
	spi_byte(CMD_RESET);
	spi_byte(0);
	ticks(1);
	tb->spi_cs|=2; /* bit 1 for OSD */	
	ticks(16);
}

void reset() {
	tb->spi_cs=7;
	tb->cpu_as=1;
	tb->cpu_r_w=1;
	tb->cpu_uds=tb->cpu_lds=tb->cpu_uds2=tb->cpu_lds2=1;
	tb->reset_n=0;
	tick7(1);
	tick7(0);
	tb->reset_n=1;
	spi_release_cpu();
	while(!tb->cpu_reset) {
		tick7(1);
		tick7(0);
	}
}

void write16(int a,int d) {
	tb->cpu_as=1;
	while(tb->cpu_dtack==0) {
		tick7(1);
		tick7(0);
	}
	tick7(0);
	tb->cpu_address=a;
	tb->cpu_data_in=d;
	tick7(1);
	tick7(0);
	tb->cpu_as=0;
	tb->cpu_r_w=0;
	tb->cpu_uds=0;
	tb->cpu_lds=0;
	tb->cpu_uds2=1;
	tb->cpu_lds2=1;
	tick7(1);
	do {
		tick7(0);
		tick7(1);
	} while(tb->cpu_dtack==1);
	tick7(0);
	tick7(1);
	tb->cpu_r_w=1;
	tb->cpu_as=1;
	tb->cpu_uds=1;
	tb->cpu_lds=1;
}


int read16(int a) {
	int result=0;
	tb->cpu_as=1;
	while(tb->cpu_dtack==0) {
		tick7(1);
		tick7(0);
	}
	tick7(0);
	tb->cpu_address=a;
	tb->cpu_r_w=1;
	tick7(1);
	tick7(0);
	tb->cpu_as=0;
	tb->cpu_uds=0;
	tb->cpu_lds=0;
	tb->cpu_uds2=1;
	tb->cpu_lds2=1;
	tick7(1);
		tick7(0);
		tick7(1);
	do {
		tick7(0);
		tick7(1);
	} while(tb->cpu_dtack==1);
	tick7(0);
	tick7(1);
	result=tb->cpu_data;
	tb->cpu_as=1;
	tb->cpu_uds=1;
	tb->cpu_lds=1;
	tick7(1);
	return(result);
}


int main(int argc, char **argv) {

	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);
//	Verilated::debug(1);
	Verilated::traceEverOn(true);
	trace = new VerilatedVcdC;

	// Create an instance of our module under test
	tb = new Vchipset_tb;
	tb->trace(trace, 99);
	trace->open("chipset.vcd");

	reset();

	write16(0xdff180,0x678);
	tick7(1);
	tick7(0);
	read16(0xbfe001);

	for(int i=0;i<8;++i)
		printf("VHPOSR %04x\n",read16(0xdff006));
	printf("CIAA PRA: %04x\n",read16(0xbfe001));

	for(int i=0;i<500;++i)
		ticks(64);

	trace->close();
}
