## Question
```
contract O
contract A is O
contract B is O
contract C is O
contract K1 is A, B
contract K2 is A, C
contract Z is K1, K2
```

## Answer
```
L(O) := [O]

L(A) := [A] + merge(L(O), [O]) 
			= [A] + merge([O], [O]) 
			= [A, O]

L(B) := [B, O]

L(C) := [C, O]

L(K1) := [K1] + merge(L(A), L(B), [A, B]) 
			 = [K1] + merge([A, O], [B, O], [A, B])
			 = [K1, A] + merge([O], [B, O], [B]) 
			 = [K1, A, B] + merge([O], [O])
			 = [K1, A, B, O]

L(K2) := [K2] + merge(L(A), L(C), [A, C])
       = [K2, A, C, O]

L(Z) := [Z] + merge(L(K1), L(K2), [K1, K2])                  
			= [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])  // select K1
			= [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])      // fail A, select K2
			= [Z, K1, K2] + merge([A, B, O], [A, C, O])            // select A
			= [Z, K1, K2, A] + merge([B, O], [C, O])               // select B
			= [Z, K1, K2, A, B] + merge([O], [C, O])               // select C
			= [Z, K1, K2, A, B, C] + merge([O], [O])               // select O
			= [Z, K1, K2, A, B, C, O]                              // done
```

参考：()[https://en.wikipedia.org/wiki/C3_linearization]