# 10-bit-CPU

## Instruction Set Architecture (ISA)

| Instruction        | Mnemonic | Format | Operation                           | Opcode/Function |
|--------------------|-----------|-------|-------------------------------------|-----------------|
| Add                | add       | R     | R[rs] ← R[rs] + R[rt]               | 000/0           |
| Subtract           | sub       | R     | R[rs] ← R[rs] - R[rt]                | 000/1          |
| Load word          | lw        | R     | R[rs] ← M[R[rt]]                    | 001/0           |
| Store word         | sw        | R     | M[R[rt]] ← R[rs]                    | 001/1           |
| Branch ≥           | bge       | R     | if (R[rs] ≥ R[rt]) PC ← R[7]        | 010/0           |
| Branch ≠           | bne       | R     | if (R[rs] ≠ R[rt]) PC ← R[7]        | 010/1           |
| Nor                | nor       | R     | R[rs] ← !(R[rs] ∨ R[rt])            | 011/0           |
| Shift left         | sl        | R     | R[rs] ← R[rs] << R[rt]              | 011/1           |
| Load upper half    | luhw      | I1    | R[rs] ← I[4:0]:rs[4:0]              | 100             |
| Load lower half    | llhw      | I1    | R[rs] ← rs[9:5]:I[4:0]              | 101             |
| Add immediate      | addi      | I2    | R[rs] ← R[rs] + SignExtImm          | 110/0           |
| Jump               | j         | I2    | PC ← R[0]                           | 110/1           |
| End                | end       | E     | PC ← PC                             | 111             |
