pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 10 seconds;

    uint totalSalary;
    uint totalEmployee;
    address[] employeeList;
    mapping(address => Employee) public employees;

    event AddEmployee(address employee);
    event UpdateEmployee(address employee);
    event RemoveEmployee(address employee);
    event AddFund(uint balance);
    event GetPaid(address employee);

    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayDay)).div(payDuration);
        employee.id.transfer(payment);
    }

    function checkEmployee(uint index) public returns (address employeeId, uint salary, uint lastPayDay) {
        employeeId   = employeeList[index];
        var employee = employees[employeeId];
        salary       = employee.salary;
        lastPayDay   = employee.lastPayDay;
    }

    function addEmployee(address employeeId, uint _salary) onlyOwner employeeNotExist(employeeId) public {
        uint salary  = _salary.mul(1 ether);
        employees[employeeId] = Employee({id: employeeId, salary: salary, lastPayDay: now});
        totalSalary           = totalSalary.add(salary);
        totalEmployee         = totalEmployee.add(1);
        employeeList.push(employeeId);

        AddEmployee(employeeId);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
       var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        totalEmployee = totalEmployee.sub(1);

        uint len = employeeList.length;
        for(uint i = 0; i < len; i++) {
            if (employeeList[i] == employeeId) {
                delete employeeList[i];
                employeeList[i] = employeeList[len-1];
                len--;
                return;
            }
        }

        RemoveEmployee(employeeId);
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee   = employees[employeeId];
        uint newSalary = salary.mul(1 ether);
        assert(newSalary != employee.salary);

        _partialPaid(employee);
        totalSalary         = totalSalary.sub(employee.salary).add(newSalary);
        employee.salary     = newSalary;
        employee.lastPayDay = now;

        UpdateEmployee(employeeId);
    }

    function changePaymentAddress(address employeeNewId) employeeExist(msg.sender) employeeNotExist(employeeNewId) public {
        var employee = employees[msg.sender];
        employees[employeeNewId] = Employee({id: employeeNewId, salary: employee.salary, lastPayDay: employee.lastPayDay});
        delete employees[msg.sender];
    }

    function addFund() payable public returns (uint) {
        AddFund(this.balance);
        return this.balance;
    }

    function calculateRunway() public returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) public {
        var employee    = employees[msg.sender];
        uint nextPayDay = employee.lastPayDay.add(payDuration);
        assert(nextPayDay < now);

        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);

        GetPaid(employee.id);
    }

    function checkInfo() public returns (uint balance, uint runway, uint employeeCount) {
        balance       = this.balance;
        employeeCount = totalEmployee;
        if (totalSalary > 0) {
            runway = calculateRunway();
        }   
    }
}
