pragma solidity ^0.4.14;
import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {

  struct Employee {
    address id  ;
    uint salary  ;
    uint lastPayday ;
  }
  uint constant payCycle  = 10 seconds;
  address owner ;
   uint totalsalary = 0 ;
  mapping(address => Employee) employees;

  function Payroll() {
    owner = msg.sender;
  }

  modifier employeeExist(address eaddr) {
    var employee  =  employees[eaddr];
    assert(employee.id != 0x0);
    _;
  }

  function _payFullSal(Employee  employee) private {
    uint fullSalary = employee.salary *(now - employee.lastPayday) / payCycle;
    employee.id.transfer(fullSalary);
  }


  function addFound() payable returns(uint) {
    return this.balance ;
  }

  function calculRunway() returns(uint) {
    return (this.balance / totalsalary);
  }

  function checkEmployee(address eaddr)  returns(uint salary ,uint lastPayday) {
      salary =  employees[eaddr].salary;
      lastPayday = employees[eaddr].lastPayday;
  }

  function addEmployee(address eaddr ,uint sal)  onlyOwner {
     var employee =  employees[eaddr];
    assert(employee.id == 0x0);
    totalsalary += sal  * (1 ether);
    employees[eaddr] = Employee(eaddr, sal * (1 ether), now);
  }

  function  removeEmployee(address eaddr) onlyOwner employeeExist(eaddr) {
     var employee  =  employees[eaddr];
      _payFullSal(employee);
    totalsalary -=  employees[eaddr].salary;
    delete employees[eaddr];
   }


   function changePaymentAddress(address newaddr )   employeeExist(msg.sender) {
       assert(newaddr != 0x0);
       var employee  = employees[msg.sender];
       employees[newaddr] = Employee(newaddr, employee.salary,employee.lastPayday);
       delete employees[msg.sender];
  }

  function updateEmployee(address eaddr ,uint newsal) onlyOwner  employeeExist(eaddr) {
    var employee  = employees[eaddr];
     _payFullSal(employee);
    totalsalary = totalsalary - employee.salary + newsal  * (1 ether);
    employees[eaddr].salary = newsal  * (1 ether);
    employees[eaddr].lastPayday =now;
  }

  function getSalary()   employeeExist(msg.sender)  {
    var  employee  = employees[msg.sender];
     uint nextPayday = employee.lastPayday + payCycle;
    assert(nextPayday < now);
    // employees[employee.id].lastPayday = nextPayday;
    employee.lastPayday = nextPayday;
    employee.id.transfer(employee.salary);
   }
}
