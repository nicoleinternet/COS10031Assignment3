\begin{titlepage}
\begin{center}

\textbf{COS10031 Computer Technology}

\vspace{0.5cm}

\textbf{Assignment 3: ARMLite Mastermind Game}

\vspace{2.5cm}

\textbf{8:30am Tuesday, 10:30am Wednesday}

\textbf{with Dr. Sourabh Dani}

\vspace{2.5cm}

\textbf{Nicole Reichert (100589839)}

\textbf{Marcus Mifsud (105875038)}

\textbf{Vandy Aum (105715697)}

\textbf{Luke Byrnes (7194587)}

\vspace{2.5cm}

Due: 18 May 2025

\textbf{Diploma IT - Swinburne College}

\end{center}
\end{titlepage}

\tableofcontents

# Mastermind Assembly Game

## Program Overview

This program replicates gameplay of the Mastermind boardgame in Assembly using the ARMLite assembly utility.

## Key Functions

### Stage 1 (`stage1.txt`)

Stage 1 makes use of the following functions:

```{.asm filename="Functions of 'stage1.txt'" code-line-numbers="true"}
// Program functions:
    // Display whoIsCodeMaker Query prompt:
    whoIsCodeMakerMsg: .ASCIZ "Codemaker is: "
    // Store block of memory of 128 bytes to store the string
    codeMakerMsg: .BLOCK 128
    // Display whoIsCodeMaker Query prompt:
    whoIsCodeBreakerMsg: .ASCIZ "\nCodebreaker is: "
    // Store block of memory of 128 bytes to store the string
    codeBreakerMsg: .BLOCK 128
    // Display guessLimit Query prompt:
    whatIsGuessLimitMsg: .ASCIZ "\nGuess Limit: "
```

![Stage 1: Functional Screenshot](./img/stage1.png){width="600"}

### Stage 2 (`stage2.txt`)

In stage 2 a function `getcode` was created to receive input of a code and validate that it follows the rules of the game. After receiving input, the value of each character is extracted from the string using `LDRB` before branching to `validateChar` where it is checked against all valid characters. The fifth character of the string is then checked and returns an error if it has any value.

---
stage2.txt
---

```{.asm code-line-numbers="true"}
getcode:
    // store address of where the function was called from
    MOV R8, LR
    getcodeNested:
        // Read input of code
        MOV R12, #tempcode
        STR R12, .ReadString
        // Validate Secret Code
        // First Character
            // Store the address of the first byte of R12 content (secret code) in R9
            LDRB R9, [R12]
            BL validateChar
        // Second Character
            // Store the address of the second byte of R12 content (secret code) in R9
            //one character is one byte so when adding one byte to R12 it will be the address of the next character
            LDRB R9, [R12, #1] 
            BL validateChar
        // Third Character
            // Store the address of the third byte of R12 content (secret code) in R9
            LDRB R9, [R12, #2]
            BL validateChar
        // Fourth Character
            // Store the address of the fourth byte of R12 content (secret code) in R9
            LDRB R9, [R12, #3]
            BL validateChar
        // Fifth Character
            // Store the address of the fifth byte of R12 content (secret code) in R9
            LDRB R9, [R12, #4]
            CMP R9, #0      //check if a character was not entered
            BNE overLimit   //if a character was entered branch to 'overLimit'
        //if a fifth character was not entered and all prior checks passed, input is valid, return to code
        // return address the function was called from to LR
        MOV LR, R8
        B Return
         
invalidChar:
    MOV R10, #errorMsg1
    STR R10, .WriteString
    b getcodeNested
tooFewChar:
    MOV R10, #errorMsg2
    STR R10, .WriteString
    b getcodeNested
overLimit:
    MOV R10, #errorMsg3
    STR R10, .WriteString
    b getcodeNested

// VALIDATE CHARACTER FUNCTION
validateChar:
    CMP R9, #0        //check if a character was not entered
    BEQ tooFewChar
    CMP R9, #0x72     //check if the character is r(red)
    BEQ Return
    CMP R9, #0x67     //check if the character is g(green)
    BEQ Return
    CMP R9, #0x62     //check if the character is b(blue)
    BEQ Return
    CMP R9, #0x79     //check if the character is y(yellow)
    BEQ Return
    CMP R9, #0x70     //check if the character is p(purple)
    BEQ Return
    CMP R9, #0x63     //check if the character is c(cyan)
    BEQ Return
    b invalidChar     //branch to 'invalidChar' if the character was not matched by any of the above checks

// Function to return from function
Return: RET
```

