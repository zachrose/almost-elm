// @flow
import { loop, Cmd } from 'redux-loop';
import type { State } from '../initialState';

export type Action =
  | { type: 'ROLL_DICE' }
  | { type: 'DICE_ROLL_SUCCESSFUL', roll: any }
  | { type: 'DICE_ROLL_FAILED' };

function requestDiceRoll() : Promise<{}> {
  return fetch('https://rolz.org/api/?2d6.json').then((res) => res.json());
}

function diceRollSuccessfulAction(roll : {details: string}): Action {
  return {
    type: 'DICE_ROLL_SUCCESSFUL',
    roll: roll.details.split('+').map((_s) => Number((_s.match(/\d+/) || [0])[0]))
  }
}

function diceRollFailedAction(err: any): Action {
  return {
    type: 'DICE_ROLL_FAILED',
    err
  }
}

export default function(state : State, action : Action ): State {
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
        ...state,
        roll: action.roll,
        rolling: false
      };
    case 'DICE_ROLL_FAILED':
      return {
        ...state,
        roll: [], // fix
        rolling: false
      };
    default:
      return state;
  }
}
