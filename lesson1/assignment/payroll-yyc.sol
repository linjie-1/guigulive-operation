/*作业请提交在这个目录下*/
pragma solidity ^0.4.0;

contract EnhancedPayroll {
    uint salaryInMonth;
    address staff;
    uint payDuration = 30 days;
    uint lastPayDay = now;

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salaryInMonth;
    }

    function hasEnoughMoney() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if(msg.sender != staff) {
            revert();
        }

        uint shouldPayDay = lastPayDay + payDuration;
        if(shouldPayDay > now) {
            revert();
        }

        lastPayDay = shouldPayDay;
        staff.transfer(salaryInMonth);
    }

    function changeInfo(address newAddress, uint newSalary) {
        if(msg.sender != staff) {
            revert();
        }

        uint shouldPaySalary = salaryInMonth / payDuration * (now - lastPayDay);
        lastPayDay = now;
        staff.transfer(shouldPaySalary);

        staff = newAddress;
        salaryInMonth = newSalary;
    }
}
