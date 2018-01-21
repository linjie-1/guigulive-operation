pragma solidity ^0.4.14;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/payroll.sol";


contract TestPayroll is Payroll {

    address testAddress = 0xc42d7e5be797195e736683fd7624936f2537ed14;
    uint public initialBalance = 10 ether;

    function testAddEmployee() {
        addEmployee(testAddress, 1);
        var employee = employees[testAddress];
        Assert.equal(employee.id, testAddress, "employee should have correct address");
        uint expect = 1 ether;
        Assert.equal(employee.salary, expect, "employee should have correct salary");
    }

    function testGetPaid() {
        var employee = employees[testAddress];
        employee.lastPayday = now - payDuration;
        uint oldBalance = testAddress.balance;
        _getPaid(testAddress, now);
        uint newBalance = testAddress.balance;
        Assert.equal(newBalance - oldBalance, 1 ether, "employee should have correct payment");
    }

    function testRemoveEmployee() {
        removeEmployee(testAddress);

        var employee = employees[testAddress];

        Assert.equal(employee.id, 0x0, "removed employee should have empty address");
        Assert.equal(employee.salary, 0, "removed employee should have empty salary");
    }



}
/* 
solidity 测试不能修改msg.sender，
且出现异常时会停止执行，进行异常测试比较困难
要进行异常测试应使用javascript 

测试getPaid时因为timestamp无法直接修改，可以添加一个函数_getPaid带address和timestamp参数，
通过测试来_getPaid实现曲线救国
*/