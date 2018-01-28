pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
	address employeeAddr = 0x228d2c17eb24e516167b38289d8d0730ea7c4474;
	Payroll payroll = new Payroll();

	function testAddEmployee(){
		payroll.addEmployee(employeeAddr, 1);
		var (salry, lastpayday) = payroll.checkEmployee(employeeAddr);
		Assert.equal(salry, 1 ether, "this employee should have 1 ether salary");
	}

	function testRemoveEmployee(){
		// payroll.addFund();
		payroll.removeEmployee(employeeAddr);
		var (salry, lastpayday) = payroll.checkEmployee(employeeAddr);
		Assert.equal(salry, 0, "this employee should have 0 ether salary");
	}
}
