pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;
   
    
    function Payroll(address _employee, uint _salary) public{
        owner = msg.sender;
        employee = _employee;
        salary = _salary;
    }
    
    function updateEmployee(address e, uint s)  public {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function checkAuthority()  private view{
        require(msg.sender == owner);
    }
    
    function updateEmployeeAddress(address newAddr)  public{
        checkAuthority();
        employee = newAddr;
    }
    
    function updateSalary(uint newSalary)  public{
        checkAuthority();
        salary = newSalary;
    }
    
    function addFund() public payable returns (uint)  {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint)  {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public view returns (bool)  {
        return calculateRunway() > 0;
    }
    
    function getPaid()  public{
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
