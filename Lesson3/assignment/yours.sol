/*作业请提交在这个目录下*/

第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图

回答：代码附在下面，测试过程与截图参考excel文档。

第二题：增加changePaymentAddress函数，更改员工的薪水支付地址。思考一下能否使用modifier整合某个功能

回答：代码附在下面。因为更改后的新地址需要确认在现有mapping对象中不存在，所以可以用modifier来进行整个。
　　　同理，在addEmployee中也需要确认地址在mapping对象中不存在，所以整合是有意义的。

第三题：（加分题）：自学C3 Linearization，求以下contract Z的继承线。

contract Z的继承线为：K2 -> C -> K1 -> B -> A -> O

------------------------------------------------------------------------------------------------------
代码如下：

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
	
    uint constant public gPayDuration = 10 seconds;	
    mapping(address => Employee) public gEmployees;	
    uint public gTotalSalary;	
 	
    modifier employeeExist(address _employeeId) {	
        assert(gEmployees[_employeeId].id != 0x0);	
        _;	
    }	
    	
    modifier employeeNotExist(address _employeeId) {	
        assert(gEmployees[_employeeId].id == 0x0);	
        _;	
    }	
	
    function _partialPaid(Employee _employee) private {	
        //uint _partialPaidPayment = _employee.salary * (now - _employee.lastPayday) / gPayDuration;	
        uint _partialPaidPayment = (_employee.salary.mul(now.sub(_employee.lastPayday))).div(gPayDuration);	
        _employee.id.transfer(_partialPaidPayment);	
    }	
   	
    function changePaymentAddress(address _oldAddress, address _newAddress) onlyOwner employeeExist(_oldAddress) employeeNotExist(_newAddress) {	
        _partialPaid(gEmployees[_oldAddress]);	
        addEmployee(_newAddress, gEmployees[_oldAddress].salary);	
        removeEmployee(_oldAddress);	
    }	
    	
    function addEmployee(address _employeeId, uint _Salary) onlyOwner employeeNotExist(_employeeId) {	
        //_Salary = _Salary * 1 ether;	
        //assert(gEmployees[_employeeId].id == 0x0);	
        _Salary = _Salary.mul(1 ether);	
        //gTotalSalary += _Salary;	
        gTotalSalary = gTotalSalary.add(_Salary);	
        gEmployees[_employeeId]=Employee(_employeeId, _Salary, now);	
    }	
    	
    function removeEmployee(address _employeeId) onlyOwner employeeExist(_employeeId) {	
        _partialPaid(gEmployees[_employeeId]);	
        gTotalSalary = gTotalSalary.sub(gEmployees[_employeeId].salary);	
        delete gEmployees[_employeeId];	
        	
    }	
    	
    function updateEmployee(address _employeeId, uint _newSalary) onlyOwner employeeExist(_employeeId) {	
        _partialPaid(gEmployees[_employeeId]);	
        	
        gTotalSalary = (gTotalSalary.sub(gEmployees[_employeeId].salary)).add(_newSalary.mul(1 ether));	
        gEmployees[_employeeId].salary = _newSalary.mul(1 ether);	
        gEmployees[_employeeId].lastPayday = now;	
    }	
    	
    function addFund() payable returns (uint contractBalance) {	
        return this.balance;	
    }	
    	
    function calculateRunway() returns (uint Runway) {	
        Runway = this.balance.div(gTotalSalary);	
    }	
    	
    function hasEnoughFund() returns (bool enough) {	
        enough = calculateRunway() > 0;	
    }	
    	
    function getPaid() employeeExist(msg.sender) {	
        var getPaidEmployee = gEmployees[msg.sender];	
        uint getPaidNextPayday = getPaidEmployee.lastPayday.add(gPayDuration);	
        assert(getPaidNextPayday < now);	
        getPaidEmployee.lastPayday = getPaidNextPayday;	
        getPaidEmployee.id.transfer(getPaidEmployee.salary);	
    }	
}	


