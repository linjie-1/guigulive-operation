import React, { Component } from 'react'

class Employee extends Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    componentDidMount() {
        this.checkEmployee();
    }

    checkEmployee = () => {
        const { payroll, employee, web3 } = this.props;
        payroll.employees.call(employee, {
            from: employee,
            gas: 1000000
        }).then((result) => {
            console.log(result)
            this.setState({
                salary: web3.fromWei(result[1].toNumber()),
                lastPaidDate: new Date(result[2].toNumber() * 1000)
            });
        }); 
    }

    getPaid = () => {
        const { payroll, employee } = this.props;
        payroll.getPaid({
            from: employee,
            gas: 1000000
        }).then((result) => {
            alert(`You have been paid`);
        });
    }

    render() {
        const { salary, lastPaidDate } = this.state;
        const { employee } = this.props;

        return (
            <div>
                <h2>employee {employee}</h2>
                { !salary || salary === '0' ?
                    <p>You are not employee</p> :
                    (
                        <div>
                            <p>salary: {salary}</p>
                            <p>last paid date: { lastPaidDate.toString()}</p>

                            <button type="button" className="pure-button" onClick={this.getPaid}>Get Paid</button>
                        </div>
                    )
                }
            </div>
        );
    }
}

export default Employee