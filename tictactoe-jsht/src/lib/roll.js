// @flow

export type Roll = {
  +dice: [number, number],
  +total: number
}

export type RollResponse = {
  +details: string
}

export function toRoll (res: RollResponse): Roll {
  // "( 1 + 3 )" => [1, 3];
  const dice = res.details.split('+').map((s) => Number(s.match(/\d+/)));
  return {
    dice: [dice[0], dice[1]],
    total: dice.reduce((memo, d) => memo + d, 0)
  }
}
