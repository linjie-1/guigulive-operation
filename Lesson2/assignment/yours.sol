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

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint amount = employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(amount);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0;i<employees.length;i++){
            if(employeeId==employees[i].id){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender==owner);
        var (employee, index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        employees.push(Employee(employeeId, salary, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender==owner);
        var (employee, index)=_findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length--;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender==owner);
        var (employee, index)=_findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        employee.salary=salary*1 ether;
        employee.lastPayday=now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / (totalSalary*1 ether);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        var (employee, index)=_findEmployee(msg.sender);
        assert(employee.id!=0x0);
        uint nextPayday = employee.lastPayday+payDuration;
        assert(nextPayday<now);
        employees[index].lastPayday=nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}

/*

Added 10 employees. The gas used in each action was not the same. 
When there is no employee yet while we add the first employee, the gas was used the most, more than all the other circumstances. 
Then we add from the 2nd employeeto the 10th employee, the gas was linearly increased each time.
1:
 transaction cost 	103982 gas 
 execution cost 	82326 gas 
2:
 transaction cost 	89823 gas 
 execution cost 	68167 gas       
3:
 transaction cost 	90664 gas 
 execution cost 	69008 gas 
4:
 transaction cost 	91505 gas 
 execution cost 	69849 gas
5:
 transaction cost 	92346 gas 
 execution cost 	70690 gas 
6:
 transaction cost 	93187 gas 
 execution cost 	71531 gas
7:
 transaction cost 	94028 gas 
 execution cost 	72372 gas 
8:
  transaction cost 	94869 gas 
  execution cost 	73213 gas
9:
  transaction cost 	95710 gas 
  execution cost 	74054 gas
10:
  transaction cost 	96551 gas 
  execution cost 	74895 gas
  
Reason: The first time we add an employee, there is no array yet. We need to create an employee array first. This can cost gas.
From the 2nd time to the 10th time, each time, the function find employee is called, and we need to travers the whole array of employees.
Each time, there is one more element in the array, that is why the gas is increased linearly.



*/
