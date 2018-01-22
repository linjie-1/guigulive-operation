import React, { Component } from 'react'

import PayRollContract from '../build/contracts/PayRoll.json'
import getWeb3 from './utils/getWeb3'

import Common from "./components/Common";
import Accounts from "./components/Accounts";
import Employer from "./components/Employer";
import Employee from "./components/Employee";

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null
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

    // Declaring this for later so we can chain functions on PayRoll.
    var PayRollInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {

      console.log(accounts);

      this.setState({
        accounts,
        selectedAccount:accounts && accounts[0]
      });


      PayRoll.deployed().then((instance) => {
        PayRollInstance = instance

        this.setState({
          payroll:instance
        });

      });
    })
  }


  onSelectAccount=(e)=>{
    this.setState({
      selectedAccount:e.target.text
    });
  }




  render() {

    const {selectedAccount,accounts,payroll,web3}=this.state;

    if(!accounts){
      return <div>Loading</div>;
    }

    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Payroll</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-3">
                <Accounts accounts={accounts} onSelectAccount={this.onSelectAccount} />
            </div>
            <div className="pure-u-2-1">
              {
                selectedAccount === accounts[0]?
                <Employer employer={selectedAccount} payroll={payroll} web3={web3} /> :
                <Employee employee={selectedAccount} payroll={payroll} web3={web3} />
              }
              {payroll && <Common account={selectedAccount} payroll={payroll} web3={web3} />}
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
