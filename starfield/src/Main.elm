module Main exposing (Model, Msg(..), init, main, update)

import Browser
import Browser.Dom exposing (getViewport, Viewport)
import Html exposing (Html, button, div, h1, img, p, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Parser exposing ((|.), (|=), Parser, int, run, spaces, succeed, symbol)
import Tuple
import Time exposing (every)
import Svg
import Svg.Attributes
import Task


---- MODEL ----

acceleration : Int
acceleration = 1

field =
  {
    w = Just 1000
  , h = Just 1000
  }


type alias Star =
    { x : Maybe Float
    , y : Maybe Float
    , sx : Float
    , sy : Float
    , w : Int
    , h : Int
    , age : Int
    , id : Int
    , c : String
    }

star1 : Star
star1 = 
  { x = Nothing
  , y = Nothing
  , sx = -4
  , sy = 3
  , w = 2
  , h = 2
  , age = 30
  , id = 1
  , c = "#ffffff"
  }

type alias Model =
    { stars : List Star
    , debug : String
    , viewport : Maybe Viewport
    }


type Msg
    = Tick
    | GotViewport Viewport

getV : Cmd Msg
getV =
  getViewport
    |> Task.perform GotViewport


init : ( Model, Cmd Msg )
init =
    ( { stars = [ star1 ]
      , debug = "don't got it yet"
      , viewport = Nothing
      }
    , Cmd.batch
      [ getV
      ]
    )

---- UPDATE ----


advance : Star -> Star
advance star =
  case star.x of
    Nothing -> star
    Just xx ->
      case star.y of
        Nothing -> star
        Just yy ->
          let
            cond1 = star.age == floor(50/toFloat acceleration)
            cond2 = star.age == floor(150/toFloat acceleration)
            cond3 = star.age == floor(300/toFloat acceleration)
            growStar = cond1 || cond2 || cond3
          in
            { star |
              x = Just (xx + star.sx)
            , y = Just (yy + star.sy)
            , age = star.age + 1
            , w = if growStar then star.w + 1 else star.w
            , h = if growStar then star.h + 1 else star.h
            }

isDead : Star -> Bool
isDead star =
  case field.w of
    Nothing -> False
    Just fw ->
      case field.h of
        Nothing -> False
        Just fh ->
          case star.x of
            Nothing -> False
            Just xx ->
              case star.y of
                Nothing -> False
                Just yy ->
                  let
                    cond1 = (xx + toFloat(star.w)) < 0
                    cond2 = (xx > fw)
                    cond3 = (yy + toFloat(star.h)) < 0
                    cond4 = (yy > fh)
                  in
                    cond1 || cond2 || cond3 || cond4

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GotViewport vp ->
      ({ model | debug = "got it" }, Cmd.none)
    _ ->
      let
        advanced = List.map advance model.stars
        filtered = List.filter isDead advanced
      in
        ( {
          model |
          stars = advanced -- List.filter isDead model.stars
        }, Cmd.none )


---- VIEW ----

viewStar : Star -> Html Msg
viewStar star =
  case star.x of
    Nothing -> p [] [text "unborn"]
    Just xx ->
      case star.y of
        Nothing -> p [] [text "half born"]
        Just yy ->
          let
            x = String.fromFloat xx
            y = String.fromFloat yy
            sx = String.fromFloat star.sx
            sy = String.fromFloat star.sy
            w = String.fromInt star.w
            h = String.fromInt star.h
            age = String.fromInt star.age
            id = String.fromInt star.id
            c = star.c
            starlog =
              "x: " ++ x ++
              " y: " ++ y ++
              " sx: " ++ sx ++
              " sy: " ++ sy ++
              " w: " ++ w ++
              " h: " ++ h ++
              " age: " ++ age ++
              " id: " ++ id ++
              " c: " ++ c
          in
            p [] [
              text starlog
            ]

-- // view : Model -> Html Msg
-- // view model =
-- //     div [ class "App" ] (List.map viewStar model.stars)



---- PROGRAM ----


main : Program () Model Msg
main =
  Browser.element
    { view = vv
    , init = \_ -> init
    , update = update
    , subscriptions = (\model -> every 1000 (\t -> Tick))
    }

vs : Viewport -> Star -> Html Msg
vs viewport star =
  case star.x of
    Nothing -> Svg.rect [] []
    Just xx ->
      case star.y of
        Nothing -> Svg.rect [] []
        Just yy ->
          Svg.rect
            [ Svg.Attributes.width (String.fromInt (star.w * 1))
            , Svg.Attributes.height (String.fromInt (star.h * 1))
            , Svg.Attributes.x (String.fromFloat xx)
            , Svg.Attributes.y (String.fromFloat yy)
            , Svg.Attributes.fill "white"
            ] []

vv : Model -> Html Msg
vv model =
  case model.viewport of
    Nothing ->
      div [ class "debug" ] [ text model.debug ]
    Just viewport ->
      div [
      ] [
        h1 [] [text model.debug],
        Svg.svg
          [ Svg.Attributes.width "1000"
          , Svg.Attributes.height "1000"
          , Svg.Attributes.fill "green"
          ] (List.map (vs viewport) model.stars)
      ]
