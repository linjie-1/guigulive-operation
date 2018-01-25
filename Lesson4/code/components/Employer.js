import React, { Component } from 'react'

class Employer extends Component{

    constructor(props){
        super(props);
        this.state={};
    }


    addFund=()=>{
        const {payroll, employer, web3}=this.props;

        payroll.addFund({
            from:employer,
            value:web3.toWei(this.fundInput.value)
        });


    }


    addEmployee=()=>{

        const {payroll, employer}=this.props;
        payroll.addEmployee(this.employeeInput.value, parseInt(this.salaryInput.value,10),{
            from:employer,
            gas:1000000
        }).then(result=>{
            alert("success");
        });

    }

    updateEmployee=()=>{

        const {payroll, employer}=this.props;
        payroll.updateEmployee(this.employeeInput.value, parseInt(this.salaryInput.value),{
            from:employer,
            gas:1000000
        }).then(result=>{
            alert('success');
        });

    }


    removeEmployee=()=>{

        const {payroll, employer}=this.props;
        payroll.removeEmployee(this.removeEmployeeInput.value,{
            from:employer,
            gas:1000000
        }).then(result=>{
            alert('success');
        });

    }



    render(){


        return (
            <div>
                <h2>雇主</h2>
                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>注资</legend>
                        <label>金额</label>
                        <input 
                            type="text" placeholder="fund" ref={(input)=>{this.fundInput=input;}} />
                        <button type="submit" className="pure-button" onClick={this.addFund}>添加资金</button>
                    </fieldset>
                </form>

                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>添加/更新 员工</legend>
                        <label>员工Id</label>
                        <input type="text" placeholder="employee" ref={(input)=>{this.employeeInput=input;}} />
                        <label>salary</label>
                        <input type="text" placeholder="salary" ref={(input)=>{this.salaryInput=input;}} />

                        <button type="submit" className="pure-button" onClick={this.addEmployee}>添加</button>
                        <button type="submit" className="pure-button" onClick={this.updateEmployee}>更新</button>

                    </fieldset>
                </form>

                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>移除员工</legend>
                        <label>员工Id</label>
                        <input 
                            type="text" placeholder="employee" ref={(input)=>{this.removeEmployeeInput=input;}} />
                        <button type="submit" className="pure-button" onClick={this.removeEmployee}>移除</button>
                    </fieldset>
                </form>
            </div>
        );

    }
}

export default Employer;