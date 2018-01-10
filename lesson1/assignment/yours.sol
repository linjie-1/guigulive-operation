/*作业请提交在这个目录下*/
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

    //设置自定义地址
    function updateAddress(address e) public {
        require(msg.sender == owner);
        employee = e;
    }
    
    //设置自定义薪酬
    function updateSalary(uint s) public {
        require(msg.sender == owner);
        salary = s * 1 ether;
    }  


    function updateEmployee(address e, uint s) public {
        require(msg.sender == owner);
        
        //调整员工薪资前，旧薪资结算
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
