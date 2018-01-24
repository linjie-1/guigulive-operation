var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {

	// test addEmployee & removeEmployee
	it("...should add and remove employee successfully.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.removeEmployee(accounts[1]);
		}).then(function () {
			return payrollInstance.addEmployee(accounts[2], 1);
		}).then(function () {
			assert(true, "The employeeId should add and remove employee successfully.");
		});
	});

	it("...the operator who call addEmployee function should be owner.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[1]});
		}).catch(function (error) {
			assert(error.toString().includes('revert'), "it should revert.")
		})
	})

	it("...the employee added should not exist in employees.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.addEmployee(accounts[1], 1);	
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})

	it("...the operator who call removeEmployee function should be owner.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.removeEmployee(accounts[1], { from: accounts[1] });
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})

	it("...the employee removed should exist in employees.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.removeEmployee(accounts[1]);
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})

	// test getPaid
	it("...the employee who get paid should exist in employees.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.addMoney({ from: accounts[0], value: "100" });
		}).then(function () {
			return payrollInstance.employeeGetPaid({ from: accounts[2] })
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})	

	it("...the employee who call getPaid should be himself", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.addMoney({ from: accounts[0], value: "100" });
		}).then(function () {
			return payrollInstance.employeeGetPaid({ from: accounts[0] })
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})
	
	it("...the employee should get paid successfully.", function () {
		var previousBalance, nowBalance;
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.addMoney({ from: accounts[0], value: "100" });
		}).then(function () {
			return previousBalance = web3.eth.getBalance(accounts[1]);
		}).then(function () {
			return payrollInstance.employeeGetPaid({ from: accounts[1] })
		}).then(function () {
			return nowBalance = web3.eth.getBalance(accounts[1]);
		}).then(function () {
			assert(nowBalance > previousBalance, "employee account balance increase, get paid successfully.")
		})
	})
});