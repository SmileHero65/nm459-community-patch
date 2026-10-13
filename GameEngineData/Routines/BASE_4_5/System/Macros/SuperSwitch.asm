

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Arbitrary Bankswitch by JamesNES
;;https://www.nesmakers.com/index.php?threads/arbitrary-bankswitch.8271/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MACRO SuperSwitch arg0, arg1, arg2

	;;arg0 = bank to switch to
	;;arg1 = low byte of subroutine address
	;;arg2 = high byte of subroutine address
	
	
	LDA arg0
	STA arg5_hold
	LDA arg1
	STA arg6_hold
	LDA arg2
	STA arg7_hold
	
	JSR superSwitch
	
ENDM

