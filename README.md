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


## Instruction Formats

### R Format
| Field    | Opcode | rs   | rt   | Function |
|-----------|---------|------|------|-----------|
| Bits      | 3     | 3  | 3  | 1     |

### I1 Format
| Field    | Opcode | rs   | Immediate |
|-----------|---------|------|-----------|
| Bits      | 3     | 2  | 5       |

### I2 Format
| Field    | Opcode | rs   | Immediate | Function |
|-----------|---------|------|-----------|-----------|
| Bits      | 3     | 3  | 3       | 1       |

### E Format
| Field    | Opcode | Zero | Unused   |
|-----------|---------|------|-----------|
| Bits      | 3     | 3  | 7       |

## Registers

| Name  | Number | Use              |
|---------|---------|-------------------|
| $la    | 0     | Location address |
| $s0    | 1     | Saved temporary  |
| $s1    | 2     | Saved temporary  |
| $t0    | 3     | Temporary        |
| $t1    | 4     | Temporary        |
| $t2    | 5     | Temporary        |
| $t3    | 6     | Temporary        |
| $zero | 7     | Constant 0       |


## Example Instructions

| Instruction         | Example        | Meaning                    |
|---------------------|----------------|----------------------------|
| add                 | add $s1, $t1  | $s1 = $s1 + $t1           |
| subtract            | sub $s1, $t1  | $s1 = $s1 - $t1           |
| load word           | lw $s1, $t1   | $s1 = Memory[$t1]         |
| store word          | sw $s1, $t1   | Memory[$t1] = $s1         |
| branch ≥          | bge $s1, $t1 | If ($s1 ≥ $t1) PC = R[7] |
| branch ≠          | bne $s1, $t1 | If ($s1 ≠ $t1) PC = R[7] |
| nor                 | nor $s1, $t1 | $s1 = !($s1 ∨ $t1)      |
| shift left         | sl $s1, $t1  | $s1 = $s1 << $t1        |
| load upper halfword| luhw $t1, 4  | $t1 = 00100:$t1[4:0]    |
| load lower halfword| llhw $t1, 9  | $t1 = $t1[9:5]:01001    |
| add immediate      | addi $s2, 3  | $s2 = $s2 + 3           |
| jump               | j            | PC = R[7]               |
| end                | end         | Stops program          |
