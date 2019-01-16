module Main exposing (..)

import Browser
import Tuple
import Html exposing (Html, text, div, h1, img, p, button)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Http

import Json.Decode exposing (Decoder, field, string)

---- MODEL ----

type alias Roll =
  {
    dice: (Int, Int),
    total: Int
  }


type alias Model =
    { roll: Maybe Roll,
      rolling: Bool,
      s: Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( {
      roll = Nothing,
      rolling = False,
      s = Nothing
    }, Cmd.none )



---- UPDATE ----


type Msg
    = RollDice
    | DiceRollSuccessful (Result Http.Error String)
    | DiceRollFailed


rollDecoder : Decoder String
rollDecoder =
  field "details" string

rollDice : Cmd Msg
rollDice =
  Http.get {
    url = "https://rolz.org/api/?2d6.json",
    expect = Http.expectJson DiceRollSuccessful rollDecoder
  }
  

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      RollDice -> ({ model | rolling = True }, rollDice)
      DiceRollSuccessful result ->
        ({ model |
          rolling = False, s = Just (Result.withDefault "nope" (result))}, Cmd.none)
      DiceRollFailed -> ( model, Cmd.none )

---- VIEW ----

formatRoll : Roll -> String
formatRoll roll =
  String.fromInt (Tuple.first roll.dice)

view : Model -> Html Msg
view model =
    let
      p1 = case model.roll of
        Nothing -> p [ class "hide" ] [ text "no roll" ]
        _ -> p [] [ text "uh" ]
      p2 = case model.rolling of
        True -> p [] [ text "rolling" ]
        False -> p [] [ text "not rolling" ]
      b = button [onClick RollDice] [ text "Roll the Dice" ]
      d = case model.s of
        Nothing -> p [] [ text "nothing" ]
        _ -> p [] [ text (Maybe.withDefault "ugh" (model.s)) ]
    in
    div [ class "App" ] [
      p1, p2, b, d
    ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
