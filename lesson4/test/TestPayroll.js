var Payroll = artifacts.require("Payroll");

var employeeAddr = "0xb15e819f737f3975f9cb4534aebb69285ff526dd";

var salary = 1;

var fund = web3.toWei(50, "ether");


contract('Payroll', function(accounts) {

	// 添加员工
	it("添加员工", function() {

		return Payroll.deployed().then((instance) => {

			instance.addEmployee(employeeAddr, salary);
			return instance.getEmployee(employeeAddr);
		}).then((res) => {

			assert.equal(res.valueOf(), web3.toWei(salary, 'ether'), "添加有错误");
		});

	});

	// 添加余额
	it("添加余额", function() {

		return Payroll.deployed().then((instance) => {

			return instance.addFund({
				value: fund,
			});
		}).then((res) => {

			assert.equal(res.valueOf(), fund, "添加余额错误");
		});
	});

	// 移除员工
	// it("移除员工", function() {

	// 	return Payroll.deployed().then(function(instance) {
	// 		instance.removeEmployee(employeeAddr);
	// 		return instance.getEmployee(employeeAddr);
	// 	}).then(function(res) {
	// 		assert.equal(1, 1, "移除有错误");
	// 	});
	// });

	
});