// @flow
import React from 'react';
import type { Node } from 'react';
import { connect } from 'react-redux';
import './App.css';
import actions from './actions/index';
import type { Roll } from './lib/roll';
import type { State } from './store';

function formatRoll(roll: Roll): string {
  return roll.dice[0] + ' + ' + roll.dice[1] + ' = ' + roll.total;
}

function App(props: State & typeof actions): Node {
  return (
    <div className="App">
      <p className={props.roll ? '' : 'hide'}>{props.roll ? formatRoll(props.roll) : 'no roll'}</p>
      <p>{props.rolling ? 'rolling' : 'not rolling' }</p>
      <button onClick={props.rollDice}>Roll the Dice</button>
    </div>
  );
}

/*
 * There isn't a need to rearrange Redux state into React props yet.
 */
const mapState = (state) => state;

export default connect(mapState, actions)(App);
