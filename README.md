# Almost Elm

This repo is for collecting little example apps, with each app written in Elm and "Almost Elm".

The idea of "Almost Elm" is to approximate Elm with enough JavaScript libraries and tooling to get 80% of the way to Elm. The hypothesis is that it will be easier to create bugs in "Almost Elm" and the tooling won't be as nice, but who knows!

## Example Apps

### DiceRoll

![a minimal UI for rolling two dice](https://i.imgur.com/p7FkH9i.png "DiceRoll UI")

Rolls a pair of dice by hitting a [Dice Rolling API](https://rolz.org/help/api), parses a string in the JSON response to get each die, then gratuitously adds them together.
