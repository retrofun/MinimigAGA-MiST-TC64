#!/opt/intelFPGA_lite/18.1/quartus/bin/quartus_stp -t

#   jtagbridge.tcl - Virtual JTAG proxy for Altera devices

package require Tk
init_tk

source [file dirname [info script]]/../../EightThirtyTwo/tcl/vjtagutil.tcl

source amiga_registers.tcl


set CMD_STATUS 0x00
set CMD_GO 0x01
set CMD_SELECT 0x02
set CMD_UNSELECT 0x03
set CMD_REPORT 0x04
set CMD_RESET 0xff

####################### Main code ###################################


proc send_cmd {cmd {data 0}} {
	global connected
	set contmp $connected;
	set connected 0
	if {$contmp} {
		if [ vjtag::usbblaster_open ] {
			vjtag::send [expr (($cmd << 24) | $data) ]
		}
		vjtag::usbblaster_close
	}
	set connected $contmp
}

proc get_word {} {
	global connected
	set contmp $connected;
	set connected 0
	if {$contmp} {
		if [ vjtag::usbblaster_open ] {
			set word [vjtag::recv]
		}
		vjtag::usbblaster_close
	}
	set connected $contmp
	return $word
}

proc reset {} {
	global CMD_RESET
	send_cmd $CMD_RESET
}

proc select {reg} {
	global CMD_SELECT
	global regmap
	set regaddr $regmap($reg)
	send_cmd $CMD_SELECT [expr $regaddr / 2]
}

proc unselect {reg} {
	global CMD_UNSELECT
	global regmap
	set regaddr $regmap($reg)
	send_cmd $CMD_UNSELECT [expr $regaddr / 2]
}

proc start_log {} {
	global CMD_GO
	send_cmd $CMD_GO
}

proc wait_log {} {
	global CMD_STATUS
	send_cmd $CMD_STATUS
	while {[get_word] == 1} {
		send_cmd $CMD_STATUS
	}
}

proc report_log {} {
	global CMD_REPORT
	global regmap
	send_cmd $CMD_REPORT
	set word [get_word]
	set timelast -1
	while {$word >-1 } {
		set word2 [get_word]
		set reg [expr ($word2 >> 15) & 0x1fe]
		set value [expr $word2 & 0xffff]
		set blitbusy [expr $word >> 31]
		set timestamp [expr ($word & 0x7fffffff) / 7090]
		if {[expr $timestamp - $timelast] > 3 } {
			puts ""
		}
		set timelast $timestamp
		puts [format "%05d: %s: 0x%04x, blitter busy: %d" $timestamp $regmap($reg) $value $blitbusy]
		set word [get_word]
	}
}

proc connect {} {
	global connected
	set connected 0

	if { [vjtag::select_instance 0x8371] < 0} {
		puts "Connection failed\n"
		set connected 0
	} else {
		puts "Connected to:\n$::vjtag::usbblaster_name\n$::vjtag::usbblaster_device"
		set connected 1
	}
}


proc drain_fifo {} {
	global connected
	if {$connected} {
		if [ vjtag::usbblaster_open ] {
			while {[vjtag::recv] >-1 } {
			}
			vjtag::usbblaster_close
		}
	}
}


proc send_fetch {} {
	global CMD_FETCH

	drain_fifo
	send_cmd $CMD_REPORT

	if {$connected} {
		if [ vjtag::usbblaster_open ] {
			set v1 [vjtag::recv_blocking]
			set v2 [vjtag::recv_blocking]
			puts $v1 $v2
		}
		vjtag::usbblaster_close
	}
}

##################### EXAMPLE USAGE ###################################

# connect

# reset
# select color00
# select color01
# select color02
# select color03

# start_log
# wait_log
# report_log

##################### End Code ########################################

