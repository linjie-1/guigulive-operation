## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

十次gas变化的记录如下：
1. 1694gas
2. 2475gas
3. 3256gas
4. 4037gas
5. 4818gas
6. 5599gas
7. 6380gas
8. 7161gas
9. 7942gas
10. 8723gas
每次增加781gas，增加的原因是每次增加一个员工，for循环要多执行一次（一个员工累加1次，十个员工累加10次），每当多执行一次则需要消耗更多的gas。

calculateRunway函数的优化:
1.增加全局变量 totalSalary 记录所有员工一次薪水的总和。
2.去掉 calculateRunway 函数的for循环。
3.在增加，删除，修改员工的时候，对应修改 totalSalary 的值。
