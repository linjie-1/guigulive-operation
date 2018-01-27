// 合约
var Payroll = artifacts.require("Payroll");
// 获取地址
var accounts = web3.eth.accounts;
var employeeAddr = accounts[0];
// 薪水
var salary = 1;
// 添加余额
var fund = web3.toWei(5, "ether");
// 合约地址
var contractAddr = "";

// 雇员时间相关
var addTime = 0;
var getTime = 0;

// sleep方法
function sleep(d){
	for(var t = Date.now();Date.now() - t <= d;);
}

var payrollContract;
Payroll.deployed().then((instance) => {
	payrollContract = instance;
});

contract('Payroll', function(accounts) {

	// 添加员工
	it("Test AddEmployee()", function() {
		return Payroll.deployed().then((instance) => {
			addTime = Date.parse(new Date());
			instance.addEmployee(employeeAddr, salary);
			return instance.getEmployee(employeeAddr);
		}).then((res) => {
			assert.equal(res.valueOf(), web3.toWei(salary, 'ether'), "addEmployee() test error");
		});

	});

	// 添加余额
	it("Test AddFund()", function() {
		var address;
		return Payroll.deployed().then((instance) => {
			address = instance.address;
			return instance.addFund({value: fund});
		}).then((res) => {		
			var balance = web3.eth.getBalance(address).valueOf();
			assert.equal(balance, fund, "addFund() test error");
		});
	});

	// 提取薪水
	// it("Test GetPaid()", function() {
	// 	var oldBlance = 0;	
	// 	sleep(5);
	// 	getTime = Date.parse(new Date());					
	// 	return Payroll.deployed().then(function(instance) {
	// 		contractAddr = instance.address;
	// 		oldBlance = web3.eth.getBalance(contractAddr);
	// 		return instance.getPaid({from: employeeAddr});
	// 	}).then(function(res) {
	// 		var newBalance = web3.eth.getBalance(contractAddr).valueOf();
	// 		var getSalary = web3.fromWei(oldBlance - newBalance, "ether");
	// 		assert.equal(getSalary, salary, "getPaid() test error");
	// 	});
	// });

	it("getPaid() smoke test", async () => {

		const beforePaid = web3.eth.getBalance(employeeAddr);
		try {
			var payrollContract = await Payroll.deployed();
			const payDuration = await payrollContract.payDuration.call();
			// Increase next block's timestamp with 2 * payDuration.
			web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [ 2 * payDuration ], id: 1});
			web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 2});
			let result = await payrollContract.getPaid({from : employeeAddr});
			var gasPrice = web3.eth.getTransaction(result.tx).gasPrice.toNumber();
			let gas = await payrollContract.getPaid.estimateGas({from : employeeAddr});
			const afterPaid = web3.eth.getBalance(employeeAddr);
			console.log(beforePaid.valueOf(), payDuration.valueOf(), gasPrice.valueOf(), gas.valueOf(), afterPaid.valueOf());
			assert.equal(web3.toWei(salary), afterPaid.minus(beforePaid).plus(gasPrice * gas).toString());
		} catch (err) {
		  	console.log("await promise error: ", err);
		}
	});

	// 移除员工
	it("Test RemoveEmployee()", function() {
		return Payroll.deployed().then(function(instance) {
			instance.removeEmployee(employeeAddr);
			return instance.getEmployee(employeeAddr);	
		}).then(function(res) {
			assert.equal(res.valueOf(), 0, "removeEmployee() test error");
		});
	});	

	
});