import React, { useRef, useState, useMemo } from "react";
import { Canvas, useFrame } from "@react-three/fiber";
import * as THREE from "three";
import { OrbitControls } from "@react-three/drei";
import BoardMeasures, { BoardSizes } from "../constants/BoardMeasures";
import BoardMaterials from "./Board";
import five from "../ethereumLogo.png";
import GroundMaterial from "./GroundMaterial";
import TileMaterials, { TileMeshgroupWithFallback } from "./TileMaterials";
import PlayerFactory from "./PlayerFactory";

const Box = props => {
  const mesh = useRef();

  const [active, setActive] = useState(false);

  useFrame(() => {
    mesh.current.rotation.x = mesh.current.rotation.y += 0.01;
  });

  const texture = useMemo(() => new THREE.TextureLoader().load(five), []);

  return (
    <mesh {...props} ref={mesh} scale={active ? [2, 2, 2] : [1.5, 1.5, 1.5]} onClick={e => setActive(!active)}>
      <boxBufferGeometry args={[1, 1, 1]} />
      <meshBasicMaterial attach="material" transparent side={THREE.DoubleSide}>
        <primitive attach="map" object={texture} />
      </meshBasicMaterial>
    </mesh>
  );
};

const GameCanvas = () => {
  return (
    <Canvas
      camera={{
        fov: 25,
        //  aspect : Camera frustum aspect ratio, usually the canvas width / canvas height. Default is 1 (square canvas).,
        near: 1,
        far: 1000,
        position: [(BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2, 100, 160],
      }}
    >
      {/* <ambientLight intensity={0.5} /> */}
      <pointLight
        position={[
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2,
          150,
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2,
        ]}
        intensity={0.4}
      />
      {/* TODO: Fix both spot lights */}
      <spotLight
        position={[
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2,
          100,
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2 + 300,
        ]}
        intensity={0.3}
        castShadow
        shadow-camera-fov={55}
      />
      <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} />
      {/* light that will follow the this.camera position */}
      <pointLight color={0xf9edc9} position={[0, 20, 0]} intensity={0.5} distance={500} />

      <BoardMaterials position={[0, -0.02, 0]} />
      <GroundMaterial />
      <TileMeshgroupWithFallback />
      <Box position={[-1.2, 0, 0]} />
      <Box position={[2.5, 0, 0]} />
      <PlayerFactory position={[5, 0, 1]} />
      <OrbitControls
        target={[
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2,
          -6,
          (BoardMeasures.SQUARE_SIZE * BoardSizes.SIZE) / 2,
        ]}
      />
    </Canvas>
  );
};
export { Box as SuspenseBox };
export default GameCanvas;
