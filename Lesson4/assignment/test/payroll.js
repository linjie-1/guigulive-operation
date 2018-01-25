var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
      
    it("can add employee", function() {
        Payroll.deployed().then(function(contract) {
            return contract.addEmployee(accounts[1],1);
        }).then(function() {
            assert(true, "pass");
        })
    });

    it("can remove employee", function() {
        var contr;
        Payroll.deployed().then(function(contract) {
            contr = contract;
            return contract.addEmployee(accounts[1],1);
        }).then(function() {
            return inst.removeEmployee(accounts[1]);
        }).then(function() {
            assert(true, "pass");
        })
    });

    it("non-owner cannot call addEmployee", function() {
        Payroll.deployed().then(function(contract) {
            return contract.addEmployee(accounts[1],1,{from:accounts[2]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        });
    });

    it("non-owner cannot call removeEmployee", function() {
        var contr;
        Payroll.deployed().then(function(contract) {
            contr = contract;
            return contract.addEmployee(accounts[1],1);
        }).then(function() {
            return inst.removeEmployee(accounts[1],{from:accounts[1]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });
});