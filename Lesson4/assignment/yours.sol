pragma solidity ^0.4.14;

//assignment 4: add isEmployeeExist()

/** @title Payroll contract. */
contract Payroll {
    struct Employee {
        address wallet;
        uint salary;
        uint lastPayday;
    }
    
    mapping(address => Employee) public employees;
    address owner;
    uint totalSalary = 0;
    uint constant payDuration = 10 seconds;
    
    /** @dev Constructor.
      */
    function Payroll() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address wallet){
        var employee = employees[wallet];
        assert(employee.wallet != 0x0);
        _;
    }
    
    modifier employeeNotExist(address wallet){
        assert(employees[wallet].wallet == 0x0);
        _;
    }

    function isEmployeeExist(address wallet) onlyOwner returns (bool isExist) {
        isExist = (employees[wallet].wallet != 0x0);
    }
    
    /** @dev Pay employee their rest payment before any change.
      * @param employee Employee that need to be paid.
      */
    function _payRestSalary(Employee employee) private {
        uint restPayment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.wallet.transfer(restPayment);
    }
    
    /** @dev Add new employee to contract.
      * @param salary Salary of the new employee.
      * @param wallet Wallet address of the new employee.
      */
    function addEmployee(uint salary, address wallet) onlyOwner employeeNotExist(wallet){
        var employee = employees[wallet];

        employees[wallet] = Employee(wallet, salary * 1 ether, now);
        totalSalary += employees[wallet].salary;
    }
    
    /** @dev Update employee in the contract.
      * @param salary Salary of the new employee needs to be updated.
      * @param wallet Wallet address of the employee needs to be updated.
      */
    function updateEmployee(uint salary, address wallet) onlyOwner employeeExist(wallet) {
        var employee = employees[wallet];
        
        _payRestSalary(employee);
        totalSalary = totalSalary - employees[wallet].salary;
        employees[wallet].salary = salary * 1 ether;
        employees[wallet].lastPayday = now;
        totalSalary = totalSalary + employees[wallet].salary;
    }
    
    function checkEmployee(address wallet) returns (uint salary, uint lastPayday) {
        var employee = employees[wallet];
        
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function changePaymentAddress(address oldWallet, address newWallet) onlyOwner employeeExist(oldWallet) employeeNotExist(newWallet){
        var employee = employees[oldWallet];
        _payRestSalary(employee);
        var oldSalary = employee.salary;
        removeEmployee(oldWallet);
        addEmployee(oldSalary / 1 ether, newWallet);
    }
    
    /** @dev Remove employee in the contract.
      * @param wallet Wallet address of the employee needs to be removed.
      */
    function removeEmployee(address wallet) onlyOwner employeeExist(wallet){
        var employee = employees[wallet];
        
        _payRestSalary(employee);
        totalSalary -= employees[wallet].salary;
        delete employees[wallet];
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
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employees[msg.sender].lastPayday = nextPayDay;
        employee.wallet.transfer(employee.salary);
    }
}