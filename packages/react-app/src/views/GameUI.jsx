/* eslint-disable jsx-a11y/accessible-emoji */

import React, { useState } from "react";
import { Button, List, Card, DatePicker, Slider, Switch, Progress, Spin } from "antd";
import { Row, Col } from "antd";
import { SyncOutlined } from "@ant-design/icons";
import { Address } from "../components";
import { parseEther, formatEther } from "@ethersproject/units";

import {
  useExchangePrice,
  useGasPrice,
  useUserProvider,
  useContractLoader,
  useContractReader,
  useEventListener,
  useBalance,
  useExternalContractLoader,
} from "../hooks";

import GameCanvas from "../components/GameCanvas";

export default function GameUI({
  purpose,
  setPurposeEvents,
  address,
  mainnetProvider,
  userProvider,
  localProvider,
  yourLocalBalance,
  price,
  tx,
  readContracts,
  writeContracts,
}) {
  const [newPurpose, setNewPurpose] = useState("loading...");

  //📟 Listen for broadcast events
  const mockGameEvents = useEventListener(readContracts, "MockGameActions", "SetAction", localProvider, 1);
  console.log("📟 GameUI SetAction events:", mockGameEvents);

  return (
    <div>
      {/*
        ⚙️ Here is an example UI that displays and sets the purpose in your smart contract:
      */}
      <Row>
        <Col span={16}>
          <GameCanvas localProvider={localProvider} gameEvents={mockGameEvents} />
        </Col>
        <Col span={8}>
          <div style={{ width: 480, margin: "auto", marginTop: 32, paddingBottom: 32 }}>
            <h2>Events:</h2>
            <List
              bordered
              dataSource={mockGameEvents}
              renderItem={item => {
                return (
                  <List.Item key={item.blockNumber + "_" + item.sender + "_" + item.purpose}>
                    <Address address={item[0]} ensProvider={mainnetProvider} fontSize={16} /> =>
                    {item[1]}
                  </List.Item>
                );
              }}
            />
          </div>
        </Col>
      </Row>

      {/*
        📑 Maybe display a list of events?
          (uncomment the event and emit line in YourContract.sol! )
      */}

      <div style={{ width: 600, margin: "auto", marginTop: 32, paddingBottom: 256 }}>
        <Card>
          Check out all the{" "}
          <a
            href="https://github.com/austintgriffith/scaffold-eth/tree/master/packages/react-app/src/components"
            target="_blank"
            rel="noopener noreferrer"
          >
            📦 components
          </a>
        </Card>

        <Card style={{ marginTop: 32 }}>
          <div>
            There are tons of generic components included from{" "}
            <a href="https://ant.design/components/overview/" target="_blank" rel="noopener noreferrer">
              🐜 ant.design
            </a>{" "}
            too!
          </div>

          <div style={{ marginTop: 8 }}>
            <Button type="primary">Buttons</Button>
          </div>

          <div style={{ marginTop: 8 }}>
            <SyncOutlined spin /> Icons
          </div>

          <div style={{ marginTop: 8 }}>
            Date Pickers?
            <div style={{ marginTop: 2 }}>
              <DatePicker onChange={() => {}} />
            </div>
          </div>

          <div style={{ marginTop: 32 }}>
            <Slider range defaultValue={[20, 50]} onChange={() => {}} />
          </div>

          <div style={{ marginTop: 32 }}>
            <Switch defaultChecked onChange={() => {}} />
          </div>

          <div style={{ marginTop: 32 }}>
            <Progress percent={50} status="active" />
          </div>

          <div style={{ marginTop: 32 }}>
            <Spin />
          </div>
        </Card>
      </div>
    </div>
  );
}
