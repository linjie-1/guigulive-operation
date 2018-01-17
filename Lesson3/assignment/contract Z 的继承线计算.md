# 题目
>contract O   <br /> 
>contract A is O   <br /> 
>contract B is O   <br /> 
>contract C is O   <br /> 
>contract K1 is A, B   <br /> 
>contract K2 is A, C   <br /> 
>contract Z is K1, K2   <br /> 


# 解答
L(O):= [O]

L(A):   <br />
= [A] + merge(L(O), [O])   <br /> 
= [A] + merge([O], [O])   <br /> 
= [A, O]   <br /> 
      

L(C):   <br />
= [C] + merge(L(O), [O])   <br />
= [C] + merge([O], [O])   <br />
= [C, O]   <br /> 

L(K1):   <br />
= [K1] + merge(L(A), L(B), [A, B])   <br />
= [K1] + merge([A, O], [B, O], [A, B])   <br />
= [K1, A] + merge([O], [B, O], [B])   <br />
= [K1, A, B] + merge([O], [O])   <br />
= [K1, A, B, O]   <br />

L(K2):   <br />
= [K2] + merge(L(A), L(C), [A, C])   <br />
= [K2] + merge([A, O], [C, O], [A, C])   <br />
= [K2, A] + merge([O], [C, O], [C])   <br />
= [K2, A, C] + merge([O], [O])   <br />
= [K2, A, C, O]   <br />

L(Z):   <br />
= [Z] + merge(L(K1), L(K2), [K1, K2])   <br />
= [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])   <br />
= [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])   <br />
= [Z, K1, K2] + merge([A, B, O], [A, C, O])  <br />
= [Z, K1, K2, A] + merge([B, O], [C, O])  <br />
= [Z, K1, K2, A, B] + merge([O], [C, O])  <br />
= [Z, K1, K2, A, B, C] + merge([O], [O])  <br />
= [Z, K1, K2, A, B, C, O]  <br />
