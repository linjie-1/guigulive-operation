pragma solidity ^0.4.0;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayDate;
    }

    address employer;
    Employee[] employees;
    uint constant payInterval = 10 seconds;

    function Payroll(address _employee) {
        employer = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function _partialPay(Employee employee) private {
        uint amountToPay = employee.salary * (now - employee.lastPayDate) / payInterval;
        employee.id.transfer(amountToPay);
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == employer);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == employer);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPay(employee);
        delete employees[idx]; // 这一行是否必要？
        employees[idx] = employees[employees.length -1];
        employees.length -= 1;
    }

    function getPaid() {
        var (employee, idx) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint timeToPay = employee.lastPayDate + payInterval;
        if (timeToPay > now) {
            revert();
        }
        employees[idx].lastPayDate = timeToPay;
        employee.id.transfer(employee.salary);
    }

    function updateEmployeeId(address employeeId, address newId) {
        require(msg.sender == employer);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        employees[idx].id = newId;
    }

    function updateEmployeeSalary(address employeeId, uint s) {
        require(msg.sender == employer);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPay(employee);
        employees[idx].lastPayDate = now;
        employees[idx].salary = s * 1 ether;
    }

    function updateEmployeeAndSalary(address id, address newId, uint s) {
        require(msg.sender == employer);
        updateEmployeeSalary(id, s);
        updateEmployeeId(id, newId);
    }

    /**************************** Some Tests *********************************/


    function setUpEmployees() {
        addEmployee(0x14723a09acff6d2a60dcdf7aa4aff308fddc160c, 1);
        addEmployee(0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db, 1);
        addEmployee(0x583031d1113ad414f02576bd6afabfb302140225, 1);
    }

    function testAddEmployee() {
        assert(employees.length == 3);
        assert(employees[0].id == 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c);
        assert(employees[0].salary == 1 ether);
        assert(employees[1].id == 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db);
        assert(employees[1].salary == 1 ether);
        assert(employees[2].id == 0x583031d1113ad414f02576bd6afabfb302140225);
        assert(employees[2].salary == 1 ether);
    }

    function testGetPaid() {
        uint balanceBefore = employees[0].id.balance;
        getPaid();
        assert(employees[0].id.balance - balanceBefore == 1 ether);
    }

    function testRemoveEmployee() {
        removeEmployee(0x14723a09acff6d2a60dcdf7aa4aff308fddc160c);
        assert(employees.length == 2);
        assert(employees[0].id == 0x583031d1113ad414f02576bd6afabfb302140225);
    }

    function testUpdateEmployee() {
        updateEmployeeId(employees[0].id, 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2dd);
        assert(employees[0].id == 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2dd);

        uint oldLastPayDate = employees[0].lastPayDate;
        uint oldSalary = employees[0].salary;
        uint oldBalance = employees[0].id.balance;
        updateEmployeeSalary(employees[0].id, 2);
        assert(employees[0].salary == 2 ether);
        assert(employees[0].id.balance - oldBalance == oldSalary * (employees[0].lastPayDate - oldLastPayDate) / payInterval);
    }

    /**
     *
    1. 加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用 calculateRunway 这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

    Gas 消耗：
      1782
      2563
      3344
      4125
      4906
      5687
      6433
      7249
      8030
      8811

    从结果可以看出来 gas 的消耗是逐渐增加的，这是应该 calculateRunway 这个函数每次都要循环遍历当前所有的 employee，累加计算总的 salary，
    每次加入新员工，循环计算的次数就要增加一次，所以是 gas 消耗是越来越多的。

    2. 如何优化calculateRunway这个函数来减少gas的消耗？

    在合约中定义一个 currentTotalSalary 的变量，每次添加员工是就把这个员工的 salary 累加到 currentTotalSalary 上，
    remove 员工是就把对应的 salary 从 currentTotalSalary 中减去，
    update 员工 salary 的时候也对应 update currentTotalSalary，
    这样 在 calculateRunway 函数中只需直接 return this.balance / currentTotalSalary 即可，不需要做重复的循环遍历计算

    **/
}
