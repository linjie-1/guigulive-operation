pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;  //for new calculateRunway function
    address owner;
    mapping (address => Employee) public employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        uint salaryInWei = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salaryInWei, now);
        totalSalary += salaryInWei;
    }
    
    function removeEmployee(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, address employeeIdNew, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        totalSalary -= employee.salary;
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[employeeId];
        uint salaryInWei = salary * 1 ether;
        employees[employeeIdNew] = Employee(employeeIdNew, salaryInWei, now);
        totalSalary += salaryInWei;
        
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
            
        uint nextPayday = employee.lastPayday + payDuration;
        if (nextPayday > now)
            revert();
            
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}



