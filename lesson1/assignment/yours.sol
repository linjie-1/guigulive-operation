/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employeeAddress;
    uint lastPayday;

    function Payroll() payable{
        owner = msg.sender;
    }

    function setSalary(uint s) payable returns (uint){
        require (msg.sender == owner);

        if(s < 0){
            revert;
        }
        salary = s * 1 ether;
        return salary;
    }

    function SetEmployeeAddress(address eaddress) payable{
        require(msg.sender == owner);

        if(eaddress != 0x0){
            uint payment = salary *(now - lastPayday)/payDuration;
            employeeAddress.transfer(payment);
        }

        employeeAddress = eaddress;

        lastPayday = now;
    }

    function addFund() payable returns (uint){
        return this.balance;
    }

    function calculateRunway() returns (uint){
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0 ;
    }

    function getPaid(){
        require(msg.sender == employeeAddress);

        uint nextPayday = lastPayday + payDuration;
        //assert(nextPayday < now);
        if( nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        employeeAddress.transfer(salary);
    }
}
