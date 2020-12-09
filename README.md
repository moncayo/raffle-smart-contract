Purpose of Contract:

This smart contract will start a raffle where any address may buy a
ticket for the designated price when the contracted is initiated.
At the end of the raffle, a random winner will be chosen with their
likelihood of winning increased with each ticket that they buy. 
The winner will receive the prize pool of ether from the tickets 
bought, while a small fee will go to the owner of the contract.


Running tests:

1. npm install -- installs testing dependencies
2. npm run build -- compile the Solidity contract
3. npm run test -- verify that the tests work