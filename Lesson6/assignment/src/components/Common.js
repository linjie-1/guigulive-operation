import React, { Component } from 'react'

import { Card, Col, Row } from 'antd';

class Common extends Component{

    constructor(props){
        super(props);
        this.state={};



    }



    checkInfo=()=>{
        const {payroll, web3, account}=this.props;
        payroll.getInfo.call({from: account}).then(result=>{
            this.setState({
                balance:web3.fromWei(result[0].toNumber()),
                runway:result[1].toNumber(),
                employeeCount:result[2].toNumber()
            });

        });
    }







    componentDidMount(){







        const {payroll, web3, account}=this.props;


        const updateInfo=(error,result)=>{
            if(!error){
                this.checkInfo();
            }
        }

        this.newFund=payroll.NewFundEvent(updateInfo);
        this.newEmployee=payroll.NewEmployeeEvent(updateInfo);
        this.updateEmployee=payroll.UpdateEmployeeEvent(updateInfo);
        this.removeEmployee=payroll.RemoveEmployeeEvent(updateInfo);
        this.getPaid=payroll.GetPaidEvent(updateInfo);




        this.checkInfo();
    }


    componentWillUnmount(){
        this.newFund.stopWatching();
        this.newEmployee.stopWatching();
        this.updateEmployee.stopWatching();
        this.removeEmployee.stopWatching();
        this.getPaid.stopWatching();

    }





    render(){
        const {runway, balance, employeeCount}=this.state;
        return (
            <div>
                <h2>通用信息</h2>
                <Row gutter={16}>
                <Col span={8}>
                    <Card title="合约金额">{balance} Ether</Card>
                </Col>
                <Col span={8}>
                    <Card title="员工人数">{employeeCount}</Card>
                </Col>
                <Col span={8}>
                    <Card title="可支付次数">{runway}</Card>
                </Col>
                </Row>
            </div>
        );
    }
}

export default Common;