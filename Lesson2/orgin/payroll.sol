pragma solidity ^0.4.14;


// many employees
contract Payroll {
    // 与C语言类似，可以支持结构类型
    struct Employee {
        address id;  // 这里的ID是个地址 
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees; // 动态数组

    // 构造函数
    function Payroll() {
        owner = msg.sender;
    }
    
    // 知识点：private
    // 如果不加private，会出现这种奇怪的错误 
    // InternalCompilerError: Static memory load of more than 32 bytes requested.
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    // 查
    // multi return values
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0; i<employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i); // ??? 返回的是一个指针 ？
            }
        }
    }

    // 增A
    // dynimic array use push function
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        employees.push(Employee(employeeId, salary, now));
    }
    
    // 删D
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (employee, index)= _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index]; // 会留下一个空位 
        employees[index] = employees[employees.length-1];
        employees.length -= 1; // 动态数组的length是可以修改的 
    }
    
    // 改U
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (employee, index)= _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employee.id = employeeId;
        employee.salary = salary;
        employee.lastPayday = now;
    }
    
    // 给合约账户里增加资金
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // 还能支付几次薪水？
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        // 支持var变量声明 
        var (employee, index)= _findEmployee(msg.sender);
        require(msg.sender == employee.id);
        
        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
