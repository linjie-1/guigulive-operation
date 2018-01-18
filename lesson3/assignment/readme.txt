## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

### 答案
推导过程如下：

L(0) := [0]

L(A) := [A] + merge(L(0), [0])
      = [A] + merge([0],[0])
      = [A,0]

L(B) := [B,0]

L(C) := [C,0]

L(K1) := [K1] + merge(L[B],L[A],[B,A])
       = [K1] + merge([B,0],[A,0],[B,A])
       = [K1, B] + merge([0],[A,0],[A])
       = [K1, B, A] + merge([0],[0])
       = [K1, B, A, 0]

L(K2) := [K2] + merge(L[C],L[A],[C,A])
       = [K2] + merge([C,0],[A,0],[C,A])
       = [K2, C] + merge([0],[A,0],[A])
       = [K2, C, A] + merge([0],[0])
       = [K2, C, A, 0]

L(Z)  := [Z] + merge(L[K2],L[K1],[K2,K1])
       = [Z] + merge([K2,C,A,0],[K1,B,A,0],[K2,K1])
       = [Z, K2] + merge([C,A,0],[K1,B,A,0],[K1])
       #(fail,递归回退) = [Z, K2, K1] + merge([A,0],[B,A,0])
       = [Z, K2] + merge([C,A,0],[K1,B,A,0],[K1])
       = [Z, K2, C] + merge([A,0],[K1,B,A,0],[K1])
       = [Z, K2, C, K1] + merge([A,0],[B,A,0])
       = [Z, K2, C, K1, B] + merge([A,0],[A,0])
       = [Z, K2, C, K1, B, A] + merge([0],[0])
       = [Z, K2, C, K1, B, A, 0]


