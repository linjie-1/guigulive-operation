### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化



### 答案

1. 新版智能合约参考 EnhancedPayroll.sol
2. 消耗记录如下

| 序号 | 新加入的 employee address | transaction cost | execution cost |
| ---------- | :-----------:  | :-----------: | :-----------: |
| 1 | 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db | 22944 gas | 1672 gas |
| 2 | 0x4b0897b0513fdc7c541b6d9d7e929c4e536bd2d4 | 23725 gas | 2453 gas |
| 3 | 0x4b0897b0513fdc7c541b6d9d7e929c4e536153db | 24506 gas | 3234 gas |
| 4 | 0x4b0897b0513fdc7c541b6d9d7e929c4e5363d1b5 | 25287 gas | 4015 gas |
| 5 | 0x4b0897b0513fdc7c541b6d9d7e929c4e5360c7b3 | 26068 gas | 4796 gas |
| 6 | 0x4b0897b0513fdc7c541b6d9d7e929c4e5363c0b7 | 26849 gas | 5577 gas |
| 7 | 0x4b0897b0513fdc7c541b6d9d7e929c4e536367da | 27630 gas | 6358 gas |
| 8 | 0x4b0897b0513fdc7c541b6d9d7e929c4e5366a7d3 | 28411 gas | 7139 gas |
| 9 | 0x4b0897b0513fdc7c541b6d9d7e929c4e536280ed | 29192 gas | 7920 gas |
| 10 | 0x4b0897b0513fdc7c541b6d9d7e929c4e536e08d2 | 29973 gas | 8701 gas |

transaction cost 大约每次增加：781 gas
excution cost 大约每次增加：781 gas

原因分析：每次新增了一个员工之后，计算时循环语句多执行一次，即 total += employees[i].salaryInMonth; 这句话会多执行一次，因此每次消耗的 gas 会多大概781那么多。
3. 函数优化

3.1 需要定义一个状态变量用于记录当前合约的薪水总数：

```
  uint totalSalary = 0;
```
3.2 每次对 employee 进行操作需要更新薪水总数：
```
    // add
    function addEmployee(address id, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(id);
        assert(employee.id == 0x0);
        employees.push(Employee(id, salary * 1 ether, now));
        totalSalary += salary;
    }

    // remove
    function removeEmployee(address id) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(id);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salaryInMonth;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    // update
    function updateEmployee(address id, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(id);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary += salary - employee.salaryInMonth;
        employee.id = id;
        employee.salaryInMonth = salary;
    }
```
3.3 计算时直接使用薪水总数，不再使用循环实时计算
```
// calculateRunway
    function calculateRunway() returns (uint) {
        assert(totalSalary > 0);
        return this.balance / totalSalary;
    }
```

3.4 按照新的方案部署之后，已经确认每次新增之后调取计算函数，消费的 gas 不再发生变化
transaction cost 大约每次：22331 gas
excution cost 大约每次：1059 gas
