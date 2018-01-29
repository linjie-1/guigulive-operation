<<<<<<< HEAD
pragma solidity ^0.4.14;

import './Owner.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
      address id;
      uint salary;
      uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    address owner;
    mapping (address => Employee) employees;
    uint totalSalary = 0;

    modifier employeeExist(address employeeId) {
      var employee = employees[employeeId];
      assert(employee.id != 0x00);
      _;
    }

    function _partialPaid(Employee employee) private {
      //uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
      uint payment = now.sub(employee.lastPayday).mul(employee.salary).div(payDuration);
      employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id == 0x00);

      employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
      totalSalary = totalSalary.add(employee.salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
      var employee = employees[employeeId];

      _partialPaid(employee);
      totalSalary = totalSalary.sub(employee.salary);
      delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
      var employee = employees[employeeId];

      _partialPaid(employee);
      totalSalary = totalSalary.sub(employee.salary);
      employee.salary = salary.mul(1 ether);
      employee.lastPayday = now;
      totalSalary = totalSalary.add(employee.salary);
    }

    function changePaymentAddress(address newEmployeeId) employeeExist(msg.sender) {
      var employee = employees[msg.sender];

      employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, now);
      delete employees[msg.sender];
    }

    function addFund() payable returns (uint) {
      return this.balance;
    }

    function calculateRunway() returns (uint) {
      return this.balance.div(totalSalary);
    }

    function hasEnoughFund() returns (bool) {
      return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) {
      var employee = employees[msg.sender];

      uint nextPayday = employee.lastPayday + payDuration;
      assert(nextPayday < now);

      employee.lastPayday = nextPayday;
      employee.id.transfer(employee.salary);
=======
/*作业请提交在这个目录下*/
//新增更改员工薪水的支付地址的函数
function changePaymentAddress(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId) {
  var employee = employees[employeeId];
  
  employees[employeeId].id = newEmployeeId;
}

//加分题
L[O] = 0

L[A] = A + merge[L[0],0] 
     = [A,0]

L[B] = B + merge[L[0],0] 
     = [B,0]

L[C] = C + merge[L[0],0] 
     = [C,0]

L[K1] = K1 + merge[L[B],L[A],B,A]
      = K1 + merge[[B,0],[A,0],[B,A]]
      = [K1,B] + merge[[0],[A,0],[A]]
      = [K1,B,A,0]
      
L[K2] = K2 + merge[L[C],L[A],C,A]
      = K2 + merge[[C,0]],[A,0]],[C,A]]
      = [K2,C,A,0]

L[Z] = Z + merge[L[K2],L[K1],[K2,K1]]     
     = Z + merge[[K2,C,A,0],[K1,B,A,0],[K2,K1]]     
     = [Z,K2] + merge[[C,A,0],[B,A,0],K1]
     = [Z,K2,K1] + merge[[C,A,0],[B,A,0]]
     = [Z,K2,K1,C,A,B,0]


//源码
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    uint totalSalary;
    address owner;
    mapping(address => Employee) public employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
         var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
>>>>>>> 076e71b01aac7c084a0c31ab12daf43d1cf839ec
    }
}
