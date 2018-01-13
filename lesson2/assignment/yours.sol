pragma solidity ^0.4.0;

contract Payroll {
    struct Employee {
        address addr;
        uint salary;
        uint nextPayTime;
    }

    uint constant PAY_DURATION = 10 seconds;

    address employerAddr = 0x0;
    Employee[] employees;
    uint totalSalaries = 0;

    event employeeChanged();
    event salaryChanged();

    function Payroll(address _employerAddr) public {
        employerAddr = _employerAddr;
    }

    function addFund() public payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        uint _totalSalaries = 0;
        for (uint i = 0; i < employees.length; i++) {
            _totalSalaries += employees[i].salary;
        }

        require(_totalSalaries > 0);
        return this.balance / _totalSalaries;
    }

    function optimizedCalculateRunway() public view returns (uint) {
        require(totalSalaries > 0);
        return this.balance / totalSalaries;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function findEmployee(address addr) private view returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].addr == addr) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address addr, uint salary) public {
        require(msg.sender == employerAddr && addr != employerAddr && addr != 0x0);
        var (employee, index) = findEmployee(addr);
        require(employee.addr == 0x0);

        salary *= 1 ether;
        employees.push(Employee(addr, salary, now + PAY_DURATION));
        totalSalaries += salary;

        employeeChanged();
    }

    function updateEmployee(address addr, uint salary) public returns (uint) {
        require(msg.sender == employerAddr && addr != employerAddr);
        var (employee, index) = findEmployee(addr);
        salary *= 1 ether;
        require(employee.addr != 0x0 && employee.salary != salary);

        totalSalaries += salary - employee.salary;

        uint paidSalary = payAllUnpaidSalaries(employee, index);
        employees[index] = Employee(addr, salary, now + PAY_DURATION);

        salaryChanged();
        return paidSalary;
    }

    function removeEmployee(address addr) public returns (uint) {
        require(msg.sender == employerAddr && addr != employerAddr);
        var (employee, index) = findEmployee(addr);
        require(employee.addr != 0x0);

        totalSalaries -= employee.salary;

        uint paidSalary = payAllUnpaidSalaries(employee, index);
        employees[index] = employees[employees.length - 1];
        employees.length--;

        employeeChanged();
        return paidSalary;
    }

    function getPaid() public returns (uint) {
        var (employee, index) = findEmployee(msg.sender);
        require(employee.addr != 0x0 && now >= employee.nextPayTime);

        employees[index].nextPayTime += PAY_DURATION;
        employee.addr.transfer(employee.salary);
        return employee.salary;
    }

    function payAllUnpaidSalaries(Employee employee, uint index) private returns (uint) {
        uint lastPayTime = employee.nextPayTime - PAY_DURATION;
        uint workingDuration = now - lastPayTime;
        require(workingDuration > 0);

        employees[index].nextPayTime = now + PAY_DURATION;
        uint unpaiedSalaries = employee.salary * workingDuration / PAY_DURATION;
        if (unpaiedSalaries > 0) {
            employee.addr.transfer(unpaiedSalaries);
            return unpaiedSalaries;
        }

        return 0;
    }
}
