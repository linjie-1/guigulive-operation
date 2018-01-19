/**#########1.合约调试#############**/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address owner;

    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }

    Employee[] employees;

    function Payroll() payable public{
        owner = msg.sender;
    }
    event employeesLog(address id, uint salary, uint lastPayday);
    function printEmployeesInfo() private{
        for(uint i = 0; i < employees.length; i ++){
            employeesLog(employees[i].id, employees[i].salary,employees[i].lastPayday);
        }
    }

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address e) private returns (Employee, uint){
        printEmployeesInfo();
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == e){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        require(index != 0x0);
        require(employee.id != 0x011111);
        employees.push(Employee(e, s * 1 ether, now));
        printEmployeesInfo();
    }

    function removeEmployee(address e) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].salary = s * 1 ether;
        employees[index].lastPayday = now;
    }

    event log(uint balance, uint total);
    function addFund() payable public returns (uint) {
        log(this.balance, total);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public{
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}
/**############第二题作业调用calculateRunway方法gas观察#########**/
/** transaction cost 	24069 gas execution cost 	2797 gas */
/** transaction cost 	131523 gas execution cost 	108651 gas */
/** transaction cost 	139232 gas execution cost 	116360 gas */
/** transaction cost 	154650 gas execution cost 	131778 gas */
/** transaction cost 	162359 gas execution cost 	139487 gas */
/**....没加入一个员工..每次gas execution cost  transaction cost增加7709**/
/**每次添加一个员工都会增加gas的消耗原因是每次循环都增加了步骤**/
/**############第三题calculateRunway优化#####################**/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    uint total;

    address owner;

    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }

    Employee[] employees;

    function Payroll() payable public{
        owner = msg.sender;
    }
    event employeesLog(address id, uint salary, uint lastPayday);
    function printEmployeesInfo() private{
        for(uint i = 0; i < employees.length; i ++){
            employeesLog(employees[i].id, employees[i].salary,employees[i].lastPayday);
        }
    }

    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address e) private returns (Employee, uint){
        printEmployeesInfo();
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == e){
                return (employees[i], i);
            }
        }
    }

    event log(Employee e, uint index);
    function addEmployee(address e, uint s)payable  public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        log(employee, index);
        employees.push(Employee(e, s * 1 ether, now));
        total = total + s;
        printEmployeesInfo();
    }

    function removeEmployee(address e) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        total = total - employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address e, uint s) public{
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        total = total - employee.salary;
        employees[index].salary = s * 1 ether;
        employees[index].lastPayday = now;
        total = total + s;
    }

    event log(uint balance, uint total);
    function addFund() payable public returns (uint) {
        log(this.balance, total);
        return this.balance;
    }

    function calculateRunway() public returns (uint){
        log(this.balance, total);
        return this.balance / total;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public{
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}
/**让每次循环计算变成一次增加修改删除计算，优化后每次调用calculateRunway方法用的gas都一样**/
/** transaction cost 	131423 gas execution cost 	108251 gas */




