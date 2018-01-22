import React, { Component } from 'react'

class Common extends Component {
    constructor(props) {
        super(props);

        this.state = {};
    }

    componentDidMount() {
        const { payroll, account, web3 } = this.props;
        payroll.checkInfo.call({
            from: account,
        }).then((result) => {
            this.setState({
                balance: web3.fromWei(result[0].toNumber()),
                runway: result[1].toNumber(),
                employeeCount: result[2].toNumber()
            })
        });
    }

    render() {
        const { runway, balance, employeeCount } = this.state;
        return (
            <div>
                <h2>common information</h2>
                <p>Balance: {balance}</p>
                <p>employeeCount: {employeeCount}</p>
                <p>runway: {runway}</p>
            </div>
        );
    }
}

export default Common