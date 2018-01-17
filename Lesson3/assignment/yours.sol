/*作业请提交在这个目录下*/

第一题：使用remix调用第一个函数，提交函数调用截图
运行及截图发助教。https://shimo.im/docs/2kiIg8Vak8IPRXbl/ 「老董智能合约第三课作业第2项」


第二题：增加changePaymentAddress函数
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payrolls is Ownable{
    using SafeMath for uint256;
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday; 
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    
    mapping(address => Employee) public employees;
    
    uint public totalSalary; //for gas
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
       // uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        uint payment = employee.salary *((now.sub(employee.lastPayday)).div(payDuration));
        employee.id.transfer(payment);
    }
        
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId,salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary); //for gas
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        
        //_partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        
        delete employees[employeeId];
    }
    
    function udpateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        
      //  _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
       
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
         
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function CheckEmployee(address employeeId) returns(uint salary, uint lastPayday ){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    } 
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunway() >0;
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        
        uint nextPayday =  employee.lastPayday.add(payDuration);
        assert(nextPayday<now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function updateEmployeeId(address employeeId, address newEmployeeId) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        
        employee.id = newEmployeeId;
        
        employees[newEmployeeId] = employee;
        
        delete employees[employeeId];
    }
    
}

加分题：L3继承线
L(A) = [A,O]
L(B) = [B,O]
L(C) = [C,O]
L(K1) = [K1,A,B,O]
L(K2) = [K2,A,C,O]
L(Z) = [Z,K1,K2,A,B,C,O]        
