pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
    Payroll payroll = Payroll(DeployedAddresses.Payroll());
    address e = 0xb1b669fc2d2a6e2e0574704e6e569dd0bb97f6ee;
    uint salary = 10;
    
    function testAddEmployee() public {
        payroll.addEmployee(e, salary);
        var (sal, lastPayday) = payroll.checkEmployee(e);
        Assert.equal(sal, salary, "It should store 10");
        Assert.notEqual(lastPayday, 0, "It should store 10");
    }

    function testRemoveEmployee() public {
        payroll.removeEmployee(e);
        var (sal, lastPayday) = payroll.checkEmployee(e);
        Assert.equal(sal, 0, "It should store 0");
        Assert.equal(lastPayday, 0, "It should store 10");
    }
}
