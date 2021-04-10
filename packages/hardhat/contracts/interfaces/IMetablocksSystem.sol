pragma solidity >=0.7.0 <0.9.0;
//SPDX-License-Identifier: MIT

/**
 * @title DeFi Metablocks Game MasterSystem interface
 */

interface IMetablocksSystem {

    
    // passthrough requests for the oracle
    function fetchNextRandomNumber() external view returns (uint256);
    function getCurrentPlayerAddress() external view returns (address);
    function getPlayerPosition() external view returns (uint16);
    function getCurrentTurnTimeout() external view returns (uint256);
    function isAllowedLotSize(uint64 _requestedLotSizeSatoshis) external view returns (bool);
    function insertCoinCreateGame() external payable returns (address);
}
