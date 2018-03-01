import React, { Component } from 'react';
import PayrollContract from '../build/contracts/Payroll.json';
import getWeb3 from './utils/getWeb3';

import { Layout, Menu, Spin, Alert } from 'antd';

import Employer from './components/Employer';
import Employee from './components/Employee';

import 'antd/dist/antd.css';
import './App.css';

const { Header, Content, Footer } = Layout;

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      mode: 'employer'
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
    const payroll = contract(PayrollContract)
    payroll.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on Payroll.
    var payrollInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.setState({
        accounts,
        selectedAccount: accounts[0]
      });

      payroll.deployed().then((instance) => {
        payrollInstance = instance;
        this.setState({
          payroll: instance
        });
      })
    })
  }

  onSelectAccount = (ev) => {
    this.setState({
      selectedAccount: ev.target.text
    });
  }

  onSelectTab = ({key}) => {
    this.setState({
      mode: key
    });
  }

  renderContent = () => {
    const { selectedAccount, payroll, web3, mode } = this.state;

    if (!payroll) {
      return <Spin tip="Loading..." />;
    }

    switch(mode) {
      case 'employer':
        return <Employer account={selectedAccount} payroll={payroll} web3={web3} />
      case 'employee':
        return <Employee account={selectedAccount} payroll={payroll} web3={web3} />
      default:
        return <Alert message="Please pick a mode" type="info" showIcon />
    }
  }

  render() {
    const { selectedAccount, accounts, payroll, web3 } = this.state;

    if (!accounts) {
      return <div>Loading</div>;
    }

    return (
      <Layout>
        <Header className="header">
          <div className="logo">老董区块链干货铺员工系统</div>
          <Menu
            theme="dark"
            mode="horizontal"
            defaultSelectedKeys={['employer']}
            style={{ lineHeight: '64px' }}
            onSelect={this.onSelectTab}
          >
            <Menu.Item key="employer">Employer</Menu.Item>
            <Menu.Item key="employee">Employee</Menu.Item>
          </Menu>
        </Header>
        <Content style={{ padding: '0 50px' }}>
          <Layout style={{ padding: '24px 0', background: '#fff', minHeight: '600px' }}>
            {this.renderContent()}
          </Layout>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          Payroll ©2017 老董区块链干货铺
        </Footer>
      </Layout>
    );
  }
}

export default App
