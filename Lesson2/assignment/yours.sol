/*作业请提交在这个目录下*/
第二次的作业
/*优化calculate前的代码*/
pragma solidity^0.4.14;

contract Payroll{
    struct Employee{
        address eAddress;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuratin = 10 seconds;
    address ownerAddress;
    Employee[] employees;
    
    function Payroll(){
        ownerAddress = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuratin;
        employee.eAddress.transfer(payment);
    }
    
    function _findEmployee(address eAddress) private returns (Employee,uint){
        for(uint i = 0;i < employees.length;i++) {
            if(employees[i].eAddress == eAddress) {
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address eAddress,uint salary){
        require(msg.sender == ownerAddress);
        var (employee,index) = _findEmployee(eAddress);
        assert(employee.eAddress == 0x0);
        employees.push(Employee(eAddress,salary,now));
    }
    
    function removeEmployee(address eAddress) {
        require(msg.sender == ownerAddress);
        var (employee,index) = _findEmployee(eAddress);
        assert(employee.eAddress != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address eAddress,uint salary) {
        require(msg.sender == ownerAddress);
        var (employee,index) = _findEmployee(eAddress);
        assert(employee.eAddress != 0x0);
        _partialPaid(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for(uint i = 0;i < employees.length;i++){
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.eAddress != 0x0);
        uint nextPayday = employee.lastPayday + payDuratin;
        assert(nextPayday < now);
        employee.lastPayday = nextPayday;
        employee.eAddress.transfer(employee.salary);
    }
}

/*优化calculate 前gas 记录*/



1 transact to Payroll.calculateRunway pending ...
transaction cost 
22966 gas 
execution cost 
1694 gas 
2 transact to Payroll.calculateRunway pending ...
transaction cost 
23747 gas 
execution cost 
2475 gas 
3 transact to Payroll.calculateRunway pending ...
transaction cost 
24528 gas 
execution cost 
3256 gas 
4 transact to Payroll.calculateRunway pending ...
transaction cost 
25309 gas 
execution cost 
4037 gas 
5 transact to Payroll.calculateRunway pending ...
transaction cost 
26090 gas 
execution cost 
4818 gas 
6 transact to Payroll.calculateRunway pending ...
transaction cost 
26871 gas 
execution cost 
5599 gas 
7 transact to Payroll.calculateRunway pending ...
transaction cost 
27652 gas 
execution cost 
6380 gas 
8 transact to Payroll.calculateRunway pending ...
transaction cost 
28433 gas 
execution cost 
7161 gas 
9 transact to Payroll.calculateRunway pending ...
transaction cost 
29214 gas 
execution cost 
7942 gas 
10 transact to Payroll.calculateRunway pending ...
transaction cost 
29995 gas 
execution cost 
8723 gas 
-----------------------------------------------------------------------------------------------------------------------------------------------
/*优化calculate后的代码*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary ;
    address owner;
    Employee[] employees;
    

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee , uint) {
        for(uint i;i < employees.length;i++){
            if(employees[i].id == employeeId){
                return(employees[i],i);
            }
        }    
    }

    function addEmployee(address employeeId, uint salary) {
        require (msg.sender == owner);
        var (employee,index)= _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint sSalary = salary * 1 ether;
        employees.push(Employee(employeeId,sSalary,now));
        totalSalary += sSalary;
    }

    function removeEmployee(address employeeId) {
        require (msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0 );
        _partialPaid(employee);
        delete employees[index];
        totalSalary -= employee.salary;
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require (msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        uint sSalary = salary * 1 ether;
        employees[index].salary = sSalary;
        employees[index].lastPayday = now;
        totalSalary -= employee.salary;
        totalSalary += sSalary;
    }
    
    function addFund() payable returns (uint) {
         require (msg.sender == owner);
         return this.balance;
    }
    

    function calculateRunway()public view returns (uint) {
        //因为每次都循环会很费气
    //   uint totalSalary ;
    //   for (uint i = 0; i < employees.length; i++) {
    //         totalSalary+=employees[i].salary;
    //     }
        return this.balance / totalSalary;
    }
    
    
    function emplength() public view returns(uint){
        return  employees.length;
    }
    
    function balanceOf() public view returns(uint){
        return this.balance;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index)= _findEmployee(msg.sender);
        assert(employee.id!=0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(now>nextPayday);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);  
    }
}


/*优化calculate 后的gas 记录*/
1 call to Payroll.calculateRunway
transaction cost 
22146 gas (Cost only applies when called by a contract) 
execution cost 
874 gas (Cost only applies when called by a contract) 

2 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

3 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

4 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

5 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

6 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

7 call to Payroll.calculateRunway
 transaction cost 
22146 gas (Cost only applies when called by a contract)
 execution cost 
874 gas (Cost only applies when called by a contract)

8 call to Payroll.calculateRunway...
transaction cost 
22146 gas (Cost only applies when called by a contract) 
execution cost 
874 gas (Cost only applies when called by a contract) 

9 call to Payroll.calculateRunway
transaction cost 
22146 gas (Cost only applies when called by a contract) 
execution cost 
874 gas (Cost only applies when called by a contract) 
-----------------------------------------------------------------------------
//结论：
//说明优化前的每次调calcuateRunway 函数由于每次都循环遍历去去消耗的gas多
//优化后 每次新添加新员工后调用calcuateRunway 函数所消耗的gas 看了一下日志都是 874 避免了每加一个新员工后 for循环的轮序导致的 gas消耗的增加

