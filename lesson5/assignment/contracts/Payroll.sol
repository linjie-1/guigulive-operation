pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    
    address owner;
    mapping(address => Employee) public employees;
    uint totalSalary = 0;
    uint totalEmployee;
    address[] employeeList;

    modifier employeeExist(address employeeAddr) {
        assert(employees[employeeAddr].addr != 0x0);
        _;
    }

    modifier employeeNotExist(address employeeAddr){
        assert(employees[employeeAddr].addr == 0x0);
        _;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function caculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
        return caculateRunway() > 0;
    }

    function _partialPaid(Employee employee) private {
        //如果已经不够支付当前员工拖欠的工资，则无法继续执行
        uint payTimestamp = now.sub(employee.lastPayDay);
        assert(payTimestamp.div(payDuration) <= this.balance.div(employee.salary));

        uint payment = employee.salary.mul(payTimestamp).div(payDuration);
        employee.addr.transfer(payment);
    }

    function addEmployee(address employeeAddr, uint salary) onlyOwner {

        employees[employeeAddr] = Employee(employeeAddr, salary.mul(1 ether), now);

        totalSalary = salary.mul(1 ether).add(totalSalary);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeAddr);
    }

    function removeEmployee(address employeeAddr) onlyOwner employeeExist(employeeAddr) {
        var employee = employees[employeeAddr];

        _partialPaid(employee);
        delete employees[employeeAddr];
        
        bool hasFound = false;
        for (uint i = 0; i < employeeList.length; i++) {
            if (employeeList[i] == employeeAddr) {
                hasFound = true;
            }
            if(hasFound && i != employeeList.length - 1) {
                employeeList[i] = employeeList[i+1];
            }
        }
        delete employeeList[employeeList.length - 1];
        employeeList.length -= 1;

        totalSalary = totalSalary.sub(employee.salary);
        totalEmployee = totalEmployee.sub(1);
    }

    function updateEmployee(address employeeAddr, uint salary) onlyOwner employeeExist(employeeAddr) {
        var employee = employees[employeeAddr];

        _partialPaid(employee);

        totalSalary = totalSalary.sub(employee.salary).add(salary.mul(1 ether));
        
        employees[employeeAddr].salary = salary.mul(1 ether);
        employees[employeeAddr].lastPayDay = now;
    }

    function changePaymentAddress(address employeeAddr) employeeExist(msg.sender) employeeNotExist(employeeAddr) {
        var employee = employees[msg.sender];
        
        _partialPaid(employee);
        delete employees[employeeAddr];
        
        employees[employeeAddr] = Employee(employeeAddr, employee.salary, now);
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];

        uint nextPayDay = employee.lastPayDay.add(payDuration);
        assert(nextPayDay < now);

        employees[msg.sender].lastPayDay = nextPayDay;
        employee.addr.transfer(employee.salary);
    }

    function checkEmployee(uint index) returns (address employeeAddr, uint salary, uint lastPayday) {
        employeeAddr = employeeList[index];
        var employee = employees[employeeAddr];
        salary = employee.salary;
        lastPayday = employee.lastPayDay;
    }

    function checkInfo() returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = caculateRunway();
        }
    }
}