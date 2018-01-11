pragma solidity ^0.4.14;

/**
 * The Payroll contract does this and that...
 */
contract Payroll {

	uint salary = 1 ether;

	address owner;

	address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;

	uint constant payDuration = 10 seconds;

	uint lastPayDay = now;

	/**
	 * 构造函数
	 * 初始化合约所有者
	 */
	function Payroll() public {
		owner = msg.sender;
	}
		
	/**
	 * 是否是指定员工在调用
	 */
	modifier onlyEmployee() { 
		require(msg.sender == employee); 
		_; 
	}

	/**
	 * 是否是合约所有者
	 */
	modifier onlyOwner() { 
		require(msg.sender == owner);
		_; 
	}
	
	/**
	 * 提前添加薪水
	 */
	function addFund() payable public returns (uint) {

		return this.balance;
	}

	/**
	 * 修改地址和佣金
	 */
	function updateEmployeeSalary(address _addr, uint _salary) public onlyOwner returns (bool) {
		
		if (employee != 0x0) {
			uint payment = salary * (now - lastPayDay) / payDuration;	// 计算需要结算的钱
			employee.transfer(payment);
		}

		employee = _addr;
		salary   = _salary * 1 ether;
		lastPayDay = now;

	}

	/**
	 * 计算能够发送多久的薪水
	 */
	function calculateRunway() public view returns (uint) {
		return this.balance / salary;
	}	

	/**
	 * 是否有足够的余额发送薪水
	 */
	function hasEnoughFund() public view returns (bool) {
		return calculateRunway() > 0;
	}	

	/**
	 * 领取薪水
	 */
	function getPaid() public onlyEmployee {

		uint nextPayDay = lastPayDay + payDuration;

		if (nextPayDay > now) {
			revert();
		}

		lastPayDay = nextPayDay; 
		employee.transfer(salary);
	}
}