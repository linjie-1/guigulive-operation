var Payroll = artifacts.require('./Payroll.sol');

contract('Payroll', function(accounts) {
    
    // add a new employee  
    it("should add a new employee correctly", function(done) {
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            payroll.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).then(res => {
            return payroll.employees.call(accounts[1]);
        }).then(res => {
            assert.equal(res[0], accounts[1], 'Added employee has wrong id');
            assert.equal(res[1].valueOf(), web3.toWei(1), 'ether', 'Added employee has wrong salary');
            done();
        });
    });

    

    it("should not add the same employee twice",function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[1],1,{from:accounts[0]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner should be checked");
                done();
            });
        });
    });

    it("should not allow employee to add a new employee", function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[2], 2, {from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "revert", "Message sender should be employer");
                done();
            });
        });
    });

    
    // remove an existing employee
    it("should remove an existing employee correctly", function() {
        return Payroll.deployed().then(function(instance) {
            payroll = instance;
            return payroll.addEmployee(accounts[2], 2);
        }).then(function() {
            return payroll.removeEmployee(accounts[2]);
        }).then(function(removedEmployee) {
            assert.equal(payroll.employees[accounts[2]], undefined, 'The employee hasn\`t been removed.');
        });
    });

    it("should not allow employee to remove other employees", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[3],1,{from:accounts[0]});
        }).then(res => {
            payroll.removeEmployee(accounts[3],{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "revert", "Message sender should be employer");
                done();
            });
        });
    });

    it("should not remove an non-existing employee", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[5],1,{from:accounts[0]});
        }).then(res => {
            payroll.removeEmployee(accounts[4],{from:accounts[0]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "address existence should be checked");
                done();
            });
        });
    });


}) 
