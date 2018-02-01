pragma solidity ^0.4.14;

contract Payroll {
    address public boss;
    uint paymentDurationUnit;
    uint salaryUnit;
    uint totalSalary;
    mapping (address => Employee) public employees;

    struct Employee {
        uint salary;
        uint lastPayDay;
        uint paymentDuration;
    }

    modifier bossOnly {
        require(msg.sender == boss);
        _;
    }

    modifier validEmployee(address employee) {
        require(employees[employee].salary > 0);
        _;
    }

    function Payroll(address _boss) public {
        boss = _boss;
        paymentDurationUnit = 1 seconds;
        salaryUnit = 1 ether;
    }

    function addFund() public payable returns (uint) {
        return (msg.value);
    }

    function addEmployee(address employeeAddr, uint paymentDuration, uint salary, uint lastPayDay) internal {
        Employee storage employee = employees[employeeAddr];
        employee.lastPayDay = lastPayDay;
        employee.paymentDuration = paymentDuration;
        employee.salary = salary;
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
        addEmployee(_employee, employee.paymentDuration, employee.salary, employee.lastPayDay);
        delete employees[msg.sender];
    }

    /**
     * Bosses' actions.
     */

    function updateBossAddress(address _boss) public bossOnly {
        boss = _boss;

    }

    function bossAddEmployee(address employeeAddr, uint paymentDuration, uint salary) public bossOnly {
        paymentDuration *= paymentDurationUnit;
        salary *= salaryUnit;
        totalSalary += salary;
        addEmployee(employeeAddr, paymentDuration, salary, now);
    }

    function updateSalary(address employeeAddr, uint amount) public bossOnly validEmployee(employeeAddr) {
        Employee storage employee = employees[employeeAddr];
        totalSalary -= employee.salary;
        employee.salary = amount * salaryUnit;
        totalSalary += employee.salary;
    }

    function updatePaymentDuration(address employeeAddr, uint duration) public bossOnly validEmployee(employeeAddr) {
        duration *= paymentDurationUnit;
        Employee storage employee = employees[employeeAddr];
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
