pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
      uint amount = (now - employee.lastPayday) / payDuration * employee.salary;
      employee.id.transfer(amount);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
      for (uint i = 0; i < employees.length; i++) {
        if (employees[i].id == employeeId) {
          return (employees[i], i);
        }
      }
    }

    function addEmployee(address employeeId, uint salary) {
      require(owner == msg.sender);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id == 0x0);
      employees.push(Employee(employeeId, salary, now));
      totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) {
      require(owner == msg.sender);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id != 0x0);
      totalSalary -= employee.salary;
      _partialPaid(employee);
      delete employees[index];
      employees[index] = employees[employees.length-1];
      employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
      require(owner == msg.sender);
      var (employee, index) = _findEmployee(employeeId);
      assert(employee.id != 0x0);
      _partialPaid(employee);
      employees[index].salary = salary;
    }
    
    function addFund() payable returns (uint) {
      return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        assert(totalSalary >= 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
      return calculateRunway() > 0;
    }
    
    function getPaid() {
      var (employee, index) = _findEmployee(msg.sender);
      assert(employee.id != 0x0);
      uint nextPayday = employee.lastPayday + payDuration;
      assert(nextPayday < now);
      employees[index].lastPayday = nextPayday;
      employee.id.transfer(employee.salary);
    }
}
