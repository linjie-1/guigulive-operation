
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
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function _partialPaid(employee emp){
        uint payment=emp.salary*(now-emp.lastpayday) / payduration;
        emp.id.transfer(payment);
        
    }
    function check(address a) returns(bool){
        for(uint i=0;i<es.length;i++){
            if (es[i].id == a) return false;
        }
        return true;
    }
    
    function calcruanaway() returns(uint){
        salarysum+=es[es.length-1].salary *1 ether;
        return this.balance / salarysum;
        
    }
    
    function addemployee(address a){
        require(check(a));
        es.push(employee(a,1,now));
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
        
        
        return salarysum;
        
        /*
    for(address i=0;i<10;i++){
        address id=0x583031d1113ad414f02576bd6afabfb302140225;
        id=id|i;
        addemployee(id);
    
    } 
    */
    }
}
