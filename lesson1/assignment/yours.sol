/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    
    address employer;
    address employee;
    uint salary;
    uint constant payDuration = 30 days;
    uint lastPayDay = now;
    
    function Payroll()
    {
        employer = msg.sender;
    }
    
    function setEmployee(address _employee)
    {
        if(msg.sender != employer)
        {
            revert();
        }
        
        if(employee != 0x0 && employee != _employee)
        {
            uint payment = salary * (now - lastPayDay) / payDuration;
            employee.transfer(payment);
        }
        
        employee = _employee;
    }
    
    function setSalary(uint _salary)
    {
        if(msg.sender != employer)
        {
            revert();
        }
        
        if (_salary < 0)
        {
            revert();
        }
        
        if(employee != 0x0)
        {
            uint payment = salary * (now - lastPayDay) / payDuration;
            employee.transfer(payment);
        }
            
        salary = _salary * 1 ether;
    }
    
    function addFund() payable returns (uint)
    {
        return this.balance;
    }
    
    function calculateRunway() returns (uint)
    {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool)
    {
        return calculateRunway() > 0;
    }
    
    function getPaid() returns (uint)
    {
        if(msg.sender != employee)
        {
            revert();
        }
        
        uint nextPayDay = lastPayDay + payDuration;
        if(nextPayDay > now)
        {
            revert();
        }
        
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
}
