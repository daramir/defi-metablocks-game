import React, { useRef, useState, useMemo, Suspense } from "react";
import { useFrame } from "@react-three/fiber";

import * as THREE from "three";
import ground_texture from "../static/3d_assets/ground.png";
import BoardMeasures, { BoardSizes } from "../constants/BoardMeasures";

const GroundMaterial = props => {
  const mesh = useRef();

  const [active, setActive] = useState(false);

  // useFrame(() => {
  //   mesh.current.rotation.x = mesh.current.rotation.y += 0.01;
  // });

  const texture = useMemo(() => new THREE.TextureLoader().load(ground_texture), []);

  // const boardGeom = useMemo(() => new THREE.GLTFLoader().load(boardGeometry), []);
  // useLoader(loader: THREE.Loader, url: string | string[], extensions?, xhr?)
  // const boardGeom = useMemo(() => useLoader(loader, )

  return (
    <mesh
      {...props}
      ref={mesh}
      position={[
        BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE / 2,
        -1.52,
        BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE / 2
      ]}
      rotation={[(-90 * Math.PI) / 180, 0, 0]}
    >
      <planeGeometry args={[100, 100, 1, 1]} />
      <meshBasicMaterial attach="material" transparent side={THREE.DoubleSide}>
        <primitive attach="map" object={texture} />
      </meshBasicMaterial>
    </mesh>
  );
};

export default GroundMaterial;
