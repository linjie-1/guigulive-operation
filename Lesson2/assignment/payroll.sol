pragma solidity ^0.4.14;

contract Payroll {
  
  struct Employee {
    address id  ;
    uint salary  ;
    uint lastPayday ;
  }
  uint constant payCycle  = 10 seconds;
  address owner ;
  Employee[] employees ;

  function Payroll() {
    owner = msg.sender;
  }

  function _payFullSal(Employee  employee) private {
    uint fullSalary = employee.salary *(now - employee.lastPayday) / payCycle;
    employee.id.transfer(fullSalary);
  }

  function _findEmployee(address  eaddr) private returns(Employee,uint) {
    uint amount  =  employees.length;
    for(uint i = 0 ;i < amount ;i++) {
      if(employees[i].id == eaddr ) {
        return (employees[i] , i);
       }
    }
  }

  function addFound() payable returns(uint) {
    return this.balance ;
  }

  function calculRunway() returns(uint,uint) {
    uint totalsalary = 0 ;
    uint amount  =  employees.length;
    assert(amount > 0);
    for(uint i = 0 ; i < amount ; i++) {
     totalsalary += employees[i].salary;
    }
    return (this.balance / totalsalary,amount);
  }

  function addEmployee(address eaddr ,uint sal) {
    require(msg.sender == owner );
    var (employee,index) = _findEmployee(eaddr);
    assert(employee.id == 0x0);
    employees.push(Employee(eaddr, sal * (1 ether), now));
  }

  function  removeEmployee(address eaddr) {
    require(msg.sender == owner);
    var (employee,index) = _findEmployee(eaddr);
    assert(employee.id != 0x0);
    uint amount  =  employees.length;
    _payFullSal(employee);
    delete employees[index];
    employees[index] =  employees[amount -1];
    employees.length -= 1;
  }

  function updateEmployee(address eaddr ,uint newsal) {
    require(msg.sender == owner );
    uint amount  =  employees.length;
    var (employee,index) = _findEmployee(eaddr);
    assert(employee.id != 0x0);
    _payFullSal(employee);
    employees[index].salary = newsal  * (1 ether);
    employees[index].lastPayday =now;
  }

    function isExis() returns(address,bool)  {
    var (employee,index) = _findEmployee(msg.sender);
    return (employee.id,employee.id !=0x0);
   }


  function getSalary()  {
    var (employee,index) = _findEmployee(msg.sender);
    require(employee.id != 0x0);
    uint nextPayday = employee.lastPayday + payCycle;
    assert(nextPayday < now);
    employees[index].lastPayday = nextPayday;
    employee.id.transfer(employee.salary);
   }

}
