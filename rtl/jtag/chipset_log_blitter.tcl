#!/opt/intelFPGA_lite/18.1/quartus/bin/quartus_stp -t

source chipset_log.tcl

connect

reset

select dmacon
select bltcon0
select bltcon1 
# select bltafwm 
# select bltalwm 
select bltcptl 
select bltbptl 
select bltaptl 
select bltdptl 
select bltcpth 
select bltbpth 
select bltapth 
select bltdpth 
select bltsize
select bltcon0l
select bltsizv
select bltsizh

select bltcmod
select bltbmod
select bltamod
select bltdmod

start_log
wait_log
report_log


