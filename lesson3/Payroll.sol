pragma solidity ^0.4.14;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * The Payroll contract does this and that...
 */
contract Payroll is Ownable {

	using SafeMath for uint;

	uint totalSalary;

	struct Employee {
		address addr;
		uint salary;
		uint lastPayDay;
	}

	mapping (address => Employee) public employees;
	

	uint constant payDuration = 5 minutes;

	event AddFund(address indexed sender, address indexed addr, uint value);

	/**
	 * 是否存在指定雇员
	 */
	modifier employeeExist(address _employeeAddr) { 
		// 寻找指定雇员
		var employee = employees[_employeeAddr];
		// 当返回空 则表示不存在
		assert(employee.addr != 0x0);	
		_; 
	}

	/**
	 * 添加余额
	 */
	function addFund() payable public returns(uint) {
		AddFund(msg.sender, this, msg.value);
		return this.balance;
	}

	/**
	 * 支付剩余薪水
	 */
	function _partialPaid(Employee _employee) private {
		
		uint payment = _employee.salary.mul(now.sub(_employee.lastPayDay)).div(payDuration);
		_employee.addr.transfer(payment);
	}	

	/**
	 * 添加雇员
	 */
	function addEmployee(address _employeeAddr, uint _salary) public onlyOwner {

		// 寻找指定雇员
		var employee = employees[_employeeAddr];

		// 当返回空 则表示不存在
		assert(employee.addr == 0x0);

		// 添加雇员
		uint salary = _salary.mul(1 ether);
		totalSalary = totalSalary.add(salary);
		employees[_employeeAddr] = Employee(_employeeAddr, salary, now);
	} 

	/**
	 * 移除雇员
	 */
	function removeEmployee(address _employeeAddr) public onlyOwner employeeExist(_employeeAddr) {

        var employee = employees[_employeeAddr];

		// 支付剩余薪水
		_partialPaid(employee);

		totalSalary = totalSalary.sub(employees[_employeeAddr].salary);
		
		// 移除雇员
		delete employees[_employeeAddr];
	}

	/**
	 * 更新员工薪水
	 */
	function updateEmployee(address _employeeAddr, uint _salary) public onlyOwner employeeExist(_employeeAddr) {

        var employee = employees[_employeeAddr];

		// 支付剩余薪水
		_partialPaid(employee);
		totalSalary -= totalSalary.sub(employee.salary);

		// 更新员工数据
		employees[_employeeAddr].salary 	= _salary.mul(1 ether);
		employees[_employeeAddr].lastPayDay = now;
		totalSalary = totalSalary.add(employee.salary);
		return;
	}

	/**
	 * 更新员工收取工资地址
	 */
	function changePaymentAddress(address _oldAddr, address _newAddr) public onlyOwner employeeExist(_oldAddr) {

		var employee 					= employees[_oldAddr];
		employees[_newAddr].addr 		= _newAddr;
		employees[_newAddr].salary 		= employee.salary;
		employees[_newAddr].lastPayDay 	= employee.lastPayDay;
		delete employees[_oldAddr];
	}

	/**
	 * 计算能够发送多久的薪水
	 */
	function calculateRunway() public view returns (uint) {

		return this.balance.div(totalSalary);
	}	

	/**
	 * 是否有足够的余额发送薪水
	 */
	function hasEnoughFund() public view returns (bool) {
		return calculateRunway() > 0;
	}	

	/**
	 * 领取薪水
	 */
	function getPaid() public employeeExist(msg.sender) {
        
        var employee 	= employees[msg.sender];
        
		uint nextPayDay = employee.lastPayDay.add(payDuration);

		if (nextPayDay > now) {
			revert();
		}

		employees[msg.sender].lastPayDay = nextPayDay; 
		employees[msg.sender].addr.transfer(employee.salary);
	}
}