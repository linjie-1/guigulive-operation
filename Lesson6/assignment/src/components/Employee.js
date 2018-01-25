import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employer extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    const { payroll, web3 } = this.props;
    
    const updateInfo = (error, result) => {
      console.log(result)
      if (!error) {
        this.checkEmployee();
      }
    }
    this.getPaidEvent = payroll.GetPaid(updateInfo);
    this.checkEmployee();
  }

  componentWillUnmount() {
    console.log("unmount employee")
    this.getPaidEvent.stopWatching();
  }

  checkEmployee = () => {
    const { payroll, account, web3} = this.props;
    payroll.employees.call(account).then(result => {
      const salary = result[1].toNumber()
      const lastPaidDate = result[2].toNumber()
      this.setState({
        "salary": web3.fromWei(salary),
        "lastPaidDate": new Date(lastPaidDate * 1000).toLocaleString()
      })
      web3.eth.getBalance(account, (error, result) =>{
        this.setState({
          "balance": web3.fromWei(result.toNumber()),
        })
      })
    })
  }

  getPaid = () => {
    const { payroll, account, web3} = this.props;
    payroll.getPaid({from: account, gas: 1000000}).then(result => {
      alert("getPaid success")
    })
  }

  renderContent() {
    const { salary, lastPaidDate, balance } = this.state;

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
