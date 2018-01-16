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

        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}