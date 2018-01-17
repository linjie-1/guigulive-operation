
pragma solidity ^0.4.14;

contract tenemployees{
    struct employee{
        address id;
        uint salary;
        uint lastpayday;
    }
    
    employee[] es;
    uint salarysum=0;
    uint payduration=10 seconds;
    address owner;
    
    function Payroll() {
         owner = msg.sender;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function _partialPaid(employee e) private {
         uint payment = e.salary * (now - e.lastpayday) / payduration;
         e.id.transfer(payment);
    }
    
    function updateemployee(address id,uint salary){
        require (msg.sender == owner);
        var (e, index) = findid(id);
        require (e.id != 0x0);
        _partialPaid(e);
        salarysum -= e.salary;
        es[index].salary = salary;
        es[index].lastpayday = now;
        salarysum += salary;
    }
    
    function removeemployee(address id){
        var (e, index) = findid(id);
        require (e.id != 0x0);
        _partialPaid(e);
        salarysum -= e.salary;
        delete(es[index]);
        es[index] = es[es.length - 1];
        es.length -= 1;
    }
    
    function findid(address a) returns(employee, uint){
        for(uint i = 0;i < es.length; i++){
            if (es[i].id == a) return (es[i],i);
        }
    }
    
    function calcruanaway() returns(uint){
        salarysum+=es[es.length-1].salary;
        return this.balance / salarysum;
        
    }
    
    function showsum() returns (uint){
        return salarysum;
    }
    function addemployee(address a){
        //require(check(a));
        uint salary = 1  ether;
        es.push(employee(a,salary ,now));
        calcruanaway();
        
    }
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
               

    }
}
