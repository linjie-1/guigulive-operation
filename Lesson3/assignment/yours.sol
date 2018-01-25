/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;
import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    address owner;
    mapping (address => Employee) public employees;
    

    modifier employeeExist(address employeeId){
        require(employees[employeeId].id != 0x0);
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender  == owner);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        require(employees[employeeId].id == 0x0);
        _;
    }
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now - employee.lastPayday).div(payDuration);
        assert(this.balance >= payment);
        
        employee.lastPayday = now; 
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId){
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        _partialPaid(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        _partialPaid(employees[employeeId]);
        uint newSalary = salary.mul(1 ether);
        totalSalary = totalSalary.add(newSalary).sub(employees[employeeId].salary);
        employees[employeeId].salary = newSalary;
    }
    
    function addFund() payable onlyOwner returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender){
        uint nextPayday = employees[msg.sender].lastPayday.add(payDuration);
        assert(nextPayday < now);
        assert(employees[msg.sender].salary <= this.balance);
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }
    
    //增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
    function changePaymentAddress (address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress) {
        employees[newAddress] = employees[oldAddress];
        employees[newAddress].id = newAddress;
        delete employees[oldAddress];
    }
}