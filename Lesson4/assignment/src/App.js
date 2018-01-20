import React, { Component } from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
// import SimpleStorageContract from '../build/contracts/SimpleStorage.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      // storageValue: 0,
      // addressValue: 0,
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
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
   

    const payroll = contract(PayrollContract)
    payroll.setProvider(this.state.web3.currentProvider)

    var payrollInstance



    console.log('Error finding web3.5')
    this.state.web3.eth.getAccounts((error,accounts) =>{
      payroll.deployed().then((instance) => {
        console.log(accounts)
        payrollInstance = instance
        console.log(accounts[1])
        return payrollInstance.addEmployee(""+accounts[1],1)
      }).then((result) => {
        console.log(result)
        return payrollInstance.removeEmployee(""+accounts[1])
      }).then((result) => {
        console.log(result)
      })
    })
  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Good to Go!</h1>
              <p>Your Truffle Box is installed and ready.</p>
              <h2>Smart Contract Example</h2>
              <p>If your contracts compiled and migrated successfully, below will show a stored value of 5 (by default).</p>
              <p>Try changing the value stored on <strong>line 59</strong> of App.js.</p>
              {/* <p>add value is: {this.state.addressValue}</p>
              <p>delete value is: {this.state.storageValue}</p> */}
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
