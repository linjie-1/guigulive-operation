/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll{
    address owner;
    uint constant payDuration=10 seconds;
    uint totalSalary;//calculateRunway()函数优化：定义全局变量totalSalary
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    Employee[] employees;
    
    function Payroll(){
        owner=msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment=employee.salary*(now-employee.lastPayDay)/payDuration;
        employee.id.transfer(payment);
    }
    function _findEmployee(address employee) private returns(Employee,uint){
       for(uint i=0;i<employees.length;i++){
            if(employees[i].id==employee){
                return(employees[i],i);
            }
        } 
    }
    function addEmployee(address employeeId,uint salary) payable {
        require(owner==msg.sender); 
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        totalSalary+=salary;//calculateRunway()函数优化：将totalSalary的累加放在addEmployee（）中
        employees.push(Employee(employeeId,salary,now));
    }
    
    function removeEmployee(address employeeId){
        require(owner==msg.sender);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
        
    }
    function addFund() payable returns (uint) {
        return this.balance;
    }
    function updateEmployee(address employeeId,uint salary){
        require(owner==msg.sender);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        employees[index].salary=salary*1 ether;
        employees[index].lastPayDay=now;
    
    }
  
            
    function calculateRunway() returns (uint) {
       /*************************
        uint totalSalary=0;
        for(uint i=0;i<employees.length;i++){
           totalSalary += employees[i].salary; 
        } //calculateRunway()此处循环删除
        ************************/
        return this.balance/totalSalary;
    }
    function hasEnoughFund() returns (bool) {
        //return this.balance >=salary;
       return calculateRunway() >= 0;
    }
    function getPaid(){
        var (employee,index)=_findEmployee(msg.sender);
        assert(employee.id!=0x0);
        uint nextPayday=employee.lastPayDay+payDuration;
        assert(now>nextPayday);
        
        employees[index].lastPayDay=nextPayday;
        employee.id.transfer(employee.salary);
       
    }
}
/****************************************************
一、gas值：26122/4651,26911/5639,27699/6427,28487/7215,......gas值是递增的，由于员工数量增加，所以每次循环都增加了一次加法运算，增加gas消耗
二、calculateRunway()函数优化：
    1、定义全局变量totalSalary
    2、将totalSalary的累加放在addEmployee（）函数中
    3、原calculateRunway()函数中for循环删除
calculateRunway()函数优化代码如上，优化后gas值一直保持22111,550.
   
*****************************************************/
