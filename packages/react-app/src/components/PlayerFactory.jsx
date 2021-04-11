import React, { useRef, useState, useMemo, Suspense } from "react";

import LedgerPlayer from "../components/players/LedgerPlayer";
import BtcCoinPlayer from "../components/players/BtcCoinPlayer";

const PlayerFactory = props => {
  // switch (props.component.type) {
  switch (props.type) {
    case "LedgerNano":
      return <LedgerPlayer playerAddress={props.playerAddress} {...props} />;
    case "BTCCoin":
      return <BtcCoinPlayer playerAddress={props.playerAddress} {...props} />;
    // case "C":
    //   return <C />;
    default:
      return <div>Reload...</div>;
  }
};

export default PlayerFactory;
