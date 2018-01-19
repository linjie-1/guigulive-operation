/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;
contract Payroll  {
    
    struct Employee{
        address id ;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    address owner;
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    
    
    function Payroll(){
        owner = msg.sender;
    }
    
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    
    function _findEmployee(address employeeId) private returns(Employee,uint){
            for(uint i = 0; i < employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
            }
    }
    
    
    function addEmployee(address employeeId, uint salary) {
        
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employees[index].salary ;
        delete  employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    
    function updateEmployee(address employeeId ,uint salary){
        require(owner == msg.sender);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        totalSalary = totalSalary + salary * 1 ether - employees[index].salary;
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;

    }
    
    
    function calculateRunway( ) returns (uint){
        // uint totalSalary;
        // for(uint i = 0; i < employees.length; i++){
            
        //      totalSalary += employees[i].salary;
        // }
        return this.balance/totalSalary;
        
    }


   // add fund into the account
    function addFund() payable returns(uint) {
        return  this.balance;
    }
    
    
    function hasEnoughFund() returns (bool){
        return  calculateRunway()> 0;
        
    }
  
    // the staff claim his salary
   function getPaid()  {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now) ;
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
       
   }
   

  
}
