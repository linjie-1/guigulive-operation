/*作业请提交在这个目录下*/
一、一、原代码的calculateRunway的gas消耗情况：gas消耗量每次都增长，明细如下
1、”0xca35b7d915458ef540ade6068dfe2f44e8fa733c”,1
gas	3000000 gas
        
Copied!
transaction cost	22971 gas
execution cost	1699 gas
2、”0x14723a09acff6d2a60dcdf7aa4aff308fddc160c”,1
gas	3000000 gas
transaction cost	23759 gas
execution cost	2487 gas
3、”0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db”,1
gas	3000000 gas
transaction cost	24547 gas
execution cost	3275 gas
”0x583031d1113ad414f02576bd6afabfb302140225”,1
gas	3000000 gas
transaction cost	25335 gas
execution cost	4063 gas
”0xdd870fa1b7c4700f2bd7f44238821c26f7392148”,1
gas	3000000 gas
transaction cost	26123 gas
execution cost	4851 gas
“0xca35b7d915458ef540ade6068dfe2f44e8fa733d”,1
gas	3000000 gas
transaction cost	26911 gas
execution cost	5639 gas
”0x14723a09acff6d2a60dcdf7aa4aff308fddc160d”,1
gas	3000000 gas
transaction cost	27699 gas
execution cost	6427 gas
”0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2dc”,1
gas	3000000 gas
transaction cost	28487 gas
execution cost	7215 gas
”0x583031d1113ad414f02576bd6afabfb302140226”,1
gas	3000000 gas
transaction cost	29275 gas
execution cost	8003 gas
”0xdd870fa1b7c4700f2bd7f44238821c26f7392149”,1
gas	3000000 gas
transaction cost	30063 gas
execution cost	8791 gas

二、结论和解决思路：
1、结论：同一段代码，gas消耗越来越高。原因是增加员工后，数组长度增加，循环次数也在增加，计算量增大导致。
2、解决办法：减少循环次数。维护一个全局变量totalSalary，在员工新增、删除、和更新时维护该变量。

二、修改后的gas消耗情况，gas保持不变：
1、"0xca35b7d915458ef540ade6068dfe2f44e8fa733c",1
gas	3000000 gas
transaction cost	22122 gas
execution cost	850 gas

2、"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",1
gas	3000000 gas
transaction cost	22122 gas
execution cost	850 gas

3、”0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db”,1
gas	3000000 gas
transaction cost	22122 gas
execution cost	850 gas


附：更新的代码
pragma solidity ^0.4.14;

contract Payrolls {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday; 
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    uint totalSalary; //for gas
    
    function Payrolls(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now-employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employee) private returns(Employee,uint){
        for(uint i=0; i<employees.length; i++){
            if(employees[i].id == employee){
                return(employees[i],i);
            }
        }
    }
    
        
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary * 1 ether, now));
        totalSalary += salary; //for gas
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
        
        totalSalary -= employee.salary;  //for gas
    }
    
    function udpateEmployee(address employeeId,uint salary){
        require(msg.sender == owner);
        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        
        totalSalary += salary-employee.salary;
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
       /* uint totalSalary = 0;
        for(uint i = 0; i < employees.length; i++){
            totalSalary += employees[i].salary;
        }
        
        return this.balance / totalSalary;*/
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunway() >0;
    }
    
    function getPaid(){
        var(employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday =  employee.lastPayday + payDuration;
        assert(nextPayday<now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}
