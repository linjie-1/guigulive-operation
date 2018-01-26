pragma solidity ^0.4.14;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    using SafeMath for uint;
    uint constant payDuration = 10 seconds;
    uint totalSalary ;
    address owner;
    mapping  (address=>Employee)  public employees;


    event aaa(address a);

    function Payroll() {
        owner = msg.sender;
    }
    modifier onlyowner {
         require (msg.sender == owner);
         _;
    }

     modifier employeeExist(address employeeId) {
         var employee = employees[employeeId];
         assert(employee.id != 0x0);
         _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee , uint) {
    }

    function addEmployee(address employeeId, uint salary) public
       onlyowner {
       var employee = employees[employeeId];
       assert(employee.id == 0x0);
       employees[employeeId] = Employee(employeeId,salary * 1 ether, now);
       totalSalary = totalSalary.add(salary* 1 ether);
    }

    function removeEmployee(address employeeId)public
    onlyowner employeeExist(employeeId){
         var employee = employees[employeeId];
         _partialPaid(employee);
         totalSalary = totalSalary.sub(employee.salary);
         delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary)public
    onlyowner employeeExist(employeeId){
         var employee = employees[employeeId];
         _partialPaid(employee);
         employees[employeeId].salary = salary * 1 ether;
         employees[employeeId].lastPayday = now;
         totalSalary=totalSalary-employee.salary+salary * 1 ether;

    }

    function changePaymentAddress(address newAddress)public
         employeeExist(msg.sender){
         var emp = employees[msg.sender];
         _partialPaid(emp);
         employees[newAddress] = Employee(newAddress, emp.salary, emp.lastPayday);
         delete employees[msg.sender];
     }


    function addFund()onlyowner payable returns (uint) {
         return this.balance;
    }

    function calculateRunway()public view returns (uint) {
     //   return totalSalary;
        return this.balance / totalSalary;
    }


    function balanceOf() public view returns(uint)
    {
        return this.balance;
    }
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender){
          aaa(msg.sender);
          var employee = employees[msg.sender];
          uint nextPayday = employee.lastPayday + payDuration;
          assert(now>nextPayday);
          employees[msg.sender].lastPayday = nextPayday;
          employee.id.transfer(employee.salary);
    }
}
