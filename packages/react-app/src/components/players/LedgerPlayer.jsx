import React, { useState, useMemo, Suspense, useEffect } from "react";
import { useContractLoader, useContractReader, useEventListener } from "../../hooks";
import { useSpring } from "@react-spring/three";

import PlayerModel from "./LedgerNanoModel";

const LedgerPlayer = props => {
  const { localProvider, gameEvents } = props;

  const [active, setActive] = useState(false);

  // Load in your local 📝 contract and read a value from it:
  const readContracts = useContractLoader(localProvider);
  console.log("📝 LedgerNanoModel readContracts", readContracts);

  // keep track of a variable from the contract in the local React state:
  const crPosition = useContractReader(readContracts, "MockGameActions", "purpose", null, 100000);
  let positionObj = crPosition == null || crPosition == "" ? props.position : JSON.parse(crPosition);
  let newPos = null;

  //📟 Listen for broadcast events
  // const mockGameEvents = useEventListener(readContracts, "MockGameActions", "SetAction", localProvider, 1);
  console.log(`mockGameEvents: `, gameEvents)

  if (gameEvents && gameEvents.length > 0) {
    
    const latestEvent = gameEvents.sort((a, b) => b.blockNumber - a.blockNumber)[0];
    console.log("LedgerPlayer latestEvent", latestEvent);
    try {
      newPos = JSON.parse(latestEvent.action);
    } catch (error) {
      console.warn(`Coudln't read player position properly`)
      newPos = positionObj;
    }
    
  } else {
    newPos = positionObj == "" ? [0,0,0] : positionObj;
  }
  console.log(`MockGameActions purpose newPos is .....`, newPos);

  ({ position: positionObj } = useSpring({ position: positionObj == newPos ? positionObj : newPos }));

  console.log("Rendering LedgerPlayer");
  return (
    <Suspense fallback={null}>
      <PlayerModel onClick={e => setActive(!active)} {...props} position={positionObj}></PlayerModel>
    </Suspense>
  );
};

export default LedgerPlayer;
