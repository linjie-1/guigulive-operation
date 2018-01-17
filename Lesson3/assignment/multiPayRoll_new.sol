/*第三节课作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2
*/

第一题：

截图在'./img'下。

pragma solidity ^0.4.14;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    uint totalSalary = 0;
    
    // mapping
    mapping(address => Employee) public employees;

    
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
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint s) onlyOwner employeeNotExist(employeeId) public{
        var employee = employees[employeeId];
        uint salary = s * 1 ether;
        employees[employeeId] = Employee(employeeId,salary,now);
        totalSalary = totalSalary.add(salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);
    }
    
    function addFund() payable onlyOwner public returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() employeeExist(msg.sender) public returns (uint) {
        var employee = employees[msg.sender];
        return this.balance / totalSalary;
    }
    
    function getPaid() employeeExist(msg.sender) public {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday <= now);
        employee.lastPayday = now;
        employee.id.transfer(employee.salary);
    }
}

第二题：

确保原有id存在并且改变后id不存在。

modifier idNotExist(address originId, address newId) {
    require(employees[originId].id != 0x0 && employees[newId].id == 0x0);
    _;
}

function changePaymentAddress(address originId, address newId) idNotExist(originId, newId) public{
    var originEmployee = employees[originId];
    _partialPaid(originEmployee);
    employees[newId] = Employee(newId, originEmployee.salary, now);
    delete employees[originId];
}

或者使用两个modifier确保originId存在以及newId不存在。

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

function changePaymentAddress(address originId, address newId) employeeExist(originId) employeeNotExist(newId) public{
    var originEmployee = employees[originId];
    _partialPaid(originEmployee);
    employees[newId] = Employee(newId, originEmployee.salary, now);
    delete employees[originId];
}

第三题（加分题）：

自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

L(O) = [O]
L(A) = [A] + merge L(L(O), [O]) 
	 = [A] + merge L([0], [0])
     = [A, O]
L(A) = [B] + merge L(L(O), [O]) 
	 = [B] + merge L([0], [0])
     = [B, O]
L(A) = [C] + merge L(L(O), [O]) 
	 = [C] + merge L([0], [0])
     = [C, O]
L(K1) = [K1] + merge L(L(A), L(B), [A, B]) 
      = [K1] + merge L([A, O], [B, O], [A, B]) 
      = [K1, A] + merge L([O], [B, O], [B]) 
      = [K1, A, B] + merge L([O], [O], [O])
      = [K1, A, B, O]
L(K2) = [K2] + merge L(L(A), L(C), [A, C]) 
      = [K2] + merge L([A, O], [C, O], [A, C]) 
      = [K2, A] + merge L([O], [C, O], [C]) 
      = [K2, A, C] + merge L([O], [O], [O])
      = [K2, A, C, O]
L(Z) = [Z] + merge L(L(K1), L(K2), [K1, K2]) 
     = [Z] + merge L([K1, A, B, O], [K2, A, C, O], [K1, K2])
     = [Z, K1] + merge L([A, B, O], [K2, A, C, O], [K2]) 
     = [Z, K1, K2] + merge L([A, B, O], [A, C, O]) 
     = [Z, K1, K2, A] + merge L([B, O], [C,O])
     = [Z, K1, K2, A, B] + merge L([O], [C, O])
     = [Z, K1, K2, A, B, C] + merge L([O], [O])
     = [Z, K1, K2, A, B, C, O]