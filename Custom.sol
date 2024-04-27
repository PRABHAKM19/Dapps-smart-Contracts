// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Custom 
{


struct Account {
    address accountAddress;
    address publicKey;
    uint256 balance;
  }
mapping(address=>Account) private accounts0;
address private owner;


  constructor ()
  {

  }

  function createAccount(address _publicKey) external
  {
    require ((accounts0[_publicKey].accountAddress == address(0)),"Account already exists");
    Account storage newAccount = accounts0[_publicKey];
    newAccount.accountAddress = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, _publicKey)))));
    newAccount.publicKey = _publicKey;
  }
  function deposit(address _accountAddress, uint256 _amount) external
  {
    require ((_amount > 0),"Amount must be greater than zero");
    Account storage account = accounts0[_accountAddress];
    account.balance += _amount;
  }
  function withdraw(address _accountAddress, uint256 _amount) external
  {
    require ((_amount > 0),"Amount must be greater than zero");
    Account storage account = accounts0[_accountAddress];
    require ((account.balance >= _amount),"Insufficient balance");
    account.balance -= _amount;
  }
  function transfer(address _senderAddress, address _recipientAddress, uint256 _amount) external
  {
    require ((_amount > 0),"Amount must be greater than zero");
    Account storage senderAccount = accounts0[_senderAddress];
    require ((senderAccount.balance >= _amount),"Insufficient balance");
    Account storage recipientAccount = accounts0[_recipientAddress];
    recipientAccount.balance += _amount;
    senderAccount.balance -= _amount;
  }
  function getBalance(address _accountAddress) external view returns (uint256 )
  {
    return accounts0[_accountAddress].balance;
  }
  function getAccountAddress(address _publicKey) external view returns (address )
  {
    return accounts0[_publicKey].accountAddress;
  }
  function getAccountDetails(address _accountAddress) external view returns (address ,address ,uint256 )
  {
    Account storage account = accounts0[_accountAddress];
    return (account.accountAddress, account.publicKey, account.balance);
  }
  function updatePublicKey(address _accountAddress, address _newPublicKey) external
  {
    Account storage account = accounts0[_accountAddress];
    require ((account.publicKey == msg.sender),"Not authorized");
    account.publicKey = _newPublicKey;
  }
  function closeAccount(address _accountAddress) external
  {
    Account storage account = accounts0[_accountAddress];
    require ((account.publicKey == msg.sender),"Not authorized");
    uint256 balance = account.balance;
    account.balance = 0;
    payable(msg.sender).transfer(balance);
    delete accounts0[_accountAddress];
  }
  function selfDestruct() external   
  {
    require ((msg.sender == owner),"Only the owner can trigger self-destruction");
    selfdestruct(payable(owner));
  }
}