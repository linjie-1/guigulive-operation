pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll is Payroll {
    function testAddEmployee() public {
        Payroll payroll = Payroll(DeployedAddresses.Payroll());

        addEmployee(0x583031d1113ad415f02576bd6afabfb302140223, 1);

        uint salary = 1 ether;
        address id = 0x583031d1113ad415f02576bd6afabfb302140223;

        Assert.equal(employees[id].salary, salary, "the employee added and the salary is 1 ether.");
    }


    function testRemoveEmployee() public {
        var e = employees[0x583031d1113ad415f02576bd6afabfb302140223];

        removeEmployee(e.id);
        Assert.equal(employees[e.id].id, 0x0, "the employee is not exist");
    }
}