pragma solidity ^ 0.4.14;
import "./SafeMath.sol";
contract Payroll {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    mapping (address => Employee) employees;

    uint totalSalary = 0;
    
    function Payroll() public  {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul((now.sub(employee.lastPayday)).div(payDuration)) ;
        if(payment > 0){
            employee.lastPayday = now;
            employee.id.transfer(payment);
        }
    }
    

    modifier requireOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier validAddress(address addr) {
        require(addr != 0x0);
        _;
    }
    
    function addEmployee(address employeeId, uint salary) public requireOwner
                validAddress(employeeId){
        var e = employees[employeeId];
        if (e.id != 0x0) revert();
        totalSalary = totalSalary.add(salary);
        employees[employeeId] = Employee(employeeId, salary, now);
    }
    
    function removeEmployee(address employeeId) public payable requireOwner validAddress(employeeId){
        var e = employees[employeeId];
        if (e.id == 0x0) revert();
        _partialPaid(e);
        totalSalary-= e.salary;
    }
    
    function updateEmployee(address employeeId, uint salary) public requireOwner payable validAddress(employeeId){
        var e = employees[employeeId];
        if (e.id == 0x0) revert();
        e.salary = salary;
    }


    function addFund() public payable returns(uint) 
    {
        return this.balance;
    }
    
    
    
    function calculateRunway() public view returns(uint) {
       return totalSalary;
    }
    
    function hasEnoughFund() public  view returns(bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid(Employee e) internal requireOwner {
        
        var nextPayday = e.lastPayday.add(payDuration);
        assert(nextPayday < now);
        e.lastPayday = nextPayday;
        e.id.transfer(e.salary);
    }
}