pragma solidity >=0.7.6;
//SPDX-License-Identifier: MIT

import {DiceRoll} from "./DiceRoll.sol";

contract MetablocksJoseph  {
    
    address private owner;

    DiceRoll private diceRollPlugin;
    
    constructor(address diceRollContract) {
        owner = msg.sender;

        diceRollPlugin = DiceRoll(diceRollContract);
        
        // Create land
        createLand(1, "Mayfair", 80);
        createLand(3, "Adelaide", 80);
        createLand(4, "City Grill", 150);
        createLand(5, "VLINE", 98);
        createLand(6, "Melbourne", 200);
        createLand(8, "Mildura", 200);
        
        // Step 1: Create player who wants to host game
        createPlayer("jrocco2");
        // Step 2: Create game
        createGame("JoesGame", 2);        
    }
    
    // ----- PLAYERS ENTITY -----
    struct Player {
        string username;
        address playerAddress;
        uint256 balance;
        uint256 positionOnBoard;
        address gameAddress;
    }
    
    function createPlayer(string memory username) public {
        Player memory myPlayer;
        myPlayer.username = username;
        myPlayer.playerAddress = msg.sender;
        playerMapping[msg.sender] = myPlayer;
    }
    
    function setupPlayer(string memory gameName) private {
        // Setup player
        //playerMapping[msg.sender] is a Player
        playerMapping[msg.sender].gameAddress = hostMapping[gameName];
        playerMapping[msg.sender].positionOnBoard = 0;
        // Monoply Rule: Each player is given $1500
         playerMapping[msg.sender].balance = 1500;
    }
    
    mapping(address => Player) public playerMapping;
    
    // ----- GAME ENTITY -----
    struct Game {
        string name; 
        int256 timePerMove;
        bool hasStarted;
        address creatorAddress;
        address[] players;
        Player currentPlayer;
    }
    
    // mapping this way means one player can only host one game
    // and therefore must remove their game in order to create another
    mapping(address => Game) private gameMapping;
    mapping(string => address) private hostMapping;
    
    function createGame(string memory name, int256 timePerMove) public {
        require(playerMapping[msg.sender].playerAddress == msg.sender, "You have to create your player before you can create a game");
        Game memory myGame;
        myGame.name = name;
        myGame.timePerMove = timePerMove;
        myGame.hasStarted = false;
        myGame.creatorAddress = msg.sender;
        gameMapping[msg.sender] = myGame;
        gameMapping[msg.sender].players.push(msg.sender);
        
        hostMapping[name] = msg.sender;
        
        setupPlayer(name);
        
    }
    
    function joinGame(string memory name) public {
        require(hostMapping[name] != address(0), "Invalid name");
        require(hostMapping[name] != playerMapping[msg.sender].gameAddress, "You have already joined this game");
        // Monoply Rule: There is usually 8 players in a game (but works with more)
        require(gameMapping[hostMapping[name]].players.length < 8, "This game has reached the maximum number of players");
        require(gameMapping[hostMapping[name]].hasStarted == false, "The game has already started");
        require(playerMapping[msg.sender].playerAddress == msg.sender, "You have to create your player before you can join a game");
        gameMapping[hostMapping[name]].players.push(msg.sender); 
        
        setupPlayer(name);
    }
    
    
    
    function startGame() public {
        // require(gameMapping[hostMapping[name]].creatorAddress == msg.sender,"Only the host can start the game they have created");
        require(gameMapping[msg.sender].creatorAddress != address(0), "You are not hosting any games");
        require(gameMapping[msg.sender].players.length >= 2, "Not enough players");
        gameMapping[msg.sender].hasStarted = true;
        //TODO: DO VRF HERE TO CHOOSE WHO PLAYS FIRST, atm it's fifo
        gameMapping[msg.sender].currentPlayer = playerMapping[gameMapping[msg.sender].players[0]];
        // AND ROLL DICE FOR PLAYER
        diceRollPlugin.rollDice();

    }
    
    function endGame() public {
        require(gameMapping[msg.sender].creatorAddress != address(0), "You are not hosting any games");
        gameMapping[msg.sender].hasStarted = false;
    }
    
    function removeGame(string memory name) private {
        require(gameMapping[hostMapping[name]].creatorAddress == msg.sender || owner == msg.sender,"Only the host can remove the game they have created");
        delete gameMapping[hostMapping[name]];
        delete hostMapping[name];
    }

    function showMeMyGame() public view returns (string memory, int256, address, address[] memory) {
        Game memory myGame = gameMapping[msg.sender];
        return (myGame.name, myGame.timePerMove, myGame.creatorAddress, myGame.players);
    }
    
    // ----- GAME FUNCTIONALITY -----
    
    function rollDice() public {
        require(playerMapping[msg.sender].gameAddress != address(0), "Player has not joined a game");
        // VRF rollDice then......
        // playerMapping[msg.sender].positionOnBoard += diceRoll;
        // NEXT PLAYERS TURN
    }
    
    function pickUpCard() public {
        require(playerMapping[msg.sender].gameAddress != address(0), "Player has not joined a game");
        // Pick up card and do some function based on card
    }
    
    function buyLand() public {
        
    }
    
    function swapLand() public {
        
    }
    
    function payDebt() public {
        
    }

    // ----- LAND ENTITY -----
    struct Land {
        int32 landTileId;
        string name;
        int256 value;
        address ownerAddress;
    }

    mapping(int32 => Land) public landMapping;
    int32[] public landList; // The order of the list is the order of Land on the Monopoly board
    
    function createLand(int32 _landTileId, string memory landName, int256 landValue) private {
        landMapping[_landTileId] = Land(_landTileId, landName, landValue, owner);
        landList.push(_landTileId);
    }
    
    function getLand(int32 _landTileId) public view returns (int32, string memory, int256) {
        return (landMapping[_landTileId].landTileId, landMapping[_landTileId].name, landMapping[_landTileId].value);
    }
    
    //  -------------------------------
}