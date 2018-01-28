/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    mapping (address => Employee) private employees;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    modifier onlySelf(address employeeId) {
        require(employeeId == msg.sender);
        _;
    }

    function Payroll() public{
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
      uint amount = (now - employee.lastPayday) / payDuration * employee.salary;
      employee.id.transfer(amount);
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id == 0x0);
      employees[employeeId] = Employee(employeeId, salary, now);
      totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) public onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id != 0x0);
      _partialPaid(employees[employeeId]);
      delete employees[employeeId];
      totalSalary -= employees[employeeId].salary * 1 ether;
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner {
      var employee = employees[employeeId];
      assert(employee.id != 0x0);
      _partialPaid(employee);
      totalSalary -= employees[employeeId].salary;
      employees[employeeId].salary = salary * 1 ether;
      employees[employeeId].lastPayday = now;
      totalSalary += salary * 1 ether;
    }
    
    function addFund() payable public returns (uint) {
      return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        assert(totalSalary > 0);
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
      return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) public view returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = lastPayday;
    }
    
    function getPaid() public {
      var employee = employees[msg.sender];
      assert(employee.id != 0x0);
      uint nextPayday = employees[msg.sender].lastPayday + payDuration;
      assert(nextPayday < now);
      employees[msg.sender].lastPayday = nextPayday;
      employee.id.transfer(employees[msg.sender].salary);
    }
    
    function changePaymentAddress(address EmployeeId, address newAddress) public onlySelf(EmployeeId){
      var employee = employees[msg.sender];
      assert(employee.id != 0x0);
      employees[msg.sender].id = newAddress;
    }
}
