## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
答：Gas记录在cost-report.xlsx文件中，原函数会根据动态数组的元素增加，每次迭代消耗更多的gas。

- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
答：如果读取计算结果次数多，使用全局变量进行优化，在每次增删改employee的时候改变该全局变量，删除calculateRunway中的循环，达到优化gas消耗的目的
