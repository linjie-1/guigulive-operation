import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
	function testAddEmployee(){
		Payroll payroll = Payroll(DeployedAddress.Payroll());
		address employeeAdd = account[1];
		payroll.addEmployee(employeeAdd,1);
		Assert.equal(true,"pass");
	}

	function testRemoveEmployee(){
		Payroll payroll = Payroll(DeployedAddress.Payroll());
		address employeeAdd = account[1];
		payroll.addEmployee(employeeAdd,1);
		payroll.removeEmployee(employeeAdd);
		Assert.equal(true,"pass");
	}

	function testAddEmployeeNonOwner(){
		Payroll payroll = Payroll(DeployedAddress.Payroll());
		address employeeAdd = account[1];
		payroll.addEmployee(employeeAdd,1,{from:accounts[2]});
		Assert.equal(error.toString().includes('invalid opcode'), "expect exception here");
	}

	function testRemoveEmployeeNonOwner(){
		Payroll payroll = Payroll(DeployedAddress.Payroll());
		address employeeAdd = account[1];
		payroll.addEmployee(employeeAdd,1);
		payroll.removeEmployee(employeeAdd,{from:accounts[2]});
		Assert.equal(error.toString().includes('invalid opcode'), "expect exception here");
	}
}
