## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图

Answer: 课程开发的合约产品化内容：payroll-origin.sol

函数调用截图：
1. addFund.jpg: call "addFund" function to add 100eth into the contract
2. addEmployee.jpg: owner add new employee into the contract
3. calculateRunway.jpg: show how many times the contract can pay this employee
4. updateEmployee.jpg: owner update the salary information of this employee
5. getPaid.jpg: employe request to get paid.
6. hasEnoughFund.jpg: check whether this contract has enough fund to pay employee
7. removeEmployee.jpg:  owner remove this employee from contract
8. transferOwnership.jpg: owner transfer the ownership of this contract to others

===========================================================================================
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能

Answer: 增加changePaymentAddress函数以后的solidity程序： payroll_with_changePaymentAddress.sol

函数调用截图：

9. changePaymentAddress.jpg: owner change the payment address of this employee
10. getPaid after changePaymentAddress:  employee request to get paid, and the salary is transferred to his new payment address

===========================================================================================
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2
