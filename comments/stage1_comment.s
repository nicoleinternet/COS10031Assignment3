;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COS10031 - Computer Technology | Assessment 3
;; Vandy Aum, Marcus Mifsud, Nicole Reichert, Luke Byrnes
;; Mastermind Game - stage1.txt - Luke Byrnes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Register Assignations
;; R0, (Compare Code of Correct Pos;Col)
;; R1, (Compare Code of (Correct Pos, Incorrect Col))
;; R2, General Purpose
;; R3, General Purpose
;; R4, General Purpose
;; R5, General Purpose
;; R10 Message Register
;; R9,8 General Purpose
;; R11 Guess Limit
;; R12 Secret Code
;; Stage 1 - Game Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;STAGE_1;;;;;;;;;;;;;;;;;;;;;;;
;; Prompt and store Codemaker Name
;; Set whoIsCodeMaker ASCIZ label to R10
    MOV R10, #whoIsCodeMaker
;; print R10 (whoIsCodeMaker) to WriteString
    STR R10, .WriteString
;; Set codeMaker ASCIZ label to R4 - THIS IS CURRENTLY EMPTY
    MOV R4, #codeMaker
;; Take input from user and store to R4 - POPULATES R4 WITH USER INPUT
    STR R4, .ReadString
;; Print codeMaker address from R4
    STR R4, .WriteString
;; Prompt and store CodeBreaker Name
    ;;  Set whoIsCodeBreaker ASCIZ label to R10
    MOV R10, #whoIsCodeBreaker
    ;; print R10 (whoIsCodeBreker) to WriteString
    STR R10, .WriteString
    ;; Set codeBreaker ASCIZ label to R5 - THIS IS CURRENTLY EMPTY
    MOV R5, #codeBreaker
    ;; Take input from user and store to R5 - POPULATES R5 WITH USER INPUT
    STR R5, .ReadString
    ;; Store codeMaker address from R5, prints string to IO
    STR R5, .WriteString

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prompt and store GuessLimit for the game
    ;; Set whatIsGuessLimit address to R10
    MOV R10, #whatIsGuessLimit
    ;; Store whatIsGuessLimit address to the writeString label, IO to user to prompt input.
    STR R10, .WriteString
    ;; Take input from user and store to R11
    LDR R11, .InputNum
    ;; Store input value to address of #guessLimit
    STR R11, #guessLimit
    ;; Print guessLimit (from addr, in R11) to WriteUnsignedNum
    STR R11, .WriteUnsignedNum
    ;; STAGE 1 COMPLETE, MOVE TO STAGE 2    
    HALT

;; Program functions:
    ;; Display whoIsCodeMaker Query prompt:
    whoIsCodeMaker: .ASCIZ "Codemaker is: "
    ;; Store block of memory of 128 bytes to store the string
    codeMaker: .BLOCK 128
    ;; Display whoIsCodeMaker Query prompt:
    whoIsCodeBreaker: .ASCIZ "\nCodebreaker is: "
    ;; Store block of memory of 128 bytes to store the string
    codeBreaker: .BLOCK 128
    ;; Display guessLimit Query prompt:
    whatIsGuessLimit: .ASCIZ "\nGuess Limit: "
    ;; Store the guesslimit as a label, 0 as default
    guessLimit: .WORD 0
