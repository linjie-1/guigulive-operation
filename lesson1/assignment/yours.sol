pragma solidity ^0.4.14;

/** @title Payroll contract. */
contract Payroll {

    uint employeeSalary;
    address employeeWallet;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    /** @dev Initialize Payroll contract.
      * @param salary Salary of the employee.
      * @param wallet Wallet address of the employee.
      */
    function Payroll(uint salary, address wallet) {
        employeeSalary = salary * 1 wei;
        employeeWallet = wallet;
    }
    
    /** @dev set salary.
      * @param salary Width of the rectangle.
      */
    function setSalary(uint salary) {
        employeeSalary = salary * 1 wei;
    }
    
    /** @dev set employee wallet address.
      * @param wallet Wallet address of the employee.
      */
    function setWalletAddress(address wallet) {
        employeeWallet = wallet;
    }

    /** @dev add fund to employer.
      * @return employer balance after adding fund.
      */
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    /** @dev calculate how many times the employer can pay the employee
      * @return the times that employee can get paid from employer's balance
      */
    function calculateRunway() returns (uint) {
        if (employeeSalary == 0) {
            revert();
        }
        return this.balance / employeeSalary;
    }
    
    /** @dev check if employer has enough money to pay
      * @return true means employers has enough money, false means not
      */
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    /** @dev pay salary to employee
      */
    function getPaid() {
        if (msg.sender != employeeWallet) {
            revert();
        }
        
        if (employeeSalary == 0 || employeeWallet == address(0)) {
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        } 
        
        lastPayday = nextPayDay;
        employeeWallet.transfer(employeeSalary);
    }
}