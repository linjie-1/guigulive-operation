pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {

	address employeeAddr = 0xee68889212b99d649b610dd03982b6f4381bc069;

	Payroll pay = new Payroll();

	/**
	 * 测试添加
	 */
	function testAddEmployee() {

		pay.addEmployee(employeeAddr, 1);

		var _salary = pay.getEmployee(employeeAddr);

		Assert.equal(_salary, 1 ether, "该官员应该拥有1个ether的薪水");
	}

	/**
	 * 测试移除
	 */
	function testRemoveEmployee() {

		pay.removeEmployee(employeeAddr);

		var _salary = pay.getEmployee(employeeAddr);

		Assert.equal(_salary, 0, "该成员的薪水应该为0，因为获取不到该成员");
	}

}
