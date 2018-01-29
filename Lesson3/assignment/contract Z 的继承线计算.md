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
= [K1] + merge(L(B), L(A), [A, B])   <br />
= [K1] + merge([A, O], [B, O], [B, A])   <br />
= [K1, B] + merge([O], [B, O]A, [B])   <br />
= [K1, B, A] + merge([O], [O])   <br />
= [K1, B, A, O]   <br />

L(K2):   <br />
= [K2, C, A, O]   <br />

L(Z):   <br />
= [Z] + merge(L(K1), L(K2), [K1, K2])   <br />
= [Z] + merge( [K2, C, A, O], [K1, B, A, O],  [K2, K1])   <br />
= [Z, K2, C] + merge([ A, O], [K1,B, A, O])  <br />
= [Z, K2, C, K1, B] + merge([A, O], [A, O])  <br />
= [Z,  K2, C, K1, B, A, O]  <br />
