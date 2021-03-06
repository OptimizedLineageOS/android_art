    /*
     * Long integer shift, 2addr version.  vA is 64-bit value/result, vB is
     * 32-bit shift distance.
     */
    /* ushr-long/2addr vA, vB */
    mov     r3, rINST, lsr #12          @ r3<- B
    ubfx    r9, rINST, #8, #4           @ r9<- A
    GET_VREG r2, r3                     @ r2<- vB
    CLEAR_SHADOW_PAIR r9, lr, ip        @ Zero out the shadow regs
    VREG_INDEX_TO_ADDR r9, r9           @ r9<- &fp[A]
    and     r2, r2, #63                 @ r2<- r2 & 0x3f
    ldmia   r9, {r0-r1}                 @ r0/r1<- vAA/vAA+1
    mov     r0, r0, lsr r2              @ r0<- r2 >> r2
    rsb     r3, r2, #32                 @ r3<- 32 - r2
    orr     r0, r0, r1, asl r3          @ r0<- r0 | (r1 << (32-r2))
    subs    ip, r2, #32                 @ ip<- r2 - 32
    FETCH_ADVANCE_INST 1                @ advance rPC, load rINST
    movpl   r0, r1, lsr ip              @ if r2 >= 32, r0<-r1 >>> (r2-32)
    mov     r1, r1, lsr r2              @ r1<- r1 >>> r2
    GET_INST_OPCODE ip                  @ extract opcode from rINST
    stmia   r9, {r0-r1}                 @ vAA/vAA+1<- r0/r1
    GOTO_OPCODE ip                      @ jump to next instruction
