pragma solidity >=0.7.3;
//SPDX-License-Identifier: MIT


// import {DepositUtils} from "./DepositUtils.sol";
// import {DepositStates} from "./DepositStates.sol";
// import {ITBTCSystem} from "../interfaces/ITBTCSystem.sol";
// import {IERC721} from "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";
// import {TBTCToken} from "../system/TBTCToken.sol";

import "./system/GameFactoryAuthority.sol";

// solium-disable function-order
// Below, a few functions must be public to allow bytes memory parameters, but
// their being so triggers errors because public functions should be grouped
// below external functions. Since these would be external if it were possible,
// we ignore the issue.

/// @title  tBTC Deposit
/// @notice This is the main contract for tBTC. It is the state machine that
///         (through various libraries) handles bitcoin funding, bitcoin-spv
///         proofs, redemption, liquidation, and fraud logic.
/// @dev This contract presents a public API that exposes the following
///      libraries:
///
///       - `DepositFunding`
///       - `DepositLiquidaton`
///       - `DepositRedemption`,
///       - `DepositStates`
///       - `DepositUtils`
///       - `OutsourceDepositLogging`
///       - `TBTCConstants`
///
///      Where these libraries require deposit state, this contract's state
///      variable `self` is used. `self` is a struct of type
///      `DepositUtils.Deposit` that contains all aspects of the deposit state
///      itself.
contract MetablocksGame is GameFactoryAuthority {


    /// @dev Deposit should only be _constructed_ once. New deposits are created
    ///      using the `DepositFactory.createDeposit` method, and are clones of
    ///      the constructed deposit. The factory will set the initial values
    ///      for a new clone using `initializeDeposit`.
    constructor () public {
        // The constructed Deposit will never be used, so the deposit factory
        // address can be anything. Clones are updated as per above.
        initialize(address(0xdeadbeef));
    }

    /// @notice Contract does not accept arbitrary ETH.
    // function () external payable {
    //     require(msg.data.length == 0, "Deposit contract was called with unknown function selector.");
    // }

//----------------------------- METADATA LOOKUP ------------------------------//

    

//------------------------------ GAME FLOW --------------------------------//



//--------------------------- MUTATING HELPERS -------------------------------//

    /// @notice This function can only be called by the deposit factory; use
    ///         `DepositFactory.createDeposit` to create a new deposit.
    /// @dev Initializes a new deposit clone with the base state for the
    ///      deposit.
    /// @param _tbtcSystem `TBTCSystem` contract. More info in `TBTCSystem`.
    /// @param _tbtcToken `TBTCToken` contract. More info in TBTCToken`.
    /// @param _tbtcDepositToken `TBTCDepositToken` (TDT) contract. More info in
    ///        `TBTCDepositToken`.
    /// @param _feeRebateToken `FeeRebateToken` (FRT) contract. More info in
    ///        `FeeRebateToken`.
    /// @param _vendingMachineAddress `VendingMachine` address. More info in
    ///        `VendingMachine`.
    /// @param _lotSizeSatoshis The minimum amount of satoshi the funder is
    ///                         required to send. This is also the amount of
    ///                         TBTC the TDT holder will be eligible to mint:
    ///                         (10**7 satoshi == 0.1 BTC == 0.1 TBTC).
    // function initializeGame(
    //     ITBTCSystem _tbtcSystem,
    //     TBTCToken _tbtcToken,
    //     IERC721 _tbtcDepositToken,
    //     FeeRebateToken _feeRebateToken,
    //     address _vendingMachineAddress,
    //     uint64 _lotSizeSatoshis
    // ) public onlyFactory payable {
    //     self.tbtcSystem = _tbtcSystem;
    //     self.tbtcToken = _tbtcToken;
    //     self.tbtcDepositToken = _tbtcDepositToken;
    //     self.feeRebateToken = _feeRebateToken;
    //     self.vendingMachineAddress = _vendingMachineAddress;
    //     self.initialize(_lotSizeSatoshis);
    // }


    /// @notice Withdraw the native token balance of the deposit allotted to the caller.
    /// @dev Withdrawals can only happen when a contract is in an end-state.
    function withdrawFunds() external {
        // self.withdrawFunds();
    }
}
