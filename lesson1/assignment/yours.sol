pragma solidity ^0.4.14;

contract PayRoll {
    address boss;
    mapping (address => Employee) employees;

    struct Employee {
        uint salary;
        uint lastPayDay;
        uint paymentDuration;
        uint salaryUpdateWindow;
    }

    modifier bossOnly {
        require(msg.sender == boss);
        _;
    }

    modifier validEmployee {
        require(employees[msg.sender].salary > 0);
        _;
    }

    function PayRoll(address _boss) public {
        boss = _boss;
    }

    function addFund() public payable returns (uint) {
        return (msg.value);
    }

    function calculateRunaway() public view returns (uint) {
        return this.balance;
    }

    function hasEnoughFund() internal view validEmployee returns (bool) {
        return calculateRunaway() >= employees[msg.sender].salary;
    }

    function getSalary() public validEmployee {
        Employee storage employee = employees[msg.sender];
        uint nextPayDay = employee.paymentDuration + employee.lastPayDay;
        require(nextPayDay <= now && hasEnoughFund());
        employee.lastPayDay = nextPayDay;
        msg.sender.transfer(employee.salary);
    }

    function updateBossAddress(address _boss) public bossOnly {
        boss = _boss;
    }

    function addEmployee(address employee) public bossOnly {
        addEmployee(employee, 0, 0, 10 seconds);
    }

    function addEmployee(address employeeAddr, uint paymentDuration, uint salary, uint salaryUpdateWindow) public bossOnly {
        Employee storage employee = employees[employeeAddr];
        employee.lastPayDay = now;
        employee.paymentDuration = paymentDuration;
        employee.salary = salary;
        employee.salaryUpdateWindow = salaryUpdateWindow < paymentDuration ? salaryUpdateWindow : paymentDuration;
    }

    function updateSalary(address employeeAddr, uint amount) public bossOnly {
        Employee storage employee = employees[employeeAddr];
        require(now - employee.lastPayDay <= employee.salaryUpdateWindow);
        employee.salary = amount;
    }

    function updatePaymentDuration(address employeeAddr, uint duration) public bossOnly {
        employees[employeeAddr].paymentDuration = duration;
    }

    function getEmployees(address employeeAddr) public view bossOnly returns (address, uint, uint, uint, uint) {
        Employee storage employee = employees[employeeAddr];
        return (employeeAddr, employee.salary, employee.paymentDuration, employee.lastPayDay, employee.salaryUpdateWindow);
    }
}
