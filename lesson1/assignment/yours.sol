/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    
    address owner;
    uint salary = 1;
    address employee;
    uint lastPayday;

    function Payroll() public {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) public {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1;
        lastPayday = now;
    }
    
     event updateAddressLog(bool b);
    
     function updateAddress(address e) public {
        bool b = (msg.sender == owner);
        updateAddressLog(b);
        employee = e;
    }
    
    event updateSalaryLog(uint s);
     function updateSalary(uint s) public {
        require(msg.sender == owner);
        salary = s * 1;
        updateSalaryLog(salary);
    }    

    event addFundLog(uint balance);
    function addFund() public payable returns (uint) {
        addFundLog(this.balance);
        return this.balance;
    }
    
    function getBalance() public{
        addFundLog(this.balance);
     }
    
    event calculateRunwayLog(uint balance);
    
    function calculateRunway() public    returns (uint) {
        calculateRunwayLog(this.balance);
         calculateRunwayLog(salary);
         calculateRunwayLog(this.balance / salary);
        return this.balance / salary;
    }

    function hasEnoughFund() public   returns (bool) {
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
