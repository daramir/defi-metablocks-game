pragma solidity >=0.7.6;

/// @title  Metablocks System Authority.
/// @notice Contract to secure function calls to the Metablocks System contract.
/// @dev    The `MetablocksSystem` contract address is passed as a constructor parameter.
contract MetablocksSystemAuthority {

    address internal metablocksSystemAddress;

    /// @notice Set the address of the System contract on contract initialization.
    constructor(address _metablocksSystemAddress) public {
        metablocksSystemAddress = _metablocksSystemAddress;
    }

    /// @notice Function modifier ensures modified function is only called by MetablocksSystem.
    modifier onlyMetablocksSystem(){
        require(msg.sender == metablocksSystemAddress, "Caller must be metablocksSystem contract");
        _;
    }
}
