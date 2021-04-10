pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract RandomNumberConsumer is VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;

    event Roll (uint8 roll1, uint8 roll2, uint8 roll3, uint8 roll4, uint8 roll5, uint8 roll6, uint8 roll7, uint8 roll8);

    constructor()
    VRFConsumerBase(

        // --- KOVAN
//        0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, // VRF Coordinator
//        0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
        // -- MUMBAI
        0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
        0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK Token
    ) public
    {
        // --- KOVAN
//        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        // -- MUMBAI
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;

        // --- KOVAN
//        fee = 0.1 * 10 ** 18; // 0.1 LINK
        // -- MUMBAI
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK

    }

    /**
     * Requests randomness from a user-provided seed
     */
    function rollDice() public returns (bytes32 requestId) {

        uint256 userProvidedSeed = 1234;

        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");

        bytes32 requestId = requestRandomness(keyHash, fee, userProvidedSeed);

        emit Roll(
            uint8(requestId[0]) % 6,
            uint8(requestId[1]) % 6,
            uint8(requestId[2]) % 6,
            uint8(requestId[3]) % 6,
            uint8(requestId[4]) % 6,
            uint8(requestId[5]) % 6,
            uint8(requestId[6]) % 6,
            uint8(requestId[7]) % 6
        );

        return requestId;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }
}