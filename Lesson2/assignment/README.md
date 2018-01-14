## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


1.  
transaction cost 	22966 gas 
execution cost 		1694 gas 

2.  
transaction cost 	23747 gas 
execution cost 		2475 gas 

3.  
transaction cost 	24528 gas 
execution cost 		3256 gas 

4.  
transaction cost 	25309 gas 
execution cost 		4037 gas 

5.  
transaction cost 	26090 gas 
execution cost 		4818 gas 

6.  
transaction cost 	26871 gas 
execution cost 		5599 gas 

7.  
transaction cost 	27652 gas 
execution cost 		6380 gas 

8.  
transaction cost 	28433 gas 
execution cost 		7161 gas 

9.  
transaction cost 	29214 gas 
execution cost 		7942 gas 

10.  
transaction cost 	29995 gas 
execution cost 		8723 gas 

More employees, more cost. The For loop will cost more gas because it needs to traverse every employee in the array.


Set a new state variable called totalSalary to record the salary and update it in addEmployee(), removeEmployee() and updateEmployee().