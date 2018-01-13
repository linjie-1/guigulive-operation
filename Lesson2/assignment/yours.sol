/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;

    uint totalSalary;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }


    function _partialPaid(Employee employee) private {
        uint amount = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(employee.salary);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0 ; i < employees.length ; i ++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (findedEmp,index) = _findEmployee(employeeId);
        assert(findedEmp.id == 0x0);

        employees.push(Employee(employeeId,salary * 1 ether,now));

        //当添加成功时，更改totalSalary
        totalSalary += salary * 1 ether;
    }


    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (findedEmp,index) = _findEmployee(employeeId);

        assert(findedEmp.id != 0x0);

        _partialPaid(findedEmp);

        //预选保存delSalary
        uint delSalary = findedEmp.salary;

        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;

        //当删成功时，更改totalSalary
        totalSalary -= employees[index].salary;


    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);

        var (findedEmp,index) = _findEmployee(employeeId);
        assert(findedEmp.id != 0x0);

        _partialPaid(findedEmp);

        //预选保存oldSalary
        uint oldSalary = findedEmp.salary;

        findedEmp.salary = salary * 1 ether ;
        findedEmp.lastPayday = now;

        //当更新成功时，更改totalSalary
        totalSalary = totalSalary - oldSalary + salary * 1 ether;

    }

    function addFund() payable returns (uint) {

        return this.balance;
    }

    function calculateRunway() returns (uint) {

        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }

    function getPaid() {
        for (uint i = 0 ; i < employees.length ; i ++){
            uint nextPayDay = employees[i].lastPayday + payDuration;
            if (nextPayDay < now){
                employees[i].id.transfer(employees[i].salary);
            }
        }
    }
}
