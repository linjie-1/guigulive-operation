/*作业请提交在这个目录下*/
/*## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2
*/

pragma solidity ^0.4.14;

import './Ownable.sol';
contract Payroll is Ownable{
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    mapping(address => Employee) public employees;
    
    uint totalSalary = 0;
    
    modifier hasEmployee(address employeeId) {
    	assert(employees[employeeId].id != 0x0);
    	_;
    }
    
    function _partialPaid(Employee employee) private {
    	uint salaryToPay = employee.salary * (now - employee.lastPayday) / payDuration;
    	employee.id.transfer(salaryToPay * 1 ether);
    	employee.lastPayday = now;
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
    	assert(employees[employeeId].id == 0x0);
    	employees[employeeId] = Employee(employeeId, salary, now);
    	totalSalary += salary;
    }
    
    function removeEmployee(address employeeId) public onlyOwner hasEmployee(employeeId) {
    	Employee storage employee = employees[employeeId];
		_partialPaid(employee);
		totalSalary -= employee.salary;
		delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner hasEmployee(employeeId) {
    	Employee storage employee = employees[employeeId];
    	_partialPaid(employee);
    	totalSalary += salary;
    	totalSalary -= employee.salary;
    	employee.salary = salary;
    }
    
    function addFund() payable public returns (uint) {
    	return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public returns (bool) {
    	return calculateRunway() > 0;
    }
    
    function getPaid() public hasEmployee(msg.sender) {
		_partialPaid(employees[msg.sender]);
    }
    
    function changePaymentAddress(address oldAddr, address newAddr) onlyOwner hasEmployee(oldAddr) {
        uint salary = employees[oldAddr].salary;
        removeEmployee(oldAddr);
        addEmployee(newAddr, salary);
    }
}