/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {

    uint constant payDuration = 10 seconds;
    uint total;
    address owner;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    mapping(address => Employee) employees;

    function Payroll() payable public {
        owner = msg.sender;
    }
    event log(Employee e, uint index);
    event employeesLog(uint balance, address employeeId, uint salary, uint lastPayday);
    function printEmployeesInfo(address employeeId) private {
        employeesLog(this.balance, employees[employeeId].id, employees[employeeId].salary,employees[employeeId].lastPayday);
    }
    event log(uint balance, uint total);

    function partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function findEmployee(address employeeId) private returns (Employee employee){
        printEmployeesInfo(employeeId);
        return employees[employeeId];
    }
    function addEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var employee  = findEmployee(employeeId);
        assert(employee.id ==0x0);
        employees[employeeId]=(Employee(employeeId, s * 1 ether, now));
        total = total + s;
        printEmployeesInfo(employees[employeeId].id);
    }
       // 新加改变地址方法
        function changePaymentAddress(address from , address to) public {
        require(msg.sender == owner);
        var frommEployee= findEmployee(from);
        require(frommEployee.id != 0x0);
        var toEmployee = frommEployee;
        toEmployee.id = to;
        partialPaid(frommEployee);
        employees[to] =  toEmployee;
        
    }
    // 新加改变合约创建人方法
    function transferOwnership (address newOwner) public{
        require(msg.sender == owner);
        owner = newOwner;
    }
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var  employee = findEmployee(employeeId);
        assert(employee.id != 0x0);
        partialPaid(employee);
        total = total - employee.salary;
        delete employees[employeeId];
    }
    function updateEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var employee= findEmployee(employeeId);
        assert(employee.id != 0x0);
        partialPaid(employee);
        total = total - employee.salary;
        employees[employeeId].salary = s * 1 ether;
        employees[employeeId].lastPayday = now;
        total = total + s;
    }
    function addFund() payable public returns (uint) {
        log(this.balance, total);
        return this.balance;
    }
    function calculateRunway() public returns (uint){
        log(this.balance, total);
        return this.balance / total;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var employee= findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employee.salary);
    }
}
