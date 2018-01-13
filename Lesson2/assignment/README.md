## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

### Solutions

#### Gas 消耗 (优化前)

| # | Transaction cost | Execution cost |
|:-:|:----------------:|:--------------:|
| 1 |22966|1694|
| 2 |23747|2475|
| 3 |24528|3256|
| 4 |25309|4037|
| 5 |26090|4818|
| 6 |26871|5599|
| 7 |27652|6380|
| 8 |28433|7161|
| 9 |29214|7942|
| 10 |29995|8723|

Gas消耗会随着员工的增加而增长。

##### 原因分析：

`calculateRunway`函数：

```solidity
function calculateRunway() returns (uint) {
    uint totalSalary = 0;
    for (uint i = 0; i < employees.length; i++) {
        totalSalary += employees[i].salary;
    }
    return this.balance / totalSalary;
}
```

分析`calculateRunway`函数，发现问题在于`employees`数组会不断增长，导致循环带来的计算量变大。

##### 优化：

`totalSalary`这个数据可以在`addEmployee`、`removeEmployee`以及`updateEmployee`时及时更新，这样可以避免每次都遍历数组去计算`totalSalary`，所以可以通过在`contract`中增加一个变量`totalSalary`来记录总工资的变化（详细修改见代码）。

#### Gas 消耗 (优化后)

| # | Transaction cost | Execution cost |
|:-:|:----------------:|:--------------:|
| 1 |22353|1081|
| 2 |22353|1081|
| 3 |22353|1081|
| 4 |22353|1081|
| 5 |22353|1081|
| 6 |22353|1081|
| 7 |22353|1081|
| 8 |22353|1081|
| 9 |22353|1081|
| 10 |22353|1081|

