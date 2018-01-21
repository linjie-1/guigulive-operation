var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");
var Payroll = artifacts.require("./Payroll.sol");



contract('Payroll', function(accounts) {
    var owner = accounts[0];
    var salary = 1;
    var fund = 100000;

    // Add Fund in the first step
    it ("Add Fund in the first step", function(){
        return Payroll.deployed().then(function(instance){
            return instance.addFund.call({value:web3.toWei(fund,'ether'),from: owner});
        }).then(function(balance){
            assert.equal(balance.toNumber(),web3.toWei(fund,'ether'));
        });
    });


    // Add Employee Here
    it("Add Employee Here",function(){
        let employeeId = accounts[1];
        return Payroll.deployed().then(function(instance){
            payrollInstance = instance;
            return payrollInstance.addEmployee(employeeId,salary,{from:owner});
        }).then(function(){
            return payrollInstance.employees.call(employeeId);
        }).then(function(newEmployee){
            assert.equal(newEmployee[0],employeeId,'check new employee address');
            assert.equal(newEmployee[1].valueOf(),web3.toWei(salary,'ether'),'check new employee salary');
        });
    });

    // Remove Employee Here
    it ("Remove Employee Here",function(){
        let employeeId = accounts[1];
        return Payroll.deployed().then(function(instance){
            payrollInstnace = instance;
            return payrollInstance.removeEmployee(employeeId,{from:owner});
        }).then(function() {
            return payrollInstance.employees.call(employeeId);
        }).then(function(deletedEmployee){
            assert.equal(payrollInstance.employees[employeeId],undefined, 'this employee has been removed');
        });
    });


});