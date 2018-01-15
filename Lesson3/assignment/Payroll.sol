pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    mapping (address => Employee) public employees;
    uint totalSalary;
    
    modifier employeeExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId) {
        require(employeeId != 0x0);
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function addEmployee(
        address employeeId,
        uint salary
    ) onlyOwner employeeNotExist(employeeId) external {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(
        address employeeId
    ) onlyOwner employeeExist(employeeId) external {
        Employee storage employee = employees[employeeId];
        uint payment = _calculatePayment(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        _partialPay(employeeId, payment);
    }
    
    function updateEmployee(
        address employeeId,
        uint salary
    ) onlyOwner employeeExist(employeeId) external {
        Employee storage employee = employees[employeeId];
        uint payment = _calculatePayment(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        totalSalary = totalSalary.add(employee.salary);
        employee.lastPayday = now;
        _partialPay(employeeId, payment);
    }
    
    function addFund() external payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() external view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) external {
        Employee storage employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(
        address employeeId
    ) employeeExist(msg.sender) employeeNotExist(employeeId) external {
        employees[employeeId] = Employee(
            employeeId,
            employees[msg.sender].salary,
            employees[msg.sender].lastPayday
        );
        
        delete employees[msg.sender];
    }
    
    function _partialPay(address employeeId, uint payment) private {
        employeeId.transfer(payment);
    }
    
    function _calculatePayment(Employee employee) private view returns (uint) {
        uint workDuration = now.sub(employee.lastPayday);
        return employee.salary.mul(workDuration).div(payDuration);
    }
}
