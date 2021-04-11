pragma solidity >=0.6.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@chainlink/contracts/src/v0.7/dev/VRFConsumerBase.sol";

contract MockDiceRoll {
        using SafeMathChainlink for uint8;
    using SafeMathChainlink for uint256;
    uint8 public mostRecentRoll;

    uint8 private constant ROLL_IN_PROGRESS = 42;

    bytes32 private keyHash;
    uint256 private fee;
    mapping(uint8 => address) private rollers;
    mapping(address => uint8) private results;

    event DiceRolled(uint8 indexed requestId, address indexed roller);
    event DiceLanded(uint8 indexed requestId, address indexed roller, uint8 indexed result);
    
    //Mock RequestId
    uint8 public lclRequestId;

    //VRFConsumerBase(VRF Coordinator, LINK Token)
    constructor() public
    {
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK;
        lclRequestId = 0;
    }

    function rollDice() public returns (uint8 requestId) {
        // require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to pay fee");

        uint256 userProvidedSeed = 1234;
        address roller = msg.sender;

        // requestId = requestRandomness(keyHash, fee, userProvidedSeed);
        requestId++;

        rollers[requestId] = roller;
        results[roller] = ROLL_IN_PROGRESS;

        emit DiceRolled(requestId, roller);
    }

    function fulfillRandomness(uint8 requestId, uint256 randomness) external {
        uint8 rollValue = uint8(randomness.mod(6).add(1));
        results[rollers[requestId]] = rollValue;
        mostRecentRoll = rollValue;
        emit DiceLanded(requestId, rollers[requestId], rollValue);
    }

    /// @notice Returns the latest dice roll.
    function getMostRecentRoll() external view returns (uint8) {
        return mostRecentRoll;
    }
}
