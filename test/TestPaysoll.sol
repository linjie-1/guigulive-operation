pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPaysoll is Payroll{

function testAddEmployee() public{
     address id =  0x8bcd5c5d1fcff75ca8b03b53d5f3f95bfb5cc137;
     addEmployee(0x8bcd5c5d1fcff75ca8b03b53d5f3f95bfb5cc137,1);
     uint salary = 1 ether;
     Assert.equal(employees[id].salary, salary, "the employee added and the salary is 1 ether.");
 }
 function testremoveEmployee() public{
     var employee = employees[0x8bcd5c5d1fcff75ca8b03b53d5f3f95bfb5cc137];
     removeEmployee(employee.id);
     Assert.equal(employees[employee.id].id, 0x0, "the employee is not exist");
 }

}
