pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint total;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _assertEmployee(address id, bool exist) private returns (uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == id) {
                if (exist) return i;
                else revert();
            }
        }
        if (exist) revert();
    }
    
    function addEmployee(address id, uint s) {
        require(msg.sender == owner);
        _assertEmployee(id, false);

        employees.push(Employee(id, s * 1 ether, now));
        total += s * 1 ether;
    }
    
    function removeEmployee(address id) {
        require(msg.sender == owner);
        uint i = _assertEmployee(id, true);

        payRemainingSalary(id);
        total -= employees[i].salary;
        delete employees[i];
        
        uint l = employees.length;
        if (i < l - 1) {
            employees[i] = employees[l - 1];
        }
        
        employees.length -= 1;
    }

    function updateEmployee(address id, uint s) {
        require(msg.sender == owner);
        uint i = _assertEmployee(id, true);
        Employee e = employees[i];
        
        payRemainingSalary(id);

        total = total - e.salary + s * 1 ether;
        e.salary = s * 1 ether;
        e.lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / total;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        uint i = _assertEmployee(msg.sender, true);
        Employee e = employees[i];

        uint nextPayday = e.lastPayday + payDuration;
        assert(nextPayday < now);

        e.lastPayday = nextPayday;
        e.id.transfer(e.salary);
    }
    
    function payRemainingSalary(address id) {
        require(msg.sender == owner);
        uint i = _assertEmployee(id, true);
        Employee e = employees[i];

        uint payment = e.salary * (now - e.lastPayday) / payDuration;
        if (payment > 0) {
            e.lastPayday = now;
            e.id.transfer(payment);
        }
    }
}
