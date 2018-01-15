## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？
```
gas消耗记录为：
transaction cost(gas)： 23203 -> 23984 -> 24765 -> 25546 -> 26327 -> 27108 -> 27889 -> 28670 -> 29451 -> 30232
execution cost(gas)： 1931 -> 2712 -> 3493 -> 4274 -> 5055 -> 5836 -> 6617 -> 7398 -> 8179 -> 8960
```
Gas变化么？如果有 为什么？
```
变化; 因为每增加一个员工，遍历时要多计算一个员工，所以递增，且每次gas消耗的delta值一样。

```

- 如何优化calculateRunway这个函数来减少gas的消耗？
```
由于每次修改employee（add/delete/update）时才会对totalSalary有影响，故将totalSalary设为成员变量并只有当修改employee时才计算，即可避免每次都重新计算。
详见代码。
优化后，每次gas消耗保持不变，transaction cost均为22361 gas，execution cost均为1089 gas。
```
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
