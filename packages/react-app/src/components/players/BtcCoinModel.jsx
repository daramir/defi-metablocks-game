/*
Auto-generated by: https://github.com/pmndrs/gltfjsx
author: Karolina Renkiewicz (https://sketchfab.com/KarolinaRenkiewicz)
license: CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0/)
source: https://sketchfab.com/3d-models/bitcoin-ff17dab54b044d789d05ae7c8dfb9808
title: Bitcoin
*/

import React, { useRef, useMemo } from "react";
import { useGLTF } from "@react-three/drei";

import { a } from "@react-spring/three";

export default function Model(props) {
  const group = useRef();
  const { nodes, materials } = useGLTF("/player_models/btc_coin/model_btc_coin.gltf");

  const baseScale = useMemo(() => [0.03, 0.03, 0.03], []);

  return (
    <a.group
      ref={group}
      {...props}
      scale={baseScale}
      // position={positionPlusBase}
      dispose={null}
    >
      <group rotation={[-Math.PI / 2, 0, 0]}>
        <group rotation={[Math.PI / 2, 0, 0]}>
          <group position={[-3.49, 36.23, -11.29]} rotation={[0, 0, 0]}>
            <mesh geometry={nodes.Cylinder002__0.geometry} material={materials["Scene_-_Root"]} />
          </group>
        </group>
      </group>
    </a.group>
  );
}

useGLTF.preload("/player_models/btc_coin/model_btc_coin.gltf");
