/*作业请提交在这个目录下*/
Q1: 截图放置在了images文件夹中(./images/*.png)。
Q2: 
添加的函数：
    function changePaymentAddress(address employeeId) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        
        delete employees[msg.sender];
    }
    
完整代码：   
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    mapping (address => Employee) public employees;
    
    
    uint constant payDuration = 10 seconds;
    
    uint totalSalary = 0;

    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function changePaymentAddress(address employeeId) employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        employees[employeeId] = Employee(employeeId, employee.salary, employee.lastPayday);
        
        delete employees[msg.sender];
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
                       .mul(now.sub(employee.lastPayday))
                       .div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        totalSalary = totalSalary.add(salary.mul(1 ether));
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
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
        
        totalSalary = totalSalary.add(salary.mul(1 ether)).sub(employee.salary);
        
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
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
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

Q3:
L(O)  := [O]                                                

L(A)  := [A] + merge(L(O), [O]) 
       = [A] + merge([O], [O])
       = [A, O]

L(B)  := [B, O]                                            
L(C)  := [C, O]

L(K1) := [K1] + merge(L(A), L(B), [A, B])          
       = [K1] + merge([A, O], [B, O], [A, B])    
       = [K1, A] + merge([O], [B, O], [B])       
       = [K1, A, B] + merge([O], [O])       
       = [K1, A, B, O]

L(K2) := [K2] + merge(L(A), L(C), [A, C])          
       = [K2] + merge([A, O], [C, O], [A, C])    
       = [K2, A] + merge([O], [C, O], [C])       
       = [K2, A, C] + merge([O], [O])       
       = [K2, A, C, O]


L(Z)  := [Z] + merge(L(K1), L(K2), [K1, K2])
       = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])
       = [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])
       = [Z, K1, K2] + merge([A, B, O], [A, C, O])
       = [Z, K1, K2, A] + merge([B, O], [C, O])
       = [Z, K1, K2, A, B] + merge([O], [C, O])
       = [Z, K1, K2, A, B, C] + merge([O], [O])
       = [Z, K1, K2, A, B, B, O]
