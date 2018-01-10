pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address boss = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    address newAddr1 = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
    address newAddr2 = 0x583031d1113ad414f02576bd6afabfb302140225;
    address newAddr3 = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
    uint salary = 10 wei;
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
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        frank.transfer(salary);
    }
    function addrChange(address addr) {
        if (msg.sender != newAddr1 && msg.sender != newAddr2 && msg.sender != newAddr3) {
            revert();
        }
        frank = addr;
     }

     function salaryChange(uint target) {
        if (msg.sender != boss) {
            revert();
        }
        salary = target;
     }
}
