## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？
0:"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1
 transaction cost 	23010 gas 
 execution cost 	1738 gas

1:"0x14723a09acff6d2a60dcdf7aa4aff308fddc161c",1
 transaction cost 	91288 gas 
 execution cost 	68416 gas
 
2:"0x14723a09acff6d2a60dcdf7aa4aff308fddc162c",1
 transaction cost 	23780 gas 
 execution cost 	2508 gas 

3:"0x14723a09acff6d2a60dcdf7aa4aff308fddc163c",1
 transaction cost 	24550 gas 
 execution cost 	3278 gas 
 
4:"0x14723a09acff6d2a60dcdf7aa4aff308fddc164c",1
 transaction cost 	25320 gas 
 execution cost 	4048 gas
 
5:"0x14723a09acff6d2a60dcdf7aa4aff308fddc165c",1
 transaction cost 	26090 gas 
 execution cost 	4818 gas 
 
6:"0x14723a09acff6d2a60dcdf7aa4aff308fddc166c",1
 transaction cost 	26860 gas 
 execution cost 	5588 gas 
 
7:"0x14723a09acff6d2a60dcdf7aa4aff308fddc167c",1
 transaction cost 	27630 gas 
 execution cost 	6358 gas 
 
8:"0x14723a09acff6d2a60dcdf7aa4aff308fddc168c",1
 transaction cost 	28400 gas 
 execution cost 	7128 gas 
 
9:"0x14723a09acff6d2a60dcdf7aa4aff308fddc169c",1
 transaction cost 	29170 gas 
 execution cost 	7898 gas 

Gas变化么？如果有 为什么？
gas在增加，每次都需要计算totalSalary



- 如何优化calculateRunway这个函数来减少gas的消耗？
增加一个成员变量totalSalary，每次增删改员工的时候更新totalSalary

