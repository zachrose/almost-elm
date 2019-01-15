import { loop, Cmd } from 'redux-loop';

function requestDiceRoll(args) {
  return fetch('https://rolz.org/api/?2d6.json').then((res) => res.json());
}

function diceRollSuccessfulAction(roll) {
  return {
    type: 'DICE_ROLL_SUCCESSFUL',
    roll: roll.details.split('+').map((_s) => _s.match(/\d+/)[0])
  }
}

function diceRollFailedAction(err) {
  return {
    type: 'DICE_ROLL_FAILED',
    err
  }
}

export default (state, action) => {
  switch (action.type) {
    case 'SIMPLE_ACTION':
      const newState = {
        ...state,
        result: action.payload
      };
      return newState;
    case 'ROLL_DICE':
      return loop({
        ...state,
        rolling: true
      }, Cmd.run(requestDiceRoll, {
        successActionCreator: diceRollSuccessfulAction,
        failActionCreator: diceRollFailedAction,
        args: [123]
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
        roll: 'failed',
        rolling: false
      };
    default:
      return state;
  }
}
