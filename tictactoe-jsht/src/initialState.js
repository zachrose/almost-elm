// @flow

export type State = {
  roll: ?Array<number>,
  rolling: boolean
}

const initialState: State = {
  roll: undefined,
  rolling: false
}

export default initialState
