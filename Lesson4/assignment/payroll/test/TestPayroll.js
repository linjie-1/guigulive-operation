var Payroll = artifacts.require("./Payroll.sol");
 
 var employeeAddr = "0x18";
 
 var salary = 77;
 
 contract('Payroll', function(accounts) {
 
 	// addEmployee
 	it("ADD EMPLOYEE...", function() {
 		return Payroll.deployed().then(function(instance){
 			instance.addEmployee(employeeAddr, salary);
 			return instance.getEmployee(employeeAddr);
 		}).then((result) => {
 			assert.equal(result.valueOf(), web3.toWei(salary, 'ether'), "Error IN ADD EMPLOYEE!");
 		});
 
 	});
 
 	// removeEmployee
	it("REMOVE EMPLOYEE...", function() {
		return Payroll.deployed().then(function(instance) {
 			instance.removeEmployee(employeeAddr);
 			return instance.getEmployee(employeeAddr);	
		}).then(function(result) {
			assert.equal(result.valueOf(), 0, "ERROR IN REMOVING EMPLOYEE");
 		});
 	});	
 }); 