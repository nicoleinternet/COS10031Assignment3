# COS10031Assignment3

**Purpose**: Implement a simplified version of the board game Mastermind in ARM assembly for the ARMlite simulator.

**Task**: Follow the defined sequence of stages to implement the functionality for the board game Mastermind (described in more detail below). Each stage should be thoroughly tested and is expected to work as described in each stage when loaded into the ARMlite simulator.
#### Members
- @itsmmarc
- @VandyAum
- @nicoleinternet
- @ekulbyrnes

##### Registers
R0, (Compare Code of Correct Pos/Col)
R1, (Compare Code of (Correct Pos, Incorrect Col))
R2
R3 General Purpose (used in codeToArray, outCodeArray, and Stage 4)
R4
R5
R6 General Purpose (used in codeToArray and outCodeArray functions)
R7 General Purpose (used as a counter/index in codeToArray and outCodeArray functions)
R8 Function Return (stores LR to return after a function is used within a function) (used in getcode function)
R9 Code Character Address
R10 String/Message Handling
R11 Guess Limit
R12 Address to temp code