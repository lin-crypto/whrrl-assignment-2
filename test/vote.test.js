const { ethers } = require("hardhat");

describe("Test", () => {
  before(async () => {
    this.signers = await ethers.getSigners();
    this.unMembers = [];
    this.candidates = [];
    this.unMembers[0] = this.signers[2].address;
    this.unMembers[1] = this.signers[3].address;
    this.unMembers[2] = this.signers[4].address;
    this.candidates[0] = this.signers[5].address;
    this.candidates[1] = this.signers[6].address;
    this.candidates[2] = this.signers[7].address;

    let factory = await ethers.getContractFactory("VoterList");
    this.contractVoterList = await factory.deploy();
    await this.contractVoterList.deployed();

    factory = await ethers.getContractFactory("Ballot");
    this.contractBallot = await factory.deploy(
      this.contractVoterList.address,
      this.candidates,
      this.unMembers
    );
    await this.contractBallot.deployed();
  });

  it("Voter List", async () => {
    // await this.contract.connect(this.signers[0]).registerVoter();
    await this.contractVoterList.registerVoter(
      this.signers[1].address,
      "Jack",
      25,
      "Male",
      "1169 Comfort Court Madison Wisconsin"
    );
    const voters = await this.contractVoterList.getAllVoters();
    console.log("All Voters: ", voters);
    const isRegistered1 = await this.contractVoterList
      .connect(this.signers[0])
      .isRegistered();
    console.log(`Is ${this.signers[0].address} registered?`, isRegistered1);
    const isRegistered2 = await this.contractVoterList
      .connect(this.signers[1])
      .isRegistered();
    console.log(`Is ${this.signers[1].address} registered?`, isRegistered2);

    const userContract = await this.contractVoterList.getContractAddress(
      this.signers[1].address
    );
    console.log(userContract);
    const details = await this.contractVoterList.getUserDetails(
      this.signers[1].address
    );
    console.log(details);
  });

  it("Ballot", async () => {
    await this.contractBallot.castVote(this.candidates[0]);

    const result = await this.contractBallot.getResults(this.candidates[0]);
    console.log(result);

    const userVote = await this.contractBallot.getUsersVote(
      this.signers[0].address
    );
    console.log(userVote);
  });
});
