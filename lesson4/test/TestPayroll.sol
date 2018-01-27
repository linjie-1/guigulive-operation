pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {

	address employeeAddr = 0x228d2c17eb24e516167b38289d8d0730ea7c6a74;

	Payroll pay = new Payroll();

	/**
	 * 测试添加
	 */
	function testAddEmployee() public {

		pay.addEmployee(employeeAddr, 1);

		var _salary = pay.getEmployee(employeeAddr);

		Assert.equal(_salary, 1 ether, "该官员应该拥有1个ether的薪水");
	}

	/**
	 * 测试移除
	 */
	function testRemoveEmployee() public {

		pay.removeEmployee(employeeAddr);

		var _salary = pay.getEmployee(employeeAddr);

		Assert.equal(_salary, 0, "该成员的薪水应该为0，因为获取不到该成员");
	}

}
