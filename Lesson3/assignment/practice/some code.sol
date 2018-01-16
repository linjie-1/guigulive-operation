pragma solidity ^0.4.14;


interface AInterface{
    
    function a_simple_func() returns (uint);
    
}

//抽象合约，无法部署在网络里
contract Object is AInterface{
    
    function someFunc() returns (uint);
    
    function a_simple_func() returns (uint){
        return 1;
    }
    

}


contract Owned is Object {
    
    address owne;
    
    function owned(){
        owne=msg.sender;
    }
    
    
    function someFunc() returns (uint){
        return 2;
    }
    
    
}

contract Parent is Owned{
    uint y;
    function Parent(uint _y){ //这里会默认先调用父类的无参构造函数
        y=_y; 
    }
    
    function selfDestruct(address id){
        
    }
    
    function parentFunc1() internal{
        if(msg.sender==owne) selfDestruct(owne);
    }
    
    function parentFunc2() public {
        
    }
    
    function parentFunc3() private {
        
    }
    
    function parentFunc4() external {
        
    }
    
    
}

contract Child is Parent{
    
    uint y;
    
    function Child(uint _c) Parent(_c*_c){ //显式的调用父类的构造函数
        y=_c;
    }
    
    function child(){
        parentFunc1();
        parentFunc2();
        this.parentFunc4(); //external 只能通过这个方式，加this
        //parentFunc3();  //错误， 这里无法调用 private 的
    }

}



contract Child2 is Parent(66){ //静态的构造一个，66写死了
    
}





contract Foundation{
    function fun1() returns (uint){
        return 1;
    }
}

contract Base1 is Foundation{
    function fun1() returns (uint){
       super.fun1();
    }
}


contract Base2 is Foundation{
    function fun1() returns (uint){
       super.fun1();
    }
}

contract Final is Base1, Base2{
    
}

contract Test{
    function test(){
        Final f=new Final();
        f.fun1();
        //函数调用次序：Base2.fun1, Base1.fun1, Foundation.fun1
    }
}




contract Parent{
    uint  public a=2;
    modifier someModifier(){
        _;
        a=1;
    }
    
    function parentFun2(uint value) someModifier public returns (uint){
        a=value;
        return a;// modifier 插入的代码在return之前，a 被改为value，然后又被modifier改为 1，最后返回
    }
    
    function parentFunc3(uint value) public returns(uint){
        a=value;
        return a;
        a=1;        //这里a 不会执行到
    }
    
}

