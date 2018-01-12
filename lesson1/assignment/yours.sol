/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract SinglePayeePayroll {
    struct Payee{
        address payeeAddress;
        string payeeName;

    }
    address owner =  0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 0;
    uint constant payDuration = 30 days;
    uint lastPayday = now;
    Payee payee;

    function setPayee(string name, address addr) {
        if(msg.sender != owner) {
            revert();
        }
        if (payee.payeeAddress != address(0)) {
            uint shouldPay = salary*(now - lastPayday) / payDuration;
            lastPayday = now;
            payee.payeeAddress.transfer(shouldPay);
        }

        payee.payeeName = name;
        payee.payeeAddress = addr;
    }
    
    
    function getPayeeAddress() returns (address){
        return payee.payeeAddress;
    }
    
    function getPayeeName() returns (string){
        return payee.payeeName;
    }
    
    function setSalary(uint sal) {
        if(msg.sender != owner) {
            revert();
        }
        salary = sal;
    }
    
    function getSalary() returns (uint) {
        return salary;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function getPaid() {
        if(msg.sender != payee.payeeAddress) {
            revert();
        }
        uint nextPayday =lastPayday + payDuration;
        if (nextPayday > now) {
            revert();            
        }
        lastPayday = nextPayday;
        payee.payeeAddress.transfer(salary);
    }
    
// tests    
    
    function testGetSalary() returns (bool) {
        setSalary(10000);
        return getSalary() == 10000;
    }

    
    function test() returns (bool) {
        return 1 wei == 1;
    }
}