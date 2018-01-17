<<<<<<< HEAD
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
    
    function updateEmployeeAddress(address e ){
        require(msg.sender == owner);
        
        if (employee != e) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            employee = e;
            lastPayday = now;
        }
    }
    
    function updateEmployeeSalary(uint s){
        require(msg.sender == owner);
        
        if (salary != s) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            salary = s * 1 ether;
            lastPayday = now; 
        }
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() payable {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function getFullPaid() payable{
        require(msg.sender == employee);
        
        uint gaps = (now - lastPayday);
        uint numPays =  gaps / payDuration;
        assert(numPays > 0);
        
        lastPayday = lastPayday + (numPays * payDuration);
        uint amount = salary * numPays;
        employee.transfer(amount);
=======
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
>>>>>>> 4fc9130572fac2bc01ddef78f44852ea18fbe98d
    }
}
