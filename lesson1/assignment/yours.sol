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

    function updateEmployee(address e, uint s) public {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    //作业内容 更新雇员地址
    function updateAddress(address e) public {
        require(msg.sender == owner);
        employee = e;
    }
    
    //作业内容 更新雇员薪酬
    function updateSalary(uint s) public {
        require(msg.sender == owner);
        salary = s * 1 ether;
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
