import React from 'react';
import { connect } from 'react-redux';
import './App.css';
import {rollDice} from './actions/index';

const formatRoll = (roll) => {
  return roll[0] + ' + ' + roll[1] + ' = ' + (Number(roll[0]) + Number(roll[1]));
}

function App(props) {
  return (
    <div className="App">
      <p className={props.roll ? '' : 'hide'}>{props.roll ? formatRoll(props.roll) : 'no roll'}</p>
      <p>{props.rolling ? 'rolling' : 'not rolling' }</p>
      <button onClick={props.rollDice}>Roll the Dice</button>
    </div>
  );
}

/*
 * There's no need to rearrange Redux state into React props yet.
 */
const mapState = (state) => state;

/*
 * Boilerplate: action creators need to be listed here.
 */
const dispatchables = {
  rollDice
}

export default connect(mapState, dispatchables)(App);
