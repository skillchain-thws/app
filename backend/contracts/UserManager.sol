// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./FreelancerMarketplace.sol";
import "./CommitteeManager.sol";

contract UserManager {
  FreelancerMarketplace freelancerMarketplace;
  CommitteeManager committeeManager;

  mapping(address => User) public users;
  mapping(uint256 => address) public addresses;
  uint256 public userCount;

  struct User {
    address owner;
    string userName;
    bool isJudge;
    uint256[] jobIds;
    uint256[] escrowIds;
  }

  constructor(address _freelancerMarketplaceAddress) {
    freelancerMarketplace = FreelancerMarketplace(
      _freelancerMarketplaceAddress
    );
  }

  //*********************************************************************
  //*********************************************************************
  //                        Setter Functions
  //*********************************************************************
  //*********************************************************************

  function setCommitteeManager(address _address) external {
    require(
      freelancerMarketplace.onlyAdmin(),
      "Only the Admin can add Managers"
    );
    committeeManager = CommitteeManager(_address);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Getter Functions
  //*********************************************************************
  //*********************************************************************

  function getUser(
    address _address
  )
    external
    view
    returns (
      address owner,
      string memory userName,
      bool isJudge,
      uint256[] memory jobIds,
      uint256[] memory escrowIds
    )
  {
    User storage user = users[_address];
    return (
      user.owner,
      user.userName,
      user.isJudge,
      user.jobIds,
      user.escrowIds
    );
  }

  function getAllUserAddresses() external view returns (address[] memory) {
    address[] memory allUserAddresses = new address[](userCount);

    for (uint256 i = 0; i < userCount; i++) {
      allUserAddresses[i] = addresses[i];
    }

    return allUserAddresses;
  }

  function getAllUsers() external view returns (User[] memory) {
    User[] memory allUsers = new User[](userCount);

    for (uint256 i = 0; i < userCount; i++) {
      address userAddress = addresses[i];
      User storage user = users[userAddress];

      User memory _user;
      _user.owner = user.owner;
      _user.userName = user.userName;
      _user.isJudge = user.isJudge;
      _user.jobIds = user.jobIds;
      _user.escrowIds = user.escrowIds;

      allUsers[i] = _user;
    }

    return allUsers;
  }

  function getAllJobIds(
    address userAddress
  ) external view returns (uint256[] memory) {
    return users[userAddress].jobIds;
  }

  //*********************************************************************
  //*********************************************************************
  //                        User Functions
  //*********************************************************************
  //*********************************************************************

  event UserRegistered(address userAddress, string name);

  function registerUser(string memory _name) external nameNotTaken(_name) {
    require(
      freelancerMarketplace.nonEmptyString(_name),
      "String must not be empty"
    );
    require(users[msg.sender].owner == address(0), "User already registered");

    User storage newUser = users[msg.sender];
    newUser.owner = msg.sender;
    newUser.userName = _name;
    newUser.isJudge = false;

    // Every registered users becomse a judge, if he does not want to he has to call unsetJudge
    setJudge(msg.sender);

    addresses[userCount] = msg.sender;
    userCount++;

    emit UserRegistered(msg.sender, _name);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Job Functions
  //*********************************************************************
  //*********************************************************************

  function addJobId(uint256 jobId, address _address) external {
    users[_address].jobIds.push(jobId);
  }

  function removeJobId(uint256 jobId, address _address) external {
    User storage currentUser = users[_address];
    uint256 indexToRemove;

    for (uint256 i = 0; i < currentUser.jobIds.length; i++) {
      if (currentUser.jobIds[i] == jobId) {
        indexToRemove = i;
        break;
      }
    }

    require(indexToRemove < currentUser.jobIds.length, "Job ID not found");

    currentUser.jobIds[indexToRemove] = currentUser.jobIds[
      currentUser.jobIds.length - 1
    ];
    currentUser.jobIds.pop();
  }

  function addEscrowId(uint256 escrowId, address _address) external {
    users[_address].escrowIds.push(escrowId);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Judge Functions
  //*********************************************************************
  //*********************************************************************

  event JudgeSet(address userAddress);

  function setJudge(address userAddress) public {
    users[userAddress].isJudge = true;
    committeeManager.joinCommittee(userAddress);

    emit JudgeSet(userAddress);
  }

  event JudgeUnset(address userAddress);

  function unsetJudge(address userAddress) external {
    users[userAddress].isJudge = false;
    // Set status of this committee member to unavailable
    committeeManager.markMemberAsUnavailable(userAddress);

    emit JudgeUnset(userAddress);
  }

  //*********************************************************************
  //*********************************************************************
  //                              Modifier
  //*********************************************************************
  //*********************************************************************

  modifier nameNotTaken(string memory str) {
    bool taken = false;

    for (uint256 i = 0; i < userCount; i++) {
      taken = (keccak256(abi.encodePacked(users[addresses[i]].userName)) ==
        keccak256(abi.encodePacked(str)));

      if (taken) {
        break;
      }
    }

    require(!taken, "Name is already taken");
    _;
  }
}
