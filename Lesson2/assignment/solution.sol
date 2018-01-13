pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
        
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee storage, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint numOfEthers) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != employeeId);
        uint salary = numOfEthers * 1 ether;
        
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == employeeId);
        _partialPaid(employee);

        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint numOfEthers) public {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == employeeId);
        _partialPaid(employee);
        employee.salary = numOfEthers * 1 ether;
        employee.lastPayday = now;
    }
    
    function addFund() public payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function getPayDuration() returns (uint) {
        return payDuration;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; // In EVM it's jump operation; if use this.calculateRunway() will use msg, gas cost is high 
    }
    
    function getPaid() {
        address sender = msg.sender;
        var (employee, index) = _findEmployee(sender);
        assert(employee.id == sender);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
