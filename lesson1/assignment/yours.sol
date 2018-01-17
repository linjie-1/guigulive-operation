pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint payDuration = 10 seconds;
    uint lastPayday = now;

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if (msg.sender != frank) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }

        lastPayday = nextPayDay;
        frank.transfer(salary);
    }

    function changeSalary(uint new_salary) {
        salary = new_salary * 1 ether;
    }

    function getSalary() returns (uint) {
        return salary;
    }

    function changeOwner(address new_add) {
        frank = new_add;
    }
}