pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address employer = 0x583031d1113ad414f02576bd6afabfb302140225;
    uint salary = 1 ether;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday = now;

    function Payroll() public {
        employer = msg.sender;
    }
    
    function updateEmployee(address newEmployee) public {
        // note: call updateEmployeeAndSalary(newEmployee, salary) as a shortcut
        // will cost more gas than this implementation
        require(newEmployee != 0x0);
        require(msg.sender == employer);
        
        address currentEmployee = employee;
        uint currentLastPayday = lastPayday;

        employee = newEmployee;
        lastPayday = now;
        
        uint payment = salary * (now - currentLastPayday) / payDuration;
        currentEmployee.transfer(payment);
    }
    
    function updateSalary(uint newSalary) public {
        require(msg.sender == employer);
        
        uint currentSalary = salary;
        uint currentLastPayday = lastPayday;
        
        salary = newSalary * 1 ether;
        lastPayday = now;
        
        uint payment = currentSalary * (now - currentLastPayday) / payDuration;
        employee.transfer(payment);
    }
    
    function updateEmployeeAndSalary(address newEmployee, uint newSalary) public {
        require(newEmployee != 0x0);
        require(msg.sender == employer);
        
        address currentEmployee = employee;
        uint currentSalary = salary;
        uint currentLastPayday = lastPayday;
        
        employee = newEmployee;
        salary = newSalary * 1 ether;
        lastPayday = now;
        
        uint payment = currentSalary * (now - currentLastPayday) / payDuration;
        currentEmployee.transfer(payment);
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
