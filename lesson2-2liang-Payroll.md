#### 1、每加入一个员工，调用`calculateRunway`函数，Gas会变化吗？

> 会变化，因为每加入一个员工，数组的长度边长，每次for循环次数增多，也就是计算次数增多，所以Gas花费更多，优化方式就是，减少循环次数。
>
> 解决方案：
>
> 维护一个全局变量，totalSolary，每次添加删除以及更新对该变量进行更新。

### 2、Gas变化记录

> 备注：仅记录五次。

**原始代码Gas花费记录**

| 成员数量 | execution cost |
| ---- | -------------- |
| 1    | 1694           |
| 2    | 2475           |
| 3    | 3256           |
| 4    | 4037           |
| 5    | 4818           |

**优化后Gas花费记录**

| 成员数量 | execution cost |
| ---- | -------------- |
| 1    | 852            |
| 2    | 852            |
| 3    | 852            |
| 4    | 852            |
| 5    | 852            |

### 3、优化后的代码

```javascript
pragma solidity ^0.4.14;

/**
 * The Payroll contract does this and that...
 */
contract Payroll {

	address owner;

	uint totalSalary;

	struct Employee {
		address addr;
		uint salary;
		uint lastPayDay;
	}

	Employee[] employees;

	uint constant payDuration = 10 seconds;

	/**
	 * 构造函数
	 * 初始化合约所有者
	 */
	function Payroll() public {
		owner = msg.sender;
	}

	/**
	 * 是否是合约所有者
	 */
	modifier onlyOwner() { 
		require(msg.sender == owner);
		_; 
	}

	/**
	 * 添加余额
	 */
	function addFund() payable public returns(uint) {
		return this.balance;
	}

	/**
	 * 支付剩余薪水
	 */
	function _partialPaid(Employee _employee) private {
		
		uint payment = _employee.salary * (now - _employee.lastPayDay) / payDuration;
		_employee.addr.transfer(payment);
	}	

	/**
	 * 寻找指定雇员
	 */
	function _findEmployee(address _employeeAddr) private returns (Employee, uint) {

		for (uint i = 0; i < employees.length; i++) {

			if (employees[i].addr == _employeeAddr) {
				return (employees[i], i);
			}
		}
		return (Employee(0, 0, 0), 0);
	}

	/**
	 * 添加雇员
	 */
	function addEmployee(address _employeeAddr, uint _salary) public onlyOwner {

		// 寻找指定雇员
		var (employee, index) = _findEmployee(_employeeAddr);

		// 当返回空 则表示不存在
		assert(employee.addr == 0x0);	

		// 添加雇员
		uint salary = _salary * 1 ether;
		totalSalary += salary;
		employees.push(Employee(_employeeAddr, salary, now));
	} 

	/**
	 * 移除雇员
	 */
	function removeEmployee(address _employeeAddr) public onlyOwner {

		// 寻找指定雇员
		var (employee, index) = _findEmployee(_employeeAddr);

		// 判断是否存在
		assert(employee.addr != 0x0);

		// 支付剩余薪水
		_partialPaid(employee);

		totalSalary -= employees[index].salary;
		
		// 移除雇员
		delete employees[index];

		// 将最后一个雇员移入该变量
		// 当该雇员是最后一个变量 无需处理
		if (index != employees.length - 1) {	
			employees[index] = employees[employees.length - 1];
		}
		employees.length -= 1;
		return;
	}

	/**
	 * 更新员工薪水
	 */
	function updateEmployee(address _employeeAddr, uint _salary) public onlyOwner {

		var (employee, index) = _findEmployee(_employeeAddr);

		assert(employee.addr != 0x0);

		// 支付剩余薪水
		_partialPaid(employee);
		totalSalary -= employee.salary;

		// 更新员工数据
		employee.salary 	= _salary * 1 ether;
		employee.lastPayDay = now;
		totalSalary += employee.salary;
		return;
	}

	/**
	 * 计算能够发送多久的薪水
	 */
	function calculateRunway() public view returns (uint) {

		return this.balance / totalSalary;
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
	function getPaid() public {

		var (employee, index) = _findEmployee(msg.sender);
		assert(employee.addr != 0x0);

		uint nextPayDay = employee.lastPayDay + payDuration;

		if (nextPayDay > now) {
			revert();
		}

		employee.lastPayDay = nextPayDay; 
		employee.addr.transfer(employee.salary);
	}
}
```
