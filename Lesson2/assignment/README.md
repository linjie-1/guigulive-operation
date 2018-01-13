## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

Transaction cost    22913    23224    24642    25412    26041    26952    27749    28457    29268    29979
Execution Cost      1072      2453     3163     4031     4773     5609     6419     7128     8010     8851

优化后calculateRunway的Transaction cost：22124；Execution Cost：852
