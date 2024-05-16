; Removes the countdown timer from the escape sequence. Countdown reappears
; with 3 minutes on entering the Omega Metroid arena.

.org 08060EECh
.region 0F8h
    ldr     r1, =CurrEvent
    ldrb    r1, [r1]
    mov     r0, r1
    sub     r0, #3Bh
    cmp     r0, #3Ch - 3Bh
    bhi     @@check_restricted_sector_detach
    mov     r1, #1
    bx      lr
@@check_restricted_sector_detach:
    cmp     r1, #5Dh
    bne     @@check_escape_sequence
    mov     r1, #2
    bx      lr
@@check_escape_sequence:
    mov     r0, r1
    sub     r0, #69h
    cmp     r0, #6Ch - 69h
    bhi     @@return_zero
    mov     r0, #3
    bx      lr
@@return_zero:
    mov     r0, #0
    bx      lr
    .pool
.endregion

.autoregion
    .align 2
.func StartEscapeSequence
    push    { lr }
    ldr     r0, =#2DAh
    bl      Sfx_Play
    pop     { pc }
    .pool
.endfunc
.endautoregion

.org 08072C20h
.area 06h
    ; prevent countdown timer particle from playing escape sequence intercom
    nop :: nop :: nop
.endarea

.org 083C8B1Ch
.region 1Ah * 4
    ; remove escape sequence event locks
    .db     69h
    .db     Area_MainDeck, 40h
    .db     3Fh
.endregion

.org 08063D88h
.area 02h
    ; fix event lock table length
    cmp     r4, #30h
.endarea

.org 0806331eh
.area 02h
    ; remove escape sequence nav room event locks
    cmp     r4, #56h
.endarea
