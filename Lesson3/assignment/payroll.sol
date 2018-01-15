contract Payroll {
    // 与C语言类似，可以支持结构类型
    struct Employee {
        address id;  // 这里的ID是个地址 
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) employees;
    
    uint totalSalary;

   //test steps
   // use the first address to create contract
   // addFund 100 ether, balance = 100 ether
   // add employee "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", 1
   // add employee "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", 1
   // add employee "0x583031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0xdd870fa1b7c4700f2bd7f44238821c26f7392148", 1

   // add employee "0x54723a09acff6d2a60dcdf7aa4aff308fddc160c", 1
   // add employee "0x60897b0513fdc7c541b6d9d7e929c4e5364d2db", 1
   // add employee "0x783031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0x8d870fa1b7c4700f2bd7f44238821c26f7392148", 1
   // add employee "0x983031d1113ad414f02576bd6afabfb302140225", 1
   // add employee "0xad870fa1b7c4700f2bd7f44238821c26f7392148", 1

   // use the second address to getPaid, balance = 8 ether


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
    
    // 增A
    function addEmployee(address employeeId, uint salaryOfEther) {
        require(msg.sender == owner);
        employees[employeeId] = Employee(employeeId, salaryOfEther * 1 ether, now);
        totalSalary += salaryOfEther * 1 ether;
    }
    
    // 删D
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[employeeId];
        totalSalary -= employee.salary;
    }
    
    // 改U
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        
        totalSalary = totalSalary - employee.salary + salary * 1 ether;

        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
    }
    
    // 给合约账户里增加资金
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    // 还能支付几次薪水？
    function calculateRunway() returns (uint) {
        require(totalSalary > 0);
/*
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
*/
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns(uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
        //return (employee.salary, employee.lastPayday);
    }
    
    function getPaid() {
        // 支持var变量声明 
        var employee = employees[msg.sender];
        require(msg.sender == employee.id);
        
        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
