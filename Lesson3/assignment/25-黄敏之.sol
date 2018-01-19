pragma solidity ^0.4.14;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Payroll is Ownable {
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;  //for new calculateRunway function
    mapping (address => Employee) public employees;
    
    modifier employeeExist(address employeeId){
        assert(employees[employeeId].id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        assert(employees[employeeId].id == 0x0);
        _;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        uint salaryInWei = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salaryInWei, now);
        totalSalary = totalSalary.add(salaryInWei);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, address employeeIdNew, uint salary) onlyOwner employeeExist(employeeId) {
        removeEmployee(employeeId);
        addEmployee(employeeIdNew, salary);
    }
    
    function changePaymentAddress(address employeeNewAddress) employeeExist(msg.sender)  employeeNotExist(employeeNewAddress){
        var employee = employees[msg.sender];
        employees[employeeNewAddress] = Employee(employeeNewAddress, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
            
        uint nextPayday = employee.lastPayday + payDuration;
        if (nextPayday > now)
            revert();
            
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

/*
函数截图调用顺序：
addFund -> addFund.png
addEmployee 地址1 -> addEmployee.png
calculateRunway -> calculateRunway.png
getPaid 地址1 -> getPaid1.png
hasEnoughFund -> hasEnoughFund.png
changePaymentAddress 地址1到地址2 -> changePaymentAddress.png
getPaid 地址2 -> getPaid2.png
updateEmployee 地址2到地址3 -> updateEmployee.png
getPaid 地址3 -> getPaid3.png

- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

L(0) = [0]
L(A) = [A, O]
L(B) = [B, O]
L(C) = [C, O]

L(K1) = [K1] + merge(L[B] + L[A] + [B, A])
      = [K1] + merge([B, O] + [A, O] + [B, A])
	  = [K1, B] + merge([O] + [A, O] + [A])
	  = [K1, B, A] + merge([O], [O])
	  = [K1, B, A, O]
L(K2) = [K2, C, A, O]

L(Z) = [Z] + merge(L[K2] + L[K1] + [K2, K1])
     = [Z] + merge([K2, C, A, O] + [K1, B, A, O] + [K2, K1])
	 = [Z, K2] + merge(C, A, O] + [K1, B, A, O] + [K1])
	 = [Z, K2, C] + merge([A, O] + [K1, B, A, O] + [K1])
	 = [Z, K2, C, K1] + merge([A, O] + [B, A, O])
	 = [Z, K2, C, K1, B] + merge([A, O] + [A, O])
	 = [Z, K2, C, K1, B, A] + merge([O], [O])
	 = [Z, K2, C, K1, B, A, O]
*/
