import React, { useRef, useState, useMemo, Suspense } from "react";
import { useFrame, useLoader } from "@react-three/fiber";

import * as THREE from "three";
import default_tile_texture from "../static/3d_assets/tiles/-1.png";
import { tileAssets } from "./TileAssets";
import BoardMeasures, { BoardSizes } from "../constants/BoardMeasures";
import { SuspenseBox } from "./GameCanvas";

const TileMaterials = props => {
  const group = useRef();

  const [active, setActive] = useState(false);

  // useFrame(() => {
  //   mesh.current.rotation.x = mesh.current.rotation.y += 0.01;
  // });

  // const defaultTexture = useMemo(() => new THREE.TextureLoader().load(default_tile_texture), []);
  const defaultTexture = useLoader(THREE.TextureLoader, default_tile_texture);

  const posToTileId = (row, col) => {
    if (row === 0) {
      return 20 + col;
    } else if (row === 10) {
      return 10 - col;
    } else if (col === 0) {
      return 20 - row;
    } else if (col === 10) {
      return 30 + row;
    } else {
      return -1;
    }
  };

  const tileTextures = useLoader(THREE.TextureLoader, tileAssets);

  const tileMeshMaterials = useMemo(() => {
    let arrTileTextures = [];
    try {
      for (let row = 0; row < BoardSizes.SIZE; row++) {
        let rowMaterial = [];
        for (let col = 0; col < BoardSizes.SIZE; col++) {
          const tileModelIndex = posToTileId(row, col);
          console.log(`Trying to load asset ../static/3d_assets/tiles/${tileModelIndex}.png`);
          const tileMaterial =
            tileModelIndex === -1 ? (
              <meshLambertMaterial attach="material">
                <primitive attach="map" object={defaultTexture} />
              </meshLambertMaterial>
            ) : (
              <meshLambertMaterial attach="material">
                <primitive attach="map" object={tileTextures[tileModelIndex]} />
              </meshLambertMaterial>
            );
          rowMaterial.push(tileMaterial);
        }
        arrTileTextures.push(rowMaterial);
      }
    } catch (error) {
      console.error(error);
    }

    return arrTileTextures;
  }, [tileTextures]);

  const tileMeshes = useMemo(() => {
    let arrTileMeshes = [];
    try {
      for (let row = 0; row < BoardSizes.SIZE; row++) {
        for (let col = 0; col < BoardSizes.SIZE; col++) {
          const unpTileTextures = tileMeshMaterials;
          // console.log(tileTextures)
          // console.log(unpTileTextures)
          let tile = (
            <mesh
            key={`[${row}][${col}]`}
              position={[
                col * BoardMeasures.SQUARE_SIZE + BoardMeasures.SQUARE_SIZE / 2,
                -0.01,
                row * BoardMeasures.SQUARE_SIZE + BoardMeasures.SQUARE_SIZE / 2,
              ]}
              rotation={[(-90 * Math.PI) / 180, 0, 0]}
            >
              <planeGeometry args={[BoardMeasures.SQUARE_SIZE, BoardMeasures.SQUARE_SIZE, 1, 1]} />
              {unpTileTextures[row][col]}
            </mesh>
          );
          arrTileMeshes.push(tile);
        }
      }
    } catch (error) {
      console.error(error);
    }

    return arrTileMeshes;
  }, [tileTextures, tileMeshMaterials]);

  return (
    <group ref={group} {...props} dispose={null}>
      {tileMeshes}
    </group>
  );
};

const TileMeshgroupWithFallback = props => {
  const mesh = useRef();

  // useFrame(() => {
  //   mesh.current.rotation.x = mesh.current.rotation.y += 0.01;
  // });

  return (
    // <Suspense fallback={<SuspenseBox />}>
    <Suspense fallback={null}>
      <TileMaterials {...props} />
    </Suspense>
  );
};
export { TileMeshgroupWithFallback };
export default TileMaterials;
