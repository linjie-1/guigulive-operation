## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


### 交作业
优化之前每次运行calculateRunway消耗的execution cost gas如下：
- 1686 gas
- 2467 gas
- 3248 gas
- 4029 gas
- 4810 gas
- 5591 gas
- 6372 gas
- 7153 gas
- 8715 gas

这是由于每次运行calculateRunway函数，都需要将所有的salary进行运算，随着员工数量的增加，运算次数增多，消耗的gas也大幅增长。
进行优化，将totalSalary计算放在增删改员工函数中，修改后的calculateRunway只需要做一次除法运算即可。增加、删除、修改员工后调用calculateRunway函数为，消耗的execution cost gas为固定值，如下：
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas
- 852 gas

本次优化会造成增删改函数消耗的gas稍有增加，但总体的gas消耗会有所减小，权衡利弊，采用优化后的函数进行运算。
