/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary ;
    address owner;
    Employee[] employees;


    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee , uint) {
        for(uint i;i < employees.length;i++){
            if(employees[i].id == employeeId){
                return(employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require (msg.sender == owner);
        var (employee,index)= _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint sSalary = salary * 1 ether;
        employees.push(Employee(employeeId,sSalary,now));
        totalSalary += sSalary;
    }

    function removeEmployee(address employeeId) {
        require (msg.sender == owner);
        var (employee,index)= _findEmployee(employeeId);
        assert(employee.id != 0x0 );
        _partialPaid(employee);
        delete employees[index];
        totalSalary -= employee.salary;
        employees[index]=employees[employees.length-1];
        employees.length-=1;
    }

    function updateEmployee(address employeeId, uint salary) {
        require (msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        uint sSalary = salary * 1 ether;
        employees[index].salary = sSalary;
        employees[index].lastPayday = now;
        totalSalary -= employee.salary + sSalary;
    }

    function addFund() payable returns (uint) {
         require (msg.sender == owner);
         return this.balance;
    }


    function calculateRunway()public view returns (uint) {
        //因为每次都循环会很费气
    //   uint totalSalary ;
    //   for (uint i = 0; i < employees.length; i++) {
    //         totalSalary+=employees[i].salary;
    //     }
        return this.balance / totalSalary;
    }


    function emplength() public view returns(uint){
        return  employees.length;
    }

    function balanceOf() public view returns(uint){
        return this.balance;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee,index)= _findEmployee(msg.sender);
        assert(employee.id!=0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(now>nextPayday);
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
