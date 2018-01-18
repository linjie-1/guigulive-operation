pragma solidity ^0.4.14;

contract Payroll {

    // 10秒钟秒发一次工资
    uint constant payDuration = 10 seconds;
    // 公司所有发一次工资需要的钱
    uint total;
    // 合约创建
    address owner;
    // 员工结构体
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    mapping(address => Employee) employees;

    //构造方法
    function Payroll() payable public {
        owner = msg.sender;
    }
    // 日志
    event log(Employee e, uint index);
    //日志
    event employeesLog(address employeeId, uint salary, uint lastPayday);
    // 打印所有员工日志
    function printEmployeesInfo(address employeeId) private {
        employeesLog(employees[employeeId].id, employees[employeeId].salary,employees[employeeId].lastPayday);
    }
    // 打印出合同的以以太币和发工资一次所需要的总金额
    event log(uint balance, uint total);

    // 付清这个员工所有的工资
    function partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    // 根据地质查询员工
    function findEmployee(address employeeId) private returns (Employee employee){
        printEmployeesInfo(employeeId);
        return employees[employeeId];
    }
    // 添加员工
    function addEmployee(address employeeId, uint s) public {
        // 合约制定者才可以添加新员工以及决定发的工资额度
        require(msg.sender == owner);
        //查看员工是否存在
        var employee  = findEmployee(employeeId);
        //员工存在返回
        assert(employee.id != 0x0);
        //初始化员工
        employees[employeeId]=(Employee(employeeId, s * 1 ether, now));
        //下次要发工资加
        total = total + s;
        printEmployeesInfo(employees[employeeId].id);
    }
    // 删除员工
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var  employee = findEmployee(employeeId);
        assert(employee.id != 0x0);
        partialPaid(employee);
        total = total - employee.salary;
        delete employees[employeeId];
    }
    // 更新员工
    function updateEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var employee= findEmployee(employeeId);
        assert(employee.id != 0x0);
        partialPaid(employee);
        total = total - employee.salary;
        employees[employeeId].salary = s * 1 ether;
        employees[employeeId].lastPayday = now;
        total = total + s;
    }
    // 往合约账户添加以太币
    function addFund() payable public returns (uint) {
        log(this.balance, total);
        return this.balance;
    }
    // 计算合约账户的钱可以发几次工资
    function calculateRunway() public returns (uint){
        log(this.balance, total);
        return this.balance / total;
    }

    // 判断合约账户的钱是否够发一次工资
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    // 员工要求发工资
    function getPaid() public {
        var employee= findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employee.salary);
    }
}