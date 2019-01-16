// @flow
import { createStore, compose /*, applyMiddleware */ } from 'redux';
import reducer from './reducers/index';
import { install } from 'redux-loop';
import type { Roll } from './lib/roll';

const enhancer = compose(
  // applyMiddleware(someMiddleware),
  install()
);

export type State = {
  +roll: Roll | null,
  +rolling: boolean
}

const initialState: State = {
  roll: null,
  rolling: false
}

const store = createStore(reducer, initialState, enhancer);

export default store;
