/*作业请提交在这个目录下*/
//未优化前 \
//创建花费       交易769157  执行542217
//存100ETH      交易21918   执行646
//加入第1位员工  交易105198  执行82326
//计算次数       交易22966   执行1694
//加入第2位员工  交易91039   执行68167
//计算次数       交易23747   执行2475
//加入第3位员工  交易91880   执行69008
//计算次数       交易24528   执行3256
//加入第4位员工  交易92721   执行69849
//计算次数       交易25309   执行4037
//加入第5位员工  交易93562   执行70690
//计算次数       交易26090   执行4818
//加入第6位员工  交易94403   执行71531
//计算次数       交易26871   执行5599
//加入第7位员工  交易95244   执行72372
//计算次数       交易27652   执行6380
//加入第8位员工  交易96085   执行73213
//计算次数       交易28433   执行7161
//加入第9位员工  交易96926   执行74054
//计算次数       交易29214   执行7942
//加入第10位员工 交易97767   执行74895
//计算次数       交易29995   执行8723

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

    function Payroll() public {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);        
    }
    
    function _findEmployee(address employeeId) private constant returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary) public { 
        require(msg.sender == owner);
        var (employee, ) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
         _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);        
        
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() public constant returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);  

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
