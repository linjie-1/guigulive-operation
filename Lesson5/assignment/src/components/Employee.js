import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employer extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    this.checkEmployee();
  }

  checkEmployee = () => {
    const {payroll, account, web3} = this.props;
    payroll.employees.call(account, {
      from: account
    }).then(function(result){
      this.setState({
        salary: web3.fromWei(result[1].toNumber()),
        lastPaidDate: new Date(result[2].toNumber() * 1000).toString()
      });
    }).then(function(){
      web3.eth.getBalance(account, function(err, res){
        if(!err){
          this.setState({
            balance: web3.fromWei(res.toNumber())
          });
        }
      });
    });

  }

  getPaid = () => {
    const {payroll, account} = this.props;
    payroll.getPaid({
      from: account, 
      gas: 3000000
    }).then(function(res){
      this.setState({
        paymentMessage: "You have been paid"
      });
    });
  }

  renderContent() {
    const { salary, lastPaidDate, balance, paymentMessage } = this.state;

    if (!salary || salary === '0') {
      return   <Alert message="你不是员工" type="error" showIcon />;
    }

    return (
      <div>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="薪水">{salary} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="上次支付">{lastPaidDate}</Card>
          </Col>
          <Col span={8}>
            <Card title="帐号金额">{balance} Ether</Card>
          </Col>
        </Row>

        <Button
          type="primary"
          icon="bank"
          onClick={this.getPaid}
        >
          获得酬劳
        </Button>
        <div>{paymentMessage}</div>
      </div>
    );
  }

  render() {
    const { account, payroll, web3 } = this.props;

    return (
      <Layout style={{ padding: '0 24px', background: '#fff' }}>
        <Common account={account} payroll={payroll} web3={web3} />
        <h2>个人信息</h2>
        {this.renderContent()}
      </Layout >
    );
  }
}

export default Employer
