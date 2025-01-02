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

void clocks(int c) {
	for(int i=0;i<c;++i) {
		tick(1);
		tick(0);
	}
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

	tb->reset = 0;
	clocks(2);
	tb->reset = 1;
	clocks(1);

	tb->cpu_address=0x100; /* BPLCON0 */
	tb->cpu_data_in=4; /* Enable lace */
	clocks(8);
	tb->cpu_address=0x1ff; /* IDLE */
	clocks(8);

	int frames=10;
	int vsp=tb->vsync;
	int blankp=tb->blank;
	int blank_to_vsync=-1;
	int vsync_to_blank=-1;
	int vsync_to_vsync=0;
	int vsync_width=0;
	while(frames) {
		if(tb->vsync!=vsp) {
			if(tb->vsync) {
				printf("vs high - width: %d\n",vsync_width);
				printf("vsync to vsync: %d\n",vsync_to_vsync);
				vsync_to_blank=0;
				vsync_to_vsync=0;
			}
			else {
				vsync_width=0;
				printf("vs low - blank to vsync: %d\n",blank_to_vsync);
			}
			vsp=tb->vsync;
			--frames;
		}
		if(tb->blank!=blankp) {
			if(tb->blank)
				blank_to_vsync=0;

			if(!tb->blank && vsync_to_blank>0) {
				printf("Blank low - vsync to blank: %d\n\n",vsync_to_blank);	
				vsync_to_blank=-1;
			}
			blankp=tb->blank;
		}
		clocks(1);
		if(vsync_to_blank>-1)
			++vsync_to_blank;
		++blank_to_vsync;
		++vsync_to_vsync;
		++vsync_width;
	}
	
	trace->close();

}
