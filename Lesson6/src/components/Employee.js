import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, Button } from 'antd';

import Common from './Common';

class Employer extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    const { payroll } = this.props;
    const updateInfo = (error, result) => {
      if (!error) {
        this.checkEmployee();
      } else {
        console.log(error);
      }
    }

    this.getPaidEvent = payroll.GetPaid(updateInfo);
    this.newEmployeeEvent = payroll.NewEmployee(updateInfo);
    this.updateEmployeeEvent = payroll.UpdateEmployee(updateInfo);
    this.removeEmployeeEvent = payroll.RemoveEmployee(updateInfo);

    this.checkEmployee();
  }

  componentWillUnmount() {
    this.getPaidEvent.stopWatching();
    this.newEmployeeEvent.stopWatching();
    this.updateEmployeeEvent.stopWatching();
    this.removeEmployeeEvent.stopWatching();
  }

  checkEmployee = () => {
    const { payroll, account, web3 } = this.props;
    payroll.employees.call(
      account,
      {from: account, gas: 5000000}
    ).then((result) => {
      this.setState({
        salary: web3.fromWei(result[1].toNumber()),
        lastPaidDate: (new Date(result[2].toNumber() * 1000)).toString(),
      });
      web3.eth.getBalance(account, (error, result) => {
        if (!error) {
          this.setState({
            balance: web3.fromWei(result.toNumber()),
          })
        } else {
          console.log(error);
          alert("发现异常！！！");
        }
      });
    }).catch((error) => {
      console.log(error);
      alert("发现异常！！！");
    });
  }

  getPaid = () => {
    const { payroll, account } = this.props;
    payroll.getPaid({from: account, gas: 5000000}).then((result) => {
      if (parseInt(result.receipt.status, 10) === 1) {
        alert("领取薪水成功！");
      } else {
        console.log(result);
        alert("领取薪水失败！！！");
      }
    }).catch((error) => {
      console.log(error);
      alert("领取薪水失败！！！");
    });
  }

  renderContent() {
    const { salary, lastPaidDate, balance } = this.state;
    if (!salary || salary === '0') {
      return <Alert message="你不是员工" type="error" showIcon />;
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
