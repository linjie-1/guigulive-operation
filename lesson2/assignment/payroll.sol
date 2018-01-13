pragma solidity ^0.4.14;
contract Payroll {
    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    uint _totalSalary = 0;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function caculateRunway() returns (uint) {
        return this.balance / _totalSalary;
    }

    function _partialPaid(Employee employee) private {
        //如果已经不够支付当前员工拖欠的工资，则无法继续执行
        uint payTimestamp = now - employee.lastPayDay;
        assert((payTimestamp / payDuration) < (this.balance / employee.salary));

        uint payment = employee.salary * payTimestamp / payDuration;
        employee.addr.transfer(payment);
    }

    function _findEmployee(address employeeAddr) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].addr == employeeAddr) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeAddr, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeAddr);
        assert(employee.addr == 0x0);

        _totalSalary = _totalSalary + salary * 1 finney;

        employees.push(Employee(employeeAddr, salary * 1 finney, now));
    }

    function removeEmployee(address employeeAddr) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeAddr);
        assert(employee.addr != 0x0);

        _partialPaid(employee);

        _totalSalary -= employee.salary;

        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddr, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeAddr);
        assert(employee.addr != 0x0);

        _partialPaid(employee);

        _totalSalary = _totalSalary - employee.salary + salary * 1 finney;

        employees[index].salary = salary * 1 finney;
        employees[index].lastPayDay = now;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.addr != 0x0);

        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);

        employees[index].lastPayDay = nextPayDay;
        employee.addr.transfer(employee.salary);
    }
}