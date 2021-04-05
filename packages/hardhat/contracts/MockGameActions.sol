pragma solidity >=0.7.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
//import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract MockGameActions {

  event SetAction(address sender, string action);

  string public purpose = "";

  constructor() {
    // what should we do on deploy?
  }

  function setAction(string memory newPurpose) public {
    purpose = newPurpose;
    console.log("ACTION: ",purpose);
    emit SetAction(msg.sender, purpose);
  }

}
