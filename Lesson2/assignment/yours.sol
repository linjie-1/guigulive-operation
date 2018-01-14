pragma solidity ^0.4.14;

/**
   Each new employee will add around 800 gas, due to the for-loop of the employees is O(n).
   Use totalSalary to store the salary sum to get rid of the employees for-loop.
   Transaction cost, execution cost
   1. 22966 gas 1694 gas
   2. 23747 2475
   3. 24528 3256
   4. 25309 4037
   5. 26090 4818
   6. 26871 5599
   7. 27652 6380
   8. 28433 7161
   9. 29214 7942
   10. 29995 8723
 */
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        totalSalary -= employee.salary;
        employee.id.transfer(employee.salary * (now - employee.lastPayday) / payDuration);
        employee.lastPayday = now;
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0 ; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        // get tuple
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);

        // append new employee, STRUCT initialization
        salary *= 1 ether;
        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) {
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        // remove target and add last one to the empty position
        _partialPaid(employees[index]);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) {
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employees[index]);
        employees[index].id = employeeId;
        employees[index].salary = salary * 1 ether;
        totalSalary += employees[index].salary;
    }

    // just return balance, payable will handle value update
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employees[index].lastPayday + payDuration;
        require(nextPayday <= now);
        employees[index].id.transfer(employees[index].salary);
        employees[index].lastPayday = nextPayday;
    }
}
