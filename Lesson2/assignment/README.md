## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

transaction cost: 22966,23747,24528,25309,26090,26871,27652,28433,29214,29995,30776
execution cost: 1694,2475,3256,4037,4818,5599,6380,7161,7942,8723,9504

gas消耗的越来越多，因为calculateRunway计算的时候要遍历所有员工，员工数量越多，计算量就越大，消耗的gas也就越多

优化calculateRunway需要配合addEmployee和removeEmployee，见代码
