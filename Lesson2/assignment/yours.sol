/*
题目1：加入十个员工，每个员工的薪水都是1ETH 每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？

增加几位员工时的Gas变化情况
   transaction cost , execution cost    , calculateRunway() cost
1     105162   82290    22966  1694
2      91003   68131    23747  2475
3      91844   68972    24528  3256
4      92685   69813    25309  4037
5      93526   70654    26090  4818

gas不断增大，addEmployee时，每次操作时gas增加841，calculateRunway时，每次gas增加781
findEmployee()函数遍历的员工人数变多时，查找操作消耗的gas会变多
*/


/*
题目2：如何优化calculateRunway这个函数来减少gas的消耗？

优化后的code如下：
*/
contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    uint totalSalary;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salaryOfEther) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        employees.push(Employee(employeeId, salaryOfEther * 1 ether, now));
        totalSalary += salaryOfEther;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];

        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        totalSalary -= employee.salary;
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);

        totalSalary -= employee.salary + salary;

        employee.salary = salary;
        employee.lastPayday = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        require(totalSalary > 0);
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        require(msg.sender == employee.id);

        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}