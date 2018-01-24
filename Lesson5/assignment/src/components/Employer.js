import React, { Component } from 'react';

class Employer extends Component {
	constructor(props) {
		super(props);
		this.state = {};
	}

	addMoney = () => {
		const { payroll, employer, web3 } = this.props;
		payroll.addMoney({
			from: employer,
			value: web3.toWei(this.fundInput.value)
		});
	}

	addEmployee = () => {
		const { payroll, employer } = this.props;
		payroll.addEmployee(this.employeeInput.value, parseInt(this.salaryInput.value), {
			from: employer,
			gas: 1000000
		}).then((result) => {
			alert('success');
		})
	}

	updateEmployee = () => {
		const { payroll, employer } = this.props;
		payroll.ownerUpdateEmployee(this.employeeInput.value, parseInt(this.salaryInput.value), {
			from: employer,
			gas: 1000000
		}).then((result) => {
			alert('success');
		})
	}

	removeEmployee = () => {
		const { payroll, employer } = this.props;
		payroll.removeEmployee(this.removeEmployeeInput.value, {
			from: employer,
			gas: 1000000
		}).then((result) => {
			alert('success');
		})
	}

	render() {
		return (
			<div>
				<h2>Employer</h2>
				<form className="pure-form pure-form-stacked">
					<fieldset>
						<legend>Add fund</legend>
						<label>fund</label>
						<input type="text" placeholder="fund" ref={(input) => { this.fundInput = input; }}/>
						<button type="button" className="pure-button" onClick={this.addMoney}>Add</button>
					</fieldset>
				</form>

				<form className="pure-form pure-form-stacked">
					<fieldset>
						<legend>Add/Update Employee</legend>
						<label>employee id</label>
						<input type="text" placeholder="employee" ref={(input) => { this.employeeInput = input; }} />
						<label>salary</label>
						<input type="text" placeholder="salary" ref={(input) => { this.salaryInput = input; }} />
						<button type="button" className="pure-button" onClick={this.addEmployee}>Add</button>
						<button type="button" className="pure-button" onClick={this.updateEmployee}>Update</button>
					</fieldset>
				</form>

				<form className="pure-form pure-form-stacked">
					<fieldset>
						<legend>Remove Employee</legend>
						<label>employee id</label>
						<input type="text" placeholder="employee" ref={(input) => { this.removeEmployeeInput = input; }} />
						<button type="button" className="pure-button" onClick={this.removeEmployee}>Remove</button>
					</fieldset>
				</form>
			</div>
		)
	}
}

export default Employer;