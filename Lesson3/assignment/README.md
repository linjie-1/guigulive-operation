## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图


 create payroll

![Screen Shot 2018-01-16 at 11.25.27 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.25.27 PM.png)

addFund

![Screen Shot 2018-01-16 at 11.25.37 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.25.37 PM.png)

addEmployee

![Screen Shot 2018-01-16 at 11.25.47 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.25.47 PM.png)

getSalary

![Screen Shot 2018-01-16 at 11.25.57 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.25.57 PM.png)

updateSalary

![Screen Shot 2018-01-16 at 11.26.13 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.26.13 PM.png)

updatePaymentDuration

![Screen Shot 2018-01-16 at 11.26.24 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.26.24 PM.png)

hasEnoughFund

![Screen Shot 2018-01-16 at 11.26.35 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.26.35 PM.png)

calculateRunaway

![Screen Shot 2018-01-16 at 11.26.44 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.26.44 PM.png)

updateEmployeeAddress

![Screen Shot 2018-01-16 at 11.26.55 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.26.55 PM.png)

After call updateEmployeeAddress

![Screen Shot 2018-01-16 at 11.27.19 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.27.19 PM.png)

removeEmployee

![Screen Shot 2018-01-16 at 11.27.33 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.27.33 PM.png)

After call removeEmployee

![Screen Shot 2018-01-16 at 11.28.15 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.28.15 PM.png)

updateBossAddress

![Screen Shot 2018-01-16 at 11.28.26 PM](/Users/xinwenwang/Desktop/Screen Shot 2018-01-16 at 11.28.26 PM.png)





- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

最后的继承顺序是 $Z, K_2, K_1,C,B,A,O$.

$L(Z) =[Z, MERGE(L(K_2), L(K_1), [K_2, K_1])]$

$L(K_1) = [K_1, MERGE(L(B), L(A),[B,A])] = [K_1, MERGE([B,O],[A,O],[B,A])] = [K_1, B, MERGE([O],[A,O],[A])] = [K_1, B, A, O]$

$L(K_2) = [K_2, MERGE(L(C), L(A),[C,A])] = [K_2, MERGE([C,O],[A,O],[C,A])] = [K_2, C, MERGE([O],[A,O],[A])] = [K_2, C, A, O]$

$\therefore L(Z) = [Z, MERGE([K_2,C,A,O], [K_1,B,A,O], [K_2,K_1])]=[Z,K_2,MERGE([C,A,O],[K_1,B,A,O],[K_1])] = [Z,K_2,K_1,C,B,A,O]$

