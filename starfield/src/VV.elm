module VV exposing (vv)

import Svg
import Svg.Attributes

vs star =
  Svg.rect
    [ Svg.Attributes.width star.w
    , Svg.Attributes.height star.h
    , Svg.Attributes.x star.x
    , Svg.Attributes.y star.y
    ] []

vv model =
  Svg.svg
    [ Svg.Attributes.width "200"
    , Svg.Attributes.height "200"
    ]
    (List.map vs model.stars)
