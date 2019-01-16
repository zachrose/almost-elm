// @flow
import { loop, Cmd } from 'redux-loop';
import type { State } from '../store';
import type { Roll, RollResponse } from '../lib/roll';
import { toRoll } from '../lib/roll'

export type Action =
  | { type: 'ROLL_DICE' }
  | { type: 'DICE_ROLL_SUCCESSFUL', roll: Roll }
  | { type: 'DICE_ROLL_FAILED' };

function requestDiceRoll() : Promise<RollResponse> {
  return fetch('https://rolz.org/api/?2d6.json').then((res) => res.json());
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
        roll: null,
        rolling: false
      };
    default:
      return state;
  }
}
