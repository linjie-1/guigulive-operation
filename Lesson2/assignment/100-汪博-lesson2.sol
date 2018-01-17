pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint totalSalary; //track the change of totalsalary
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            uint salaryTmp = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(salaryTmp);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {/*每次运行addEmployee的gas消耗增加。因为在_findEmployee循环中的运行代价增加*/
        require(msg.sender == owner);
        
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 finney, now));
        totalSalary += salary * 1 finney;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -=1;
        return;
           
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var(employee,index) = _findEmployee(employeeId);
        
        _partialPaid(employees[index]);
        totalSalary -= employee.salary;
        totalSalary += salary * 1 finney;
        employees[index].salary = salary * 1 finney;
        employees[index].lastPayday = now;
        return;
          
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
       /* uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
           totalSalary += employees[i].salary;
        }*/
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >= 1;
    }
    
    function getPaid() {
        
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        
        assert(nextPayDay <= now );

        uint salaryTmp = employee.salary*((now-employee.lastPayday)/payDuration);
        employees[index].lastPayday = now;
        employees[index].id.transfer(salaryTmp);// allow get paid after several duration
    }
    
    function Test() returns (uint){
        addEmployee(1,1);
        addEmployee(2,1);
        addEmployee(3,1);
        addEmployee(4,1);
        addEmployee(5,1);
        addEmployee(6,1);
        addEmployee(7,1);
        addEmployee(8,1);
        addEmployee(9,1);
        addEmployee(10,1);
        return  calculateRunway();
    }
}
