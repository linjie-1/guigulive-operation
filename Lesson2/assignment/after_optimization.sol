
pragma solidity ^0.4.14;

contract Payroll {
    
    // struct to present "employee" object
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    
    // local variable of total salary to save gas!
    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
        // initialize totalSalary to be zero
        totalSalary = 0;
    }
    
    // 1. pay employee before remove or update employee to avoid mistake
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    // 2. find employee from the list - use for-loop 
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    // 3. owner adds new employee - note: increase totalSalary
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        uint ethersalary = salary * 1 ether;
        employees.push(Employee(employeeId, ethersalary, now));
        // update totalSalary
        totalSalary += ethersalary;
    }
    
    // 4. owner remove employee from contract - note: decrease totalSalary
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        // pay employee before remove him!
        _partialPaid(employee);
        
        // update totalSalary
        totalSalary -= employees[index].salary;
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    // 5. owner update employee record - note: update totalSalary
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        // pay employee before update
        _partialPaid(employee);
        
        // update totalSalary correspondingly
        uint ethersalary = salary * 1 ether;
        totalSalary += ethersalary - employees[index].salary;
        
        // update employee reocord
        employees[index].salary = ethersalary;
        employees[index].lastPayday = now;
    }
    
    // 6. add fund into contract by owner
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // 7. calculate times of pay in this contract - avoid for-loop to save gas!
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    // 8. check whether this contract has enough fund
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    // 9. employee request to get paid 
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
