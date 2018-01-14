pragma solidity ^0.4.14;

/** @title Payroll contract. */
contract Payroll {
    struct Employee {
        address wallet;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    address owner;
    uint constant payDuration = 10 seconds;
    
    /** @dev Constructor.
      */
    function Payroll() {
        owner = msg.sender;
    }
    
    /** @dev Pay employee their rest payment before any change.
      * @param employee Employee that need to be paid.
      */
    function _payRestSalary(Employee employee) private {
        uint restPayment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.wallet.transfer(restPayment);
    }
    
    /** @dev Find target employee in employee array.
      * @param targetWallet Wallet address of the target employee.
      */
    function _findEmployee(address targetWallet) private returns (Employee, uint) {
        for (uint i=0; i<employees.length; i++) {
            if (employees[i].wallet == targetWallet) {
                return (employees[i], i);
            }
        }
    }
    
    /** @dev Add new employee to contract.
      * @param salary Salary of the new employee.
      * @param wallet Wallet address of the new employee.
      */
    function addEmployee(uint salary, address wallet) {
        require(msg.sender == owner);
        
        var (employee,index) = _findEmployee(wallet);
        assert(employee.wallet == 0x0);

        employees.push(Employee(wallet, salary * 1 ether, now));
    }
    
    /** @dev Remove new employee in the contract.
      * @param salary Salary of the new employee needs to be updated.
      * @param wallet Wallet address of the employee needs to be updated.
      */
    function updateEmployee(uint salary, address wallet) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(wallet);
        assert(employee.wallet != 0x0);
        
        _payRestSalary(employees[index]);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }
    
    /** @dev Update employee in the contract.
      * @param wallet Wallet address of the employee needs to be removed.
      */
    function removeEmployee(address wallet) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(wallet);
        assert(employee.wallet != 0x0);
        
        _payRestSalary(employees[index]);
        employees[index] = employees[employees.length-1];
        employees.length-1;
    }

    /** @dev add fund to employer.
      * @return employer balance after adding fund.
      */
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    /** @dev calculate how many times the employer can pay the employees
      * @return the times that employees can get paid from employer's balance
      */
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
        for (uint i=0; i<employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    /** @dev check if employer has enough money to pay
      * @return true means employers has enough money, false means not
      */
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    /** @dev pay salary to employee
      */
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.wallet == 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        } 
        
        employees[index].lastPayday = nextPayDay;
        employees[index].wallet.transfer(employee.salary);
    }
}

//gas history
0xca35b7d915458ef540ade6068dfe2f44e8fa733c
transaction cost  23009 gas 
execution cost   1737 gas 

0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
transaction cost  23779 gas 
execution cost   2507 gas

0x583031d1113ad414f02576bd6afabfb302140225
transaction cost  24549 gas 
execution cost   3277 gas

0xdd870fa1b7c4700f2bd7f44238821c26f7392148
transaction cost  25319 gas 
execution cost   4047 gas

//transaction cost 和 execution cost都在逐渐提升

//原因：我认为是因为Employee数组中的员工数量递增，使得for循环次数增加，导致计算成本加大，从而gas cost升高。

//优化：不必每次调用calculateRunway都调用for循环来计算totalSalary，可以在每次添加新员工是进行计算，还要在更新员工信息的时候进行更新。
//优化代码
pragma solidity ^0.4.14;

/** @title Payroll contract. */
contract Payroll {
    struct Employee {
        address wallet;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    address owner;
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    
    /** @dev Constructor.
      */
    function Payroll() {
        owner = msg.sender;
    }
    
    /** @dev Pay employee their rest payment before any change.
      * @param employee Employee that need to be paid.
      */
    function _payRestSalary(Employee employee) private {
        uint restPayment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.wallet.transfer(restPayment);
    }
    
    /** @dev Find target employee in employee array.
      * @param targetWallet Wallet address of the target employee.
      */
    function _findEmployee(address targetWallet) private returns (Employee, uint) {
        for (uint i=0; i<employees.length; i++) {
            if (employees[i].wallet == targetWallet) {
                return (employees[i], i);
            }
        }
    }
    
    /** @dev Add new employee to contract.
      * @param salary Salary of the new employee.
      * @param wallet Wallet address of the new employee.
      */
    function addEmployee(uint salary, address wallet) {
        require(msg.sender == owner);
        
        var (employee,index) = _findEmployee(wallet);
        assert(employee.wallet == 0x0);

        employees.push(Employee(wallet, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
    /** @dev Remove new employee in the contract.
      * @param salary Salary of the new employee needs to be updated.
      * @param wallet Wallet address of the employee needs to be updated.
      */
    function updateEmployee(uint salary, address wallet) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(wallet);
        assert(employee.wallet != 0x0);
        
        _payRestSalary(employees[index]);
        totalSalary = totalSalary - employees[index].salary;
        employees[index].salary = salary * 1 ether;
        totalSalary = totalSalary + salary;
        
        employees[index].lastPayday = now;
    }
    
    /** @dev Update employee in the contract.
      * @param wallet Wallet address of the employee needs to be removed.
      */
    function removeEmployee(address wallet) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(wallet);
        assert(employee.wallet != 0x0);
        
        _payRestSalary(employees[index]);
        employees[index] = employees[employees.length-1];
        employees.length-1;
    }

    /** @dev add fund to employer.
      * @return employer balance after adding fund.
      */
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    /** @dev calculate how many times the employer can pay the employees
      * @return the times that employees can get paid from employer's balance
      */
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    /** @dev check if employer has enough money to pay
      * @return true means employers has enough money, false means not
      */
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    /** @dev pay salary to employee
      */
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.wallet == 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        } 
        
        employees[index].lastPayday = nextPayDay;
        employees[index].wallet.transfer(employee.salary);
    }
}

//new gas history
0xca35b7d915458ef540ade6068dfe2f44e8fa733c
transaction cost  125490 gas 
execution cost   102618 gas

0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
transaction cost  22202 gas 
execution cost   930 gas

0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db
transaction cost  22202 gas 
execution cost   930 gas

0x583031d1113ad414f02576bd6afabfb302140225
transaction cost   22202 gas 
execution cost   930 gas

//gas 不变了，因为calculateRunway现在只是做一个除法
