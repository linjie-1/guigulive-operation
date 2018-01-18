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
    mapping(address=>Employee) public xEmployees;//_findEmployee()
   /**********************************
    function Payroll() {
         owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
    _;
    }
    *********************************/
    modifier employeeExist(address employeeId){
      
        assert(xEmployees[employeeId].id!=0x0);
        _;
    }
    modifier employeeNotExist(address employeeId){
        assert(xEmployees[employeeId].id==0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        //uint payment=employee.salary*(now-employee.lastPayDay)/(payDuration);
        uint payment=(employee.salary.mul(now.sub(employee.lastPayDay))).div(payDuration);
        employee.id.transfer(payment);
    }
   
    function addEmployee(address employeeId,uint salary) payable onlyOwner employeeNotExist(employeeId) {
        //assert(xEmployees[employeeId].id==0x0);
        //totalSalary+=salary*1 ether;
        
        salary=salary.mul(1 ether);
        totalSalary=totalSalary.add(salary);
        xEmployees[employeeId]=Employee(employeeId,salary,now);//
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){

        _partialPaid(xEmployees[employeeId]);
         //totalSalary-=xEmployees[employeeId].salary;
         totalSalary= totalSalary.sub(xEmployees[employeeId].salary);
        delete xEmployees[employeeId];
    }
    
    function addFund() payable returns (uint Balance) {
       Balance=this.balance;
    }
    function updateEmployee(address employeeId,uint newSalary) onlyOwner employeeExist(employeeId) {

        _partialPaid(xEmployees[employeeId]);
          //totalSalary-=xEmployees[employeeId].salary;
        //xEmployees[employeeId].salary=newSalary*1 ether;
        //totalSalary+=xEmployees[employeeId].salary;
        totalSalary= (totalSalary.sub(xEmployees[employeeId].salary)).add(newSalary.mul(1 ether));
        xEmployees[employeeId].salary=newSalary.mul(1 ether);
        xEmployees[employeeId].lastPayDay=now;
    
    }
    function changePaymentAddress(address oldPaymentAddress,address newPaymentAddress) onlyOwner employeeExist(oldPaymentAddress) employeeNotExist(newPaymentAddress){
        _partialPaid(xEmployees[oldPaymentAddress]);
        addEmployee(newPaymentAddress,xEmployees[oldPaymentAddress].salary);
        removeEmployee(oldPaymentAddress);
    }
  
    function calculateRunway() returns (uint Runway) {
       /*************************
        uint totalSalary=0;
        for(uint i=0;i<employees.length;i++){
           totalSalary += employees[i].salary; 
        } //mapping can't traverse the hashtable
        ************************/
        Runway=this.balance.div(totalSalary);
    }
    function hasEnoughFund() returns (bool enough) {
        //return this.balance >=salary;
       enough=calculateRunway() > 0;
    }
    function getPaid() employeeExist(msg.sender){
        var getPaidEmployee=xEmployees[msg.sender];
        //assert(getPaidEmployee.id!=0x0);
        uint nextPayday=getPaidEmployee.lastPayDay.add(payDuration);
        assert(nextPayday<now);
        
        getPaidEmployee.lastPayDay=nextPayday;
        getPaidEmployee.id.transfer(getPaidEmployee.salary);
       
    }
    
}
