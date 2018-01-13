    /*作业请提交在这个目录下*/
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
        
        //添加一个变量存储当前薪水总和，这样不需要每一次都计算从而增加gas的cost
        uint salarySum;

        function Payroll() {
            owner = msg.sender;
            salarySum = 0;
        }
        
        function _partialPaid(Employee employee) private {
            
            if(employee.id!=0x0){
                uint toPaid = employee.salary * (now - employee.lastPayday)/payDuration;
                employee.id.transfer(toPaid);
            }
        }
        
        function _findEmployee(address employeeId) private returns (Employee, uint) {
            for(uint i=0; i<employees.length; i++){
                if(employees[i].id == employeeId){
                    return (employees[i], i);
                }
            }
        }

        function addEmployee(address employeeId, uint salary) {

            require(msg.sender == owner);
            
            var (employee, index) = _findEmployee(employeeId);
            assert(employee.id == 0x0);
           
            employees.push(Employee(employeeId, salary * 1 ether, now));
            
            salarySum += salary*1 ether;

        }
        
        function removeEmployee(address employeeId) {
            require(msg.sender == owner);
      
            var (employee, index) = _findEmployee(employeeId);
            assert(employee.id != 0x0);

            _partialPaid(employees[index]);
            salarySum -=employees[index].salary;
            delete employees[index];
            employees[index]=employees[employees.length-1];
            employees.length = employees.length-1;
            
            return;
            
        }
        
        function updateEmployee(address employeeId, uint salary) {
            
            var (employee, index) = _findEmployee(employeeId);
            
            _partialPaid(employee);
            
            employees[index].id = employeeId;
            employees[index].lastPayday = now;
            salarySum += salary - employees[index].salary;
            employees[index].salary = salary;
            
             
        }
        
        function addFund() payable returns (uint) {
            return this.balance;
        }
        
        function calculateRunway() returns (uint) {
            
            return this.balance / salarySum;
        }
        
        function hasEnoughFund() returns (bool) {
            return calculateRunway() > 0;
        }
        
        //this is full salary pay, so do not need to calculate the partial payment. needs to be salary
        function getPaid() {
            var (employee, index) = _findEmployee(msg.sender);
            
            assert (employee.id != 0x0);

            uint nextPayDate = employee.lastPayday + payDuration;
            assert (nextPayDate < now);
            employees[index].lastPayday = nextPayDate;
            employee.id.transfer(employee.salary);
        }
    }
