pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address employer;
    Employee[] employees;
    uint totalSalary;

    function Payroll() public payable {
        employer = msg.sender;
    }
    
    function _partialPay(uint index) private {
        Employee storage employee = employees[index];
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }
    
    function _findEmployeeIndex(address employeeId) private view returns (int) {
        for (uint i = 0; i < employees.length; i++) {
            if (employeeId == employees[i].id) {
                return int(i);
            }
        }
        return -1;
    }
    
    function addEmployee(address employeeId, uint salary) public {
        require(employeeId != 0x0);
        require(msg.sender == employer);
        int index = _findEmployeeIndex(employeeId);
        assert(index < 0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == employer);
        int index = _findEmployeeIndex(employeeId);
        assert(index >= 0);
    
        _partialPay(uint(index));
        totalSalary -= employees[uint(index)].salary;
        delete employees[uint(index)];
        employees[uint(index)] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) public {
        require(employeeId != 0x0);
        require(msg.sender == employer);
        int index = _findEmployeeIndex(employeeId);
        assert(index >= 0);
        
        _partialPay(uint(index));
        totalSalary -= employees[uint(index)].salary;
        employees[uint(index)].salary = salary * 1 ether;
        totalSalary += salary * 1 ether;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        require(totalSalary > 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        int index = _findEmployeeIndex(msg.sender);
        assert(index >= 0);
        
        Employee storage employee = employees[uint(index)];
        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
