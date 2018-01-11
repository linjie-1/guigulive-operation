pragma solidity ^0.4.14;

contract Payroll {
    
    uint constant payDuration = 10 seconds;
    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() public {
        owner = msg.sender;
    }

    function changeAddress(address new_employee) public {
        require(msg.sender == owner);
        employee = new_employee;
    }
    
    function changeSalary(uint newsalary) public {
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        salary = newsalary * 1 ether;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public constant returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
