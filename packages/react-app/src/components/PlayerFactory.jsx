import React, { useRef, useState, useMemo, Suspense } from "react";
import { Canvas, useFrame } from "@react-three/fiber";

import * as THREE from "three";
import five from "../ethereumLogo.png";
import board_texture from "../static/3d_assets/board_texture.jpg";
// import board_texture from "../ethereumLogo.png";
import PlayerModel from "../components/players/LedgerNanoModel";

const PlayerFactory = props => {
  const mesh = useRef();

  const [active, setActive] = useState(false);

  // const boardGeom = useMemo(() => new THREE.GLTFLoader().load(boardGeometry), []);
  // useLoader(loader: THREE.Loader, url: string | string[], extensions?, xhr?)
  // const boardGeom = useMemo(() => useLoader(loader, )

  return (
    <Suspense fallback={null}>
      <PlayerModel onClick={e => setActive(!active)} {...props}>
      </PlayerModel>
    </Suspense>
  );
};

export default PlayerFactory;
