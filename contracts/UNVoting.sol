// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Ballot {
  VoterList public VoterListContract;
  address[] public candidates;
  uint256 public period;
  mapping(address => bool) public UNMembers;
  mapping(address => uint256) Votes;
  mapping(address => address) votedCandidate;

  modifier onlyUNMembers() {
    require(UNMembers[msg.sender] == true, "You are not UN member.");
    _;
  }

  function isRegistered(address user) public view returns (bool) {
    bool _isRegistered = false;
    address[] memory voters = VoterListContract.getAllVoters();
    for (uint256 i = 0; i < voters.length; i++) {
      if (voters[i] == user) {
        _isRegistered = true;
        break;
      }
    }
    return _isRegistered;
  }

  constructor(
    address _VoterList,
    address[] memory _candidates,
    address[] memory _UNMembers
  ) {
    VoterListContract = VoterList(_VoterList);
    for (uint256 i = 0; i < _candidates.length; i++) {
      candidates.push(_candidates[i]);
    }

    for (uint256 i = 0; i < _UNMembers.length; i++) {
      UNMembers[_UNMembers[i]] = true;
    }
  }

  function getMyVote() public view returns (address) {
    return votedCandidate[msg.sender];
  }

  function getResults(address candidate) public view returns (uint256) {
    return Votes[candidate];
  }

  function castVote(address _candidate) public {
    Votes[_candidate] += 1;
    votedCandidate[msg.sender] = _candidate;
  }

  function getUsersVote(address user) public view returns (address) {
    require(isRegistered(user) == true, "The user doesn't exist.");
    return votedCandidate[user];
  }

  function getVoteMap(address user)
    public
    view
    returns (address[] memory, uint256)
  {
    return (VoterListContract.getAllVoters(), Votes[user]);
  }

  function consolidateVotes() public view returns (bool) {
    uint256 votesFromBallot;
    for (uint256 i = 0; i < candidates.length; i++) {
      votesFromBallot += Votes[candidates[i]];
    }

    uint256 votesFromCitizen;
    address[] memory voters = VoterListContract.getAllVoters();
    for (uint256 i = 0; i < voters.length; i++) {
      Citizen CitizenContract = VoterListContract.getContractAddress(voters[i]);
      if (CitizenContract.VoteTo() == address(0x0)) {
        votesFromCitizen += 1;
      }
    }

    require(votesFromBallot == votesFromCitizen, "There is discrepancy.");
    return true;
  }
}

contract VoterList {
  address[] public voters;
  mapping(address => Citizen) public citizens;

  function registerVoter(
    address wallet,
    string memory name,
    uint32 age,
    string memory gender,
    string memory addr
  ) public {
    Citizen newCitizen = new Citizen(wallet, name, age, gender, addr);
    citizens[wallet] = newCitizen;
    voters.push(wallet);
  }

  function getAllVoters() public view returns (address[] memory) {
    return voters;
  }

  function getContractAddress(address user) public view returns (Citizen) {
    return citizens[user];
  }

  function getUserDetails(address user)
    public
    view
    returns (
      string memory,
      uint32,
      string memory,
      string memory,
      address
    )
  {
    return citizens[user].getDetails();
  }

  function isRegistered() public view returns (bool) {
    bool _isRegistered = false;
    for (uint256 i = 0; i < voters.length; i++) {
      if (voters[i] == msg.sender) {
        _isRegistered = true;
        break;
      }
    }
    return _isRegistered;
  }
}

contract Citizen {
  address Owner;
  string Name;
  uint32 Age;
  string Gender;
  string Address;
  address public VoteTo;

  struct Permission {
    address user;
    uint256 expiry;
  }
  Permission[] permission;

  modifier onlyPermission() {
    require(msg.sender == Owner, "You don't have permission.");
    _;
  }

  constructor(
    address _Owner,
    string memory _Name,
    uint32 _Age,
    string memory _Gender,
    string memory _Address
  ) {
    Owner = _Owner;
    Name = _Name;
    Age = _Age;
    Gender = _Gender;
    Address = _Address;
  }

  function getDetails()
    public
    view
    onlyPermission
    returns (
      string memory,
      uint32,
      string memory,
      string memory,
      address
    )
  {
    return (Name, Age, Gender, Address, VoteTo);
  }

  function giveAccess(address user, uint256 expiry) public {
    Permission memory newPermission;
    newPermission = Permission(user, expiry);
    permission.push(newPermission);
  }
}
