pragma solidity >=0.7.3;
//SPDX-License-Identifier: MIT

library MetablocksConstants {
    // System Parameters
    uint256 public constant PLAYER_TURN_TIMEOUT = 3 * 60; // 3 min in seconds

    // Getters for easy access
    function getPlayerTurnTimeout() external pure returns (uint256) {
        return PLAYER_TURN_TIMEOUT;
    }
}
