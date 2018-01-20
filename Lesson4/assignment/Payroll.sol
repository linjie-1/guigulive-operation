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
        //pay attention to the gEmployees[_oldAddress].salary.div(1 ether)
        addEmployee(_newAddress, gEmployees[_oldAddress].salary.div(1 ether));	
        removeEmployee(_oldAddress);	
    }	
    	
    function addEmployee(address _employeeId, uint _Salary) onlyOwner employeeNotExist(_employeeId) {	
    //function addEmployee(address _employeeId, uint _Salary) onlyOwner {	
        //_Salary = _Salary * 1 ether;	
        //assert(gEmployees[_employeeId].id == 0x0);	
        _Salary = _Salary.mul(1 ether);	
        //gTotalSalary += _Salary;	
        gTotalSalary = gTotalSalary.add(_Salary);	
        gEmployees[_employeeId]=Employee(_employeeId, _Salary, now);	
    }	
    	
    function removeEmployee(address _employeeId) onlyOwner employeeExist(_employeeId) {	
    //function removeEmployee(address _employeeId) {	
        //new!! _partialPaid(gEmployees[_employeeId]);	
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
