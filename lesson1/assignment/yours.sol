/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payCycle = 10 seconds;
    
    address owner;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 1 ether;
    uint lastPayday = now;
    
    function addFund() payable returns(uint) {
        return this.balance;
    }
    
    function calculateRunway() returns(uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns(bool) {
        return calculateRunway() > 0;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    function getOwner() returns(address) {
        return owner;
    }
    
    function getPaid() {
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayday = lastPayday + payCycle;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function payCurrentSalary() {
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payCycle;
            employee.transfer(payment);
        }
        lastPayday = now;
    }

    function updateEmployeeAddress(address e) {
        require(msg.sender == owner);
        payCurrentSalary();
        employee = e;
    }

    function updateEmployeeSalary(uint s) {
        require(msg.sender == owner);
        payCurrentSalary();
        salary = s * 1 ether;
    }

    
}
