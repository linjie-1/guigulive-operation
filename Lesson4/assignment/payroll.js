var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    it("should add and remove employee successfully", function() {
        var inst;
        Payroll.deployed().then(function(instance) {
            inst = instance;
            return instance.addEmployee(accounts[2],1);
        }).then(function() {
            return inst.removeEmployee(accounts[2]);
        }).then(function() {
            return inst.addEmployee(accounts[2],1);
        }).then(function() {
            assert(true, "pass");
        })
    });
    
    it("should prevent non-owner from calling addEmployee", function() {
        Payroll.deployed().then(function(instance) {
            return instance.addEmployee(accounts[2],2,{from:accounts[2]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        });
    });

    it("should not add a 0x0 address employee", function() {
        Payroll.deployed().then(function(instance) {
            return instance.addEmployee("0x0",2);
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        });
    });

    it("should not add an existed employee", function() {
        var inst;
        Payroll.deployed().then(function(instance) {
            inst = instance;
            return instance.addEmployee(accounts[2],1);
        }).then(function() {
            return instance.addEmployee(accounts[2],1);
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });

    it("should prevent non-owner from calling removeEmployee", function() {
        var inst;
        Payroll.deployed().then(function(instance) {
            inst = instance;
            return instance.addEmployee(accounts[2],1);
        }).then(function() {
            return inst.removeEmployee(accounts[2],{from:accounts[1]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });
    it("should not remove a nonexisted employee", function() {
        Payroll.deployed().then(function(instance) {
            return instance.removeEmployee(accounts[1]);
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });
    // test getPaid
    it("should not getPaid by wrong msg.sender",function() {
        var inst;
        Payroll.deployed().then(function(instance) {
            inst = instance;
            return instance.addEmployee(accounts[2],1);
        }).then(function() {
            return inst.getPaid({from:accounts[1]});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });

    it("should not getPaid by 0x0",function() {
        var inst;
        Payroll.deployed().then(function(instance) {
            inst = instance;
            return instance.addEmployee(accounts[2],1);
        }).then(function() {
            return inst.getPaid({from:"0x0"});
        }).catch(function(error) {
            assert(error.toString().includes('invalid opcode'), "expect exception here");
        })
    });

    it("should getpaid successfully", function() {
        var inst;
        var old;
       Payroll.deployed().then(function(instance) {
           inst = instance;
           return instance.addFund({from: accounts[0], value:"2000000000000000000"});
       }).then(function(){
           console.log("1");
           return inst.addEmployee(accounts[1],1);
       }).then(function(){
           console.log("2");
           old = web3.eth.getBalance(accounts[1]);
           for(var t = Date.now();Date.now() - t <= 12000;);
       }).then(function(){
           console.log("3");
           return inst.getPaid({from:accounts[1]});
       }).then(function() {
           return web3.eth.getBalance(accounts[1]);
       }).then(function(value) {
           console.log(value);
           console.log(old);
           assert(value > old, "getpaid should be successfully, new value must be greater than old");
           old = value;
       }).then(function() {
           return inst.getPaid({from:accounts[1]});
       }).then(function() {
           value = web3.eth.getBalance(accounts[1]);
           console.log(value);
           console.log(old);
           assert(value < old, "getpaid should be not successfully, new value must be smaller than old");
       })
    });    
});
