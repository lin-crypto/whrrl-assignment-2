# Assignment from Whrrl Fintech Solutions (Task 2)

The United Nations is planning to conduct a General elections for a particular constituency on a private ethereum blockchain. For every registered voter, there will be a separate smart contract. The access to this smart contract is only available with the citizen’s address. The citizen contract can only be accessed by members of UN. The citizen
can allow any other third party (exit polling organisations) if they wish to.
The following contracts will be used to run this prototype. The contracts are as follows and the details in each contract.

## Ballot

### Variables
1. List of candidates
2. Voting time period
3. List of all UN members
4. Votes each candidate has received.
5. User address=> candidate voted mapping

### Functions (functions in italic bold are publicly accessible, rest only UN members can access)
6. Get My Vote: input none, returns candidate which the querying user has voted, false if not voted yet.
7. Get Results: if the voting has ended, return the votes each candidate has received.
8. Cast Vote: If user in voter list, cast their vote, also update their individual contract for the same
9. Get Users Vote: input user address, returns the candidate the user has voted, false if not voted yet, throw error if no user exists.
10. Get Vote Map : input none, returns list of users and the votes they have cast.
11. Consolidate votes: Match votes from ballot contract and summation of votes in each users contracts. Basically there are two copies of the votes cast, one with the users contract and one in the ballot contract. Throw an error if there are any discrepancies. Take care of users who have not voted yet

## VoterList

### Variables
1. List of all registered voters
2. Mapping of Citizen address to citizen contract address.

### Functions
3. Get all voters: input none,returns list of Users address
4. Get contract address: input (user address) returns users contract address
5. Get user details: input (contract address) returns user details
6. isRegistered: input none, returns true or false depending on whether the querying user is registered.

## Individual User Contract

###  Variables
7. Name
8. Age
9. Gender
10. Address
11. Vote given to(once vote is given)
12. Permission to access contract (will be addresses of other users), should also maintain the expiry of that address to the particular users contract.

### Functions
13. Get Details: input none, returns the details, check the address of msg.sender to make sure either it is the user querying the detail, or a member of the UN or some one the user has given access.
14. Give access: input address, expiry, returns true or false of whether the permission was set. Take a default value for expiry if expiry is not provided.

## Available scripts

### Setup
```npm i``` or ```npm install```

### Compile
```npx hardhat compile```

### Test
```npx hardhat test```

### Deploy
Rename `.env.example` with `.env`.

Add PRIVATE_KEY and BSCSCAN_API_KEY in `.env`.

Add candidates and UN members in `deploy.js`.

```npx hardhat run ./scripts/deploy.js --network bsc_testnet```

### Verify
```npx hardhat verify [contract address] --network bsc_testnet```
