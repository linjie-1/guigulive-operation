var Payroll = artifacts.require("../contracts/Payroll.sol");

contract('Payroll',function(accounts){

    it("should set owner to account[0]", function(){
        return Payroll.deployed().then(function(instance){
            return instance.owner.call();
        }).then(function(ownerAddress){
            assert.equal(ownerAddress, accounts[0], "owner should be accounts[0]");
        });
    });

    it ("should successfully addEmpolyee and removeEmployee", function(){
        var payroll;
        var initialBalance;
        return Payroll.new().then(function(instance){
            payroll = instance;
            return instance.addemployee(accounts[1], 2, {from: accounts[0]});
        }).then(function(){
            return payroll.es.call(accounts[1]);
        }).then(function(v){
            assert.equal(v[0], accounts[1]);
            assert.equal(v[1], 2000000000000000000);
        }).then(function(){
            return web3.eth.getBalance(accounts[1]).toNumber();
        }).then(function(balance){
            initialBalance = balance;
        }).then(function(){
            return payroll.removeemployee(accounts[1], {from: accounts[0]});
        }).then(function(){
            return payroll.es.call(accounts[1]);
        }).then(function(v){
            assert.equal(v[0], 0x0);
            assert.equal(v[1], 0);
        });
    });

    it("should fail addemployee as msg.sender is not owner", function(){
        return Payroll.new().then(function(instance){
            return instance.addemployee(accounts[2], 2, {from: accounts[1]});
        })
        .then(assert.fail)
        .catch(function(error){
            assert.isAbove(error.message.search('revert'), -1, 'Revert error must be returned');
        });
    });

    it("should fail addemployee as employee already exists", function(){
        var payroll;
        return Payroll.new().then(function(instance){
            payroll = instance;
            return instance.addemployee(accounts[3], 2, {from: accounts[0]});
        }).then(function(){
            return payroll.addemployee(accounts[3], 2, {from: accounts[0]});
        })
        .catch(error => {
            assert.include(error.toString(),"invalid", "owner should be checked");
        });
    });

    it("should fail removeemployee as msg.sender is not owner",function(){
        return Payroll.new().then(function(instance){
            return instance.removeemployee(accounts[4], {from: accounts[1]});
        })
        .then(assert.fail)
        .catch(function(error){
            assert.isAbove(error.message.search('revert'), -1, 'Revert error must be returned');
        });
    });

    it("should fail removeemloyee as employee does not exist", function(){
        return Payroll.new().then(function(instance){
            return instance.removeemployee(accounts[5], {from: accounts[0]});
        })
        .then(assert.fail)
        .catch(function(){
            assert.isAbove(error.message.search('invalid'), -1, error.message);
        });
    });

    it("should fail as msg.sender does not exist", function(){
        var payroll;
        return Payroll.new().then(function(instance){
            payroll = instance;
            return instance.getPaid({from: accounts[6]});
        })
        .then(assert.fail)
        .catch(function(error){
            assert.isAbove(error.message.search('invalid'), 1, error.message);
        });
    });

    it("should fail as it is too early to get paid", function(){
        var payroll;
        return Payroll.new().then(function(instance){
            payroll = instance;
            return instance.addemployee(accounts[7], 2, {from: accounts[0]});
        }).then(function(){
            return payroll.getPaid({from: accounts[7]});
        })
        .then(assert.fail)
        .catch(function(error){
            assert.isAbove(error.message.search('invalid'), -1, error.message);
        });
    });

    it("should fail as there is not enough fund to getPaid", function() {
        var payroll;
        var initialBalance;
        return Payroll.new().then(function(instance) {
          payroll = instance;
          return instance.addemployee(accounts[8], 2, {from: accounts[0]});
        }).then(function() {
          return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
          initialBalance = balance;
        }).then(function(){
          return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
        }).then(function(){
          return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
        }).then(function() {
          return payroll.getPaid({from: accounts[8]});
        }).then(assert.fail)
        .catch(function(error) {
          assert.isAbove(error.message.search('revert'), -1, error.message);
        });
      });
    
      it("should successfully getPaid", function() {
        var payroll;
        var initialBalance;
        return Payroll.new().then(function(instance) {
          payroll = instance;
          return instance.addemployee(accounts[8], 2, {from: accounts[0]});
        }).then(function() {
          return payroll.addFund({from: accounts[0], value: 30000000000000000000});
        }).then(function() {
          return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
          initialBalance = balance;
        }).then(function(){
          return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
        }).then(function(){
          return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
        }).then(function() {
          return payroll.getPaid({from: accounts[8]});
        }).then(function() {
          return web3.eth.getBalance(accounts[8]);
        }).then(function(balance) {
          assert.isAbove(balance.toNumber(), initialBalance.toNumber(), "balance should be larger after getPaid");
        });
      });

}
