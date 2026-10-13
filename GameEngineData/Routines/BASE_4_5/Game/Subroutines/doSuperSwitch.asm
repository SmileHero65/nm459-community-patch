
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Arbitrary Bankswitch by JamesNES
;;https://www.nesmakers.com/index.php?threads/arbitrary-bankswitch.8271/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

superSwitch:
	LDA prevBank
	PHA
	LDA currentBank
	PHA
	
	JSR doSuperSwitch
	
	PLA
	STA temp
	SwitchBank temp
	PLA
	STA prevBank

	RTS


doSuperSwitch:
	SwitchBank arg5_hold
		;;decrease low byte of address
		LDA arg6_hold
		SEC
		SBC #$01
		STA arg6_hold
		BCS +dontChangeHighByte
			;;if it's right on a page boundary
			;;we need to decrease the high byte as well
			DEC arg7_hold
		+dontChangeHighByte

		LDA arg7_hold
		PHA
		LDA arg6_hold
		PHA
		
		RTS

