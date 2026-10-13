
doAnimAction00:
    .include ROOT\Game\Subroutines\blank.asm
    RTS

doAnimAction01:
    .include ROOT\Game\TimerEndScripts\advance.asm
    RTS

doAnimAction02:
    .include ROOT\Game\TimerEndScripts\repeat.asm
    RTS

doAnimAction03:
    .include ROOT\Game\TimerEndScripts\goToFirst.asm
    RTS

doAnimAction04:
    .include ROOT\Game\TimerEndScripts\goToLast.asm
    RTS

doAnimAction05:
    .include ROOT\Game\TimerEndScripts\goToPrevious.asm
    RTS

doAnimAction06:
    .include ROOT\Game\TimerEndScripts\destroyObject.asm
    RTS

doAnimAction07:
    .include ROOT\Game\TimerEndScripts\goToWarp.asm
    RTS

doAnimAction08:
    .include ROOT\Game\Subroutines\blank.asm
    RTS

doAnimAction09:
    .include ROOT\Game\TimerEndScripts\goToContinue.asm
    RTS

doAnimAction10:
    .include ROOT\Game\TimerEndScripts\restartScreen.asm
    RTS

doAnimAction11:
    .include ROOT\Game\TimerEndScripts\restartGame.asm
    RTS

doAnimAction12:
    .include ROOT\Game\Subroutines\blank.asm
    RTS

doAnimAction13:
    .include ROOT\Game\Subroutines\blank.asm
    RTS


EndAnimAndActions_Lo:
    .db #<doAnimAction00, #<doAnimAction01, #<doAnimAction02, #<doAnimAction03
    .db #<doAnimAction04, #<doAnimAction05, #<doAnimAction06, #<doAnimAction07
    .db #<doAnimAction08, #<doAnimAction09, #<doAnimAction10, #<doAnimAction11
    .db #<doAnimAction12, #<doAnimAction13

EndAnimAndActions_Hi:
    .db #>doAnimAction00, #>doAnimAction01, #>doAnimAction02, #>doAnimAction03
    .db #>doAnimAction04, #>doAnimAction05, #>doAnimAction06, #>doAnimAction07
    .db #>doAnimAction08, #>doAnimAction09, #>doAnimAction10, #>doAnimAction11
    .db #>doAnimAction12, #>doAnimAction13

