import React, { useRef, useState, useMemo, Suspense } from "react";
import { Canvas, useFrame } from "@react-three/fiber";

import * as THREE from "three";
import five from "../ethereumLogo.png";
import board_texture from "../static/3d_assets/board_texture.jpg";
// import board_texture from "../ethereumLogo.png";
import BoardGeometry from "../components/BoardGeometry";

const BoardMaterials = props => {
  const mesh = useRef();

  const [active, setActive] = useState(false);

  // useFrame(() => {
  //   mesh.current.rotation.x = mesh.current.rotation.y += 0.01;
  // });

  const texture = useMemo(() => new THREE.TextureLoader().load(five), []);
  const boardTexture = useMemo(() => new THREE.TextureLoader().load(board_texture), []);

  // const boardGeom = useMemo(() => new THREE.GLTFLoader().load(boardGeometry), []);
  // useLoader(loader: THREE.Loader, url: string | string[], extensions?, xhr?)
  // const boardGeom = useMemo(() => useLoader(loader, )

  return (
    <Suspense fallback={null}>
      <BoardGeometry onClick={e => setActive(!active)} {...props}>
        <meshLambertMaterial attach="material">
          <primitive attach="map" object={boardTexture} />
        </meshLambertMaterial>
      </BoardGeometry>
    </Suspense>
  );
};

export default BoardMaterials;
