import React, { Component } from 'react'

class Employee extends Component{

    constructor(props){
        super(props);
        this.state={};
    }

    componentDidMount(){
        this.checkEmployee();
    }

    checkEmployee=()=>{
        const {payroll, account, web3} =this.props;
        payroll.employees.call(account,{
            from:account,
            gas:1000000
        }).then((result)=>{
            console.log(result);
            this.setState({
                salary:result.length>=2?web3.fromWei(result[1].toNumber()):0,
                lastPaidDate:result.length>=3?new Date(result[2].toNumber()*1000):0
            });
        });
    }

    getPaid=()=>{
        const {payroll, account, web3} =this.props;

        console.log(account);

        // web3.eth.call和web3.eth.sendtransaction的区别
        // 合约function加上constant,
        //如果js不指定call还是send,默认用的是call的方式
        //不加constant默认是sendtransaction的方式
        payroll.getPaid({
            from:account,
            gas:1000000
        }).then((result)=>{
            alert("You have been paid.");

        }).catch(e=>{
            console.log("employeeId:",account);
            console.log("getPaid error:",e);
        });

    }

    



    render(){
        const {salary, lastPaidDate } = this.state;
        const {payroll, account, web3} = this.props;
        return (
            <div>
                <h2>员工: {account}</h2>
                {
                    !salary || salary==='0' ?
                    <p>您不是员工</p> :
                    (<div>
                        <p>薪水:{salary}</p>
                        <p>上次支付日: {lastPaidDate.toString()}</p>
                        <button type="button" className="pure-button" onClick={this.getPaid}>获取薪水</button>
                    </div>)
                }
            </div>
        );

    }


}

export default Employee;