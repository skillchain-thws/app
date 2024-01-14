// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./UserManager.sol";
import "./JobManager.sol";
import "./EscrowManager.sol";

contract FreelancerMarketplace {
  address owner;
  UserManager userManager;
  JobManager jobManager;
  EscrowManager escrowManager;

  //*********************************************************************
  //*********************************************************************
  //                        Utility Functions
  //*********************************************************************
  //*********************************************************************

  function onlyAdmin() external view returns (bool) {
    require(msg.sender != owner, "You need to be a Admin for this action");
    return true;
  }

  function nonEmptyString(string memory str) external pure returns (bool) {
    require(bytes(str).length > 0, "String must not be empty");
    return true;
  }
}
