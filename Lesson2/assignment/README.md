## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

Before optimizing calculateRunway, the gas keep increasing due to the increase of array length for number of employees. 
After using mapping structure, the gas cost remain consistent to be 22124 and 852 for transaction and execution separately.

|employee |	transaction cost	| execution cost  
|---------|-------------------|-----------------
|1	| 22,966 |	1,694  
|2	| 23,747	| 2,475  
|3	| 24,528	| 3,256  
|4	| 25,309	| 4,037  
|5	| 26,090	| 4,818  
|6	| 26,871	| 5,599  
|7	| 27,652	| 6,380  
|8	| 28,433	| 7,161  
|9	| 29,214	| 7,942  
|10	| 29,995	| 8,723  
