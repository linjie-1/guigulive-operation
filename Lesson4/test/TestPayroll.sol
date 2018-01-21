pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
    Payroll payroll = Payroll(DeployedAddresses.Payroll());
    address id = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;

    function testAddEmployee() public {
        payroll.addEmployee(0xca35b7d915458ef540ade6068dfe2f44e8fa733c, 1);

        uint salary = 1 ether;
        

        Assert.equal(payroll.findEmployee(id).salary, salary, "the employee added and the salary is 1 ether.");
    }


    function testRemoveEmployee() public {
        var e = payroll.findEmployee(0xca35b7d915458ef540ade6068dfe2f44e8fa733c);

        payroll.removeEmployee(e.id);
        Assert.equal(payroll.findEmployee(e.id).id, 0x0, "the employee is not exist");
    }
}