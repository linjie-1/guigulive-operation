pragma solidity ^0.4.14;

contract PayRoll {
    address boss;
    uint paymentDurationUnit;
    uint salaryUnit;
    uint totalSalary;
    Employee[] employees;
    mapping (address => Emap) emaps; // helper mapping for fast retrieve Employee object.

    struct Emap {
        uint128 index;
        uint128 valid;
    }

    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
        uint paymentDuration;
        uint salaryUpdateWindow; // only allow boss to change the salary within this time window since the emplyee got his/her last salary.
    }

    modifier bossOnly {
        require(msg.sender == boss);
        _;
    }

    modifier validEmployee {
        require(emaps[msg.sender].valid > 0);
        _;
    }

    function PayRoll(address _boss) public {
        boss = _boss;
        paymentDurationUnit = 1 seconds;
        salaryUnit = 1 ether;
    }

    function addFund() public payable returns (uint) {
        return (msg.value);
    }

    function addEmployee(address employeeAddr, uint paymentDuration, uint salary, uint salaryUpdateWindow, uint lastPayDay) internal {
        Employee memory employee;
        employee.addr = employeeAddr;
        employee.lastPayDay = lastPayDay;
        employee.paymentDuration = paymentDuration;
        employee.salary = salary;
        employee.salaryUpdateWindow = salaryUpdateWindow < paymentDuration ? salaryUpdateWindow : paymentDuration;
        employees.push(employee);
        emaps[employeeAddr] = Emap(uint128(employees.length-1), 1);

    }

    function calculateRunaway() public constant returns (uint) {
        require(totalSalary > 0);
        return this.balance/totalSalary;
    }

    function findEmployee(address employee) internal returns (uint) {
        return emaps[employee].index;
    }

    /**
     * Employees' actions
     */

    function hasEnoughFund() public constant validEmployee returns (bool) {
        return this.balance >= employees[findEmployee(msg.sender)].salary;
    }

    function getSalary() public validEmployee {
        Employee memory employee = employees[findEmployee(msg.sender)];
        uint numPay = (now - employee.lastPayDay) / employee.paymentDuration;
        uint nextPayDay =  numPay * employee.paymentDuration + employee.lastPayDay;
        require(nextPayDay <= now && hasEnoughFund());
        employee.lastPayDay = nextPayDay;
        msg.sender.transfer(employee.salary * numPay);
    }

    function updateEmployeeAddress(address _employee) public validEmployee {
        Emap storage m = emaps[_employee];
        m.valid = 1;
        m.index = uint128(findEmployee(msg.sender));
        delete emaps[msg.sender];
        employees[findEmployee(m.index)].addr = _employee;
    }

    /**
     * Bosses' actions.
     */

    function updateBossAddress(address _boss) public bossOnly {
        boss = _boss;

    }

    function bossAddEmployee(address employeeAddr, uint paymentDuration, uint salary, uint salaryUpdateWindow) public bossOnly {
        paymentDuration *= paymentDurationUnit;
        salaryUpdateWindow *= paymentDurationUnit;
        salary *= salaryUnit;
        totalSalary += salary;
        addEmployee(employeeAddr, paymentDuration, salary, salaryUpdateWindow, now);
    }

    function updateSalary(address employeeAddr, uint amount) public bossOnly {
        Employee storage employee = employees[findEmployee(employeeAddr)];
        require(now - employee.lastPayDay <= employee.salaryUpdateWindow);
        totalSalary -= employee.salary;
        employee.salary = amount * salaryUnit;
        totalSalary += employee.salary;
    }

    function updatePaymentDuration(address employeeAddr, uint duration) public bossOnly {
        duration *= paymentDurationUnit;
        Employee storage employee = employees[findEmployee(employeeAddr)];
        require(employee.salaryUpdateWindow <= duration);
        employee.paymentDuration = duration;
    }

    function getEmployeeInfo(address employeeAddr) public constant bossOnly returns (address, uint, uint, uint, uint) {
        Employee storage employee = employees[findEmployee(employeeAddr)];
        return (employeeAddr, employee.salary, employee.paymentDuration, employee.lastPayDay, employee.salaryUpdateWindow);
    }

    function removeEmployee(address employeeAddr) public bossOnly {
        uint i = findEmployee(employeeAddr);
        Employee storage e = employees[i];
        require(e.salary > 0);
        if (e.lastPayDay + e.paymentDuration < now) {
            uint amount = uint((now - e.lastPayDay) / e.paymentDuration) * e.salary;
            totalSalary -= e.salary;
            delete emaps[employeeAddr];
            employees[i] = employees[employees.length-1];
            emaps[employees[i].addr].index = uint128(i);
            employees.length --;
            employeeAddr.transfer(amount);
        }
    }

    function getBalance() public bossOnly constant returns (uint) {
        return this.balance;
    }
}
