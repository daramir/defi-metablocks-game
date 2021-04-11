pragma solidity >=0.7.3;
//SPDX-License-Identifier: MIT

import {GameUtilsAndStruct} from "./GameUtilsAndStruct.sol";
import {GameStates} from "./GameStates.sol";
import {IMetablocksSystem} from "./interfaces/IMetablocksSystem.sol";
// import {IERC721} from "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
// import {TBTCToken} from "../system/TBTCToken.sol";

import "./system/GameFactoryAuthority.sol";

// solium-disable function-order
// Below, a few functions must be public to allow bytes memory parameters, but
// their being so triggers errors because public functions should be grouped
// below external functions. Since these would be external if it were possible,
// we ignore the issue.

/// @title  Metablocks Deposit
/// @notice This is the main contract for a Metablocks Game. It is the state machine that
///         (through various libraries) handles bitcoin funding, bitcoin-spv
///         proofs, redemption, liquidation, and fraud logic.
/// @dev This contract presents a public API that exposes the following
///      libraries:
///
///       - `DepositFunding`
///       - `DepositLiquidaton`
///       - `DepositRedemption`,
///       - `DepositStates`
///       - `GameUtilsAndStruct`
///       - `OutsourceDepositLogging`
///       - `MetablocksConstants`
///
///      Where these libraries require deposit state, this contract's state
///      variable `self` is used. `self` is a struct of type
///      `GameUtilsAndStruct.Game` that contains all aspects of the deposit state
///      itself.
contract MetablocksGame is GameFactoryAuthority {
    using GameUtilsAndStruct for GameUtilsAndStruct.Game;
    using GameStates for GameUtilsAndStruct.Game;

    GameUtilsAndStruct.Game self;

    /// @dev Deposit should only be _constructed_ once. New deposits are created
    ///      using the `DepositFactory.createDeposit` method, and are clones of
    ///      the constructed deposit. The factory will set the initial values
    ///      for a new clone using `initializeDeposit`.
    constructor() public {
        // The constructed Deposit will never be used, so the deposit factory
        // address can be anything. Clones are updated as per above.
        initialize(address(0xdeadbeef));
    }

    /// @notice Contract does not accept arbitrary ETH.
    // function () external payable {
    //     require(msg.data.length == 0, "Deposit contract was called with unknown function selector.");
    // }

    //----------------------------- METADATA LOOKUP ------------------------------//

    /// @notice Check if the Deposit is in CREATED state.
    /// @return True if state is CREATED, false otherwise.
    function inFunding() external view returns (bool) {
        return self.inFunding();
    }

    //------------------------------ GAME FLOW --------------------------------//

    //--------------------------- MUTATING HELPERS -------------------------------//

    /// @notice This function can only be called by the deposit factory; use
    ///         `DepositFactory.createDeposit` to create a new deposit.
    /// @dev Initializes a new deposit clone with the base state for the
    ///      deposit.
    /// @param _metablocksSystem `MetablocksSystem` contract. More info in `MetablocksSystem`.
    function initializeGame(
        IMetablocksSystem _metablocksSystem
    ) public onlyFactory payable {
        self.initialize();
    }

    /// @notice Withdraw the native token balance of the deposit allotted to the caller.
    /// @dev Withdrawals can only happen when a contract is in an end-state.
    function withdrawFunds() external {
        // self.withdrawFunds();
    }
}
