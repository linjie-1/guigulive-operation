<<<<<<< HEAD
pragma solidity ^0.4.14;
contract Yours {
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    uint salary;
    uint payment;
    address owner;
    address employee;

    function Yours() public {
        owner = msg.sender;
    }

    function addFund() public payable returns (uint) {
        return this.balance;
    }

    function updateSalary(uint s) public {
        require(owner == msg.sender);
        if (employee != 0x00) {
            payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        salary = s * 1 ether;
        lastPayday = now;
    }

    function updateEmployee(address e) public {
        require(owner == msg.sender);
        if (e != 0x00) {
            payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        lastPayday = now;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public returns (uint) {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;

=======
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    
    function updateEmployee(address e) {
        require(msg.sender == owner);
        
        employee = e;
    }
    
    function updateSalary(uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint payment = salary * (now - lastPayday) / payDuration;
        return this.balance / payment;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec
