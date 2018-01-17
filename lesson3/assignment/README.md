## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
  * ![AddFund](images/2018/01/addfund.png)
  * ![AddEmployee](images/2018/01/addemployee.png)
  * ![getPaid](images/2018/01/getpaid.png)
  * ![CalculateRunway](images/2018/01/calculaterunway.png)
  * ![HasEnoughFund](images/2018/01/hasenoughfund.png)
  * ![UpdateEmployee](images/2018/01/updateemployee.png)
  * ![RemoveEmployee](images/2018/01/removeemployee.png)
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
  * ![changePaymentAddress](images/2018/01/changepaymentaddress.png)
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
  * L(Z)  := [O]
- contract A is O
  * L(A)  := [A, O]
- contract B is O
  * L(B)  := [B, O]
- contract C is O
  * L(C)  := [C, O]
- contract K1 is A, B
  * L(K1)  := [K1] + Merge([A, O], [B,O])
  * L(K1)  := [K1, A] + Merge([O], [B,O])
  * L(K1)  := [K1, A, B] + Merge([O], [O])
  * L(K1)  := [K1, A, B, O]
- contract K2 is A, C
  * L(K2)  := [K2] + Merge([A, O], [C,O])
  * L(K2)  := [K2, A] + Merge([O], [C,O])
  * L(K2)  := [K2, A, C] + Merge([O], [O])
  * L(K2)  := [K2, A, C, O]
- contract Z is K1, K2
  * L(Z)  := [Z] + Merge([K1, A, B, O], [K2, A, C, O])
  * L(Z)  := [Z, K1] + Merge([A, B, O], [K2, A, C, O])
  * L(Z)  := [Z, K1, K2] + Merge([A, B, O], [A, C, O])
  * L(Z)  := [Z, K1, K2, A] + Merge([B, O], [C, O])
  * L(Z)  := [Z, K1, K2, A, B] + Merge([O], [C, O])
  * L(Z)  := [Z, K1, K2, A, B, C] + Merge([O], [O])
  * L(Z)  := [Z, K1, K2, A, B, C, O]
