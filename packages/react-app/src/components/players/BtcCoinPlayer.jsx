import React, { useState, useMemo, Suspense, useEffect } from "react";
import { useContractLoader, useContractReader, useEventListener } from "../../hooks";
import { useSpring } from "@react-spring/three";
import { boardToWorld } from "../../helpers/BoardPositions";
import BoardMeasures from "../../constants/BoardMeasures";

import PlayerModel from "./BtcCoinModel";

const BtcCoinPlayer = props => {
  const { localProvider, gameEvents, gameStartTurnEvents } = props;

  const [active, setActive] = useState(false);

  // Load in your local 📝 contract and read a value from it:
  const readContracts = useContractLoader(localProvider);
  console.log("📝 BtcCoinModel readContracts", readContracts);

  // keep track of a variable from the contract in the local React state:
  const crPosition = useContractReader(readContracts, "MetablocksJoseph", "getMyPosition", null, 100000);
  console.log("BtcCoinPlayer crPosition: ", crPosition);

  //option 1, when receving explicit coordinates
  // let positionObj = crPosition == null || crPosition == "" ? props.position : JSON.parse(crPosition);
  // let newPos = null;

  // option 2, using board to pos with tileId

  const newPosWithBase = nPos => {
    const basePosition = [0, 2, 0];
    return [nPos[0] + basePosition[0], nPos[1] + basePosition[1], nPos[2] + basePosition[2]];
  };

  let newPos = newPosWithBase([0, 0, 0]);
  let positionObj;
  let tileId = crPosition == null ? 0 : crPosition;
  const type = BoardMeasures.MODEL_PLAYER;
  // TODO: Fix hardcode
  const total = 2;
  const index = 0;
  const options = { tileId, type, total, index };
  console.log("BtcCoinPlayer options for btw: ", options);
  const btwResult = boardToWorld(options);
  console.log("btwResult: ", btwResult);
  positionObj = btwResult;

  //📟 Listen for broadcast events
  // const mockGameEvents = useEventListener(readContracts, "MockGameActions", "SetAction", localProvider, 1);
  console.log(`mockGameEvents: `, gameEvents);

  if (gameEvents && gameEvents.length > 0) {
    const latestEvent = gameEvents.sort((a, b) => b.blockNumber - a.blockNumber)[0];
    console.log("BtcCoinPlayer latestPlayerJoinEvent", latestEvent);
    //op 1
    // try {
    //   newPos = JSON.parse(latestEvent.action);
    // } catch (error) {
    //   console.warn(`Coudln't read player position properly`)
    //   newPos = positionObj;
    // }
    //op 2
    try {
      const joinEventAvatar = gameEvents.find(eve => eve.avatar == "BTCCoin");
      if (joinEventAvatar == null) {
        newPos = newPosWithBase([0, 0, 0]);
        console.log(`BTCCoin hasn't joined`);
      } else {
        const plyrAddress = joinEventAvatar.playerAddress;
        if (gameStartTurnEvents && gameStartTurnEvents.length > 0) {
          let latestPosEvent = gameStartTurnEvents
            .sort((a, b) => b.blockNumber - a.blockNumber)
            .find(eve => eve.playerAddress == plyrAddress);
          console.log("BTCCoin latestPosEvent:", latestPosEvent);
          tileId = latestPosEvent.newPosition;
          console.log(`eveNewPosition: `, { tileId, type, total, index });
          newPos = newPosWithBase(boardToWorld({ tileId, type, total, index }));
          console.log(`BTCCoin is IN GAME`);
        }
        else {
          newPos = newPosWithBase(btwResult);
        }
      }
    } catch (error) {
      console.warn(`Coudln't read player position properly`);
      newPos = newPosWithBase(positionObj);
    }
  } else {
    // op 1
    // newPos = positionObj == null || positionObj == "" ? [0,0,0] : positionObj;
    //op 2
    newPos = newPosWithBase([0, 0, 0]);
  }
  console.log(`MockGameActions purpose newPos is .....`, newPos);

  console.log("Rendering BtcCoinPlayer pre-spring", positionObj);
  ({ position: positionObj } = useSpring({ position: positionObj == newPos ? positionObj : newPos }));

  console.log("Rendering BtcCoinPlayer", positionObj);
  return (
    <Suspense fallback={null}>
      <PlayerModel onClick={e => setActive(!active)} {...props} position={positionObj}></PlayerModel>
    </Suspense>
  );
};

export default BtcCoinPlayer;
