import React, { Component } from 'react'

import PayRollContract from '../build/contracts/PayRoll.json'
import getWeb3 from './utils/getWeb3'

import {Layout, Menu, Spin, Alert} from 'antd'

import Common from "./components/Common";
//import Accounts from "./components/Accounts";
import Employer from "./components/Employer";
import Employee from "./components/Employee";

//import './css/oswald.css'
//import './css/open-sans.css'
//import './css/pure-min.css'

import 'antd/dist/antd.css'
import './App.css'

const {Header, Content, Footer}= Layout;

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      mode:'employer'
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


    const contract = require('truffle-contract')
    const PayRoll = contract(PayRollContract)
    PayRoll.setProvider(this.state.web3.currentProvider)

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {

      console.log(accounts);

      this.setState({
        accounts:accounts[0]
      });


      PayRoll.deployed().then((instance) => {
        this.setState({
          payroll:instance
        });
      });
    })
  }


  onSelectTab=(key)=>{
    this.setState({
      mode:key
    });
  }

  renderContent=()=>{
    const {account, payroll, web3, mode}=this.state;

    if(!payroll){
      return <Spin tip="Loading....."></Spin>
    }

    switch(mode){
      case "employer":
        return <Employer account={account} payroll={payroll} web3={web3} />;
      case "employee":
        return <Employee account={account} payroll={payroll} web3={web3} />;
      default:
        return <Alert message="请选一个模式" type="info" showIcon></Alert>
    }

  }




  render() {

    const {accounts,payroll,web3}=this.state;

    if(!accounts){
      return <div>Loading</div>;
    }

    return (
      <Layout>
        <Header className='header'>
          <div className='logo'>老董区块链干货铺员工系统</div>
          <Menu 
            theme="dark" 
            mode="horizontal" 
            defaultSelectedKeys={['employer']}
            style={{lineHeight:'64px'}}
            onSelect={this.onSelectTab}
            >
            <Menu.Item key="employer">雇主</Menu.Item>
            <Menu.Item key="employee">雇员</Menu.Item>
          </Menu>
        </Header>
        <Content style={{padding:'0 50px'}}>
          <Layout style={{ padding:'24px 0', background:'#fff', minHeight: '600px'}}>
          {this.renderContent()}
          </Layout>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          Payroll ©2018 老董区块链干货铺
        </Footer>
      </Layout>
    
    );
  }
}

export default App
