var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll-1',function(accounts){

    it("should add employee correctly by owner", function(done){
        var payroll;
		Payroll.deployed().then(instance => {
	        payroll = instance;
	        payroll.addEmployee(accounts[0],1, {from: accounts[0]});
        }).then( res => {
	        return payroll.totalSalary.call();
        }).then( res => {
	        assert.equal(res.toString(),web3.toWei(1),'totalSalary not correct');
	        return payroll.employees.call(accounts[0]);
	    }).then( res => {
	        assert.equal(res[0].toString(),accounts[0],'address not added correctly');
	        assert.equal(res[1].toString(),web3.toWei(1),'salary not added correctly');
            done();
	    });
    });

    it("should not add employee by others except owner", function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[1],1,{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner should be checked");
                done();
            });
        });
	});

    it("should not add a already-exists employee",function(done){
        Payroll.deployed().then(instance => {
            instance.addEmployee(accounts[0],1,{from:accounts[0]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner should be checked");
                done();
            });
        });
    });
});

contract('Payroll-2',function(accounts){
    it("should remove employee correctly by owner", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[3],1,{from:accounts[0]});
        }).then(res =>{
            return payroll.removeEmployee(accounts[3],{from:accounts[0]});
        }).then( res => {
            return payroll.totalSalary.call();
        }).then( res => {
            assert.equal(res.toString(),web3.toWei(0),'totalSalary not correct');   
            return payroll.employees.call(accounts[3]);
        }).then( res =>{
            assert.equal(res[0].toString(),'0x0000000000000000000000000000000000000000','address not correct');
            done();
        });
    });

    it("should not remove employee by others", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[4],1,{from:accounts[0]});
        }).then(res => {
            payroll.removeEmployee(accounts[4],{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "owner should be checked");
                done();
            });
        });
    });

    it("should not remove a non-exists employee by owner", function(done){
        var payroll;
        Payroll.deployed().then(instance => {
            payroll = instance;
            return payroll.addEmployee(accounts[5],1,{from:accounts[0]});
        }).then(res => {
            payroll.removeEmployee(accounts[5],{from:accounts[1]}).catch(error =>{
                assert.include(error.toString(), "invalid opcode", "address existence should be checked");
                done();
            });
        });
    });

            
});

contract('Payroll-3',function(accounts){

    it("should pay to an correct employee in correct time", function(done){
        var payroll;
        var lastBalance;
        Payroll.deployed().then(instance => {
            payroll = instance;
            lastBalance = web3.eth.getBalance(accounts[6]).toNumber();
            return payroll.addEmployee(accounts[6],1,{from:accounts[0]});
        }).then( res => {
            return payroll.addFund({from:accounts[0],value:web3.toWei(5)});
        }).then( res => {
            web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
            return payroll.getPaid({from:accounts[6]})
        }).then( res =>{
            assert(web3.eth.getBalance(accounts[6]).toNumber()>lastBalance,'balance not added');
            done();
        });
    });

    it("should not pay to an non-exists employee", function(done){
        var payroll;
        var lastBalance;
        Payroll.deployed().then(instance => {
            payroll = instance;
            payroll.getPaid({from:accounts[7]}).catch(err => {
                assert.include(err.toString(), "invalid opcode", "address existence should be checked");
                done();
            });
        });
    });

    it("should not pay before payduration", function(done){
        var payroll;
        var lastBalance;
        Payroll.deployed().then(instance => {
            payroll = instance;
            lastBalance = web3.eth.getBalance(accounts[8]).toNumber();
            return payroll.addEmployee(accounts[8],1,{from:accounts[0]});
        }).then( res => {
            return payroll.addFund({from:accounts[0],value:web3.toWei(5)});
        }).then( res => {
            web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [5], id: 0});
            payroll.getPaid({from:accounts[8]}).catch(err => {
                assert.include(err.toString(), "invalid opcode", "time need check");
                done();
            });
        });
    });

});

