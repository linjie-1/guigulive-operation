var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {

	it("...should add and remove employee successfully.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.removeEmployee(accounts[1]);
		}).then(function () {
			return payrollInstance.addEmployee(accounts[2], 1);
		}).then(function () {
			assert(true, "pass the test.");
		});
	});

	it("...the operator who execute addEmployee function should be owner.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1, {
				from: accounts[1]
			});
		}).catch(function (error) {
			assert(error.toString().includes('revert'), "it should revert.")
		})
	})

	it("...the employee added should not existed in employees.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.addEmployee(accounts[1], 1);
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})

	it("...the operator who execute removeEmployee function should be owner.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.addEmployee(accounts[1], 1);
		}).then(function () {
			return payrollInstance.removeEmployee(accounts[1], {
				from: accounts[1]
			});
		}).catch(function (error) {
			assert(error.toString().includes('revert'), "it should revert.")
		})
	})

	it("...the employee removed should be existed in employees.", function () {
		return Payroll.deployed().then(function (instance) {
			payrollInstance = instance;
			return payrollInstance.removeEmployee(accounts[1]);
		}).catch(function (error) {
			assert(error.toString().includes('invalid opcode'), "it should expect exception.")
		})
	})

});