var SafeMath = artifacts.require("./libs/SafeMath.sol");
var Ownable = artifacts.require("./libs/Ownable.sol");
var Mypayroll = artifacts.require("./Mypayroll.sol");



contract('Payroll', function(accounts) {


   it("add employee",function(){
       return Mypayroll.deployed().then(function(instance){
           Mypayroll = instance;
           return Mypayroll.addEmployee("1",1);
       }).then(function(){

           return Mypayroll.employees.call("1");
       }).then(function(employee){
           assert.equal(employee[0],"0x0000000000000000000000000000000000000001",' employee address is not correct');
           assert.equal(employee[1].valueOf(),web3.toWei(1,'ether'),'salary is not correct')
       });
   });


   it("remove employee",function(){
       return Mypayroll.deployed().then(function(instance){
           aaa = instance;
           return aaa.removeEmployee("1");
       }).then(function(){

           return aaa.employees.call("1");
       }).then(function(employee){
           assert.equal(employee[0],undefined,' employee is removed');
       });
   });





});