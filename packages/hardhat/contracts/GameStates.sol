pragma solidity >=0.7.6;
//SPDX-License-Identifier: MIT

import {GameUtilsAndStruct} from "./GameUtilsAndStruct.sol";

library GameStates {

    enum States {
        // DOES NOT EXIST YET
        START,

        CREATED,
        FUNDED,
        WAITING_FOR_PLAYER,
        FINISHED
    }

    /// @notice     Check if the contract is currently in the funding flow.
    /// @dev        This checks on the funding flow happy path, not the fraud path.
    /// @param _d   Game storage pointer.
    /// @return     True if contract is currently in the funding flow else False.
    function inFunding(GameUtilsAndStruct.Game storage _d) external view returns (bool) {
        return (
            _d.currentState == uint8(States.CREATED)
        );
    }

    /// @notice     Check if the contract has halted.
    /// @dev        This checks on any halt state, regardless of triggering circumstances.
    /// @param _d   Game storage pointer.
    /// @return     True if contract has halted permanently.
    function inEndState(GameUtilsAndStruct.Game storage _d) external view returns (bool) {
        return (
            _d.currentState == uint8(States.FINISHED)
        );
    }

    /// @notice     Check if the contract is available for a redemption request.
    /// @dev        Redemption is available from active and courtesy call.
    /// @param _d   Game storage pointer.
    /// @return     True if available, False otherwise.
    function inRedeemableState(GameUtilsAndStruct.Game storage _d) external view returns (bool) {
        return (
            _d.currentState == uint8(States.FUNDED)
         || _d.currentState == uint8(States.FINISHED)
        );
    }

    /// @notice     Check if the contract is currently in the start state (awaiting setup).
    /// @dev        This checks on the funding flow happy path, not the fraud path.
    /// @param _d   Game storage pointer.
    /// @return     True if contract is currently in the start state else False.
    function inStart(GameUtilsAndStruct.Game storage _d) external view returns (bool) {
        return (_d.currentState == uint8(States.FUNDED));
    }

    // function inAwaitingSignerSetup(GameUtilsAndStruct.Deposit storage _d) external view returns (bool) {
    //     return _d.currentState == uint8(States.AWAITING_SIGNER_SETUP);
    // }

    // function inAwaitingBTCFundingProof(GameUtilsAndStruct.Deposit storage _d) external view returns (bool) {
    //     return _d.currentState == uint8(States.AWAITING_BTC_FUNDING_PROOF);
    // }

    function setFunded(GameUtilsAndStruct.Game storage _d) external {
        _d.currentState = uint8(States.FUNDED);
    }

    function setActive(GameUtilsAndStruct.Game storage _d) external {
        _d.currentState = uint8(States.WAITING_FOR_PLAYER);
    }

    function setFinished(GameUtilsAndStruct.Game storage _d) external {
        _d.currentState = uint8(States.FINISHED);
    }
}
