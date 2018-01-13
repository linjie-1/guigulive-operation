添加新员工后调用calculateRunway函数所消耗的gas会随着员工数量增加而增加，优化前每增加一名新员工，调用calculateRunway函数时所消耗的gas大约会增加781gas，具体消耗情况如下：
优化前
一名员工：1716gas;
两名员工：2497gas;
三名员工：3278gas;
四名员工：4059gas;
五名员工：4840gas;
六名员工：5621gas;
七名员工：6402gas;
八名员工：7183gas;
九名员工：7964gas;
十名员工：8745gas;
合计：52305gas;

优化后
添加新员工后调用calculateRunway函数所消耗的gas保持不变，不再随着员工数量增加而增加，每次都是852 gas，合计8520 gas，合计减少41485 gas，降低了83%；

优化方案
增加 totalSalary 状态变量记录工资总额，并在工资变化点重新计算工资总额，并赋值给 totalSalary（具体包括新增、删除、更新员工三处），同时删除calculateRunway中通过遍历员工数组获取工资总额的方法，改为直接读取totalSalary 状态变量。

优化后代码
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 10 seconds;

    address owner;
    uint totalSalary;
    Employee []employees;

    function Payroll() {
        owner = msg.sender;
    }

    modifier isOwner() {
       require(msg.sender == owner);
       _;
    }

    function _partialFindEmployee(address employeeId) private returns (Employee, uint) {
        uint len = employees.length;
        for (uint i = 0; i < len; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) isOwner {
        var(employee, _) = _partialFindEmployee(employeeId);
        assert(employee.id == 0x0);

        employees.push(Employee(employeeId, salary * 1 ether, now));

		// 同步工资总金额
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) isOwner {
        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);

		// 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        uint len = employees.length;
        delete employees[index];
        employees[index] = employees[len - 1];
        len--;

		// 同步工资总金额
        totalSalary -= employee.salary;
    }

    function updateSalary(address employeeId, uint salary) isOwner {
        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);

        uint newSalary = salary * 1 ether;
        assert(newSalary != employee.salary);

		// 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        employees[index].salary     = newSalary;
        employees[index].lastPayDay = now;

				// 同步工资总金额
        totalSalary = totalSalary - employee.salary + salary;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _partialFindEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);

        employees[index].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}

优化前代码
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 10 seconds;

    address owner;

    Employee []employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialFindEmployee(address employeeId) private returns (Employee, uint) {
        uint len = employees.length;
        for (uint i = 0; i < len; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var(employee, _) = _partialFindEmployee(employeeId);
        assert(employee.id == 0x0);

        employees.push(Employee(employeeId, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);

        // 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        uint len = employees.length;
        delete employees[index];
        employees[index] = employees[len - 1];
        len--;
    }

    function updateSalary(address employeeId, uint salary) {
        require(msg.sender == owner);

        var(employee, index) = _partialFindEmployee(employeeId);
        assert(employee.id != 0x0);

        uint newSalary = salary * 1 ether;
        assert(newSalary != employee.salary);

        // 结算工资变化前尚未支付的工资
        _partialPaid(employee);
        employees[index].salary     = newSalary;
        employees[index].lastPayDay = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }

        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _partialFindEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayDay = employee.lastPayDay + payDuration;
        assert(nextPayDay < now);

        employees[index].lastPayDay = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
