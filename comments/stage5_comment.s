;;================================================================================================
;; COS10031 - Computer Technology | Assessment 3
;; Vandy Aum, Marcus Mifsud, Nicole Reichert, Luke Byrnes
;;  ___  ___          _                      _           _
;;  |  \;  |         | |                    (_)         | |
;;  | .  . | __ _ ___| |_ ___ _ __ _ __ ___  _ _ __   __| |
;;  | |\;| |; _` ; __| __; _ \ '__| '_ ` _ \| | '_ \ ; _` |
;;  | |  | | (_| \__ \ ||  __; |  | | | | | | | | | | (_| |
;;  \_|  |_;\__,_|___;\__\___|_|  |_| |_| |_|_|_| |_|\__,_|
;;
;; Register Assignations
    ;; R0 (Compare Code of Correct Pos;Col)
    ;; R1 (Compare Code of (Correct Pos, Incorrect Col))
    ;; R2
    ;; R3
    ;; R4
    ;; R5
    ;; R6
    ;; R7
    ;; R8 Function Return (stores LR to return after a function is used within a function)
    ;; R9 Code character address
    ;; R10 String Handling
    ;; R11 Guess Limit
    ;; R12 Address to temp code
;;================================================================================================
;;;;;;;;STAGE 5 - COMPARE THE CODES OF QUERYCODE AND SECRETCODE;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Nicole Reichert, 5a;;;;;;;;;;;;
comparecodes:
;;WE USE R0, R1 for CASES OF MATCHED PINS (POS/COL), (COL)
;; Setting up registers to 0
MOV R0,#0
MOV R1,#0
;;;;CASE 1 - DO WE HAVE THE CORRECT POS/COL for QUERYCODE[IDX] and SECRETCODE[IDX]
    case1start:
    ;; HAVE WE HIT ABOVE 12 (4+4+4, 3 ITERATIONS. IT IS 0-INDEXED, SO ALL 4 CHARS) IF SO, END (STAGE 5B)
    CMP R12, #0xC
    BGT end
    ;;;;;;OUTER LOOP, R12 is IDX, R2 is ADDR of QUERYCODE;;;;;;;;
    ;;;;;;;;;;;;;LOAD A PEG FROM QUERY CODE INTO R5;;;;;;;;;;;;;;
    MOV R2,#querycode
    LDR R5,[R2+R12]

    ;;;;;;;;;;;;;;LOAD A PEG FROM SECRET CODE INTO R4;;;;;;;;;;;;
    MOV R2,#secretcode
    LDR R4,[R2+R12]
    ;;;;IS QUERYCODE[IDX] == SECRETCODE[IDX]? IF SO, CASE1 = true;;;;
    ;; Compare for Case 1 (BEQ)
    CMP R4,R5
    BEQ case1beq
    ;;;;;IS QUERYCODE[IDX] != SECRETCODE[IDX]? CHECK ALL OF SECRETCODE FOR CASE 2;;
    ;;;;;;TODO: THIS COULD BE A BL BRANCH TO RETURN IF REWRITTEN;;;;;;
    BNE case1bne
    ;;UNCONDITIONAL BRANCH TO CASE1START. IF WE HAVE R12 #0xC, WE WILL ESCAPE;;
    B case1start

;;;;;;;;;;;;;;;;;;;; CASE 1 FAIL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;IS QUERYCODE[IDX] != SECRETCODE[IDX]? IF SO, TRY CASE2 LOOP;;;
case1bne:
;;;;;;;;;;;;;;;;;;;;R12 is CASE 1 IDX. FOR CASE2, IDX is R11;;;;
;;;;SET R11 (CASE2IDX) to #0, RESET IDX
;;;;(We may have it set from previous Case2 loops)
MOV R11,#0
;; WORK ON CASE2 ;;;;
B case2start

;;;;;;;;;;;;;;;;;;;; CASE 1 SUCCESS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;IS QUERYCODE[IDX] == SECRETCODE[IDX]? IF SO, CASE1 = true;;;;
case1beq:
;;ADD 1 to R0
ADD R0,R0,#0x1
;; MOVE IDX UP A BYTE (idx++)
ADD R12,R12,#0x4
;;;;UNCDONDITIONAL BRANCH TO CASE1 LOOP
B case1start

;;;;;;;;;;;;;;;;;;;; CASE 2 SUCCESS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;IS QUERYCODE[IDX] == SECRETCODE[CASE2IDX]? IF SO, CASE2 = true;;;;
case2beq:
;;ADD 1 to R1
ADD R1,R1,#0x1
;; MOVE CASE2IDX UP A BYTE (case2idx++)
ADD R11,R11,#0x4
B case2start

;;;;;;;;;;;;;;;;;;;; CASE 2 END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; We have checked all Case2 cases against outer loop IDX of querycode.
;; MOVE OUTER IDX (CASE1) UP A BYTE AND MOVE TO NEXT QUERYCODE PEG
case2end:
;; MOVE CASE2IDX UP A BYTE (case2idx++)
ADD R12,R12,#0x4
B case1start

;;;;;;;;;;CASE1,CASE2 IDX CHECK;;;;;;;;;;
;; We don't want to check the same idx that has already been checked in CASE1
;; IF we are hitting Case2, this means the position and colour CANNOT be correct.
skipinneridx:
;; MOVE CASE2IDX UP A BYTE (case2idx++)
ADD R11,R11,#0x4
;; BRANCH TO CASE2 TO CONTINUE
B case2start

case2start:
; in this static example, it should be R0 1 R1 2
; QUERY;SECRET
; 70;70(r1), 70;67, 70;79
; 67;72,67;67(r1),67;70
; 62;72,62;67,62;70,62;79
;; HAVE WE HIT ABOVE 12 (4+4+4, 3 ITERATIONS. IT IS 0-INDEXED, SO ALL 4 CHARS) IF SO, END (STAGE 5B)
CMP R11, #0xC
;;CASE2END, ITERATE OUTER LOOP
BGT case2end
CMP R11,R12
BEQ skipinneridx;
;; load secret (from #0) peg to R6
LDR R6, [R2+R11]
;; COMPARE SECRETPEG to QUERYPEG;;;;
CMP R6,R5
;;;;;;IS CASE2 TRUE, IF SO BEQ;;;;
BEQ case2beq
;;;;IF CASE2 FALSE, MOVE CASE2IDX;;;;;;
BNE skipinneridx

end:
HALT


;; STORAGE =========================================================
; Not final array, and is static in order to have individual functionality of array.
;; Array Size
arraySize: .BYTE 16 ;; 4 elements * 4 bytes
;; secret code array
.ALIGN 128
;;assume secret of rgpy
secretcode: .BYTE   0x72
                    0x67
                    0x70
                    0x79
;;
;; query code array
;; assume query of rpgb
.ALIGN 128
querycode: .BYTE    0x72
                    0x70
                    0x67
                    0x62
;;
;; MESSAGES ========================================================