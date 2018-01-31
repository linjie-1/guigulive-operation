pragma solidity ^0.4.18;

import './libs/SafeMath.sol';
import './libs/Ownable.sol';

contract MyPayroll is Ownable{
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    mapping(address => Employee) public employees;

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    modifier employeeExists(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint value = employee.salary
        .mul(now.sub(employee.lastPayDay))
        .div(payDuration);
        employee.id.transfer(value);
    }

    // add
    function addEmployee(address id, uint salary) onlyOwner public{
        var employee = employees[id];
        assert(employee.id == 0x0);

        employees[id] = Employee(id, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[id].salary);
    }

    // remove
    function removeEmployee(address id) onlyOwner employeeExists(id) public{
        var employee = employees[id];
        _partialPaid(employee);
        delete employees[id];
        totalSalary = totalSalary.sub(employee.salary);
    }

    // update 
    function updateEmployee(address id, uint salary) onlyOwner employeeExists(id) public{
        var employee = employees[id];
        _partialPaid(employee);

        uint oldSalary = employee.salary;


        employees[id].salary = salary;
        employees[id].lastPayDay = now;

        totalSalary = totalSalary.sub(oldSalary);
        totalSalary = totalSalary.add(employees[id].salary);
    }

    // addFund
    function addFund() payable public returns (uint) {
        return this.balance;
    }

    // calculateRunway
    function calculateRunway() public view returns (uint) {
        assert(totalSalary > 0);
        return this.balance.div(totalSalary);
    }

    function hasEnoughMoney() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExists(msg.sender) public {
        var employee = employees[msg.sender];

        uint shouldPayDay = employee.lastPayDay.add(payDuration);
        assert(shouldPayDay < now);

        employees[msg.sender].lastPayDay = shouldPayDay;
        employee.id.transfer(employee.salary);
    }

    // changeAddress
    function changeEmployeeAddress(address id, address newId) onlyOwner employeeExists(id) public{
        var employee = employees[id];

        var tmpEmployee = employees[newId];
        assert(tmpEmployee.id == 0x0);

        _partialPaid(employee);
        
        employees[newId] = Employee(newId, employee.salary, now);
        delete employees[id];
    }
}