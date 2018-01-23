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
        const {payroll, employee, web3} =this.props;
        payroll.employeeList.call(employee,{
            from:employee,
            gas:1000000
        }).then((result)=>{
            console.log(result);
            this.setState({
                salary:web3.fromWei(result[1].toNumber()),
                lastPaidDate:new Date(result[2].toNumber()*1000)
            });
        });
    }

    getPaid=()=>{
        const {payroll, employee, web3} =this.props;
        payroll.getPaid({
            from:employee,
            gas:1000000
        }).then((result)=>{
            alert("You have been paid.");

        });

    }

    



    render(){
        const {salary, lastPaidDate } = this.state;
        const {payroll, employee, web3} = this.props;
        return (
            <div>
                <h2>员工: {employee}</h2>
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