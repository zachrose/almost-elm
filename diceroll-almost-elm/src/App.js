// @flow

import React from 'react';
import type { Node } from 'react';
import { createStore, compose } from 'redux';
import { connect } from 'react-redux';
import { install, loop, Cmd } from 'redux-loop';
import './App.css';


/*------------------------------------------*/
/*   TYPES                                  */
/*------------------------------------------*/

export type Roll = {
  +dice: [number, number],
  +total: number
}

export type RollResponse = {
  +details: string
}

export type State = {
  +roll: Roll | null,
  +rolling: boolean
}


/*------------------------------------------*/
/*   STORE                                  */
/*------------------------------------------*/

const initialState: State = {
  roll: null,
  rolling: false
}


/*------------------------------------------*/
/*   VIEW                                   */
/*------------------------------------------*/

function formatRoll(roll: Roll): string {
  return roll.dice[0] + ' + ' + roll.dice[1] + ' = ' + roll.total;
}

function View(props: State & typeof userActions): Node {
  return (
    <div className="App">
      <p className={props.roll ? '' : 'hide'}>{props.roll ? formatRoll(props.roll) : 'no roll'}</p>
      <p>{props.rolling ? 'rolling' : 'not rolling' }</p>
      <button onClick={props.rollDice}>Roll the Dice</button>
    </div>
  );
}


/*------------------------------------------*/
/*   ACTIONS AND ACTION CREATORS            */
/*------------------------------------------*/

export type Action =
  | { +type: 'ROLL_DICE' }
  | { +type: 'DICE_ROLL_SUCCESSFUL', +roll: Roll }
  | { +type: 'DICE_ROLL_FAILED' };

function requestDiceRoll() : Promise<RollResponse> {
  return fetch('https://rolz.org/api/?2d6.json').then((res) => res.json());
}

function toRoll (res: RollResponse): Roll {
  // "( 1 + 3 )" => [1, 3];
  const dice = res.details.split('+').map((s) => Number(s.match(/\d+/)));
  return {
    dice: [dice[0], dice[1]],
    total: dice.reduce((memo, d) => memo + d, 0)
  }
}

function diceRollSuccessfulAction(res: RollResponse): Action {
  return {
    type: 'DICE_ROLL_SUCCESSFUL',
    roll: toRoll(res)
  }
}

function diceRollFailedAction(err: any): Action {
  return {
    type: 'DICE_ROLL_FAILED',
    err
  }
}

function rollDice(): Action {
  return {
    type: 'ROLL_DICE'
  };
}

const userActions = {
  rollDice
}


/*------------------------------------------*/
/*   REDUCER                                */
/*------------------------------------------*/

function reducer(state : State, action : Action ): State {
  switch (action.type) {
    case 'ROLL_DICE':
      return loop({
        ...state,
        rolling: true
      }, Cmd.run(requestDiceRoll, {
        successActionCreator: diceRollSuccessfulAction,
        failActionCreator: diceRollFailedAction
      }))
    case 'DICE_ROLL_SUCCESSFUL':
      return {
        roll: action.roll,
        rolling: false
      };
    case 'DICE_ROLL_FAILED':
      return {
        roll: null,
        rolling: false
      };
    default:
      return state;
  }
}


/*------------------------------------------*/
/*   HV SVNT DRACONES                       */
/*------------------------------------------*/

const store = createStore(reducer, initialState, compose(install()));
const App = connect((state) => state, userActions)(View);
export { store, App }
