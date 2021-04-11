pragma solidity >=0.7.6;
//SPDX-License-Identifier: MIT

// import {IERC721} from "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import {GameStates} from "./GameStates.sol";
import {MetablocksConstants} from "./system/MetablocksConstants.sol";
import {IMetablocksSystem} from "./interfaces/IMetablocksSystem.sol";
// import {TBTCToken} from "../system/TBTCToken.sol";


library GameUtilsAndStruct {

    using SafeMath for uint256;
    using SafeMath for uint64;
  
    using GameStates for GameUtilsAndStruct.Game;

    struct Game {

        // SET DURING CONSTRUCTION
        IMetablocksSystem metablocksSystem;
        // TBTCToken tbtcToken;
        // IERC721 tbtcDepositToken;
        
        address gameOwner;
        uint64 lotSizeSatoshis;
        uint8 currentState;
        uint16 signerFeeDivisor;
        uint16 initialCollateralizedPercent;
        uint16 undercollateralizedThresholdPercent;
        uint16 severelyUndercollateralizedThresholdPercent;
        uint256 keepSetupFee;

        // SET ON FRAUD
        uint256 liquidationInitiated;  // Timestamp of when liquidation starts
        uint256 courtesyCallInitiated; // When the courtesy call is issued
        address payable liquidationInitiator;

        // written when we request a keep
        address keepAddress;  // The address of our keep contract
        uint256 signingGroupRequestedAt;  // timestamp of signing group request

        // written when we get a keep result
        uint256 fundingProofTimerStart;  // start of the funding proof period. reused for funding fraud proof period
        bytes32 signingGroupPubkeyX;  // The X coordinate of the signing group's pubkey
        bytes32 signingGroupPubkeyY;  // The Y coordinate of the signing group's pubkey

        // INITIALLY WRITTEN BY REDEMPTION FLOW
        address payable redeemerAddress;  // The redeemer's address, used as fallback for fraud in redemption
        bytes redeemerOutputScript;  // The redeemer output script
        uint256 initialRedemptionFee;  // the initial fee as requested
        uint256 latestRedemptionFee; // the fee currently required by a redemption transaction
        uint256 withdrawalRequestTime;  // the most recent withdrawal request timestamp
        bytes32 lastRequestedDigest;  // the digest most recently requested for signing

        // written when we get funded
        bytes8 utxoValueBytes;  // LE uint. the size of the deposit UTXO in satoshis
        uint256 fundedAt; // timestamp when funding proof was received
        bytes utxoOutpoint;  // the 36-byte outpoint of the custodied UTXO

        // Map of ETH balances an address can withdraw after contract reaches ends-state.
        mapping(address => uint256) withdrawableAmounts;

        // Map of timestamps representing when transaction digests were approved for signing
        mapping (bytes32 => uint256) approvedDigests;
    }

    /// @notice Closes keep associated with the deposit.
    /// @dev Should be called when the keep is no longer needed and the signing
    /// group can disband.
    function closeKeep(GameUtilsAndStruct.Game storage _d) internal {
        // IBondedECDSAKeep _keep = IBondedECDSAKeep(_d.keepAddress);
        // _keep.closeKeep();
    }

    /// @notice         Gets the current block difficulty.
    /// @dev            Calls the light relay and gets the current block difficulty.
    /// @return         The difficulty.
    function currentBlockDifficulty(Game storage _d) public view returns (uint256) {
        // return _d.tbtcSystem.fetchRelayCurrentDifficulty();
    }

    /// @notice                 Syntactically check an SPV proof for a bitcoin transaction with its hash (ID).
    /// @dev                    Stateless SPV Proof verification documented elsewhere (see https://github.com/summa-tx/bitcoin-spv).
    /// @param _d               Game storage pointer.
    /// @param _txId            The bitcoin txid of the tx that is purportedly included in the header chain.
    /// @param _merkleProof     The merkle proof of inclusion of the tx in the bitcoin block.
    /// @param _txIndexInBlock  The index of the tx in the Bitcoin block (0-indexed).
    /// @param _bitcoinHeaders  An array of tightly-packed bitcoin headers.
    function checkProofFromTxId(
        Game storage _d,
        bytes32 _txId,
        bytes memory _merkleProof,
        uint256 _txIndexInBlock,
        bytes memory _bitcoinHeaders
    ) public view{
        // require(
        //     _txId.prove(
        //         _bitcoinHeaders.extractMerkleRootLE().toBytes32(),
        //         _merkleProof,
        //         _txIndexInBlock
        //     ),
        //     "Tx merkle proof is not valid for provided header and txId");
        // evaluateProofDifficulty(_d, _bitcoinHeaders);
    }

    /// @notice Retreive the remaining term of the deposit
    /// @dev    The return value is not guaranteed since block.timestmap can be lightly manipulated by miners.
    /// @return The remaining term of the deposit in seconds. 0 if already at term
    function remainingTerm(GameUtilsAndStruct.Game storage _d) public view returns(uint256){
        uint256 endOfTerm = _d.fundedAt.add(MetablocksConstants.getPlayerTurnTimeout());
        if(block.timestamp < endOfTerm ) {
            return endOfTerm.sub(block.timestamp);
        }
        return 0;
    }

    /// @notice     Calculates the amount of value at auction right now.
    /// @dev        We calculate the % of the auction that has elapsed, then scale the value up.
    /// @param _d   Game storage pointer.
    /// @return     The value in wei to distribute in the auction at the current time.
    function auctionValue(Game storage _d) external view returns (uint256) {
        // uint256 _elapsed = block.timestamp.sub(_d.liquidationInitiated);
        // uint256 _available = address(this).balance;
        // if (_elapsed > TBTCConstants.getAuctionDuration()) {
        //     return _available;
        // }

        // // This should make a smooth flow from base% to 100%
        // uint256 _basePercentage = getAuctionBasePercentage(_d);
        // uint256 _elapsedPercentage = uint256(100).sub(_basePercentage).mul(_elapsed).div(TBTCConstants.getAuctionDuration());
        // uint256 _percentage = _basePercentage.add(_elapsedPercentage);

        // return _available.mul(_percentage).div(100);
        return 0;
    }

   

    /// @notice         Convert a LE bytes8 to a uint256.
    /// @dev            Do this by converting to bytes, then reversing endianness, then converting to int.
    /// @return         The uint256 represented in LE by the bytes8.
    function bytes8LEToUint(bytes8 _b) public pure returns (uint256) {
        // return abi.encodePacked(_b).reverseEndianness().bytesToUint();
        return uint256(0);
    }

    /// @notice         Looks up the Fee Rebate Token holder.
    /// @return         The current token holder if the Token exists.
    ///                 address(0) if the token does not exist.
    function feeRebateTokenHolder(Game storage _d) public view returns (address) {
        address tokenHolder = address(0);
        // if(_d.feeRebateToken.exists(uint256(address(this)))){
        //     tokenHolder = address(uint160(_d.feeRebateToken.ownerOf(uint256(address(this)))));
        // }
        return address(uint160(tokenHolder));
    }

    /// @notice         Looks up the game end beneficiary by calling the tBTC system.
    /// @dev            We cast the address to a uint256 to match the 721 standard.
    /// @return         The current Game beneficiary.
    function getGameOwner(Game storage _d) public view returns (address) {
        return _d.gameOwner;
    }

    /// @notice     Deletes state after termination of redemption process.
    /// @dev        We keep around the redeemer address so we can pay them out.
    function redemptionTeardown(Game storage _d) public {
        _d.redeemerOutputScript = "";
        _d.initialRedemptionFee = 0;
        _d.withdrawalRequestTime = 0;
        _d.lastRequestedDigest = bytes32(0);
    }


    /// @notice     Get the starting percentage of the bond at auction.
    /// @dev        This will return the same value regardless of collateral price.
    /// @return     The percentage of the InitialCollateralizationPercent that will result
    ///             in a 100% bond value base auction given perfect collateralization.
    function getAuctionBasePercentage(Game storage _d) internal view returns (uint256) {
        return uint256(10000).div(_d.initialCollateralizedPercent);
    }

    /// @notice     Seize the signer bond from the keep contract.
    /// @dev        we check our balance before and after.
    /// @return     The amount seized in wei.
    function seizeSignerBonds(Game storage _d) internal returns (uint256) {
        uint256 _preCallBalance = address(this).balance;

        // _keep.seizeSignerBonds();

        uint256 _postCallBalance = address(this).balance;
        require(_postCallBalance > _preCallBalance, "No funds received, unexpected");
        return _postCallBalance.sub(_preCallBalance);
    }

    /// @notice     Adds a given amount to the withdraw allowance for the address.
    /// @dev        Withdrawals can only happen when a contract is in an end-state.
    function enableWithdrawal(GameUtilsAndStruct.Game storage _d, address _withdrawer, uint256 _amount) internal {
        _d.withdrawableAmounts[_withdrawer] = _d.withdrawableAmounts[_withdrawer].add(_amount);
    }

    /// @notice     Withdraw caller's allowance.
    /// @dev        Withdrawals can only happen when a contract is in an end-state.
    function withdrawFunds(GameUtilsAndStruct.Game storage _d) internal {
        uint256 available = _d.withdrawableAmounts[msg.sender];

        require(_d.inEndState(), "Game not yet terminated");
        require(available > 0, "Nothing to withdraw");
        require(address(this).balance >= available, "Insufficient contract balance");

        // zero-out to prevent reentrancy
        _d.withdrawableAmounts[msg.sender] = 0;

        /* solium-disable-next-line security/no-call-value */
        (bool ok,) = msg.sender.call{value: available}("");
        require(
            ok,
            "Failed to send withdrawable amount to sender"
        );
    }

    /// @notice     Get the caller's withdraw allowance.
    /// @return     The caller's withdraw allowance in wei.
    function getWithdrawableAmount(GameUtilsAndStruct.Game storage _d) internal view returns (uint256) {
        return _d.withdrawableAmounts[msg.sender];
    }

    /// @notice     Distributes the fee rebate to the Fee Rebate Token owner.
    /// @dev        Whenever this is called we are shutting down.
    function distributeFeeRebate(Game storage _d) internal {
        // address rebateTokenHolder = feeRebateTokenHolder(_d);

        // // exit the function if there is nobody to send the rebate to
        // if(rebateTokenHolder == address(0)){
        //     return;
        // }

        // // pay out the rebate if it is available
        // if(_d.tbtcToken.balanceOf(address(this)) >= signerFeeTbtc(_d)) {
        //     _d.tbtcToken.transfer(rebateTokenHolder, signerFeeTbtc(_d));
        // }
    }

    /// @notice Calculate TBTC amount required for redemption by a specified
    ///         _redeemer. If _assumeRedeemerHoldTdt is true, return the
    ///         requirement as if the redeemer holds this deposit's TDT.
    /// @dev Will revert if redemption is not possible by the current owner and
    ///      _assumeRedeemerHoldsTdt was not set. Setting
    ///      _assumeRedeemerHoldsTdt only when appropriate is the responsibility
    ///      of the caller; as such, this function should NEVER be publicly
    ///      exposed.
    /// @param _redeemer The account that should be treated as redeeming this
    ///        deposit  for the purposes of this calculation.
    /// @param _assumeRedeemerHoldsTdt If true, the calculation assumes that the
    ///        specified redeemer holds the TDT. If false, the calculation
    ///        checks the deposit owner against the specified _redeemer. Note
    ///        that this parameter should be false for all mutating calls to
    ///        preserve system correctness.
    /// @return owedToDeposit A tuple of the amount the redeemer owes to the deposit to
    ///         initiate redemption
    /// @return owedToTdtHolder The amount that is owed to the TDT holder
    ///         when redemption is initiated, and the amount that is owed to the
    ///         FRT holder when redemption is initiated.
    /// @return owedToFrtHolder The amount that is owed to the
    ///         FRT holder when redemption is initiated.
    function calculateRedemptionTbtcAmounts(
        GameUtilsAndStruct.Game storage _d,
        address _redeemer,
        bool _assumeRedeemerHoldsTdt
    ) internal view returns (
        uint256 owedToDeposit,
        uint256 owedToTdtHolder,
        uint256 owedToFrtHolder
    ) {
        // bool redeemerHoldsTdt =
        //     _assumeRedeemerHoldsTdt || depositOwner(_d) == _redeemer;
        // bool preTerm = remainingTerm(_d) > 0 &&  !_d.inCourtesyCall();

        // require(
        //     redeemerHoldsTdt || !preTerm,
        //     "Only TDT holder can redeem unless deposit is at-term or in COURTESY_CALL"
        // );

        // bool frtExists = feeRebateTokenHolder(_d) != address(0);
        // bool redeemerHoldsFrt = feeRebateTokenHolder(_d) == _redeemer;
        // uint256 signerFee = signerFeeTbtc(_d);

        // uint256 feeEscrow = calculateRedemptionFeeEscrow(
        //     signerFee,
        //     preTerm,
        //     frtExists,
        //     redeemerHoldsTdt,
        //     redeemerHoldsFrt
        // );

        // Base redemption + fee = total we need to have escrowed to start
        // redemption.
        // owedToDeposit =
        //     calculateBaseRedemptionCharge(
        //         lotSizeTbtc(_d),
        //         redeemerHoldsTdt
        //     ).add(feeEscrow);

        // Adjust the amount owed to the deposit based on any balance the
        // deposit already has.
        uint256 signerFee = 0;
        uint256 balance = 0;

        // The TDT holder gets any leftover balance.
        owedToTdtHolder =
            balance.add(owedToDeposit).sub(signerFee).sub(owedToFrtHolder);

        return (owedToDeposit, owedToTdtHolder, owedToFrtHolder);
        return (0,0,0);
    }

    /// @notice  Get fees owed for redemption
    /// @param signerFee The value of the signer fee for fee calculations.
    /// @param _preTerm               True if the Game is at-term or in courtesy_call.
    /// @param _frtExists     True if the FRT exists.
    /// @param _redeemerHoldsTdt     True if the the redeemer holds the TDT.
    /// @param _redeemerHoldsFrt     True if the redeemer holds the FRT.
    /// @return                      The fees owed in TBTC.
    function calculateRedemptionFeeEscrow(
        uint256 signerFee,
        bool _preTerm,
        bool _frtExists,
        bool _redeemerHoldsTdt,
        bool _redeemerHoldsFrt
    ) internal pure returns (uint256) {
        // Escrow the fee rebate so the FRT holder can be repaids, unless the
        // redeemer holds the FRT, in which case we simply don't require the
        // rebate from them.
        // bool escrowRequiresFeeRebate =
        //     _preTerm && _frtExists && ! _redeemerHoldsFrt;

        // bool escrowRequiresFee =
        //     _preTerm ||
        //     // If the FRT exists at term/courtesy call, the fee is
        //     // "required", but should already be escrowed before redemption.
        //     _frtExists ||
        //     // The TDT holder always owes fees if there is no FRT.
        //     _redeemerHoldsTdt;

        // uint256 feeEscrow = 0;
        // if (escrowRequiresFee) {
        //     feeEscrow += signerFee;
        // }
        // if (escrowRequiresFeeRebate) {
        //     feeEscrow += signerFee;
        // }

        return 0;
    }
}
