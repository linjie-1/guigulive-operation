
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract payroll is Ownable{
    
    using SafeMath for uint;
    
    struct employee{
        address id;
        uint salary;
        uint lastpayday;
    }
    
    uint salarysum=0;
    uint ta;
    uint payduration=10 seconds;
    address owner;
    mapping (address => employee) public es;
    


    modifier notVoid (address id) {
        var e = es[id];
        require (e.id != 0x0);
        _;
      
    }
    
    function addFund() payable returns (uint balance) {
        return this.balance;
    }
    
    function changePaymentAddress(address oldid,address newid) onlyOwner notVoid(oldid) notVoid(newid) {
        employee e = es[oldid];
        e.id = newid;
        delete (es[oldid]);
        es[newid] = e;
        
    }

    function _partialPaid(employee e) private {
         uint payment = e.salary.mul (now - e.lastpayday) .div(payduration);
         e.id.transfer(payment);
    }
    
    function updateemployee(address id,uint salary) onlyOwner notVoid(id) {
        var e = es[id];
        _partialPaid(e);
        salarysum = salarysum.sub(e.salary);
        es[id].salary = salary.mul( 1 ether);
        es[id].lastpayday = now;
        salarysum = salarysum.add(salary.mul( 1 ether));
    }
    

    
    function removeemployee(address id) onlyOwner notVoid(id) {     
        var e = es[id];
        _partialPaid(e);
        salarysum = salarysum.sub(e.salary);
        delete(es[id]);
         }
    
  /*  function t(uint a){
        ta = a;
    }
*/
    
    function calcruanaway() returns(uint){
      
        return this.balance / salarysum;
        
    }
    
    function showsum() returns (uint){
        return salarysum;
    }
    function addemployee(address a,uint s) onlyOwner returns (bool){
        if (es[a].id != 0x0) return false;
        uint salary = s*1  ether;
        es[a] = employee(a,salary ,now);
        salarysum = salarysum.add(es[a].salary);
        return true;
        
    }
    
    function getPaid() notVoid(msg.sender) {
        var e = es[msg.sender];
        uint nextpayday = e.lastpayday.add(payduration);
        assert ( nextpayday < now);
        es[msg.sender].lastpayday = nextpayday;
        e.id.transfer(e.salary);
        
        
    }
/* 
    function adde() returns (uint){
        addemployee(0x583031d1113ad414f02576bd6afabfb302140221);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140222);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140223);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140224);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140225);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140226);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140227);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140228);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140220);
        addemployee(0x583031d1113ad415f02576bd6afabfb302140229);
        
        
        return salarysum;
        
    }
    */
}
