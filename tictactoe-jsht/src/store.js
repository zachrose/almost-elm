import { createStore, compose /*, applyMiddleware */ } from 'redux';
import reducer from './reducers/index';
import { install } from 'redux-loop';
import initialState from './initialState';

const enhancer = compose(
  // applyMiddleware(someMiddleware),
  install()
);

const store = createStore(reducer, initialState, enhancer);

export default store;
