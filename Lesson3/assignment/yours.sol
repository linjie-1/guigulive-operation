/*作业请提交在这个目录下*/

第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图

截好图了，放在了另一个folder里

第二题：增加changePaymentAddress函数，更改员工的薪水支付地址。思考一下能否使用modifier整合某个功能

第三题：（加分题）：自学C3 Linearization，求以下contract Z的继承线。

O[O]
A[A,O]
B[B,O]
C[C,O]
K1[K1,A,B,O]
K2[K2,A,C,O]
[Z,K1,K2,A,B,C,O]

------------------------------------------------------------------------------------------------------

pragma solidity ^0.4.14;	
	
import './SafeMath.sol';	
import './Ownable.sol';	
	
contract Payroll is Ownable {	
    using SafeMath for uint;	
    	
    struct Employee {	
        address id;	
        uint salary;	
        uint lastPayday;	
    }	
	
    uint constant public PayDuration = 10 seconds;	
    mapping(address => Employee) public Employees;	
    uint public TotalSalary;	
 	
    modifier employeeExist(address _employeeId) {	
        assert(Employees[_employeeId].id != 0x0);	
        _;	
    }	
    	
    modifier employeeNotExist(address _employeeId) {	
        assert(Employees[_employeeId].id == 0x0);	
        _;	
    }	
	
    function _partialPaid(Employee _employee) private {	
        uint _partialPaidPayment = (_employee.salary.mul(now.sub(_employee.lastPayday))).div(PayDuration);	
        _employee.id.transfer(_partialPaidPayment);	
    }	
   	
    function changePaymentAddress(address _oldAddress, address _newAddress) onlyOwner employeeExist(_oldAddress) employeeNotExist(_newAddress) {	
        _partialPaid(Employees[_oldAddress]);	
        addEmployee(_newAddress, Employees[_oldAddress].salary);	
        removeEmployee(_oldAddress);	
    }	
    	
    function addEmployee(address _employeeId, uint _Salary) onlyOwner employeeNotExist(_employeeId) {	
        _Salary = _Salary.mul(1 ether);	
        TotalSalary = TotalSalary.add(_Salary);	
        Employees[_employeeId]=Employee(_employeeId, _Salary, now);	
    }	
    	
    function removeEmployee(address _employeeId) onlyOwner employeeExist(_employeeId) {	
        _partialPaid(Employees[_employeeId]);	
        TotalSalary = TotalSalary.sub(Employees[_employeeId].salary);	
        delete Employees[_employeeId];	
        	
    }	
    	
    function updateEmployee(address _employeeId, uint _newSalary) onlyOwner employeeExist(_employeeId) {	
        _partialPaid(Employees[_employeeId]);	
        	
        TotalSalary = (TotalSalary.sub(Employees[_employeeId].salary)).add(_newSalary.mul(1 ether));	
        Employees[_employeeId].salary = _newSalary.mul(1 ether);	
        Employees[_employeeId].lastPayday = now;	
    }	
    	
    function addFund() payable returns (uint contractBalance) {	
        return this.balance;	
    }	
    	
    function calculateRunway() returns (uint Runway) {	
        Runway = this.balance.div(TotalSalary);	
    }	
    	
    function hasEnoughFund() returns (bool enough) {	
        enough = calculateRunway() > 0;	
    }	
    	
    function getPaid() employeeExist(msg.sender) {	
        var getPaidEmployee = Employees[msg.sender];	
        uint getPaidNextPayday = getPaidEmployee.lastPayday.add(PayDuration);	
        assert(getPaidNextPayday < now);	
        getPaidEmployee.lastPayday = getPaidNextPayday;	
        getPaidEmployee.id.transfer(getPaidEmployee.salary);	
    }	
}	

