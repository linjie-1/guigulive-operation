/*作业请提交在这个目录下*/
pragma solidity ^0.4.14; 
contract Payroll { 
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds; 
    address owner; 
    Employee[] employees;
    uint runway = 0;
   
    function Payroll() { 
        owner = msg.sender; 
    } 
    
    function _updateRunway() private{
        uint totalSalary = 0;
        for (uint i  = 0; i<employees.length; i++){
            totalSalary += employees[i].salary;
        }
        
        runway = this.balance / totalSalary;
    }
    
    function _partialPaid(Employee employee)  private{
        uint payment = employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeID) private returns (Employee,uint) {
        for (uint i  = 0; i<employees.length; i++){
            if(employees[i].id == employeeID){
                return (employees[i],i);
            }
        }
    }
    
    
    function addEmployee(address employeeID,uint salary){
        require(msg.sender == owner);
        var (employee,idx) = _findEmployee(employeeID);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeID,salary, now));
        _updateRunway();
    }
    
    function removeEmployee(address employeeID){
        require(msg.sender == owner);
        var (employee,idx) = _findEmployee(employeeID);
        assert(employee.id != 0x0);
       
        _partialPaid(employee);
        delete employees[idx];
        employees[idx] = employees[employees.length - 1];
        employees.length -= 1;  
        _updateRunway();
    }
    
    function updateEmployee(address employeeID, uint salary) { 
        require(msg.sender == owner); 
        var (employee,idx) = _findEmployee(employeeID);
        assert(employee.id != 0x0);
       
        _partialPaid(employee);
        employees[idx].salary =salary;
        employees[idx].lastPayday = now;
        _updateRunway();
    } 
    
    function addFund() payable returns (uint) { 
        return this.balance; 
    } 
    
    
    function calculateRunway() returns (uint) { 
        return runway; 
    } 
    function hasEnoughFund() returns (bool) { 
        return calculateRunway() > 0; 
    } 
    function getPaid() { 
        var (employee,idx) = _findEmployee(msg.sender);
        require(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration; 
        assert(nextPayday < now); 
        employees[idx].lastPayday = nextPayday; 
        employees[idx].id.transfer(employee.salary); 
    } 
 } 


员工地址：                                      trans exec
1、0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   22966 1694
2、0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   23747 2475
3、0x583031d1113ad414f02576bd6afabfb302140225   24528 3256
4、0xdd870fa1b7c4700f2bd7f44238821c26f7392148   25309 4037

gas有变化，可以看到后面每次比前面多消耗781gas，原因是每多一个员工，calculateRunway函数内的循环体的语句就要多执行一次。

改进后的gas如下
1、0x14723a09acff6d2a60dcdf7aa4aff308fddc160c 21688 416
2、0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db 21688 416
3、0x583031d1113ad414f02576bd6afabfb302140225 21688 416
4、0xdd870fa1b7c4700f2bd7f44238821c26f7392148 21688 416
