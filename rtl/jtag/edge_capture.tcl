#!/opt/intelFPGA_lite/18.1/quartus/bin/quartus_stp -t

#   jtagbridge.tcl - Virtual JTAG proxy for Altera devices

package require Tk
init_tk

source [file dirname [info script]]/../../EightThirtyTwo/tcl/vjtagutil.tcl

set CMD_STATUS 0x00
set CMD_GO 0x01
set CMD_MASK 0x02
set CMD_INITSTATE 0x03
set CMD_INITMASK 0x04
set CMD_REPORT 0xfe
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

proc wait_log {} {
	global CMD_STATUS
	send_cmd $CMD_STATUS
	while {[get_word] == 1} {
		send_cmd $CMD_STATUS
	}
}

proc report_log {} {
	global CMD_REPORT
	send_cmd $CMD_REPORT
	set word [get_word]
	set timelast -1
	while {$word >-1 } {
		set timestamp [expr $word >> 2]
		set dtime [expr $timestamp - $timelast]
		set timelast $timestamp
		set hs [expr $word & 1]
		set vs [expr ($word >> 1) & 1]
		set de [expr ($word >> 2) & 1]
		puts [format "t: %10d, dt: %10d, vs: %d, hs: %d, de: %d" $timestamp $dtime $vs $hs $de]
		set word [get_word]
	}
}

proc connect {} {
	global connected
	set connected 0

	if { [vjtag::select_instance 0xED6E] < 0} {
		puts "Connection failed\n"
		set connected 0
	} else {
		puts "Connected to:\n$::vjtag::usbblaster_name\n$::vjtag::usbblaster_device"
		set connected 1
	}
}

connect

send_cmd $CMD_RESET
send_cmd $CMD_MASK 0x6
send_cmd $CMD_INITMASK 0x7
send_cmd $CMD_INITSTATE 0x7

send_cmd $CMD_GO
wait_log
report_log

##################### End Code ########################################

