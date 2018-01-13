## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


## 作业
| Num|  transaction gas |  execution gas |
| --- | --- | --- | 
| 1 | 22812 |  1450|
|2 | 23385 |   2113
| 3  |23958| 2686  |  
| 4 |  24531  | 3259  |  
| 5 | 25104 | 3832  |  
| 6 | 25677| 4405 |  
| 7 | 26823|  5551|  
| 9 |  27396 | 6124 |  
| 10 |  27969 | 6697 |


因为num越多，循环越多，运行代码量越大，gas消耗就越多。

尝试优化代码：
因为不同存储位置，访问消耗的gas不一样。
例如demo中。循环中length使用的是状态变量直接循环，evm中状态变量的访问，消耗的gas会更多。
可以使用成员变量去保存这个length，再做循环。
```
  function calculRunway() returns(uint,uint) {
    uint totalsalary = 0 ;
    uint amount  =  employees.length;
    assert( employees.length > 0);
    for(uint i = 0 ; i < amount ; i++) {
     totalsalary += employees[i].salary;
    }
    return (this.balance / totalsalary,amount);
  }
```
