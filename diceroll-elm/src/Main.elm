module Main exposing (Model, Msg(..), Roll, TwoDice, diceParser, formatRoll, init, main, parseRoll, rollDecoder, rollDice, update, view)

import Browser
import Html exposing (Html, button, div, h1, img, p, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)
import Parser exposing ((|.), (|=), Parser, int, run, spaces, succeed, symbol)
import Tuple



---- MODEL ----


type alias TwoDice =
    ( Int, Int )


type alias Roll =
    { dice : TwoDice
    , total : Int
    }


type alias Model =
    { roll : Maybe Roll
    , rolling : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { roll = Nothing
      , rolling = False
      }
    , Cmd.none
    )



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
    Http.get
        { url = "https://rolz.org/api/?2d6.json"
        , expect = Http.expectJson DiceRollSuccessful rollDecoder
        }


diceParser : Parser TwoDice
diceParser =
    succeed (\x y -> ( x, y ))
        |. spaces
        |. symbol "("
        |. spaces
        |= int
        |. spaces
        |. symbol "+"
        |= int
        |. spaces
        |. symbol ")"


parseRoll : String -> Roll
parseRoll string =
    case run diceParser string of
        Ok t ->
            { dice = t, total = Tuple.first t + Tuple.second t }

        Err f ->
            { dice = ( 0, 0 ), total = 0 }



-- needs fixing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RollDice ->
            ( { model | rolling = True }, rollDice )

        DiceRollSuccessful result ->
            ( { model
                | rolling = False
                , roll = Result.toMaybe (Result.map parseRoll result)
              }
            , Cmd.none
            )

        DiceRollFailed ->
            ( model, Cmd.none )



---- VIEW ----


formatRoll : Roll -> String
formatRoll roll =
    let
        ( first, second ) =
            roll.dice

        total =
            String.fromInt (first + second)
    in
    String.fromInt first ++ " + " ++ String.fromInt second ++ " = " ++ total


view : Model -> Html Msg
view model =
    let
        r =
            case model.roll of
                Nothing ->
                    p [ class "hide" ] [ text "no roll" ]

                Just roll ->
                    p [] [ text (formatRoll roll) ]

        state =
            if model.rolling then
                "rolling"

            else
                "not rolling"

        b =
            button [ onClick RollDice ] [ text "Roll the Dice" ]
    in
    div [ class "App" ]
        [ r
        , p [] [ text state ]
        , b
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
