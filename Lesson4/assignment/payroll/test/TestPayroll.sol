pragma solidity ^0.4.17;
 
 import "truffle/Assert.sol";
 import "../contracts/Payroll.sol";
 
 contract TestPayroll {
 
 	address employeeAddr = 0x19;
 
 	Payroll pay = new Payroll();
 
 	/**
 	 * 测试添加
 	 */
 	function testAddEmployee() {
 
 		pay.addEmployee(employeeAddr, 89);
 
 		var _salary = pay.getEmployee(employeeAddr);
 
		Assert.equal(_salary, 89 ether, "SHOULD BE 89 ETHER!");
 	}
 
 	function testRemoveEmployee() {
 
 		pay.removeEmployee(employeeAddr);
 
 		var _salary = pay.getEmployee(employeeAddr);
 
 		Assert.equal(_salary, 0, "SHOULD BE 0 ETHER! Employee has been removed!");
 	}
 
 }