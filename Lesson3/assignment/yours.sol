pragma solidity ^0.4.14;

contract PayRoll {
    address boss;
    uint paymentDurationUnit;
    uint salaryUnit;
    uint totalSalary;
    mapping (address => Employee) public employees;

    struct Employee {
        uint salary;
        uint lastPayDay;
        uint paymentDuration;
        uint salaryUpdateWindow; // only allow boss to change the salary within this time window since the emplyee got his/her last salary.
    }

    modifier bossOnly {
        require(msg.sender == boss);
        _;
    }

    modifier validEmployee(address employee) {
        require(employees[employee].salary > 0);
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
        Employee storage employee = employees[employeeAddr];
        employee.lastPayDay = lastPayDay;
        employee.paymentDuration = paymentDuration;
        employee.salary = salary;
        employee.salaryUpdateWindow = salaryUpdateWindow < paymentDuration ? salaryUpdateWindow : paymentDuration;
    }

    /**
     * Employees' actions
     */

    function calculateRunaway() public constant validEmployee(msg.sender) returns (uint) {
        require(totalSalary > 0);
        return this.balance/totalSalary;
    }

    function hasEnoughFund() public constant validEmployee(msg.sender) returns (bool) {
        return this.balance >= employees[msg.sender].salary;
    }

    function getSalary() public validEmployee(msg.sender) {
        Employee storage employee = employees[msg.sender];
        uint numPay = (now - employee.lastPayDay) / employee.paymentDuration;
        uint nextPayDay =  numPay * employee.paymentDuration + employee.lastPayDay;
        require(nextPayDay <= now && hasEnoughFund());
        employee.lastPayDay = nextPayDay;
        msg.sender.transfer(employee.salary * numPay);
    }

    function updateEmployeeAddress(address _employee) public validEmployee(msg.sender) {
        Employee storage employee = employees[msg.sender];
        addEmployee(_employee, employee.paymentDuration, employee.salary, employee.salaryUpdateWindow, employee.lastPayDay);
        delete employees[msg.sender];
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

    function updateSalary(address employeeAddr, uint amount) public bossOnly validEmployee(employeeAddr) {
        Employee storage employee = employees[employeeAddr];
        require(now - employee.lastPayDay <= employee.salaryUpdateWindow);
        totalSalary -= employee.salary;
        employee.salary = amount * salaryUnit;
        totalSalary += employee.salary;
    }

    function updatePaymentDuration(address employeeAddr, uint duration) public bossOnly validEmployee(employeeAddr) {
        duration *= paymentDurationUnit;
        Employee storage employee = employees[employeeAddr];
        require(employee.salaryUpdateWindow <= duration);
        employee.paymentDuration = duration;
    }

    function removeEmployee(address employeeAddr) bossOnly validEmployee(employeeAddr) public {
        Employee memory e = employees[employeeAddr];
        delete employees[employeeAddr];
        if (e.lastPayDay + e.paymentDuration < now) {
            uint amount = uint((now - e.lastPayDay) / e.paymentDuration) * e.salary;
            totalSalary -= e.salary;
            employeeAddr.transfer(amount);
        }
    }
}
