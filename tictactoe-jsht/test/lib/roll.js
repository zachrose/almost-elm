import { toRoll } from '../../src/lib/roll'
import { expect } from 'chai'

describe('roll', () => {
  it('parses out the individial dice like so', () => {
    const roll = toRoll({
      details: "( 1 + 3 )"
    });
    expect(roll.dice).to.deep.equal([1,3]);
  });
});
