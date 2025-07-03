# 10-bit-CPU

## Project Overview
Instructions, Mnemonic	For-		        Operation				Opcode/  

mat 							function  

Add 			add	R		R[rs] ← R[rs] + R[rt]			000/0  

Subtract		sub	R		R[rs] ← R[rs] - R[rt]			000/1  

Load word 		lw	R		R[rs] ← M[R[rt]]			001/0  

Store word		sw	R		M[R[rt]] ← R[rs] 			001/1  

Branch greater	bge	R		if(R[rs] ≥ R[rt])				010/0  

or equal					PC=R[7]  

Branch not 		bne	R		if(R[rs] != R[rt]) 			010/1  

equal						PC=R[7]  

Nor			nor	R		R[rs] ← !(R[rs] || R[t])			011/0  

Shift left		sl	R		R[rs] ← R[rs] << R[rt]			011/1  

Load upper		luhw	I1		R[rs] ← I[4:0]:rs[4:0]			100  

halfword  

Load lower		llhw	I1		R[rs] ← rs[9:5]:I[4:0]			101  

 halfword  

Add immediate 	addi	I2		R[rs] ← R[rs] + SignExtImm		110/0  

Jump			j	I2		PC ← R[0]				110/1  

End 			end 	E		PC ← PC				111  