![Stage 2: Functional Screenshot](./img/stage2.png){width="600"}

### Stage 3 (`stage3.txt`)

In stage 3 the 'codeToArray' function was created to convert the string 'tempcode' into an array. The `getcode` function was also modified to utilize `.ReadSecret` the first time it runs (always the code maker's turn) to hide the entered code from the code breaker.

---
codeToArray function of 'stage3.txt'
---

```{.asm code-line-numbers="true"}
// Store code to array function
// R12 - Address to tempcode is stored here
// R9 - Current Character
// R6 - Memory address of the array to fill
// R7 - Array index
secretCodeToArray:
    // load the address of the secret code into R6
    MOV R6, #secretcode
    B codeToArray
codeToArray:
    // initialize the array position to 0
    MOV R7, #0
    fillArrayLoop:
        // divide R7 (index) by 4
        LSR R7, R7, #2
        // load character into R9
        LDRB R9, [R12 + R7]
        // multiply R7 (index) by 4
        LSL R7, R7, #2

        // store character into array element
        STR R9, [R6 + R7]

        // increment index counter by 4
        ADD R7, R7, #4

        CMP R7, #codeArraySize // repeat until 4 elements of the array have been filled
        BLT fillArrayLoop
    B Return
```

---
exert from updated getcode function in 'stage3.txt'
---

```{.asm code-line-numbers="true"}
getcodeNested:
        // Read input of code
        MOV R12, #tempcode
        // Initialize R6
        MOV R6, #0
        MOV R6, #secretcode
        MOV R9, #0
        LDRB R9, [R6]
        CMP R9, #0
        BEQ secretcodeentry
        BNE querycodeentry
        // If codemaker's turn
        secretcodeentry:
            STR R12, .ReadSecret
            B validateCharLoop
        // If codebreaker's turn
        querycodeentry:
            STR R12, .ReadString
            B validateCharLoop
```

![Stage 3: Functional Screenshot](./img/stage3.png){width="600"}

### Stage 4 (`stage4.txt`)

In stage 4 the `queryloop` function was created which increments the guess counter before checking if the code breaker has exceeded the guess limit. If not, the code breaker is requested to enter their guess using the `getcode` function. The code then branches back to the start of `queryloop` and continues looping until the guess limit is met.

---
query loop function
---

```{.asm code-line-numbers="true"}
queryloop:
    // Initialize to currentGuessCount
    MOV R3, #0
    LDRB R3, currentGuessCount
    // Increment guess count by 1
    ADD R3, R3, #1
    STRB R3, currentGuessCount
    // Check if we are at guess limit
    CMP R3, R11
    BGT break
    // reset R3
    MOV R3, #0
    //
    // Continue to guess now that we've checked guess count
    // Print 'What is your guess'
    MOV R10, #requestGuessMsg
    STR R10, .WriteString
    // Print codebreaker name
    MOV R10, #codeBreaker
    STR R10, .WriteString
    // Print question mark
    MOV R10, #questionMarkMsg
    STR R10, .WriteString
    // End line
    MOV R10, #newLineMsg
    STR R10, .WriteString
    //
    // Print 'This is guess number: '
    MOV R10, #guessNumberCountMsg
    STR R10, .WriteString
    // Print guess number
    LDRB R10, currentGuessCount
    STR R10, .WriteUnsignedNum
    // End line
    MOV R10, #newLineMsg
    STR R10, .WriteString
    //
    // Get codebreaker's guess
    BL getcode
    BL queryCodeToArray

    B query
// out of guesses
break:
    HALT
//================================================================================================
// Continue stage 5 here
    query:

        B queryloop
```

![Stage 4: Functional Screenshot](./img/stage4.png){width="600"}

### Stage 5a (`stage5a.txt`)

In stage 5 the `comparecodes` function was created, it utilizes a main loop for each character of the query code and a nested loop for each character of the secret code testing for case 2.

---
compare codes function
---

```{.asm code-line-numbers="true"}
comparecodes:
    // Initializing registers
    MOV R0, #0  // Case 1 Counter
    MOV R1, #0  // Case 2 Counter
    MOV R3, #0
    LDRB R3, arraySize // Array Size
    MOV R9, #0  // Query character
    MOV R4, #0  // Secret character
    MOV R5, #querycode  // Query array address
    MOV R6, #secretcode  // Secret array address
    MOV R7, #0  // array index / loop counter
    // R2 - Inner index

    // Case 1
    case1start:
        // initialize R2 (inner index)
        MOV R2, #0
        // Load a char from query code into R9
        LDRB R9, [R5 + R7]
        //
        // Load a char from secret code into R4
        LDRB R4, [R6 + R7]
        //
        // Compare for Case 1 (BEQ)
        CMP R4, R9
        // If case 1 is true
        BEQ case1true
        // If case 1 is false
        B case2start

    // Case 2
    case2start:
        // if main index = inner index, skip case2 check
        CMP R2, R7
        BEQ case2loopback
        // load secret char
        LDRB R4, [R6 + R2]
        // Compare secret char to query char
        CMP R4, R9
        // if case 2 is true
        BEQ case2true
        //
        // branch here to skip comparison of chars already done in case 1
        case2loopback:
        // increment inner index
        ADD R2, R2, #4

        // loop until full array checked
        CMP R2, R3
        BLT case2start
        B charQueryEnd
    
    ///////////////////////////////////////////////////////////
    // Case 1 success
    // Query char matches secret char in same position
    case1true:
        // Add 1 to case1 counter
        ADD R0, R0, #1
        B case2start
        

    // Case 2 success
    // Query char matches a secret char in a different position
    case2true:
        // Add 1 to case2 counter
        ADD R1, R1, #1
        // go back to case 2 start
        B case2loopback

    // Loop back to main
    charQueryEnd:
        // Add 4 to main index
        ADD R7, R7, #4
        // Have we hit end of loop?
        CMP R7, R3
        // if not, loop back to start of char checks
        BLT case1start
        // if loop complete, display char check info
        B guessfeedback
```

![Stage 5a: Screenshot showing 2 exact matches and 2 colour matches](./img/stage5a.png){width="600"}

### Stage 5b (`stage5b.txt`)

Stage 5b...

```asm {filename="stage5b.txt" code-line-numbers="true"}
1234
```

![Stage 5b: Functional Screenshot](./img/stage5b.png){width="600"}

## Assumptions

### No restrictions for user submitted Guess Limit

Reasonable number of guesses will be submitted as input for the user without controls. The application does not constrict the user-entry value of the number of guesses to either a numerical entry limit, nor a theoretical mathematical limit of guesses needed to get the right answer. For example, as per the rules of Mastermind, the total sequences available to guess from is expressed by:

$$\text{Total Sequences} = \text{Number of options}^{\text{Number of places}}$$

$$\text{Total Sequences} = 6^{4} = 1296$$

### No Duplicate Guess controls

There are no validation checks for duplicate sequence submissions made by the user. This means that the user is burning an opportunity to guess within the specified limit, but also means that they have increased the number of guesses that could potentially be needed to obtain the correct outcome if there was no limit specified. That is, for each duplicate guess $d$, the number of total sequences increases by 1.

$$
\text{Total guesses required} = \text{Total sequences} + \text{Duplicate Guesses}
$$

$$
\text{Total guesses required} = 1296 + d
$$

## Unresolved Problems

\newpage

## Appendix 1 - Full Code Stack

```asm {filename="mastermind.asm" code-line-numbers="true"}

```
