/*作业请提交在这个目录下*/

/****第一题:
放在img文件夹
*/

/****第二题：
employee可以改Payment地址，Modifier不是必须的。
function changePaymentAddress(address empolyeeId, address newEmployeeId) onlyOwner employeeExist(empolyeeId) {
        var employee = employees[empolyeeId];
        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, employee.lastPayDay);
        delete employees[empolyeeId];
    }
*/

/*****第三题：
L(O) := [O]
L(A) := [A, O]
L(B) := [B, O]
L(C) := [C, O]
L(K1) := [K1, A, B, O]
L(K2) := [K2, A, C, O]
L(Z) := [Z, K1, K2, A, B, C, O]
*/


/**
完整代码
*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    
    uint constant payDuration = 10 seconds;
    address owner;
    mapping (address => Employee) public employees;
    uint totalSalary = 0;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
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
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        salary = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary, now);
        totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        uint oldSalary = employee.salary;
        uint newSalary = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, newSalary, now);
        totalSalary = totalSalary + newSalary - oldSalary;
    }
    
    function changePaymentAddress(address empolyeeId, address newEmployeeId) onlyOwner employeeExist(empolyeeId) {
        var employee = employees[empolyeeId];
        employees[newEmployeeId] = Employee(newEmployeeId, employee.salary, employee.lastPayDay);
        delete employees[empolyeeId];
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
            
        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);
            
        employee.lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
