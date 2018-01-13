## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

Answer: The gas consumption increases when owner add more employees into the contract. This is because the contract needs to traverse the array of employee list with for-loop to search for the input employeee address, so that it will not add existing employee. The for-loop will visit more entries when we add more employees into the list, and cause the gas consumption increasing. 

The table below shows the gas consumption when we have different number of employees in the contract.

| Employee number | Gas Consumption of each function call "calculateRunway"  |
| ------ | ------ |
| 1 | 1715 gas |
| 2 | 2485 gas|
| 3 | 3255 gas |
| 4 | 4025 gas |
| 5 | 4795 gas |
| 6 | 5565 gas |
| 7 | 6335 gas |
| 8 | 7105 gas |
| 9 | 7875 gas |
| 10 | 8645 gas |



- 如何优化calculateRunway这个函数来减少gas的消耗？

Answer: To optimize the contract by reducing gas consumption, we can avoid the for-loop operation each time we call function "calculateRunway". Instead, we use a "local variable" (e.g., total_salary) to keep track of the total salary of all employees in the contract. This total salary will increment or decrement when owner add, update, or remove employee correspondingly.

The table below shows the gas consumption remains the same for each function call "calculateRunway", no matter how many employees in this contract. This demonstrates that local variable approach saved gas consumption effectively.

| Employee number | Gas Consumption of each function call "calculateRunway"  |
| ------ | ------ |
| 1 | 908 gas |
| 2 | 908 gas |
| 3 | 908 gas|
| 4 | 908 gas|
| 5 | 908 gas|
| 6 | 908 gas|
| 7 | 908 gas|
| 8 | 908 gas|
| 9 | 908 gas|
| 10 | 908 gas|



提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

