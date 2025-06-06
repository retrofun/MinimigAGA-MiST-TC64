proc setregs {} {
	global regmap
	set regs {
		bltddat 0x00
		dmaconr 0x02
		vposr 0x04
		vhposr 0x06
		dskdatr 0x08
		joy0dat 0x0A
		joy1dat 0x0C
		clxdat 0x0E

		adkconr 0x10
		pot0dat 0x12
		pot1dat 0x14
		potinp 0x16
		serdatr 0x18
		dskbytr 0x1A
		intenar 0x1C
		intreqr 0x1E

		dskpt 0x20
		dsklen 0x24
		dskdat 0x26
		refptr 0x28
		vposw 0x2A
		vhposw 0x2C
		copcon 0x2E
		serdat 0x30
		serper 0x32
		potgo 0x34
		joytest 0x36
		str 0x38
		strvbl 0x3A
		strhor 0x3C
		strlong 0x3E

		bltcon0 0x40
		bltcon1 0x42
		bltafwm 0x44
		bltalwm 0x46
		bltcpth 0x48
		bltcptl 0x4A
		bltbpth 0x4C
		bltbptl 0x4E
		bltapth 0x50
		bltaptl 0x52
		bltdpth 0x54
		bltdptl 0x56
		bltsize 0x58
		bltcon0l 0x5A
		bltsizv 0x5C
		bltsizh 0x5E

		bltcmod 0x60
		bltbmod 0x62
		bltamod 0x64
		bltdmod 0x66
		
		0x68 0x68
		0x6A 0x6A
		0x6C 0x6C
		0x6E 0x6E

		bltcdat 0x70
		bltbdat 0x72
		bltadat 0x74

		0x76 0x76
		0x78 0x78
		0x7A 0x7A

		deniseid 0x7C
		dsksync 0x7E

		cop1lc 0x80
		cop2lc 0x84
		copjmp1 0x88
		copjmp2 0x8A
		copins 0x8C
		diwstrt 0x8E
		diwstop 0x90
		ddfstrt 0x92
		ddfstop 0x94
		dmacon 0x96
		clxcon 0x98
		intena 0x9A
		intreq 0x9C
		adkcon 0x9E

		aud0lch 0xA0
		aud0lcl 0xA2
		aud0len 0xA4
		aud0per 0xA6
		aud0vol 0xA8
		aud0dat 0xAA
		
		0xAC 0xAC
		0xAE 0xAE

		aud1lch 0xB0
		aud1lcl 0xB2
		aud1len 0xB4
		aud1per 0xB6
		aud1vol 0xB8
		aud1dat 0xBA

		0xBC 0xBC
		0xBE 0xBE

		aud2lch 0xC0
		aud2lcl 0xC2
		aud2len 0xC4
		aud2per 0xC6
		aud2vol 0xC8
		aud2dat 0xCA

		0xCC 0xCC
		0xCE 0xCE

		aud3lch 0xD0
		aud3lcl 0xD2
		aud3len 0xD4
		aud3per 0xD6
		aud3vol 0xD8
		aud3dat 0xDA

		0xDC 0xDC
		0xDE 0xDE

		bpl1pth 0xE0
		bpl1ptl 0xE2
		bpl2pth 0xE4
		bpl2ptl 0xE6
		bpl3pth 0xE8
		bpl3ptl 0xEA
		bpl4pth 0xEC
		bpl4ptl 0xEE
		bpl5pth 0xF0
		bpl5ptl 0xF2
		bpl6pth 0xF4
		bpl6ptl 0xF6
		bpl7pth 0xF8
		bpl7ptl 0xFA
		bpl8pth 0xFC
		bpl8ptl 0xFE

		bplcon0 0x100
		bplcon1 0x102
		bplcon2 0x104
		bplcon3 0x106
		bpl1mod 0x108
		bpl2mod 0x10A
		bplcon4 0x10C
		clxcon2 0x10E

		bpl1dat 0x110
		bpl2dat 0x112
		bpl3dat 0x114
		bpl4dat 0x116
		bpl5dat 0x118
		bpl6dat 0x11A
		bpl7dat 0x11C
		bpl8dat 0x11E

		spr0pth 0x120
		spr0ptl 0x122
		spr1pth 0x124
		spr1ptl 0x126
		spr2pth 0x128
		spr2ptl 0x12A
		spr3pth 0x12C
		spr3ptl 0x12E
		spr4pth 0x130
		spr4ptl 0x132
		spr5pth 0x134
		spr5ptl 0x136
		spr6pth 0x138
		spr6ptl 0x13A
		spr7pth 0x13C
		spr7ptl 0x13E

		spr0pos 0x140
		spr0ctl 0x142
		spr0data 0x144
		spr0datb 0x146

		spr1pos 0x148
		spr1ctl 0x14A
		spr1data 0x14C
		spr1datb 0x14E

		spr2pos 0x150
		spr2ctl 0x152
		spr2data 0x154
		spr2datb 0x156

		spr3pos 0x158
		spr3ctl 0x15A
		spr3data 0x15C
		spr3datb 0x15E

		spr4pos 0x160
		spr4ctl 0x162
		spr4data 0x164
		spr4datb 0x166

		spr5pos 0x168
		spr5ctl 0x16A
		spr5data 0x16C
		spr5datb 0x16E

		spr6pos 0x170
		spr6ctl 0x172
		spr6data 0x174
		spr6datb 0x176

		spr7pos 0x178
		spr7ctl 0x17A
		spr7data 0x17C
		spr7datb 0x17E

		color00 0x180
		color01 0x182
		color02 0x184
		color03 0x186
		color04 0x188
		color05 0x18A
		color06 0x18C
		color07 0x18E
		color08 0x190
		color09 0x192
		color10 0x194
		color11 0x196
		color12 0x198
		color13 0x19A
		color14 0x19C
		color15 0x19E
		color16 0x1A0
		color17 0x1A2
		color18 0x1A4
		color19 0x1A6
		color20 0x1A8
		color21 0x1AA
		color22 0x1AC
		color23 0x1AE
		color24 0x1B0
		color25 0x1B2
		color26 0x1B4
		color27 0x1B6
		color28 0x1B8
		color29 0x1BA
		color30 0x1BC
		color31 0x1BE

		htotal 0x1c0
		hsstop 0x1c2
		hbstrt 0x1c4
		hbstop 0x1c6
		vtotal 0x1c8
		vsstop 0x1ca
		vbstrt 0x1cc
		vbstop 0x1ce
		sprhstrt 0x1d0
		sprhstop 0x1d2
		bplhstrt 0x1d4
		bplhstop 0x1d6
		hhposw 0x1d8
		hhposr 0x1da
		beamcon0 0x1dc
		hsstrt 0x1de
		vsstrt 0x1e0
		hcenter 0x1e2
		diwhigh 0x1e4
		fmode 0x1fc
	}

	for {set idx 0 } {$idx < [llength $regs]} { set idx [expr $idx + 2] } {
		set regname [lindex $regs $idx]
		scan [lindex $regs [expr $idx + 1]] %x regaddr
		set regmap($regname) $regaddr
		set regmap($regaddr) $regname
	}
}
setregs

