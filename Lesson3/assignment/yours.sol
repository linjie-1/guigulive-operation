/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint256;
     // 定义一个类型
    struct Employee {
         address id;
         uint salary;
         uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
 
    mapping(address => Employee) employees;

    uint lastPayday;
    address owner;
    uint totalSalary = 0 ether;
    // Ownable已定义,不需要覆盖 onlyOwner
    // modifier onlyOwner{
    //     require(msg.sender == owner);
    //     _;
    // }
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
         uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
         employee.id.transfer(payment);
    }

   //添加员工
    function addEmployee(address employeeId, uint salary) onlyOwner {
         var employee = employees[employeeId];
         assert(employee.id == 0x0);
         employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
         totalSalary = salary * 1 ether;
     }
    // 删除
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        // require(employee.id != 0x0); modifier取代
        _partialPaid(employee);
        // 优化totalSalary
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
        
    }
    // 更新
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        // require(employee.id != 0x0);modifier取代
        _partialPaid(employees[employeeId]);
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary += salary * 1 ether;
        totalSalary -= employees[employeeId].salary;
    }

     // 剩余支付次数
    function colculateRunway() returns (uint) {
        //将计算次数分摊到增删改查当中.
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return colculateRunway() > 0;
    }

    //返回map的值 
    function checkEmployeee(address employeeId) returns(uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function get() returns (uint)  {
        return this.balance;
    }
    // 付钱
    function getPaid() employeeExist(msg.sender) {
        var employee= employees[msg.sender];
        // require(employee.id != 0x0);
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now); 
        employee.lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
    
    // 修改钱包地址 参数:原地址.新地址
    function changePaymentAddress(address employeeId, address nextAddr) employeeExist(employeeId) employeeExist(nextAddr) {
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        employees[nextAddr] = Employee(nextAddr, employee.salary, now);
        delete employees[employeeId];
    }
}