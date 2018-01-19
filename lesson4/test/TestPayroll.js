var Payroll = artifacts.require("Payroll");

var employeeAddr = "0xa84906c75049f979a39490ebc78a2c6d6a99d066";

var salary = 1;

// var fund = web3.toWei(2, "ether");

var fund = 200;

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
		var address;
		return Payroll.deployed().then((instance) => {
			address = instance.address;
			return instance.addFund({value: fund});
		}).then((res) => {
			var balance = web3.eth.getBalance(address).valueOf();
			assert.equal(balance, fund, "添加余额错误");
		});
	});

	// 移除员工
	it("移除员工", function() {
		return Payroll.deployed().then(function(instance) {
			instance.removeEmployee(employeeAddr);
			return instance.getEmployee(employeeAddr);	
		}).then(function(res) {
			assert.equal(res.valueOf(), 0, "移除有错误");
		});
	});	
});