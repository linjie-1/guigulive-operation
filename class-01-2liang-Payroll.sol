pragma solidity ^0.4.14;

/**
 * The Payroll contract does this and that...
 */
contract Payroll {

	uint salary = 1 ether;

	address owner;

	address liang = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;

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
	modifier onlyLiang() { 
		require(msg.sender == liang); 
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
	 * 修改领取工资地址
	 */
	function editEmployeeAddr(address _addr) public onlyOwner returns (bool) {
		liang = _addr;
		return true;
	}

	/**
	 * 修改工资
	 */
	function editSalary(uint _salary) public onlyOwner returns (bool) {
		salary = _salary * 1 ether;
		return true;
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
	function getPaid() public onlyLiang {

		uint nextPayDay = lastPayDay + payDuration;

		if (nextPayDay > now) {
			revert();
		}

		lastPayDay = nextPayDay; 
		liang.transfer(salary);
	}
}