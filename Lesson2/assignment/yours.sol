/*作业请提交在这个目录下*/

//调试下来基本没有问题，但想请助教帮忙看一下：为什么在removeEmployee的时候，删除第一个employee会报错？删除其它的employee都不会。谢谢！

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant gPayDuration = 10 seconds;
    
    address gOwner;
    Employee[] gEmployees;
    
    uint gTotalSalary;

    function Payroll() {
        gOwner = msg.sender;
    }
    
    function _partialPaid(Employee _employee) private {
        uint _partialPaidPayment = _employee.salary * (now - _employee.lastPayday) / gPayDuration;
        _employee.id.transfer(_partialPaidPayment);
    }
    
    function _findEmployee(address _employeeId) private returns (Employee, uint) {
        require(_employeeId != 0x0);
        
        for (uint i = 0; i < gEmployees.length; i ++) {
            if(gEmployees[i].id == _employeeId) {
                return(gEmployees[i], i);
            }
        }
    }
    
    function addEmployee(address _employeeId, uint _Salary) {
        require(msg.sender == gOwner);
        require(_employeeId != 0x0 && _Salary != 0);
        var (addEmployeeEmployee, addEmployeeIndex) = _findEmployee(_employeeId);
        assert(addEmployeeEmployee.id == 0x0);
        _Salary = _Salary * 1 ether;
        gTotalSalary += _Salary;
        gEmployees.push(Employee(_employeeId, _Salary, now));
    }
    
    function removeEmployee(address _employeeId) returns (address, uint) {
        require(msg.sender == gOwner);
        require(_employeeId != 0x0);
        var (removeEmployeeEmployee, removeEmployeeIndex) = _findEmployee(_employeeId);
        assert(removeEmployeeEmployee.id != 0x0);
        
        _partialPaid(removeEmployeeEmployee);
        gTotalSalary -= removeEmployeeEmployee.salary;
        if((gEmployees.length -1) == removeEmployeeIndex) {
            delete gEmployees[removeEmployeeIndex];
        } else {
            gEmployees[removeEmployeeIndex] = gEmployees[gEmployees.length - 1];    
        }
        gEmployees.length--;
        
        //for test
        if((gEmployees.length) == removeEmployeeIndex) {
            return (gEmployees[removeEmployeeIndex - 1].id, gEmployees[removeEmployeeIndex - 1].salary);
        } else {
            return (gEmployees[removeEmployeeIndex].id, gEmployees[removeEmployeeIndex].salary);
        }
    }
    
    function updateEmployee(address _employeeId, uint _newSalary) {
        require(msg.sender == gOwner);
        require(_employeeId != 0x0 && _newSalary != 0);
        var (updateEmployeeEmployee, updateEmployeeIndex) = _findEmployee(_employeeId);
        assert(updateEmployeeEmployee.id != 0x0);
        
        _partialPaid(updateEmployeeEmployee);
        gTotalSalary = (gTotalSalary - gEmployees[updateEmployeeIndex].salary + _newSalary);
        gEmployees[updateEmployeeIndex].salary = _newSalary * 1 ether;
        gEmployees[updateEmployeeIndex].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / gTotalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (getPaidEmployee, getPaidIndex) = _findEmployee(msg.sender);
        assert(getPaidEmployee.id != 0x0);
        uint getPaidNextPayday = getPaidEmployee.lastPayday + gPayDuration;
        assert(getPaidNextPayday < now);
        gEmployees[getPaidIndex].lastPayday = getPaidNextPayday;
        gEmployees[getPaidIndex].id.transfer(getPaidEmployee.salary);
    }
    
    //for test
    function showEmployeeSalary(uint _index) returns (uint) {
        return gEmployees[_index].id.balance;
    }
    
    //for test
    function showTotalSalary() returns (uint) {
        return gTotalSalary;
    }
}


