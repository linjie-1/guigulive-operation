/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    //address public owner;
    uint constant payDuration=10 seconds;
    uint public totalSalary;
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    mapping(address=>Employee) public employees;//_findEmployee()
    /*******************************************************
    function Payroll() {
         owner = msg.sender;
    modifier onlyOwner() {
        require(msg.sender == owner);
    _;
    }
    *******************************************************/
    modifier employeeExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id!=0x0);
        _;
    }
    modifier employeeNotExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id==0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment=employee.salary
            .mul(now-employee.lastPayDay)
            .div(payDuration);
        employee.id.transfer(payment);
    }
   
    function addEmployee(address employeeId,uint salary) payable onlyOwner employeeNotExist(employeeId) {
        //var employee=employees[employeeId];
        //assert(employee.id==0x0);
        //totalSalary+=salary*1 ether;
        salary=salary.mul(1 ether);
        
        totalSalary=totalSalary.add(salary);
        employees[employeeId]=Employee(employeeId,salary*1 ether,now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){

        _partialPaid(employees[employeeId]);
         totalSalary-=employees[employeeId].salary;
         //totalSalary= totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function addFund() payable returns (uint Balance) {
       Balance=this.balance;
    }
    function updateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId) {

        _partialPaid(employees[employeeId]);
          totalSalary-=employees[employeeId].salary;
        //totalSalary= totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary=salary*1 ether;
        //employees[employeeId].salary=salary.mul(1 ether);
        totalSalary+=employees[employeeId].salary;
         //totalSalary= totalSalary.add(employees[employeeId].salary);
        employees[employeeId].lastPayDay=now;
    
    }
    
     function changePaymentAddress(address oldPaymentAddress,address newPaymentAddress) onlyOwner employeeExist(oldPaymentAddress) employeeNotExist(newPaymentAddress){
        _partialPaid(employees[oldPaymentAddress]);
        addEmployee(newPaymentAddress,employees[oldPaymentAddress].salary);
        removeEmployee(oldPaymentAddress);
    }
  
  
    function calculateRunway() returns (uint Runway) {
       /*************************
        uint totalSalary=0;
        for(uint i=0;i<employees.length;i++){
           totalSalary += employees[i].salary; 
        } //mapping can't traverse the hashtable
        ************************/
        Runway=this.balance/totalSalary;
    }
    function hasEnoughFund() returns (bool enough) {
        //return this.balance >=salary;
       enough=calculateRunway() >= 0;
    }
    function getPaid() employeeExist(msg.sender){
        var employee=employees[msg.sender];
        //assert(employee.id!=0x0);
        uint nextPayday=employee.lastPayDay+payDuration;
        assert(now>nextPayday);
        
        employee.lastPayDay=nextPayday;
        employee.id.transfer(employee.salary);
       
    }
    
    function checkEmployee(address checkEmployeeId) returns (uint salary,uint lastPayDay){
        var employee=employees[checkEmployeeId];
       // return(employee.salary,employee.lastPayDay);
       salary=employee.salary;
       lastPayDay=employee.lastPayDay;
    }
}
