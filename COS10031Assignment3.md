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

```asm {filename="Functions of 'stage1.txt'" code-line-numbers="true"}
// Program functions:
    // Display whoIsCodeMaker Query prompt:
    whoIsCodeMaker: .ASCIZ "Codemaker is: "
    // Store block of memory of 128 bytes to store the string
    codeMaker: .BLOCK 128
    // Display whoIsCodeMaker Query prompt:
    whoIsCodeBreaker: .ASCIZ "\nCodebreaker is: "
    // Store block of memory of 128 bytes to store the string
    codeBreaker: .BLOCK 128
    // Display guessLimit Query prompt:
    whatIsGuessLimit: .ASCIZ "\nGuess Limit: "
```

![Stage 1: Functional Screenshot](./img/stage1.png){width="600"}

### Stage 2 (`stage2.txt`)

Stage 2...

```asm {filename="stage2.txt" code-line-numbers="true"}
1234
```

![Stage 2: Functional Screenshot](./img/stage2.png){width="600"}

### Stage 3 (`stage3.txt`)

Stage 3...

```asm {filename="stage3.txt" code-line-numbers="true"}
1234
```

![Stage 3: Functional Screenshot](./img/stage3.png){width="600"}

### Stage 4 (`stage4.txt`)

Stage 4...

```asm {filename="stage3.txt" code-line-numbers="true"}
1234
```

![Stage 4: Functional Screenshot](./img/stage4.png){width="600"}

### Stage 5a (`stage5a.txt`)

Stage 5a...

```asm {filename="stage3.txt" code-line-numbers="true"}
1234
```

![Stage 5a: Functional Screenshot](./img/stage5a.png){width="600"}

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
