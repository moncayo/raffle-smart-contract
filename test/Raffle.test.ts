/**
 * David Moncayo
 * 
 * Simple testing file for Raffle smart contract
 */

import { expect, use } from 'chai';
import { Contract } from 'ethers';
import { deployContract, MockProvider, solidity } from 'ethereum-waffle';
import Raffle from '../build/Raffle.json';

use(solidity);

describe('Raffle', () => {
    const [wallet] = new MockProvider().getWallets();
    let raffle: Contract;

    beforeEach(async () => {
        // Deploy a raffle contract 1 sec long, 100 wei/ticket
        raffle = await deployContract(wallet, Raffle, [1, 100]);
    });

    it('Gets the raffle ticket price', async () => {
        expect(await raffle.getTicketPrice()).to.be.equal(100);
    });
    
    it('Gets the owner of the contract', async () => {
        expect(await raffle.getOwner()).to.be.equal(wallet.address)
    });

    it('Drawing the winner before the end time fails', async () => {
        await expect(raffle.drawWinner()).to.be.reverted;
    });

    it('Paying out the pool before the winner is chosen fails', async () => {
        await expect(raffle.payout()).to.be.reverted;
    })
});