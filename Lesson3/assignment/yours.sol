pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary;

    address owner;
    mapping(address => Employee) public employees;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExists(address employeeId) {
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint partialPayment = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(this.balance >= partialPayment);
        
        employee.lastPayday = now;
        employee.id.transfer(partialPayment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        salary = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary, now);
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);
        
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExists(employeeId) {
        Employee employee = employees[employeeId];

        _partialPaid(employees[employeeId]);
        
        uint newSalary = salary * 1 ether;
        totalSalary += newSalary - employee.salary;
        employees[employeeId].salary = newSalary;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExists(msg.sender) returns (Employee) {
        Employee employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        assert(this.balance >= employee.salary);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
