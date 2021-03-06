-- Move the Turtle around with the arrow keys. Use the
-- space bar to make the turtle come above water for air.

import Keyboard
import Window

-- MODEL
type Turtle = { x:Float, y:Float, angle:Float, velocity:Float }

turtle : Turtle
turtle = { x=0, y=0, angle=0, velocity=0 }


-- UPDATE
type Arrows = { x:Float, y:Float }

keysStep : Arrows -> Turtle -> Turtle
keysStep arrows turtle =
    { turtle | velocity <- 40 * arrows.y,
               angle <- turtle.angle - arrows.x / 20 }

swimStep : Time -> Turtle -> Turtle
swimStep delta turtle =
    let {x,y,angle,velocity} = turtle in
    { turtle | x <- x + delta * velocity * cos angle ,
               y <- y + delta * velocity * sin angle }

step : (Bool,Arrows,Time) -> Turtle -> Turtle
step (space,arrows,delta) turtle =
  keysStep arrows <| swimStep delta turtle


-- DISPLAY
display : (Int,Int) -> Turtle -> Element
display (w,h) turtle =
  let turtlePic = image 96 96 "turtle.gif" |> toForm
                                           |> rotate turtle.angle
                                           |> move (turtle.x,turtle.y)
  in layers [ collage w h [turtlePic],
              opacity 0.7 <| fittedImage w h "water.gif" ]


-- TURTLE
delta = inSeconds <~ fps 30
input = sampleOn delta <| lift3 (,,) Keyboard.space Keyboard.arrows delta

main  = lift2 display Window.dimensions (foldp step turtle input)

-- Try switching out Keyboard.arrows for Keyboard.wasd to
-- try out different controls (or swich Keyboard.space for
-- Keyboard.ctrl or Keyboard.shift).