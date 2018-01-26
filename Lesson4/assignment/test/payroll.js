var Payroll = artifacts.require("./payroll.sol");
var BigNumber = require('bignumber.js');

contract('Payroll', async function(accounts) {

    let payrollInstance;

    before(async () => {
        payrollInstance = await Payroll.new({from : accounts[0]});
        const wei_added = web3.toWei("2", "ether");
        await payrollInstance.addFund({from : accounts[2], value : wei_added});
        assert.equal(wei_added, web3.eth.getBalance(payrollInstance.address).toString());
    });

    it("should add an employee correctly by owner", async () => {
        await payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
        const employee = await payrollInstance.employees.call(accounts[1]);
        assert.equal(employee[0].toString(), accounts[1], "employee.id is incorrect");
        assert.equal(employee[1].toString(), "1000000000000000000", "employee.salary is incorrect");
    });

    it("should not add employee correctly by others", async () => {
        try {
            await payrollInstance.addEmployee(accounts[2], 1, {from: accounts[1]});
        } catch(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
        }
    });

    it("should not add employee with same id", async () => {
        try{
            await payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
        } catch(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
        }
    });

    it("should get paid", async () => {
        const employee = accounts[1];
        const before_paid = new BigNumber(web3.eth.getBalance(employee));
        try {
            const pay_duration = await payrollInstance.getPayDuration.call({from: employee});
            // Increase next block's timestamp with 2 * payDuration.
            web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [ 2 * pay_duration ], id: 1});
            web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 2});
            let result = await payrollInstance.getPaid({from : employee});
            var gasPrice = web3.eth.getTransaction(result.tx).gasPrice.toNumber();
            let gas = await payrollInstance.getPaid.estimateGas({from : employee});
     
            const after_paid = new BigNumber(web3.eth.getBalance(employee));
            assert.equal(web3.toWei(1), after_paid.minus(before_paid).plus(gasPrice * gas).toString());
          } catch (err) {
            console.error("await promise error: ", err);
            assert.fail()
          }
    });

    it("should remove an employee by owner", async () => {
        await payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        const employee = await payrollInstance.employees.call(accounts[1]);
        assert.equal(employee[0], "0x0000000000000000000000000000000000000000", "employee.id is incorrect");
        assert.equal(employee[1].toString(), "0", "employee.salary is incorrect")
    })

    it("should not remove employee correctly by others", async () => {
        try {
            await payrollInstance.removeEmployee(accounts[2], {from: accounts[1]});
        } catch(error) {
            assert.include(error.toString(), "revert", "contains 'revert'");
        };
    });

    it("should not remove employee with id 0x0", async () => {
        try{
            await payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        } catch(error) {
            assert.include(error.toString(), "invalid opcode", "contains 'invalid opcode'");
        };
    });
});
