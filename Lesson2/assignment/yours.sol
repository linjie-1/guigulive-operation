/* record  gas consumption before optimization,
 * for each employee added before calling calculateRunway()
 * transaction cost   execution cost
 *  22966 gas             1694 gas
 *  23747 gas             2475 gas
 *  24528 gas             3256 gas
 *  25309 gas             4037 gas
 *  26090 gas             4818 gas
 *  26871 gas             5599 gas
 *  27652 gas             6380 gas
 *  28433 gas             7161 gas
 *  29214 gas             7942 gas
 *  29995 gas             8723 gas
 * ===============================================================
 * Discovered that execution cost of calculateRunway(),
 * is in linear relationship with employee numbers.
 * That is because we iterate whole employee members on each functional call
 * ===============================================================
 * One optimization is to use state variable totalSalary to record sum of salaries,
 * when add or delete employee members
 * Therefore, calculateRunway() only need constant computation resource
 * ===============================================================
 * After optimization
 * transaction cost   execution cost
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 *  22124 gas             852 gas
 * ================================================================
*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        assert(this.balance >= payment);
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i ++){
            if(employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);

        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var(employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employees[index]);
        totalSalary -= employees[index].salary;

        delete employees[index];

        employees[index] = employees[employees.length - 1];
        employees.length --;
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        require(employee.id != 0x0);

        _partialPaid(employees[index]);
        uint newSalary = salary * 1 ether;

        totalSalary += newSalary - employees[index].salary;

        employees[index].salary = newSalary;

        employees[index].lastPayday = now;

    }

    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var(employee, index) = _findEmployee(msg.sender);
        require(employee.id != 0x0);

        uint nextPayday = employees[index].lastPayday + payDuration;
        assert(nextPayday < now);
        assert(employee.salary <= this.balance);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
    }
}
