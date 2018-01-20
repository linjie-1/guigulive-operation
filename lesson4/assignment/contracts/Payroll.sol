pragma solidity ^0.4.0;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address addr;
        uint salary;
        uint nextPayTime;
    }

    uint constant PAY_DURATION = 10 seconds;

    mapping(address => Employee) public employees;
    uint totalSalaries = 0;

    event employeeChanged();
    event salaryChanged();

    modifier employeeExist(address addr) {
        require(employees[addr].addr != 0x0);
        _;
    }

    modifier employeeNotExist(address addr) {
        require(employees[addr].addr == 0x0);
        _;
    }

    function addFund() public payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalaries);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function addEmployee(address addr, uint salary) onlyOwner employeeNotExist(addr) public {
        require(addr != 0x0);

        salary = salary.mul(1 ether);
        totalSalaries = totalSalaries.add(salary);
        employees[addr] = Employee(addr, salary, now.add(PAY_DURATION));

        employeeChanged();
    }

    function updateEmployee(address addr, uint salary) onlyOwner employeeExist(addr) public returns (uint) {
        var employee = employees[addr];
        salary = salary.mul(1 ether);
        require(employee.addr != 0x0 && employee.salary != salary);

        totalSalaries = totalSalaries.add(salary).sub(employee.salary);

        uint paidSalary = payAllUnpaidSalaries(employee);
        employees[addr].salary = salary;
        employees[addr].nextPayTime = now.add(PAY_DURATION);

        salaryChanged();
        return paidSalary;
    }

    function changePaymentAddress(address newAddr) employeeExist(msg.sender) employeeNotExist(newAddr)  public {
        var employee = employees[msg.sender];

        employees[newAddr] = Employee(newAddr, employee.salary, employee.nextPayTime);
        delete employees[msg.sender];
    }

    function removeEmployee(address addr) onlyOwner employeeExist(addr) public returns (uint) {
        var employee = employees[addr];
        require(employee.addr != 0x0);

        totalSalaries = totalSalaries.sub(employee.salary);

        uint paidSalary = payAllUnpaidSalaries(employee);
        delete employees[addr];

        employeeChanged();
        return paidSalary;
    }

    function getPaid() employeeExist(msg.sender) public returns (uint) {
        var employee = employees[msg.sender];
        require(now >= employee.nextPayTime);

        employee.addr.transfer(employee.salary);
        employees[msg.sender].nextPayTime = employee.nextPayTime.add(PAY_DURATION);
        return employee.salary;
    }

    function payAllUnpaidSalaries(Employee employee) private returns (uint) {
        uint lastPayTime = employee.nextPayTime.sub(PAY_DURATION);
        uint workingDuration = now.sub(lastPayTime);
        if (workingDuration == 0) {
            return 0;
        }

        employees[employee.addr].nextPayTime = now.add(PAY_DURATION);
        uint unpaiedSalaries = employee.salary.mul(workingDuration).div(PAY_DURATION);
        if (unpaiedSalaries > 0) {
            employee.addr.transfer(unpaiedSalaries);
            return unpaiedSalaries;
        }

        return 0;
    }
}

