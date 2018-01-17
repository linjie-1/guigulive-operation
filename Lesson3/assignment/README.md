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

### Solutions

#### Problem 1
- Call addEmployee("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1):
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/addEmployee.png)
- Call addFund():
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/addFund.png)
- Call calculateRunway():
 	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/calculateRunway.png)
- Call getPaid():
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/getPaid.png)
- Call hasEnoughFund():
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/hasEnoughFund.png)
- Call removeEmployee("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db") after addEmployee("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db",1) is called:
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/removeEmployee.png)
- Call updateEmployee("0xca35b7d915458ef540ade6068dfe2f44e8fa733c",2):
	![](https://github.com/mblsktxy/guigulive-operation/blob/master/Lesson3/assignment/images/updateEmployee.png)

#### Problem 2

Please refer to the code

#### Problem 3

L(O)  := [O]
L(A)  := [A] + merge(L(O), [O])
       = [A] + merge([O], [O])
       = [A, O]
L(B)  := [B, O]
L(C)  := [C, O]
L(K1) := [K1] + merge(L(A), L(B), [A, B])
       = [K1] + merge([A, O], [B, O], [A, B])
       = [K1, A, B, O]
L(K2) := [K2] + merge(L(A), L(C), [A, C])
       = [K2] + merge([A, O], [C, O], [A, C])
       = [K2, A, C, O]
L(Z)  := [Z] + merge(L(K1), L(K2), [K1, K2])
       = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])
       = [Z, K1, K2, A, B, C, O]