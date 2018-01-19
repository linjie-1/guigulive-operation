
import "./SafeMath.sol";

contract Parent{
    
    using SafeMath for uint8;
    
    uint8  public a=101;
    modifier someModifier(){
        _;
        a=1;
    }
    
    function parentFun2(uint8 value) someModifier public returns (uint){
        a=value;
        return a;// modifier 插入的代码在return之前，a 被改为value，然后又被modifier改为 1，最后返回
    }
    
    function parentFunc3(uint8 value) public returns(uint){
        a=value;
        return a;
        a=1;        //这里a 不会执行到
    }
    
    function set(){
        a-=100;         //溢出
    }
    
    function safeSet(){
        uint8 c=a-100;
        assert(c<a);
        
        a=c;         //溢出
    }
    
    function safeSet2(){
       a=SafeMath.sub(a,100);
       
       a=a.sub(100);
    }
    
}