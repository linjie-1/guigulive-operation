## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
  * execution cost:
    + 1686
    + 2467
    + 3248
    + 4029
    + 4810
    + 5591
    + 6372
    + 7153
    + 7934
    + 8715
  * It's because calculateRunway will loop through all of the employees for each call. Very inefficient.

- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
  * use a state variable totalSalary to track the total salary. Update this variable when change employee info.
  * execution cost after optimization:
    + 852
    + 852
    + 852
    + 852
    + 852
    + 852
    + 852
    + 852
    + 852
    + 852

```
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    uint totalSalary;

    address owner;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }

    Employee[] employees;

    function Payroll() public{
        owner = msg.sender;
    }

    function _findEmployee(address e) private returns (Employee, uint){
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == e){
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        // when no employee is found, does _findEmployee return empty values?
        assert(employee.id == 0x0);
        employees.push(Employee(e, s * 1 ether, now));
        totalSalary += s;
    }

    function removeEmployee(address e) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employees[index].salary = s * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += s;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public returns (uint){
        // uint totalSalary;
        // for (uint i = 0; i < employees.length; i++){
        //     totalSalary += employees[i].salary;
        // }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public{
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}
```
