
## HW

### 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
See snapshots folder

### 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能


### 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

mro(A) = [A,O]
mro(B) = [B,O]
mro(C) = [C,O]
mro(K1) = [K1] + merge(mro(A), mro(B), [A,B])
        = [K1] + merge([A,O], [B,O], [A,B])
        = [K1,A] + merge([O], [B,O], [B])
        = [K1,A,B] + merge([O], [O])
        = [K1,A,B,O]

mro(K2) = [K2] + merge(mro(A), mro(C), [A,C])
        = [K2] + merge([A,O], [C,O], [A,C])
        = [K2,A] + merge([O], [C,O], [C])
        = [K2,A,C] + merge([O], [O])
        = [K2,A,C,O]

mro(Z) = [Z] + merge(mro(K1), mro(K2), [K1, K2])
       = [Z] + merge([K1,A,B,O], [K2,A,C,O], [K1, K2])
       = [Z,K1] + merge([A,B,O], [K2,A,C,O], [K2])
       = [Z,K1,K2] + merge([A,B,O], [A,C,O])
       = [Z,K1,K2,A] + merge([B,O], [C,O])
       = [Z,K1,K2,A,B] + merge([O], [C,O])
       = [Z,K1,K2,A,B,C] + merge([O], [O])
       = [Z,K1,K2,A,B,C,O]
       
