import React from "react"

export default function Accounts({
    accounts=[],
    onSelectAccount
}){
   
    return (
        <div className="pure-menu sidebar">
            <span className="pure-menu-heading">帐号列表</span>
            <ul className="pure-menu-list">
            {
                accounts.map(function(account,idx){
                    return <li className="pure-menu-item" key={account} onClick={onSelectAccount} >
                        <a href="#" className="pure-menu-link">{account}</a>
                    </li>
                })
            }
            </ul>
        </div>
    );

}
