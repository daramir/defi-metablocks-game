pragma solidity >=0.7.6;
//SPDX-License-Identifier: MIT

import "./CloneFactory.sol";
import "../MetablocksGame.sol";
import "../system/MetablocksSystem.sol";
// import "../system/TBTCToken.sol";
import "../system/MetablocksSystemAuthority.sol";
// import {TBTCDepositToken} from "../system/TBTCDepositToken.sol";


/// @title Game Factory
/// @notice Factory for the creation of new Game clones.
/// @dev We avoid redeployment of MetablocksGame contract by using the clone factory.
/// Proxy delegates calls to Deposit and therefore does not affect deposit state.
/// This means that we only need to deploy the MetablocksGame contracts once.
/// The factory provides clean state for every new MetablocksGame clone.
contract GameFactory is CloneFactory, MetablocksSystemAuthority{

    // Holds the address of the MetablocksGame contract
    // which will be used as a master contract for cloning.
    address payable public masterGameAddress;
    // TBTCDepositToken tbtcDepositToken;
    MetablocksSystem public metablocksSystem;
    // TBTCToken public tbtcToken;
    // FeeRebateToken public feeRebateToken;
    address public vendingMachineAddress;

    constructor(address _systemAddress)
        MetablocksSystemAuthority(_systemAddress)
    public {}

    /// @dev                          Set the required external variables.
    /// @param _masterGameAddress     The address of the master MetablocksGame contract.
    /// @param _metablocksSystem      Metablocks system contract.
    function setExternalDependencies(
        address payable _masterGameAddress,
        MetablocksSystem _metablocksSystem
        // TBTCToken _tbtcToken,
        // TBTCDepositToken _tbtcDepositToken
    ) external onlyMetablocksSystem {
        masterGameAddress = _masterGameAddress;
        // tbtcDepositToken = _tbtcDepositToken;
        metablocksSystem = _metablocksSystem;
        // tbtcToken = _tbtcToken;
        // feeRebateToken = _feeRebateToken;
        // vendingMachineAddress = _vendingMachineAddress;
    }

    event GameCloneCreated(address gameCloneAddress);

    /// @notice Creates a new MetablocksGame instance and mints a TDT. This function is
    ///         currently the only way to create a new Game.
    /// @dev Calls `MetablocksGame.initializeGame` to initialize the instance. Reverts if the bonds
    ///      for running the Game would not be enough to play the game
    /// @return The address of the new Game.
    function createGame(uint64 _lotSizeSatoshis) external payable returns(address) {
        address cloneAddress = createClone(masterGameAddress);
        emit GameCloneCreated(cloneAddress);

        // TBTCDepositToken(tbtcDepositToken).mint(msg.sender, uint256(cloneAddress));

        MetablocksGame game = MetablocksGame(address(uint160(cloneAddress)));
        game.initialize(address(this));
        // game.initializeGame.value(msg.value)(
        //         metablocksSystem
        //     );

        return cloneAddress;
    }
}
