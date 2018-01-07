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
        
        require(msg.sender == employer);
        
        address currentEmployee = employee;

        employee = newEmployee;
        lastPayday = now;
        
        if (currentEmployee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            currentEmployee.transfer(payment);
        }
    }
    
    function updateSalary(uint newSalary) public {
        require(msg.sender == employer);
        
        uint currentSalary = salary;
        
        salary = newSalary * 1 ether;
        lastPayday = now;
        
        if (employee != 0x0) {
            uint payment = currentSalary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
    }
    
    function updateEmployeeAndSalary(address newEmployee, uint newSalary) public {
        require(msg.sender == employer);
        
        address currentEmployee = employee;
        uint currentSalary = salary;
        
        employee = newEmployee;
        salary = newSalary * 1 ether;
        lastPayday = now;
        
        if (currentEmployee != 0x0) {
            uint payment = currentSalary * (now - lastPayday) / payDuration;
            currentEmployee.transfer(payment);
        }
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
