import React, { Component } from 'react';

class Common extends Component {
	constructor(props) {
		super(props);
		this.state = {};
	}

	componentDidMount() {
		const { payroll, web3, account } = this.props;
		payroll.getInfo.call({
			from: account
		}).then((result) => {
			this.SetState({
				balance: web3.fronmWei(result[0].toNumber()),
				runwayNumber: result[1].toNumber(),
				employeesCount: result[2].toNumber()
			})
		});
	}

	render() {
		const { runwayNumber, balance, employeesCount } = this.state;
		return (
			<div>
				<h2>通用信息</h2>
				<p>合约金额：{balance}</p>
				<p>员工人数：{employeesCount}</p>
				<p>可支付次数：{runwayNumber}</p>
			</div>
		);
	}
}

export default Common;