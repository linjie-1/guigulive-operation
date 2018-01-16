pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
        
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    mapping(address => Employee) employees;
    uint totalSalary;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addEmployee(address employeeId, uint numOfEthers) {
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint salary = numOfEthers * 1 ether;
        totalSalary += salary;
        
        employees[employeeId] = Employee(employeeId, salary, now);
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);

        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint numOfEthers) public {
        require(msg.sender == owner);
        
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        totalSalary -= employee.salary;
        _partialPaid(employee);
        employee.salary = numOfEthers * 1 ether;
        totalSalary += employee.salary;
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
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0; // In EVM it's jump operation; if use this.calculateRunway() will use msg, gas cost is high 
    }
    
    function getPaid() {
        address sender = msg.sender;
        var employee = employees[sender];
        assert(employee.id != sender);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
