pragma solidity ^0.4.14;

contract PayRoll {
    uint salary = 1 ether;
    address boss = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address frank = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant duration = 10 seconds;
    uint lastpayday = now;

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughfund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if(msg.sender != frank) {
            revert();
        }
        uint nextPayday = lastpayday + duration;
        if (nextPayday >= now) {
            revert();
        }
        lastpayday = nextPayday;
        frank.transfer(salary);
    }

    function changeAddress(address addr) {
        if (msg.sender != boss) {
            revert();
        }
        frank = addr;
    }

    function changeSalary(uint target) {
        if (msg.sender != boss || target <= 0) {
            revert();
        }
        salary = target;
    }
}

