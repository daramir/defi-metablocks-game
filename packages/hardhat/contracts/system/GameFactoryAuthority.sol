pragma solidity >=0.7.3;
//SPDX-License-Identifier: MIT

/// @title  Game Factory Authority
/// @notice Contract to secure function calls to the Game Factory.
/// @dev    Secured by setting the gameFactory address and using the onlyFactory
///         modifier on functions requiring restriction.
contract GameFactoryAuthority {

    bool internal _initialized = false;
    address internal _gameFactory;

    /// @notice Set the address of the System contract on contract
    ///         initialization.
    /// @dev Since this function is not access-controlled, it should be called
    ///      transactionally with contract instantiation. In cases where a
    ///      regular contract directly inherits from GameFactoryAuthority,
    ///      that should happen in the constructor. In cases where the inheritor
    ///      is binstead used via a clone factory, the same function that
    ///      creates a new clone should also trigger initialization.
    function initialize(address _factory) public {
        require(_factory != address(0), "Factory cannot be the zero address.");
        require(! _initialized, "Factory can only be initialized once.");

        _gameFactory = _factory;
        _initialized = true;
    }

    /// @notice Function modifier ensures modified function is only called by set game factory.
    modifier onlyFactory(){
        require(_initialized, "Factory initialization must have been called.");
        require(msg.sender == _gameFactory, "Caller must be GameFactory contract");
        _;
    }
}
